VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cMovimientoFondo"
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
' cMovimientoFondo
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
Private Const C_Module = "cMovimientoFondo"

Private Const c_Efectivo = "Efectivo"
Private Const c_Cheques = "Cheques"
Private Const c_ChequesT = "Cheques En Cartera"
Private Const c_ChequesI = "Ingreso de Cheques"

Private Const c_Chequera = "Chequera"
Private Const c_ChequeT = "chqt"

Private Const c_OrigenDebe = "OrigenDebe"
Private Const c_OrigenHaber = "OrigenHaber"

Private Const K_NUMERO                         As Integer = 1
Private Const K_NRODOC                         As Integer = 2
Private Const K_DESCRIP                        As Integer = 3
Private Const K_FECHA                          As Integer = 4
Private Const K_TOTAL                          As Integer = 9
Private Const K_CLI_ID                         As Integer = 10
Private Const K_DOC_ID                         As Integer = 11
Private Const K_DOCT_ID                        As Integer = 12
Private Const K_EFECTIVO                       As Integer = 15
Private Const K_CHEQUES                        As Integer = 16
Private Const K_CHEQUEST                       As Integer = 17
Private Const K_CHEQUESI                       As Integer = 29
Private Const K_EST_ID                         As Integer = 18
Private Const K_CCOS_ID                        As Integer = 19
Private Const K_SUC_ID                         As Integer = 20
Private Const K_US_ID                          As Integer = 26
Private Const K_LGJ_ID                         As Integer = 27
Private Const K_COTIZACION                     As Integer = 28

Private Const KI_MFI_ID                         As Integer = 2
Private Const KI_ORDEN                          As Integer = 3
Private Const KI_DESCRIP                        As Integer = 6
Private Const KI_IMPORTE                        As Integer = 8
Private Const KI_ORIGEN_DEBE                    As Integer = 9
Private Const KI_ORIGEN_HABER                   As Integer = 10
Private Const KI_CCOS_ID                        As Integer = 22

Private Const KICH_MFI_ID                As Integer = 1
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

Private Const KI_CUE_ID_DEBE                    As Integer = 300
Private Const KI_CUE_ID_HABER                   As Integer = 301

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
Private m_Us_id                        As Long
Private m_Usuario                      As String
Private m_lgj_id                       As Long
Private m_Legajo                       As String

Private m_Cotizacion                   As Double
Private m_ccos_id                      As Long
Private m_CentroCosto                  As String
Private m_suc_id                       As Long
Private m_Sucursal                     As String
Private m_Cli_id                       As Long
Private m_Cliente                      As String
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
Private m_LastCli           As Long
Private m_LastDocName       As String
Private m_LastCliName       As String

Private m_IsNew             As Boolean

Private m_BranchId          As Long
Private m_TreeId            As Long

Private m_Host              As CSMenu.cIMenuHost

Private m_MonDefault        As Long

Private m_EfectivoDeleted   As String

Private m_Copy              As Boolean

Private m_GeneralConfig     As cGeneralConfig

Private m_DocEditable       As Boolean
Private m_DocEditMsg        As String

Private m_TaPropuesto       As Boolean
Private m_TaMascara         As String

Private m_iOrden            As Long

Private m_ChequesDeleted      As String
Private m_TChequesDeleted     As String
Private m_IChequesDeleted     As String

' Preferencias del Usuario
'
Private m_UserCfg           As cUsuarioConfig

' propiedades publicas
' propiedades privadas
' funciones publicas
' Implementacion de cIABMClient
Private Function cIABMClient_Copy() As Boolean

  If Not DocSecurityCanAccessEx(csPreTsrNewMovimientoFondo, _
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
  GetDocNumber m_LastDoc, m_ObjAbm, m_TaPropuesto, cscMfNrodoc
  pSetEnabled
End Function

Private Function cIABMClient_EditNew() As Boolean
  
  cIABMClient_Terminate
  m_IsNew = True

  cIEditGeneric_Edit csNO_ID
  m_LastCli = csNO_ID
  
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
  GetDocNumber m_LastDoc, m_ObjAbm, m_TaPropuesto, cscMfNrodoc
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

  Doc.ClientTable = csTMovimientoFondo
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
      Select Case Info
        Case K_CHEQUES, K_CHEQUEST, K_EFECTIVO, K_CHEQUESI
          pShowTotales
      End Select
      
    Case MSG_DOC_EDIT_STATE
      ShowEditState m_DocEditMsg, LNGGetText(2185, vbNullString)  'Movimiento de Fondos
      
    Case MSG_DOC_DELETE
      If cIEditGeneric_Delete(m_Id) Then
        cIABMClient_MessageEx = True
        pMove MSG_DOC_NEXT
      End If
    
    Case MSG_DOC_ANULAR
      DocAnular m_Id, m_est_id, m_Estado, csPreTsrAnularMovimientoFondo, csPreTsrDesAnularMovimientoFondo, m_ObjAbm, m_DocEditable, m_DocEditMsg, "sp_DocMovimientoFondoAnular", "sp_DocMovimientoFondoEditableGet"
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
      DocumentSearch csEDT_MovimientoFondo, Me, Not CBool(Info)
  
    Case MSG_DOC_DOC_AUX
      
      If m_Id Then
      
        ShowDocAux m_as_id, _
                   "CSContabilidad2.cAsiento", _
                   "CSABMInterface2.cABMGeneric"
      Else
        MsgInfo LNGGetText(1620, vbNullString)
                'Debe editar un comprobante guardado para poder ver los documentos auxiliares
      End If
  
    Case MSG_DOC_DOC_EDIT
      
      If m_Id Then
      
        If m_DocEditable Then
        
          MsgInfo LNGGetText(1555, vbNullString)  'Este documento puede editarse normalmente
        Else
          
          If DocCanSave(m_ObjAbm, cscMfFecha) Then
            
            Dim EditDoc As cEditDocEx
            Set EditDoc = New cEditDocEx
            
            Set EditDoc.ObjectClient = Me
            EditDoc.Edit m_Id, _
                         m_Doct_id, _
                         csTMovimientoFondo, _
                         cscMfId, _
                         csTMovimientoFondoItem, _
                         cscMfiId, _
                         csPreTsrNewMovimientoFondo, _
                         csPreTsrEditMovimientoFondo, _
                         m_Cli_id, csNO_ID, _
                         True
          End If
          
        End If
      
      Else
        MsgInfo LNGGetText(1556, vbNullString)
                'Esta opción solo sirve para modificar documentos guardados y aplicados
      End If
  
    Case MSG_DOC_HISTORY
    
      If m_Id <> csNO_ID Then
    
        ShowHistory csMovimientoFondo, m_Id, m_Documento & " " & m_Nrodoc
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
        GetDocNumber m_LastDoc, m_ObjAbm, m_TaPropuesto, cscMfNrodoc
        
        pShowCotizacion
        
      End If
      
      ' Defino el estado de edicion del comprobante
      '
      pSetEnabled
  
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
  If Not DocCanSave(m_ObjAbm, cscMfFecha) Then
    cIABMClient_Save = False
    Exit Function
  End If
  
  ' OJO -tsr
  If pGetCheques().Rows.count = 0 And _
     pGetTCheques().Rows.count = 0 And _
     pGetICheques().Rows.count = 0 And _
     pGetEfectivo().Rows.count = 0 Then
     
    MsgWarning LNGGetText(3903, vbNullString) 'El documento debe contener al menos un item
    cIABMClient_Save = False
    Exit Function
  End If
  
  Dim Mouse As cMouseWait
  Set Mouse = New cMouseWait
  
  DoEvents: DoEvents: DoEvents: DoEvents
  
  Set register = New cRegister
  register.fieldId = cscMfTMPId
  register.Table = csTMovimientoFondoTMP
  
  register.Id = csNew
    
  If m_Copy Then
    register.Fields.Add2 cscMfId, csNew, csLong
  Else
    register.Fields.Add2 cscMfId, m_Id, csLong
  End If
  
  If register.Id = csNew Then
    m_est_id = CSGeneralEx2.csEEstado.csEEst_Pendiente
  End If
  
  Dim IProperty As cIABMProperty
  For Each IProperty In m_ObjAbm.Properties
    With IProperty
      Select Case .Key
        Case K_NUMERO
          register.Fields.Add2 cscMfNumero, .Value, csLong
        Case K_NRODOC
          register.Fields.Add2 cscMfNrodoc, .Value, csText
        Case K_DESCRIP
          register.Fields.Add2 cscMfDescrip, .Value, csText
        Case K_FECHA
          register.Fields.Add2 cscMfFecha, .Value, csDate
        Case K_CLI_ID
          register.Fields.Add2 cscCliId, .HelpId, csId
        Case K_CCOS_ID
          register.Fields.Add2 cscCcosId, .HelpId, csId
        Case K_SUC_ID
          register.Fields.Add2 cscSucId, .HelpId, csId
        Case K_DOC_ID
          register.Fields.Add2 cscDocId, .HelpId, csId
        Case K_COTIZACION
          Cotizacion = .Value
          register.Fields.Add2 cscMfCotizacion, .Value, csDouble
        Case K_US_ID
          register.Fields.Add2 cscUsId, .HelpId, csId
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
  register.Fields.Add2 cscMfTotal, TotalOrigen * Cotizacion, csCurrency
  register.Fields.Add2 cscMfGrabarasiento, 1, csBoolean
  register.Fields.Add2 cscEstId, m_est_id, csId
  
  If bMonedaLegal Then
    register.Fields.Add2 cscMfTotalorigen, 0, csCurrency
  Else
    register.Fields.Add2 cscMfTotalorigen, TotalOrigen, csCurrency
  End If
  
  register.Fields.HaveLastUpdate = True
  register.Fields.HaveWhoModify = True
  
  If Not register.BeginTrans(gDB) Then Exit Function
  
  If Not gDB.Save(register, , "cIABMClient_Save", C_Module, c_ErrorSave) Then Exit Function
  
  m_iOrden = 0
  
  If Not pSaveEfectivo(register.Id, Cotizacion, bMonedaLegal) Then Exit Function
  If Not pSaveCheques(register.Id) Then Exit Function
  If Not pSaveTCheques(register.Id) Then Exit Function
  If Not pSaveICheques(register.Id) Then Exit Function
  
  If Not register.CommitTrans() Then Exit Function
  
  Dim sqlstmt As String
  Dim rs      As Recordset
  sqlstmt = "sp_DocMovimientoFondoSave " & register.Id
  
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
  
  m_ObjTree.sqlstmt = "sp_lsdoc_MovimientoFondo"
  
  If m_IsNew Then
    m_ObjTree.AddLine m_Id
  Else
    m_ObjTree.RefreshLine m_Id
  End If
ControlError:
End Function

Private Property Get cIABMClient_Title() As String
  cIABMClient_Title = LNGGetText(2185, vbNullString)  'Movimiento de Fondos
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
        Case K_SUC_ID
          If ValEmpty(.HelpId, csId) Then
            MsgInfo LNGGetText(1560, vbNullString)  'Debe indicar una sucursal
            Exit Function
          End If
        Case K_COTIZACION
          If ValEmpty(.Value, csDouble) And .Visible Then
            MsgInfo LNGGetText(1626, vbNullString)  'Debe indicar una cotización
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
    Case K_CHEQUESI
      cIABMClientGrid_IsEmptyRow = pIsEmptyRowICheques(Row, RowIndex)
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
  
  sqlstmt = "select doct_id, doc_id from MovimientoFondo where mf_id = " & Id
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
  cIEditGeneric_ShowList = SecurityCanAccess(csPreTsrListMovimientoFondo)
End Function

Private Property Set cIEditGeneric_ObjAbm(rhs As CSInterfacesABM.cIABMGeneric)
  Set m_ObjAbm = rhs
  m_ObjAbm.IsDocument = True

#If Not PREPROC_SFS Then
  Dim AbmGen      As cABMGenericDocEx
  
  Set AbmGen = m_ObjAbm
  With AbmGen
    .FactoryObject = "CSABMInterface2.cFactory"
    .ObjForm = "CSABMInterface2.fMovimientoFondo"
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
                          csTMovimientoFondo, _
                          cscMfId, _
                          doc_id) Then
      Exit Function
    End If
  End If
  
  If Not DocSecurityCanAccess( _
                  csPreTsrDeleteMovimientoFondo, _
                  doc_id, _
                  csEDocTPreDelete) Then
    Exit Function
  End If

  Dim sqlstmt As String
  
  sqlstmt = "sp_DocMovimientoFondoDelete " & Id & "," & EmpId & "," & User.Id
  
  cIEditGeneric_Delete = gDB.Execute(sqlstmt, "cIEditGeneric_Delete", C_Module)
End Function

Private Function cIEditGeneric_Search(Id As Long, Cancela As Boolean) As Boolean

End Function

Private Function cIEditGeneric_Edit(Id As Long, Optional ByVal InModalWindow As Boolean) As Boolean
  On Error GoTo ControlError
  
  If Not DocSecurityCanAccess(csPreTsrListMovimientoFondo, GetdocIdFromObjAbm(m_ObjAbm), csEDocTPreList) Then Exit Function
  
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
      cIABMClientGrid_ColumnAfterUpdate = pColAUpdateTCheque(m_Items.Properties.Item(c_ChequesT), lRow, lCol)
    Case K_CHEQUESI
      cIABMClientGrid_ColumnAfterUpdate = pColAUpdateICheque(m_Items.Properties.Item(c_ChequesI), lRow, lCol)
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
    Case K_EFECTIVO
      cIABMClientGrid_ColumnAfterEdit = pColumnAfterEdit(m_Items.Properties(c_Efectivo), lRow, lCol, NewValue, NewValueID)
    Case Else
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
  cIABMClientGrid_ColumnBeforeEdit = True
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
      Id = Val(pCell(Row, KICH_MFI_ID).Value)
      If Id <> csNO_ID Then m_ChequesDeleted = m_ChequesDeleted & Id & ","
    Case K_CHEQUEST
      Id = Val(pCell(Row, KICH_MFI_ID).Value)
      If Id <> csNO_ID Then m_TChequesDeleted = m_TChequesDeleted & Id & ","
    Case K_CHEQUESI
      Id = Val(pCell(Row, KICH_MFI_ID).Value)
      If Id <> csNO_ID Then m_IChequesDeleted = m_IChequesDeleted & Id & ","
    Case K_EFECTIVO
      Id = Val(pCell(Row, KI_MFI_ID).Value)
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
    Case K_CHEQUESI
      cIABMClientGrid_ValidateRow = pValidateRowICheques(Row, RowIndex)
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

Private Function pValidateRow(ByRef Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  Dim Cell                  As cIABMGridCellValue
  Dim strRow                As String
  Dim cue_id_debe           As Long
  Dim cue_id_haber          As Long
  
  strRow = " (Fila " & RowIndex & ")"
  
  For Each Cell In Row
    Select Case Cell.Key
      
      Case KI_IMPORTE
        If ValEmpty(Cell.Value, csCurrency) Then
          MsgInfo LNGGetText(1897, vbNullString, strRow) 'Debe indicar un importe (1)
          Exit Function
        End If
      
      Case KI_CUE_ID_DEBE
        If ValEmpty(Cell.Id, csId) Then
          MsgInfo LNGGetText(2187, vbNullString, strRow) 'Debe indicar una cuenta destino (1)
          Exit Function
        End If
        cue_id_debe = Cell.Id
      
      Case KI_CUE_ID_HABER
        If ValEmpty(Cell.Id, csId) Then
          MsgInfo LNGGetText(2186, vbNullString, strRow) 'Debe indicar una cuenta origen (1)
          Exit Function
        End If
        cue_id_haber = Cell.Id
      
      Case KI_ORIGEN_DEBE
        If m_Items.Properties(c_Efectivo).Grid.Columns(c_OrigenDebe).Visible Then
        
          If Not pIsMonDefault(cue_id_debe) Then
        
            If ValEmpty(Cell.Value, csCurrency) Then
            
              If m_UserCfg.DebeHaberMf Then
                MsgInfo LNGGetText(4812, vbNullString, strRow)
                        'Debe indicar el importe en la moneda de la cuenta debe (1)
              Else
                MsgInfo LNGGetText(4811, vbNullString, strRow)
                        'Debe indicar el importe en la moneda de la cuenta destino (1)
              End If
              Exit Function
            End If
          End If
        End If
      
      Case KI_ORIGEN_HABER
        If m_Items.Properties(c_Efectivo).Grid.Columns(c_OrigenHaber).Visible Then
        
          If Not pIsMonDefault(cue_id_haber) Then
        
            If ValEmpty(Cell.Value, csCurrency) Then
              If m_UserCfg.DebeHaberMf Then
                MsgInfo LNGGetText(4813, vbNullString, strRow)
                        'Debe indicar el importe en la moneda de la cuenta haber (1)
              Else
                MsgInfo LNGGetText(4810, vbNullString, strRow)
                        'Debe indicar el importe en la moneda de la cuenta origen (1)
              End If
              Exit Function
            End If
          End If
        End If
    End Select
  Next
  
  pValidateRow = True
End Function

Private Function pColumnAfterEdit(ByRef IProperty As cIABMProperty, _
                                  ByVal lRow As Long, _
                                  ByVal lCol As Long, _
                                  ByVal NewValue As Variant, _
                                  ByVal NewValueID As Long)
  Dim Column As cIABMGridColumn
  
  Set Column = IProperty.Grid.Columns.Item(lCol)
  
  Select Case Column.Key
    
    Case KI_CUE_ID_DEBE, KI_CUE_ID_HABER
      
      Dim ColKey As String
      
      If Column.Key = KI_CUE_ID_DEBE Then
        ColKey = c_OrigenDebe
      Else
        ColKey = c_OrigenHaber
      End If
      
      If Not pIsMonDefault(NewValueID) And _
         NewValueID <> csNO_ID Then
         
        IProperty.Grid.Columns.Item(ColKey).Visible = True
#If PREPROC_SFS Then
        Dim AbmObj As cABMGeneric
#Else
        Dim AbmObj As cABMGenericDocEx
#End If
        Set AbmObj = m_ObjAbm
        AbmObj.RefreshColumnProperties IProperty, ColKey
      End If
  
  End Select
  pColumnAfterEdit = True
End Function

' funciones privadas
Private Function LoadCollection() As Boolean
  Dim Filter      As String
  Dim c           As cIABMProperty
#If PREPROC_SFS Then
  Dim AbmGen      As cABMGeneric
#Else
  Dim AbmGen      As cABMGenericDocEx
#End If
  Dim Cotizacion  As Double
  
  ' Preferencias del usuario
  '
  Dim bValidateDocDefault As Boolean
  
  Set AbmGen = m_ObjAbm
  AbmGen.ResetLayoutMembers
  
  AbmGen.NoButtons1 = BUTTON_DOC_APLIC
  AbmGen.NoButtons2 = BUTTON_DOC_ACTION
  AbmGen.InitButtons
  
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
      .Table = CSDocumento2.CSDocumento
      .Name = LNGGetText(1567, vbNullString) 'Documento
      .Key = K_DOC_ID
      
      If m_doc_id <> csNO_ID Then
        .HelpId = m_doc_id
        .Value = m_Documento
      Else
        ' Preferencias del usuario
        '
        .HelpId = m_UserCfg.DocMfId
        .Value = m_UserCfg.DocMfNombre
        
        bValidateDocDefault = .HelpId <> csNO_ID
      End If
      
      .HelpFilter = "'doct_id = " & csEDT_MovimientoFondo & "'"
    End With
    
    With .Add(Nothing, csDocNumberID)
      .PropertyType = cspNumeric
      .SubType = cspInteger
      .Name = LNGGetText(1065, vbNullString) 'Número
      .Key = K_NUMERO
      .Value = m_Numero
      .Enabled = False
    End With
    
    With .Add(Nothing, csDocEstateID)
      .PropertyType = cspText
      .Name = LNGGetText(1568, vbNullString) 'Estado
      .Key = K_EST_ID
      .Value = m_Estado
      .Enabled = False
    End With
    
    With .Add(Nothing, cscMfFecha)
      .PropertyType = cspDate
      .Name = LNGGetText(1569, vbNullString) 'Fecha
      .LeftLabel = -580
      .Left = 700
      .Key = K_FECHA
      .Value = m_Fecha
    End With
    
    With .Add(Nothing, cscCliId)
      .PropertyType = cspHelp
      .Table = csCliente
      .TopFromProperty = cscMfFecha
      .Left = 3500
      .LeftLabel = -1100
      .Name = LNGGetText(1150, vbNullString) 'Cliente
      .Key = K_CLI_ID
      .HelpId = m_Cli_id
      .Value = m_Cliente
      AbmGen.NewKeyPropFocus = cscCliId
    End With
    
    With .Add(Nothing, cscMfNrodoc)
      .PropertyType = cspText
      .Name = LNGGetText(1065, vbNullString) 'Número
      .TopToPrevious = 400
      .Size = 50
      .Key = K_NRODOC
      .Value = m_Nrodoc
      .TextMask = m_TaMascara
      .TextAlign = vbRightJustify
    End With
    
    With .Add(Nothing, cscUsId)
      .PropertyType = cspHelp
      .Table = csUsuario
      .Name = LNGGetText(1822, vbNullString) 'Responsable
      .TopToPrevious = 400
      .Key = K_US_ID
      .HelpId = m_Us_id
      .Value = m_Usuario
    End With
    
    With .Add(Nothing, cscLgjId)
      .PropertyType = cspHelp
      .Table = csLegajo
      .Name = LNGGetText(1575, vbNullString) 'Legajo
      .Key = K_LGJ_ID
      .HelpId = m_lgj_id
      .Value = m_Legajo
      .TabIndex = 1
    End With
    
    With .Add(Nothing, cscMfCotizacion)
      .PropertyType = cspNumeric
      .SubType = cspMoney
      .TopFromProperty = cscCliId
      .Left = 7100
      .LeftLabel = -1200
      .Name = LNGGetText(1635, vbNullString) 'Cotización
      .Format = m_GeneralConfig.FormatDecCotizacion
      .Key = K_COTIZACION
      .Value = m_Cotizacion
      .Width = 1000
    End With
    
    If m_Cotizacion <> 0 Then
      Cotizacion = m_Cotizacion
    Else
      Cotizacion = 1
    End If
    
    With .Add(Nothing, cscCcosId)
      .PropertyType = cspHelp
      .Table = csCentroCosto
      .Name = LNGGetText(1057, vbNullString) 'Centro de Costo
      .TopToPrevious = 400
      .Key = K_CCOS_ID
      .HelpId = m_ccos_id
      .Value = m_CentroCosto
    End With
    
    With .Add(Nothing, cscSucId)
      .PropertyType = cspHelp
      .Table = csSucursal
      .Name = LNGGetText(1281, vbNullString) 'Sucursal
      .TopToPrevious = 400
      .Key = K_SUC_ID
      .HelpId = m_suc_id
      .Value = m_Sucursal
    End With
    
    With .Add(Nothing, cscMfDescrip)
      .PropertyType = cspText
      .SubType = cspMemo
      .Name = LNGGetText(1211, vbNullString) 'Observ.
      .LeftLabel = -600
      .Size = 5000
      .Key = K_DESCRIP
      .Value = m_Descrip
      .LeftFromProperty = cscMfFecha
      .TopFromProperty = cscMfNrodoc
      .Width = 8660
      .Height = 520
      .TopToPrevious = 800
    End With
  End With
  
  If Not m_ObjAbm.Show(Me) Then Exit Function
  
  Const c_TabEfectivo = 0
  Const c_TabCheque = 1
  Const c_TabChequeT = 2
  Const c_TabChequeI = 3
  
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
  
    With .Add(Nothing)
      .Index = c_TabChequeI
      .Name = LNGGetText(2189, vbNullString) 'Ingreso de Cheques
    End With
  
  End With
  
  Set AbmGen = m_Items
  AbmGen.ResetLayoutMembers
  
  With m_Items.Properties
  
    .Clear
    
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
      If Not pLoadTCheques(c) Then Exit Function
      .Name = c_ChequesT
      .Key = K_CHEQUEST
      .TabIndex = c_TabChequeT
      .GridAdd = True
      .GridEdit = True
      .GridRemove = True
    End With
    
    m_TChequesDeleted = vbNullString
  
    '/////////////////////////////////////////////////////////////////
    ' INGRESO DE CHEQUES DE TERCERO
    Set c = .Add(Nothing, c_ChequesI)
    With c
      .PropertyType = cspGrid
      .LeftLabel = -1
      If Not pLoadICheques(c) Then Exit Function
      .Name = c_ChequesI
      .Key = K_CHEQUESI
      .TabIndex = c_TabChequeI
      .GridAdd = True
      .GridEdit = True
      .GridRemove = True
    End With
    
    m_IChequesDeleted = vbNullString
  
  End With
  
    
  If Not m_Items.Show(Me) Then Exit Function
  
  Set AbmGen = m_Footer
  AbmGen.ResetLayoutMembers
  
  With m_Footer.Properties
  
    .Clear
  
    Set c = .Add(Nothing, cscMfTotal)
    With c
      .PropertyType = cspNumeric
      .Format = m_GeneralConfig.FormatDecImporte
      .Name = LNGGetText(1584, vbNullString)   'Total
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
  
  LoadCollection = True
End Function

' Cotizacion
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
  
  Set iProp = m_ObjAbm.Properties.Item(cscMfCotizacion)
  iProp.Visible = MonId <> GetMonedaDefault
  
  If m_lastMonIdCotizacion <> MonId Or iProp.Value = 0 Then
    dDate = m_ObjAbm.Properties.Item(cscMfFecha).Value
    If Not IsDate(dDate) Then dDate = Date
    iProp.Value = GetCotizacion(MonId, dDate)
    m_lastMonIdCotizacion = MonId
  End If
  
  m_ObjAbm.ShowValue iProp
End Sub

Private Function pGetMonedaDefault() As Long
  Dim sqlstmt As String
  Dim rs      As Recordset
  
  sqlstmt = "select mon_id from Moneda where mon_legal <> 0"
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Function
  
  If rs.EOF Then
    MsgWarning LNGGetText(2150, vbNullString)
              'Debe definir cual es la moneda legal con la que opera Cairo
    Exit Function
  End If
  
  pGetMonedaDefault = gDB.ValField(rs.Fields, cscMonId)
End Function

Private Function pLoadEfectivo(ByRef Propiedad As cIABMProperty, ByVal Cotizacion As Double) As Boolean
  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  
  sqlstmt = "sp_DocMovimientoFondoGetItems " & m_Id & "," & csEMovimientoFondoItemTipo.csEMfiTEfectivo
  
  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, "pLoadEfectivo", C_Module) Then Exit Function
  
  Dim o           As cIABMGridColumn
  Dim iColDebe    As cIABMGridColumn
  Dim iColHaber   As cIABMGridColumn
  Dim OrigenDebe  As Double
  Dim OrigenHaber As Double
  
  With Propiedad.Grid
    
    .Columns.Clear
    .Rows.Clear
    
    With .Columns
    
      With .Add(Nothing)
        .Visible = False
        .Key = KI_MFI_ID
      End With
      
      If m_UserCfg.DebeHaberMf Then
        
        With .Add(Nothing)
          .Name = LNGGetText(4814, vbNullString)   'Cuenta Debe
          .PropertyType = cspHelp
          .Table = csCuenta
          .Width = 1800
          .Key = KI_CUE_ID_DEBE
          .HelpFilter = GetHelpFilterCuenta()
        End With
        
        With .Add(Nothing)
          .Name = LNGGetText(4815, vbNullString)   'Cuenta Haber
          .PropertyType = cspHelp
          .Table = csCuenta
          .Width = 1800
          .Key = KI_CUE_ID_HABER
          .HelpFilter = GetHelpFilterCuenta()
        End With
        
      Else
        With .Add(Nothing)
          .Name = LNGGetText(2190, vbNullString)   'Cuenta Origen
          .PropertyType = cspHelp
          .Table = csCuenta
          .Width = 1800
          .Key = KI_CUE_ID_HABER
          .HelpFilter = GetHelpFilterCuenta()
        End With
        
        With .Add(Nothing)
          .Name = LNGGetText(2191, vbNullString)   'Cuenta Destino
          .PropertyType = cspHelp
          .Table = csCuenta
          .Width = 1800
          .Key = KI_CUE_ID_DEBE
          .HelpFilter = GetHelpFilterCuenta()
        End With
      End If
      
      With .Add(Nothing)
        .Name = C_strDescrip
        .PropertyType = cspText
        .SubType = cspTextButtonEx
        .Width = 4000
        .Key = KI_DESCRIP
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(1228, vbNullString)   'Importe
        .PropertyType = cspNumeric
        .Format = m_GeneralConfig.FormatDecImporte
        .SubType = cspMoney
        .Width = 1200
        .Key = KI_IMPORTE
      End With
      
      If m_UserCfg.DebeHaberMf Then
      
        Set iColDebe = .Add(Nothing, c_OrigenDebe)
        With iColDebe
          .Name = LNGGetText(4816, vbNullString)   'Origen Debe
          .Format = m_GeneralConfig.FormatDecImporte
          .PropertyType = cspNumeric
          .SubType = cspMoney
          .Width = 1500
          .Visible = False
          .Key = KI_ORIGEN_DEBE
        End With
        
        Set iColHaber = .Add(Nothing, c_OrigenHaber)
        With iColHaber
          .Name = LNGGetText(4817, vbNullString)   'Origen Haber
          .Format = m_GeneralConfig.FormatDecImporte
          .PropertyType = cspNumeric
          .SubType = cspMoney
          .Width = 1500
          .Visible = False
          .Key = KI_ORIGEN_HABER
        End With
      
      Else
      
        Set iColHaber = .Add(Nothing, c_OrigenHaber)
        With iColHaber
          .Name = LNGGetText(4818, vbNullString)   'Importe Origen Origen
          .Format = m_GeneralConfig.FormatDecImporte
          .PropertyType = cspNumeric
          .SubType = cspMoney
          .Width = 1500
          .Visible = False
          .Key = KI_ORIGEN_HABER
        End With
      
        Set iColDebe = .Add(Nothing, c_OrigenDebe)
        With iColDebe
          .Name = LNGGetText(4819, vbNullString)   'Importe Origen Destino
          .Format = m_GeneralConfig.FormatDecImporte
          .PropertyType = cspNumeric
          .SubType = cspMoney
          .Width = 1500
          .Visible = False
          .Key = KI_ORIGEN_DEBE
        End With
        
      End If
      
      With .Add(Nothing)
        .Name = LNGGetText(1057, vbNullString)   'Centro de Costo
        .PropertyType = cspHelp
        .Table = csCentroCosto
        .Width = 1800
        .Key = KI_CCOS_ID
      End With
    End With
  
    With .Rows
      While Not rs.EOF
      
        With .Add(Nothing, rs(cscMfiId).Value)
        
          With .Add(Nothing)
            .Value = gDB.ValField(rs.Fields, cscMfiId)
            .Key = KI_MFI_ID
          End With
          
          If m_UserCfg.DebeHaberMf Then
            
            With .Add(Nothing)
              .Value = gDB.ValField(rs.Fields, "Debe")
              .Id = gDB.ValField(rs.Fields, cscCueIdDebe)
              .Key = KI_CUE_ID_DEBE
            End With
            
            With .Add(Nothing)
              .Value = gDB.ValField(rs.Fields, "Haber")
              .Id = gDB.ValField(rs.Fields, cscCueIdHaber)
              .Key = KI_CUE_ID_HABER
            End With
          
          Else
            
            With .Add(Nothing)
              .Value = gDB.ValField(rs.Fields, "Haber")
              .Id = gDB.ValField(rs.Fields, cscCueIdHaber)
              .Key = KI_CUE_ID_HABER
            End With
            
            With .Add(Nothing)
              .Value = gDB.ValField(rs.Fields, "Debe")
              .Id = gDB.ValField(rs.Fields, cscCueIdDebe)
              .Key = KI_CUE_ID_DEBE
            End With
          End If
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.Fields, cscMfiDescrip)
            .Key = KI_DESCRIP
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.Fields, cscMfiImporte) / Cotizacion
            .Key = KI_IMPORTE
          End With
          
          If m_UserCfg.DebeHaberMf Then
          
            With .Add(Nothing)
              .Value = gDB.ValField(rs.Fields, cscMfiImporteOrigen) / Cotizacion
              OrigenDebe = .Value
              .Key = KI_ORIGEN_DEBE
            End With
            With .Add(Nothing)
              .Value = gDB.ValField(rs.Fields, cscMfiImporteOrigenHaber) / Cotizacion
              OrigenHaber = .Value
              .Key = KI_ORIGEN_HABER
            End With
          
          Else
          
            With .Add(Nothing)
              .Value = gDB.ValField(rs.Fields, cscMfiImporteOrigenHaber) / Cotizacion
              OrigenHaber = .Value
              .Key = KI_ORIGEN_HABER
            End With
            With .Add(Nothing)
              .Value = gDB.ValField(rs.Fields, cscMfiImporteOrigen) / Cotizacion
              OrigenDebe = .Value
              .Key = KI_ORIGEN_DEBE
            End With
          
          End If
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.Fields, cscCcosNombre)
            .Id = gDB.ValField(rs.Fields, cscCcosId)
            .Key = KI_CCOS_ID
          End With
        End With
        
        If OrigenDebe <> 0 Then iColDebe.Visible = True
        If OrigenHaber <> 0 Then iColHaber.Visible = True
        
        rs.MoveNext
      Wend
    End With
  End With
  
  pLoadEfectivo = True
End Function

Private Function Load(ByVal Id As Long) As Boolean
  Dim Cotizacion  As Double
  Dim sqlstmt     As String

  sqlstmt = "sp_DocMovimientoFondoGet " & EmpId & "," & Id & "," & gDB.UserId
  
  Dim rs As Recordset

  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, C_LoadFunction, C_Module) Then Exit Function

  If Not rs.EOF Then

    m_IsNew = False

    m_Cotizacion = gDB.ValField(rs.Fields, cscMfCotizacion)
    Cotizacion = IIf(m_Cotizacion <> 0, m_Cotizacion, 1)

    m_Id = gDB.ValField(rs.Fields, cscMfId)
    m_Numero = gDB.ValField(rs.Fields, cscMfNumero)
    m_Nrodoc = gDB.ValField(rs.Fields, cscMfNrodoc)
    m_Descrip = gDB.ValField(rs.Fields, cscMfDescrip)
    m_Fecha = gDB.ValField(rs.Fields, cscMfFecha)
    m_Total = gDB.ValField(rs.Fields, cscMfTotal) / Cotizacion
    m_Cli_id = gDB.ValField(rs.Fields, cscCliId)
    m_Cliente = gDB.ValField(rs.Fields, cscCliNombre)
    m_ccos_id = gDB.ValField(rs.Fields, cscCcosId)
    m_CentroCosto = gDB.ValField(rs.Fields, cscCcosNombre)
    m_suc_id = gDB.ValField(rs.Fields, cscSucId)
    m_Sucursal = gDB.ValField(rs.Fields, cscSucNombre)
    m_doc_id = gDB.ValField(rs.Fields, cscDocId)
    m_Documento = gDB.ValField(rs.Fields, cscDocNombre)
    m_Doct_id = gDB.ValField(rs.Fields, cscDoctId)
    m_Us_id = gDB.ValField(rs.Fields, cscUsId)
    m_Usuario = gDB.ValField(rs.Fields, cscUsNombre)
    m_lgj_id = gDB.ValField(rs.Fields, cscLgjId)
    m_Legajo = gDB.ValField(rs.Fields, cscLgjCodigo)
    m_Creado = gDB.ValField(rs.Fields, cscCreado)
    m_Modificado = gDB.ValField(rs.Fields, cscModificado)
    m_Modifico = gDB.ValField(rs.Fields, cscModifico)
    m_est_id = gDB.ValField(rs.Fields, cscEstId)
    m_Estado = gDB.ValField(rs.Fields, cscEstNombre)
    m_Firmado = gDB.ValField(rs.Fields, cscMfFirmado)
    m_mon_id = gDB.ValField(rs.Fields, cscMonId)
    m_DocEditable = gDB.ValField(rs.Fields, cscDocEditable)
    m_DocEditMsg = gDB.ValField(rs.Fields, cscDoceditMsg)
    
    ' Para ver documentos auxiliares
    '
    m_as_id = gDB.ValField(rs.Fields, cscAsId)
    
    m_TaPropuesto = gDB.ValField(rs.Fields, cscTa_Propuesto)
    m_TaMascara = gDB.ValField(rs.Fields, cscTa_Mascara)

    m_LastDoc = m_doc_id
    m_LastCli = m_Cli_id
    m_LastDocName = m_Documento
    m_LastCliName = m_Cliente
    
    m_lastMonIdCotizacion = m_mon_id
    
  Else
    m_Id = csNO_ID
    m_Numero = 0
    m_Nrodoc = vbNullString
    m_Descrip = vbNullString
    m_Fecha = VDGetDateById(csToday)
    m_Total = 0
    m_Cli_id = csNO_ID
    m_Cliente = vbNullString
    m_ccos_id = csNO_ID
    m_CentroCosto = vbNullString
    m_doc_id = csNO_ID
    m_Documento = vbNullString
    m_Doct_id = csNO_ID
    m_Us_id = csNO_ID
    m_Usuario = vbNullString
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
    m_Cli_id = m_LastCli
    m_Cliente = m_LastCliName
    m_Documento = m_LastDocName
  
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
    
    DocEditableGet m_doc_id, m_DocEditable, m_DocEditMsg, csPreTsrNewMovimientoFondo
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
  Dim str_2048 As String
  
  str_2048 = LNGGetText(2048, vbNullString)  'T&esoreria
  
  Set m_Host = Host
  m_Host.Server.AddMenu str_2048, csMenuEnum.csMenuTesoreria, vbNullString, 1, False, False, False, True, False, Nothing
  m_Host.Server.AddMenu LNGGetText(2192, vbNullString), csPreTsrListMovimientoFondo, str_2048, 0, True, False, False, False, False, Me
                        '&Movimientos de Fondo
  cIMenuClient_Initialize = True
  
  GoTo ExitProc
ControlError:
  MngError Err, "cIMenuClient_Initialize", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Private Function cIMenuClient_ProcessMenu(ByVal Id As Long) As Variant
#If PREPROC_SFS Then                                                                                                                                                         'Movimiento de Fondo
  m_Host.MenuListDocClick "CSABMInterface2.cABMGeneric", "CSTesoreria2.cMovimientoFondo", "CSABMInterface2.CABMGenericListDoc", "CSTesoreria2.cMovimientoFondoListDoc", Me, LNGGetText(2185, vbNullString), 0
#Else
  m_Host.MenuListDocClick "CSABMInterface2.cABMGenericDocEx", "CSTesoreria2.cMovimientoFondo", "CSABMInterface2.CABMGenericListDoc", "CSTesoreria2.cMovimientoFondoListDoc", Me, LNGGetText(2185, vbNullString), 0
#End If
End Function

Private Function pSaveEfectivo(ByVal Id As Long, _
                               ByVal Cotizacion As Double, _
                               ByVal bMonedaLegal As Boolean) As Boolean
  Dim register  As cRegister
  Dim Origen    As Double
        
  Dim Row  As cIABMGridRow
  Dim Cell As cIABMGridCellValue
  
  For Each Row In m_Items.Properties(c_Efectivo).Grid.Rows
  
    Set register = New cRegister
    register.fieldId = cscMfiTMPId
    register.Table = csTMovimientoFondoItemTMP
    register.Id = csNew
    
    For Each Cell In Row
      Select Case Cell.Key
        
        Case KI_MFI_ID
          If m_Copy Then
            register.Fields.Add2 cscMfiId, csNew, csInteger
          Else
            register.Fields.Add2 cscMfiId, Val(Cell.Value), csInteger
          End If
        Case KI_DESCRIP
          register.Fields.Add2 cscMfiDescrip, Cell.Value, csText
        Case KI_CCOS_ID
          register.Fields.Add2 cscCcosId, Cell.Id, csId
        Case KI_CUE_ID_DEBE
          register.Fields.Add2 cscCueIdDebe, Cell.Id, csId
        Case KI_CUE_ID_HABER
          register.Fields.Add2 cscCueIdHaber, Cell.Id, csId
        Case KI_IMPORTE
          Origen = Cell.Value
        Case KI_ORIGEN_DEBE
          register.Fields.Add2 cscMfiImporteOrigen, Cell.Value, csCurrency
        Case KI_ORIGEN_HABER
          register.Fields.Add2 cscMfiImporteOrigenHaber, Cell.Value, csCurrency
      End Select
    Next
    
    register.Fields.Add2 cscMfiImporte, Origen * Cotizacion, csCurrency
    If bMonedaLegal Then
      If m_Items.Properties(c_Efectivo).Grid.Columns(c_OrigenDebe).Visible = False Then
        register.Fields.Add2 cscMfiImporteOrigen, 0, csCurrency
      End If
    Else
      register.Fields.Add2 cscMfiImporteOrigen, Origen, csCurrency
    End If
    
    m_iOrden = m_iOrden + 1
    register.Fields.Add2 cscMfiOrden, m_iOrden, csInteger
    register.Fields.Add2 cscMfiTipo, csEMovimientoFondoItemTipo.csEMfiTEfectivo, csInteger
    register.Fields.Add2 cscMfTMPId, Id, csId
    
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
      register.fieldId = cscMfibTMPId
      register.Table = csTMovimientoFondoItemBorradoTMP
      register.Id = csNew
      
      register.Fields.Add2 cscMfiId, Val(vDeletes(i)), csInteger
      register.Fields.Add2 cscMfId, m_Id, csId
      register.Fields.Add2 cscMfTMPId, Id, csId
      
      register.Fields.HaveLastUpdate = False
      register.Fields.HaveWhoModify = False
      
      If Not gDB.Save(register, , "pSaveEfectivo", C_Module, c_ErrorSave) Then Exit Function
    Next
    
  End If
  
  pSaveEfectivo = True
End Function

' Reglas del Objeto de Negocios
Private Sub pShowTotales()
  Dim Total     As Double
  Dim Row       As CSInterfacesABM.cIABMGridRow
  
  For Each Row In pGetCheques.Rows
    Total = Total + Val(pCell(Row, KICH_IMPORTE).Value)
  Next
  
  For Each Row In pGetTCheques.Rows
    Total = Total + Val(pCell(Row, KICH_IMPORTE).Value)
  Next
  
  For Each Row In pGetICheques.Rows
    Total = Total + Val(pCell(Row, KICH_IMPORTE).Value)
  Next
  
  For Each Row In pGetEfectivo.Rows
    Total = Total + Val(pCell(Row, KI_IMPORTE).Value)
  Next
  
  m_Footer.Properties(cscMfTotal).Value = Total
  
  m_Footer.RefreshControls
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

Private Function pGetCueIdCliente(ByRef Mon_id As Long, ByRef Cue_id As Long) As Boolean
  Dim sqlstmt As String
  Dim rs      As Recordset
  
  ' Cuenta contable del cliente
  sqlstmt = "sp_DocGetCueId " & m_LastCli & "," & m_LastDoc
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Function

  If rs.EOF Then Exit Function

  Cue_id = gDB.ValField(rs.Fields, cscCueId)
  Mon_id = gDB.ValField(rs.Fields, cscMonId)
  
  pGetCueIdCliente = True
End Function

Private Function pFirmar() As Boolean
  Dim Doc     As cDocumento
  Dim Us_id   As Long
  
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
  
  If Not Doc.Firmar(m_doc_id, Us_id) Then Exit Function
  
  Dim sqlstmt As String
  Dim rs      As Recordset
  
  sqlstmt = "sp_DocMovimientoFondoFirmar " & m_Id & "," & Us_id
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Function
  
  m_est_id = gDB.ValField(rs.Fields, cscEstId)
  m_Estado = gDB.ValField(rs.Fields, cscEstNombre)
  
  Dim iProp As cIABMProperty
  Set iProp = m_ObjAbm.Properties(csDocEstateID)
  
  With iProp
    .HelpId = m_est_id
    .Value = m_Estado
  End With
  
  gDB.GetData csTMovimientoFondo, cscMfId, m_Id, cscMfFirmado, m_Firmado
  
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
  
  sqlstmt = "sp_DocMovimientoFondoMover " & MoveTo & "," & m_Numero & "," & doc_id
  
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
        GetDocNumber m_LastDoc, m_ObjAbm, m_TaPropuesto, cscMfNrodoc
    
    End Select
    
  Else
    If Not Load(gDB.ValField(rs.Fields, 0)) Then Exit Function
    
    pRefreshProperties
  End If
  
  pMove = True
End Function

Private Sub pRefreshProperties()
  Dim c             As cIABMProperty
#If PREPROC_SFS Then
  Dim AbmGen        As cABMGeneric
#Else
  Dim AbmGen        As cABMGenericDocEx
#End If
  Dim Filter        As String
  Dim Cotizacion    As Double
  
  With m_ObjAbm.Properties
  
    Set c = .Item(cscDocId)
    c.HelpId = m_doc_id
    c.Value = m_Documento
    
    Set c = .Item(cscMfFecha)
    c.Value = m_Fecha
    
    Set c = .Item(cscCliId)
    c.HelpId = m_Cli_id
    c.Value = m_Cliente
    
    Set c = .Item(csDocNumberID)
    c.Value = m_Numero
    
    Set c = .Item(csDocEstateID)
    c.Value = m_Estado
    
    Set c = .Item(cscMfNrodoc)
    c.Value = m_Nrodoc
    c.TextMask = m_TaMascara
    c.TextAlign = vbRightJustify
    
    Set c = .Item(cscUsId)
    c.HelpId = m_Us_id
    c.Value = m_Usuario
    
    Set c = .Item(cscMfCotizacion)
    c.Value = m_Cotizacion
    
    Set c = .Item(cscCcosId)
    c.HelpId = m_ccos_id
    c.Value = m_CentroCosto
    
    Set c = .Item(cscSucId)
    c.HelpId = m_suc_id
    c.Value = m_Sucursal
    
    Set c = .Item(cscLgjId)
    c.HelpId = m_lgj_id
    c.Value = m_Legajo
    
    Set c = .Item(cscMfDescrip)
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
  
#If PREPROC_SFS Then
  Dim AbmObj As cABMGeneric
#Else
  Dim AbmObj As cABMGenericDocEx
#End If
  
  Set AbmObj = m_ObjAbm
  AbmObj.RefreshColumnProperties c, c_OrigenDebe
  AbmObj.RefreshColumnProperties c, c_OrigenHaber
  
  m_EfectivoDeleted = vbNullString
  
  Set c = m_Items.Properties.Item(c_Cheques)
  If Not pLoadCheques(c) Then Exit Sub
  
  m_ChequesDeleted = vbNullString
  
  Set c = m_Items.Properties.Item(c_ChequesT)
  If Not pLoadTCheques(c) Then Exit Sub
  
  m_TChequesDeleted = vbNullString
  
  Set c = m_Items.Properties.Item(c_ChequesI)
  If Not pLoadICheques(c) Then Exit Sub
  
  m_IChequesDeleted = vbNullString
  
  Set AbmGen = m_Items
  AbmGen.ShowValues m_Items.Properties
  
  Set c = m_Footer.Properties.Item(cscMfTotal)
  c.Value = m_Total
  
  Set AbmGen = m_Footer
  AbmGen.ShowValues m_Footer.Properties
  
  pSetEnabled
End Sub

' Construccion - Destruccion
Private Sub Class_Initialize()
  On Error GoTo ControlError
    
  c_ErrorSave = LNGGetText(2242, vbNullString) 'Error al grabar el Movimiento de Fondo
    
  Set m_GeneralConfig = New cGeneralConfig
  m_GeneralConfig.Load
  m_MonDefault = GetMonedaDefault()

  ' Preferencias del Usuario
  '
  Set m_UserCfg = New cUsuarioConfig
  m_UserCfg.Load
  m_UserCfg.ValidateMF

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

'------------------------------------------------------------------------------------------------
Private Function pSaveICheques(ByVal Id As Long) As Boolean
  Dim register  As cRegister
  Dim Row       As cIABMGridRow
  Dim Cell      As cIABMGridCellValue

  For Each Row In pGetICheques().Rows

    Set register = New cRegister
    register.fieldId = cscMfiTMPId
    register.Table = csTMovimientoFondoItemTMP
    register.Id = csNew

    For Each Cell In Row
      Select Case Cell.Key

        Case KICH_MFI_ID
          If m_Copy Then
            register.Fields.Add2 cscMfiId, csNew, csInteger
          Else
            register.Fields.Add2 cscMfiId, Val(Cell.Value), csInteger
          End If
        
        Case KICHT_DESCRIP
          register.Fields.Add2 cscMfiDescrip, Cell.Value, csText

        Case KICHT_CHEQUE
          register.Fields.Add2 cscMfiTMPCheque, Cell.Value, csText
        
        Case KICHT_CHEQ_ID
          register.Fields.Add2 cscCheqId, Cell.Id, csId

        Case KICHT_CLE_ID
          register.Fields.Add2 cscCleId, Cell.Id, csId

        Case KICHT_BCO_ID
          register.Fields.Add2 cscBcoId, Cell.Id, csId
        
        Case KICHT_MON_ID
          register.Fields.Add2 cscMonId, Cell.Id, csId

        Case KICHT_FECHACOBRO
          register.Fields.Add2 cscMfiTMPFechaCobro, Cell.Value, csDate

        Case KICHT_FECHAVTO
          register.Fields.Add2 cscMfiTMPFechaVto, Cell.Value, csDate

        Case KI_CUE_ID_DEBE
          register.Fields.Add2 cscCueIdDebe, Cell.Id, csId
        
        Case KI_CUE_ID_HABER
          register.Fields.Add2 cscCueIdHaber, Cell.Id, csId

        Case KICHT_IMPORTEORIGEN
          register.Fields.Add2 cscMfiImporteOrigen, Val(Cell.Value), csCurrency

        Case KICHT_IMPORTE
          register.Fields.Add2 cscMfiImporte, Val(Cell.Value), csCurrency
      
        Case KI_CCOS_ID
          register.Fields.Add2 cscCcosId, Cell.Id, csId
      End Select
    Next

    m_iOrden = m_iOrden + 1
    register.Fields.Add2 cscMfiOrden, m_iOrden, csInteger
    register.Fields.Add2 cscMfiTipo, csEMovimientoFondoItemTipo.csEMfiTChequesI, csInteger
    register.Fields.Add2 cscMfTMPId, Id, csId
    register.Fields.Add2 cscMfiId, csNew, csLong

    register.Fields.HaveLastUpdate = False
    register.Fields.HaveWhoModify = False

    If Not gDB.Save(register, , "pSaveICheques", C_Module, c_ErrorSave) Then Exit Function
  Next

  Dim sqlstmt As String

  If m_IChequesDeleted <> vbNullString And m_Id <> csNO_ID And Not m_Copy Then

    Dim vDeletes As Variant
    Dim i As Long

    m_IChequesDeleted = RemoveLastColon(m_IChequesDeleted)
    vDeletes = Split(m_IChequesDeleted, ",")

    For i = 0 To UBound(vDeletes)

      Set register = New cRegister
      register.fieldId = cscMfibTMPId
      register.Table = csTMovimientoFondoItemBorradoTMP
      register.Id = csNew

      register.Fields.Add2 cscMfiId, Val(vDeletes(i)), csInteger
      register.Fields.Add2 cscMfId, m_Id, csId
      register.Fields.Add2 cscMfTMPId, Id, csId

      register.Fields.HaveLastUpdate = False
      register.Fields.HaveWhoModify = False

      If Not gDB.Save(register, , "pSaveICheques", C_Module, c_ErrorSave) Then Exit Function
    Next

  End If

  pSaveICheques = True
End Function

Private Function pSaveTCheques(ByVal Id As Long) As Boolean
  Dim register  As cRegister
  Dim Row       As cIABMGridRow
  Dim Cell      As cIABMGridCellValue

  For Each Row In pGetTCheques().Rows

    Set register = New cRegister
    register.fieldId = cscMfiTMPId
    register.Table = csTMovimientoFondoItemTMP
    register.Id = csNew

    For Each Cell In Row
      Select Case Cell.Key

        Case KICH_MFI_ID
          If m_Copy Then
            register.Fields.Add2 cscMfiId, csNew, csInteger
          Else
            register.Fields.Add2 cscMfiId, Val(Cell.Value), csInteger
          End If
        Case KICHT_DESCRIP
          register.Fields.Add2 cscMfiDescrip, Cell.Value, csText

        Case KICHT_CHEQUE
          register.Fields.Add2 cscCheqId, Cell.Id, csId

        Case KICHT_CLE_ID
          register.Fields.Add2 cscCleId, Cell.Id, csId

        Case KICHT_MON_ID
          register.Fields.Add2 cscMonId, Cell.Id, csId

        Case KICHT_FECHACOBRO
          register.Fields.Add2 cscMfiTMPFechaCobro, Cell.Value, csDate

        Case KICHT_FECHAVTO
          register.Fields.Add2 cscMfiTMPFechaVto, Cell.Value, csDate

        Case KI_CUE_ID_DEBE
          register.Fields.Add2 cscCueIdDebe, Cell.Id, csId
        Case KI_CUE_ID_HABER
          register.Fields.Add2 cscCueIdHaber, Cell.Id, csId

        Case KICHT_IMPORTEORIGEN
          register.Fields.Add2 cscMfiImporteOrigen, Val(Cell.Value), csCurrency

        Case KICHT_IMPORTE
          register.Fields.Add2 cscMfiImporte, Val(Cell.Value), csCurrency
      
        Case KI_CCOS_ID
          register.Fields.Add2 cscCcosId, Cell.Id, csId
      End Select
    Next

    m_iOrden = m_iOrden + 1
    register.Fields.Add2 cscMfiOrden, m_iOrden, csInteger
    register.Fields.Add2 cscMfiTipo, csEMovimientoFondoItemTipo.csEMfiTChequesT, csInteger
    register.Fields.Add2 cscMfTMPId, Id, csId
    register.Fields.Add2 cscMfiId, csNew, csLong

    register.Fields.HaveLastUpdate = False
    register.Fields.HaveWhoModify = False

    If Not gDB.Save(register, , "pSaveTCheques", C_Module, c_ErrorSave) Then Exit Function
  Next

  Dim sqlstmt As String

  If m_TChequesDeleted <> vbNullString And m_Id <> csNO_ID And Not m_Copy Then

    Dim vDeletes As Variant
    Dim i As Long

    m_TChequesDeleted = RemoveLastColon(m_TChequesDeleted)
    vDeletes = Split(m_TChequesDeleted, ",")

    For i = 0 To UBound(vDeletes)

      Set register = New cRegister
      register.fieldId = cscMfibTMPId
      register.Table = csTMovimientoFondoItemBorradoTMP
      register.Id = csNew

      register.Fields.Add2 cscMfiId, Val(vDeletes(i)), csInteger
      register.Fields.Add2 cscMfId, m_Id, csId
      register.Fields.Add2 cscMfTMPId, Id, csId

      register.Fields.HaveLastUpdate = False
      register.Fields.HaveWhoModify = False

      If Not gDB.Save(register, , "pSaveTCheques", C_Module, c_ErrorSave) Then Exit Function
    Next

  End If

  pSaveTCheques = True
End Function

Private Function pSaveCheques(ByVal Id As Long) As Boolean
  Dim register  As cRegister
  Dim IProperty As cIABMProperty

  Dim Row  As cIABMGridRow
  Dim Cell As cIABMGridCellValue

  For Each Row In pGetCheques().Rows

    Set register = New cRegister
    register.fieldId = cscMfiTMPId
    register.Table = csTMovimientoFondoItemTMP
    register.Id = csNew

    For Each Cell In Row
      Select Case Cell.Key

        Case KICH_MFI_ID
          If m_Copy Then
            register.Fields.Add2 cscMfiId, csNew, csInteger
          Else
            register.Fields.Add2 cscMfiId, Val(Cell.Value), csInteger
          End If
        Case KICH_DESCRIP
          register.Fields.Add2 cscMfiDescrip, Cell.Value, csText

        Case KICH_CHEQUERA
          register.Fields.Add2 cscChqId, Cell.Id, csId

        Case KICH_CHEQUE
          register.Fields.Add2 cscMfiTMPCheque, Cell.Value, csText
        
        Case KICH_CHEQ_ID
          
          If m_Copy Then
            register.Fields.Add2 cscCheqId, csNO_ID, csId
          Else
            register.Fields.Add2 cscCheqId, Cell.Id, csId
          End If

        Case KICH_CLE_ID
          register.Fields.Add2 cscCleId, Cell.Id, csId

        Case KICH_MON_ID
          register.Fields.Add2 cscMonId, Cell.Id, csId
        Case KICH_FECHACOBRO
          register.Fields.Add2 cscMfiTMPFechaCobro, Cell.Value, csDate
        Case KICH_FECHAVTO
          register.Fields.Add2 cscMfiTMPFechaVto, Cell.Value, csDate

        Case KI_CUE_ID_DEBE
          register.Fields.Add2 cscCueIdDebe, Cell.Id, csId
        Case KI_CUE_ID_HABER
          register.Fields.Add2 cscCueIdHaber, Cell.Id, csId
        
        Case KICH_IMPORTEORIGEN
          register.Fields.Add2 cscMfiImporteOrigen, Val(Cell.Value), csCurrency
        Case KICH_IMPORTE
          register.Fields.Add2 cscMfiImporte, Val(Cell.Value), csCurrency
      
        Case KI_CCOS_ID
          register.Fields.Add2 cscCcosId, Cell.Id, csId
      End Select
    Next

    m_iOrden = m_iOrden + 1
    register.Fields.Add2 cscMfiOrden, m_iOrden, csInteger
    register.Fields.Add2 cscMfiTipo, csEMovimientoFondoItemTipo.csEMfiTCheques, csInteger
    register.Fields.Add2 cscMfTMPId, Id, csId

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
      register.fieldId = cscMfibTMPId
      register.Table = csTMovimientoFondoItemBorradoTMP
      register.Id = csNew

      register.Fields.Add2 cscMfiId, Val(vDeletes(i)), csInteger
      register.Fields.Add2 cscMfId, m_Id, csId
      register.Fields.Add2 cscMfTMPId, Id, csId

      register.Fields.HaveLastUpdate = False
      register.Fields.HaveWhoModify = False

      If Not gDB.Save(register, , "pSaveCheques", C_Module, c_ErrorSave) Then Exit Function
    Next

  End If

  pSaveCheques = True
End Function

Private Function pGetICheques() As cIABMGrid
  Set pGetICheques = m_Items.Properties.Item(c_ChequesI).Grid
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

Private Function pLoadICheques(ByRef Propiedad As cIABMProperty) As Boolean
  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  
  sqlstmt = "sp_DocMovimientoFondoGetItems " & m_Id & "," & csEMovimientoFondoItemTipo.csEMfiTChequesI
  
  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, "pLoadICheques", C_Module) Then Exit Function

  With Propiedad.Grid
    
    .Columns.Clear
    .Rows.Clear
    
    With .Columns
      
      With .Add(Nothing)
        .Visible = False
        .Key = KICHT_MFI_ID
      End With
    
      With .Add(Nothing)
        .Name = LNGGetText(2190, vbNullString)    'Cuenta Origen
        .PropertyType = cspHelp
        .Table = csCuenta
        
        '.HelpFilter = cscCuecId & "=" & csECuecDocEnCartera
        .HelpFilter = GetHelpFilterCuenta()
        
        .Width = 2200
        .Key = KI_CUE_ID_HABER
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(2191, vbNullString)    'Cuenta Destino
        .PropertyType = cspHelp
        .Table = csCuenta
        
        .HelpFilter = GetHelpFilterCheques()
        
        .Width = 1800
        .Key = KI_CUE_ID_DEBE
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(2063, vbNullString)    'Mon
        .PropertyType = cspHelp
        .Table = csMoneda
        .Width = 520
        .Key = KICHT_MON_ID
        .Enabled = False
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(1901, vbNullString)    'Origen
        .PropertyType = cspNumeric
        .Format = m_GeneralConfig.FormatDecImporte
        .SubType = cspMoney
        .Width = 920
        .Key = KICHT_IMPORTEORIGEN
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(1228, vbNullString)    'Importe
        .PropertyType = cspNumeric
        .Format = m_GeneralConfig.FormatDecImporte
        .SubType = cspMoney
        .Width = 920
        .Key = KICHT_IMPORTE
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(1122, vbNullString)    'Banco
        .PropertyType = cspHelp
        .Table = csBanco
        .Width = 2000
        .Key = KICHT_BCO_ID
      End With
      
      With .Add(Nothing, c_ChequeT)
        .Name = LNGGetText(2059, vbNullString)    'Nr. Cheque
        .PropertyType = cspText
        .Width = 1000
        .Key = KICHT_CHEQUE
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(2058, vbNullString)    'Cheque
        .PropertyType = cspText
        .Width = 1000
        .Key = KICHT_CHEQ_ID
        .Enabled = False
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(2065, vbNullString)    'Depositar el
        .PropertyType = cspDate
        Set .DefaultValue = New cABMGridRowValue
        .DefaultValue.Value = Date
        .Width = 970
        .Key = KICHT_FECHACOBRO
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(1634, vbNullString)    'Vto.
        .PropertyType = cspDate
        .Width = 970
        Set .DefaultValue = New cABMGridRowValue
        .DefaultValue.Value = DateAdd("m", 1, Date)
        .Key = KICHT_FECHAVTO
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(1083, vbNullString)    'Clering
        .PropertyType = cspHelp
        .Table = csClearing
        .Width = 800
        .Key = KICHT_CLE_ID
      End With
      
      With .Add(Nothing)
        .Name = C_strDescrip
        .PropertyType = cspText
        .SubType = cspTextButtonEx
        .Width = 1600
        .Key = KICHT_DESCRIP
      End With
    
      With .Add(Nothing)
        .Name = LNGGetText(1057, vbNullString)    'Centro de Costo
        .PropertyType = cspHelp
        .Table = csCentroCosto
        .Width = 1800
        .Key = KI_CCOS_ID
      End With
    
    End With
    
    With .Rows
  
      While Not rs.EOF
      
        With .Add(Nothing, rs(cscMfiId).Value)
        
          With .Add(Nothing)
            .Value = gDB.ValField(rs.Fields, cscMfiId)
            .Key = KICHT_MFI_ID
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.Fields, "Haber")
            .Id = gDB.ValField(rs.Fields, cscCueIdHaber)
            .Key = KI_CUE_ID_HABER
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.Fields, "Debe")
            .Id = gDB.ValField(rs.Fields, cscCueIdDebe)
            .Key = KI_CUE_ID_DEBE
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.Fields, cscMonNombre)
            .Id = gDB.ValField(rs.Fields, cscMonId)
            .Key = KICHT_MON_ID
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.Fields, cscMfiImporteOrigen)
            .Key = KICHT_IMPORTEORIGEN
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.Fields, cscMfiImporte)
            .Key = KICHT_IMPORTE
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.Fields, cscBcoNombre)
            .Id = gDB.ValField(rs.Fields, cscBcoId)
            .Key = KICHT_BCO_ID
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.Fields, cscCheqNumeroDoc)
            .Key = KICHT_CHEQUE
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.Fields, cscCheqNumero)
            .Id = gDB.ValField(rs.Fields, cscCheqId)
            .Key = KICHT_CHEQ_ID
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
            .Value = gDB.ValField(rs.Fields, cscMfiDescrip)
            .Key = KICH_DESCRIP
          End With
        
          With .Add(Nothing)
            .Value = gDB.ValField(rs.Fields, cscCcosNombre)
            .Id = gDB.ValField(rs.Fields, cscCcosId)
            .Key = KI_CCOS_ID
          End With
        End With
        
        rs.MoveNext
      Wend
    End With
  End With
  
  pLoadICheques = True
End Function

Private Function pLoadTCheques(ByRef Propiedad As cIABMProperty) As Boolean
  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  
  sqlstmt = "sp_DocMovimientoFondoGetItems " & m_Id & "," & csEMovimientoFondoItemTipo.csEMfiTChequesT
  
  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, "pLoadTCheques", C_Module) Then Exit Function

  With Propiedad.Grid
    
    .Columns.Clear
    .Rows.Clear
    
    With .Columns
      
      With .Add(Nothing)
        .Visible = False
        .Key = KICHT_MFI_ID
      End With
    
      With .Add(Nothing)
        .Name = LNGGetText(2190, vbNullString)    'Cuenta Origen
        .PropertyType = cspHelp
        .Table = csCuenta
        
        '.HelpFilter = cscCuecId & "=" & csECuecDocEnCartera
        .HelpFilter = GetHelpFilterChequesT()
        
        .Width = 2200
        .Key = KI_CUE_ID_HABER
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(2191, vbNullString)    'Cuenta Destino
        .PropertyType = cspHelp
        .Table = csCuenta
        .Width = 1800
        .Key = KI_CUE_ID_DEBE
      End With
      
      With .Add(Nothing, c_ChequeT)
        .Name = LNGGetText(2059, vbNullString)    'Nr. Cheque
        .PropertyType = cspHelp
        .Table = csCheque
        .HelpFilter = "1 = 2"
        .SubType = cspInteger
        .Width = 1000
        .Key = KICHT_CHEQUE
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(1150, vbNullString)    'Cliente
        .PropertyType = cspText
        .Width = 2000
        .Key = KICHT_CLI_ID
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(1122, vbNullString)    'Banco
        .PropertyType = cspText
        .Width = 2000
        .Key = KICHT_BCO_ID
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(2063, vbNullString)    'Mon
        .PropertyType = cspHelp
        .Table = csMoneda
        .Width = 520
        .Key = KICHT_MON_ID
        .Enabled = False
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(1901, vbNullString)    'Origen
        .PropertyType = cspNumeric
        .Format = m_GeneralConfig.FormatDecImporte
        .SubType = cspMoney
        .Width = 920
        .Key = KICHT_IMPORTEORIGEN
        .Enabled = False
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(1228, vbNullString)    'Importe
        .PropertyType = cspNumeric
        .Format = m_GeneralConfig.FormatDecImporte
        .SubType = cspMoney
        .Width = 920
        .Key = KICHT_IMPORTE
        .Enabled = False
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(2065, vbNullString)    'Depositar el
        .PropertyType = cspDate
        .Width = 970
        .Key = KICHT_FECHACOBRO
        .Enabled = False
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(1634, vbNullString)    'Vto.
        .PropertyType = cspDate
        .Width = 970
        .Key = KICHT_FECHAVTO
        .Enabled = False
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(1083, vbNullString)    'Clering
        .PropertyType = cspHelp
        .Table = csClearing
        .Width = 800
        .Key = KICHT_CLE_ID
        .Enabled = False
      End With
      
      With .Add(Nothing)
        .Name = C_strDescrip
        .PropertyType = cspText
        .SubType = cspTextButtonEx
        .Width = 1600
        .Key = KICHT_DESCRIP
      End With
    
      With .Add(Nothing)
        .Name = LNGGetText(1057, vbNullString)    'Centro de Costo
        .PropertyType = cspHelp
        .Table = csCentroCosto
        .Width = 1800
        .Key = KI_CCOS_ID
      End With
    End With
    
    With .Rows
  
      While Not rs.EOF
      
        With .Add(Nothing, rs(cscMfiId).Value)
        
          With .Add(Nothing)
            .Value = gDB.ValField(rs.Fields, cscMfiId)
            .Key = KICHT_MFI_ID
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.Fields, "Haber")
            .Id = gDB.ValField(rs.Fields, cscCueIdHaber)
            .Key = KI_CUE_ID_HABER
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.Fields, "Debe")
            .Id = gDB.ValField(rs.Fields, cscCueIdDebe)
            .Key = KI_CUE_ID_DEBE
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.Fields, cscCheqNumeroDoc)
            .Id = gDB.ValField(rs.Fields, cscCheqId)
            .Key = KICHT_CHEQUE
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.Fields, cscCliNombre)
            .Key = KICHT_CLI_ID
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.Fields, cscBcoNombre)
            .Key = KICHT_BCO_ID
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.Fields, cscMonNombre)
            .Id = gDB.ValField(rs.Fields, cscMonId)
            .Key = KICHT_MON_ID
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.Fields, cscMfiImporteOrigen)
            .Key = KICHT_IMPORTEORIGEN
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.Fields, cscMfiImporte)
            .Key = KICHT_IMPORTE
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
            .Key = KICH_CLE_ID
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.Fields, cscMfiDescrip)
            .Key = KICH_DESCRIP
          End With
        
          With .Add(Nothing)
            .Value = gDB.ValField(rs.Fields, cscCcosNombre)
            .Id = gDB.ValField(rs.Fields, cscCcosId)
            .Key = KI_CCOS_ID
          End With
        End With
        
        rs.MoveNext
      Wend
    End With
  End With
  
  pLoadTCheques = True
End Function

Private Function pLoadCheques(ByRef Propiedad As cIABMProperty) As Boolean
  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  
  sqlstmt = "sp_DocMovimientoFondoGetItems " & m_Id & "," & csEMovimientoFondoItemTipo.csEMfiTCheques
  
  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, "pLoadCheques", C_Module) Then Exit Function
  
  With Propiedad.Grid
    
    .Columns.Clear
    .Rows.Clear
    
    With .Columns
    
      With .Add(Nothing)
        .Visible = False
        .Key = KICH_MFI_ID
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
      
      With .Add(Nothing)
        .Name = LNGGetText(2191, vbNullString)    'Cuenta Destino
        .PropertyType = cspHelp
        .Table = csCuenta
        .Width = 1800
        .Key = KI_CUE_ID_DEBE
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
      
      With .Add(Nothing, c_Chequera)
        .Name = LNGGetText(2064, vbNullString)    'Chequera
        .PropertyType = cspHelp
        .Table = csChequera
        .Width = 1000
        .Key = KICH_CHEQUERA
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
    
      With .Add(Nothing)
        .Name = LNGGetText(1057, vbNullString)    'Centro de Costo
        .PropertyType = cspHelp
        .Table = csCentroCosto
        .Width = 1800
        .Key = KI_CCOS_ID
      End With
    
    End With
    
    With .Rows
    
      While Not rs.EOF
        
        With .Add(Nothing, rs(cscMfiId).Value)
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.Fields, cscMfiId)
            .Key = KICH_MFI_ID
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.Fields, "Haber")
            .Id = gDB.ValField(rs.Fields, cscCueIdHaber)
            .Key = KI_CUE_ID_HABER
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.Fields, "Debe")
            .Id = gDB.ValField(rs.Fields, cscCueIdDebe)
            .Key = KI_CUE_ID_DEBE
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.Fields, cscMonNombre)
            .Id = gDB.ValField(rs.Fields, cscMonId)
            .Key = KICH_MON_ID
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.Fields, cscMfiImporteOrigen)
            .Key = KICH_IMPORTEORIGEN
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.Fields, cscMfiImporte)
            .Key = KICH_IMPORTE
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.Fields, cscChqCodigo)
            .Id = gDB.ValField(rs.Fields, cscChqId)
            .Key = KICH_CHEQUERA
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
            .Value = gDB.ValField(rs.Fields, cscMfiDescrip)
            .Key = KICH_DESCRIP
          End With
        
          With .Add(Nothing)
            .Value = gDB.ValField(rs.Fields, cscCcosNombre)
            .Id = gDB.ValField(rs.Fields, cscCcosId)
            .Key = KI_CCOS_ID
          End With
        End With
        
        rs.MoveNext
      Wend
    End With
  End With
  
  pLoadCheques = True
End Function

Private Function pColAUpdateICheque(ByRef IProperty As cIABMProperty, _
                                    ByVal lRow As Long, _
                                    ByVal lCol As Long) As Boolean
  Dim Row      As cIABMGridRow
  Dim Value    As Double
  
  With IProperty.Grid
    
    Select Case .Columns(lCol).Key
      
      Case KICHT_IMPORTEORIGEN
        Set Row = .Rows(lRow)
        With pCell(Row, KICHT_MON_ID)
          If .Id <> m_MonDefault Or .Id = 0 Then
            pCell(Row, KICHT_IMPORTE).Value = Val(pCell(Row, KICHT_IMPORTEORIGEN).Value) * Val(pGetCotizacion().Value)
          Else
            pCell(Row, KICHT_IMPORTEORIGEN).Value = 0
          End If
        End With
      
      Case KI_CUE_ID_DEBE
        Dim MonId   As Long
        Dim CueId   As Long
        Dim Moneda  As String
        
        Set Row = .Rows(lRow)
        
        CueId = pCell(Row, KI_CUE_ID_DEBE).Id
        GetMonedaFromCuenta MonId, Moneda, CueId
        
        With pCell(Row, KICHT_MON_ID)
          .Value = Moneda
          .Id = MonId
        End With
      
        If MonId = m_MonDefault Or MonId = 0 Then
          pCell(Row, KICHT_IMPORTEORIGEN).Value = 0
        End If
        
        pCol(IProperty.Grid.Columns, _
             KICHT_CHEQUE).HelpFilter = GetChequeFileter(CueId)
        
#If PREPROC_SFS Then
        Dim AbmObj As cABMGeneric
#Else
        Dim AbmObj As cABMGenericDocEx
#End If
        Set AbmObj = m_Items
        AbmObj.RefreshColumnProperties IProperty, c_ChequeT
        
        pColAUpdateICheque = True
        Exit Function
      
      Case KICHT_IMPORTE
        
        pShowTotales
      
        pColAUpdateICheque = True
        Exit Function
      
      Case Else
        pColAUpdateICheque = True
        Exit Function
    End Select
  End With
  
  pColAUpdateICheque = True
End Function

Private Function pColAUpdateTCheque(ByRef IProperty As cIABMProperty, _
                                    ByVal lRow As Long, _
                                    ByVal lCol As Long) As Boolean
  Dim Row      As cIABMGridRow
  Dim Value    As Double
  
  With IProperty.Grid
    
    Select Case .Columns(lCol).Key
      
      Case KICHT_IMPORTEORIGEN
        Set Row = .Rows(lRow)
        With pCell(Row, KICHT_MON_ID)
          If .Id <> m_MonDefault Or .Id = 0 Then
            pCell(Row, KICHT_IMPORTE).Value = Val(pCell(Row, KICHT_IMPORTEORIGEN).Value) * Val(pGetCotizacion().Value)
          Else
            pCell(Row, KICHT_IMPORTEORIGEN).Value = 0
          End If
        End With
      
      Case KI_CUE_ID_HABER
        Dim MonId   As Long
        Dim CueId   As Long
        Dim Moneda  As String
        
        Set Row = .Rows(lRow)
        
        CueId = pCell(Row, KI_CUE_ID_HABER).Id
        GetMonedaFromCuenta MonId, Moneda, CueId
        
        With pCell(Row, KICHT_MON_ID)
          .Value = Moneda
          .Id = MonId
        End With
      
        If MonId = m_MonDefault Or MonId = 0 Then
          pCell(Row, KICHT_IMPORTEORIGEN).Value = 0
        End If
        
        pCol(IProperty.Grid.Columns, _
             KICHT_CHEQUE).HelpFilter = GetChequeFileter(CueId)
        
#If PREPROC_SFS Then
        Dim AbmObj As cABMGeneric
#Else
        Dim AbmObj As cABMGenericDocEx
#End If
        Set AbmObj = m_Items
        AbmObj.RefreshColumnProperties IProperty, c_ChequeT
        
        pColAUpdateTCheque = True
        Exit Function
      
      Case KICHT_CHEQUE
        Set Row = .Rows(lRow)
        SetChequeData Row, pCell(Row, KICHT_CHEQUE).Id
      
        pShowTotales
      
        pColAUpdateTCheque = True
        Exit Function
      
      Case Else
        pColAUpdateTCheque = True
        Exit Function
    End Select
  End With
  
  pColAUpdateTCheque = True
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

Private Function pValidateRowICheques(ByRef Row As CSInterfacesABM.cIABMGridRow, _
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
      
      Case KI_CUE_ID_DEBE
        If ValEmpty(Cell.Id, csId) Then
          MsgInfo LNGGetText(2187, vbNullString, strRow)   'Debe indicar una cuenta destino (1)
          Exit Function
        End If
    
      Case KICHT_BCO_ID
        If ValEmpty(Cell.Id, csId) Then
          MsgInfo LNGGetText(2094, vbNullString, strRow)   'Debe indicar un banco (1)
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
      
      Case KICH_CHEQUE
        If ValEmpty(Cell.Value, csText) Then
          MsgInfo LNGGetText(2116, vbNullString, strRow)   'Debe indicar una número de cheque (1)
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
  
  pValidateRowICheques = True
End Function

Private Function pValidateRowTCheques(ByRef Row As CSInterfacesABM.cIABMGridRow, _
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
      
      Case KI_CUE_ID_DEBE
        If ValEmpty(Cell.Id, csId) Then
          MsgInfo LNGGetText(2187, vbNullString, strRow)   'Debe indicar una cuenta destino (1)
          Exit Function
        End If
    
    End Select
  Next
  
  pValidateRowTCheques = True
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
      Case KI_CUE_ID_DEBE
        If ValEmpty(Cell.Id, csId) Then
          MsgInfo LNGGetText(2187, vbNullString, strRow)   'Debe indicar una cuenta destino (1)
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
          MsgInfo LNGGetText(2116, vbNullString, strRow)   'Debe indicar una número de cheque (1)
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

Private Function pIsEmptyRowICheques(ByRef Row As CSInterfacesABM.cIABMGridRow, _
                                     ByVal RowIndex As Long) As Boolean
                                     
  Dim Cell                  As cIABMGridCellValue
  Dim strRow                As String
  Dim bRowIsEmpty           As Boolean
  
  strRow = " (Fila " & RowIndex & ")"
  
  bRowIsEmpty = True
  
  For Each Cell In Row
    Select Case Cell.Key
      Case KI_CUE_ID_HABER, KICHT_MON_ID, KICHT_CLE_ID, KI_CUE_ID_DEBE, _
           KICHT_BCO_ID, KICHT_CLE_ID
           
        If Not ValEmpty(Cell.Id, csId) Then
          bRowIsEmpty = False
          Exit For
        End If
    
      Case KICHT_IMPORTE, KICHT_IMPORTEORIGEN
        If Not ValEmpty(Val(Cell.Value), csDouble) Then
          bRowIsEmpty = True
          Exit For
        End If
      
      Case KICHT_DESCRIP, KICHT_CHEQUE
        If Not ValEmpty(Cell.Value, csText) Then
          bRowIsEmpty = True
          Exit For
        End If
    End Select
  Next
  
  pIsEmptyRowICheques = bRowIsEmpty
End Function

Private Function pIsEmptyRowTCheques(ByRef Row As CSInterfacesABM.cIABMGridRow, _
                                     ByVal RowIndex As Long) As Boolean
                                     
  Dim Cell                  As cIABMGridCellValue
  Dim strRow                As String
  Dim bRowIsEmpty           As Boolean
  
  strRow = " (Fila " & RowIndex & ")"
  
  bRowIsEmpty = True
  
  For Each Cell In Row
    Select Case Cell.Key
      Case KI_CUE_ID_HABER, KICHT_MON_ID, KICHT_CLE_ID
        If Not ValEmpty(Cell.Id, csId) Then
          bRowIsEmpty = False
          Exit For
        End If
    
      Case KICHT_IMPORTE, KICHT_IMPORTEORIGEN
        If Not ValEmpty(Val(Cell.Value), csDouble) Then
          bRowIsEmpty = True
          Exit For
        End If
      
      Case KICHT_DESCRIP, KICHT_CHEQUE
        If Not ValEmpty(Cell.Value, csText) Then
          bRowIsEmpty = True
          Exit For
        End If
    End Select
  Next
  
  pIsEmptyRowTCheques = bRowIsEmpty
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

Private Function pGetCotizacion() As cIABMProperty
  Set pGetCotizacion = m_ObjAbm.Properties.Item(cscMfCotizacion)
End Function

Private Function pIsMonDefault(ByVal Cue_id As Long) As Boolean
  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  
  sqlstmt = "select moneda.mon_id from cuenta, moneda" & _
            " where cuenta.mon_id = moneda.mon_id " & _
            " and cue_id = " & Cue_id & _
            " and mon_legal <> 0"
  
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Function
  
  pIsMonDefault = Not rs.EOF
End Function


