VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cOrdenPago"
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
' cOrdenPago
' 27-01-2004

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cOrdenPago"

Private Const c_Cheques = "Cheques"
Private Const c_ChequesT = "Cheque de Tercero"
Private Const c_Efectivo = "Efectivo"
Private Const c_Otros = "Otros"
Private Const c_CtaCte = "Cuenta Corriente"

Private Const c_Chequera = "Chequera"
Private Const c_ChequeT = "chqt"

Private Const K_NUMERO                         As Integer = 1
Private Const K_NRODOC                         As Integer = 2
Private Const K_DESCRIP                        As Integer = 3
Private Const K_FECHA                          As Integer = 4
Private Const K_NETO                           As Integer = 6
Private Const K_TOTAL                          As Integer = 9
Private Const K_PROV_ID                        As Integer = 10
Private Const K_DOC_ID                         As Integer = 11
Private Const K_DOCT_ID                        As Integer = 12
Private Const K_CHEQUES                        As Integer = 15
Private Const K_CHEQUEST                       As Integer = 16
Private Const K_EST_ID                         As Integer = 17
Private Const K_CCOS_ID                        As Integer = 18
Private Const K_SUC_ID                         As Integer = 19
Private Const K_OTROS                          As Integer = 24
Private Const K_COTIZACION                     As Integer = 25
Private Const K_LGJ_ID                         As Integer = 27
Private Const K_EFECTIVO                       As Integer = 28
Private Const K_CTACTE                         As Integer = 30

Private Const KI_IMPORTE                     As Integer = 1
Private Const KI_FECHA                       As Integer = 4
Private Const KI_DESCRIP                     As Integer = 6
Private Const KI_DOC                         As Integer = 7
Private Const KI_PENDIENTE                   As Integer = 8
Private Const KI_VTO                         As Integer = 9
Private Const KI_TOTAL                       As Integer = 10
Private Const KI_COTIZACION                  As Integer = 11
Private Const KI_NRODOC                      As Integer = 12
Private Const KI_IMPORTEORIGEN               As Integer = 13
Private Const KI_MONEDA                      As Integer = 14
Private Const KI_COTIZACION2                 As Integer = 15
Private Const KI_FVD_ID                      As Integer = 16

Private Const KIO_OPGI_ID                    As Integer = 1
Private Const KIO_CUE_ID                     As Integer = 2
Private Const KIO_DEBE                       As Integer = 3
Private Const KIO_HABER                      As Integer = 4
Private Const KIO_IMPORTEORIGEN              As Integer = 5
Private Const KIO_DESCRIP                    As Integer = 6
Private Const KIO_RET_ID                     As Integer = 7
Private Const KIO_NRORETENCION               As Integer = 8
Private Const KIO_PORCRETENCION              As Integer = 9
Private Const KIO_FECHARETENCION             As Integer = 10
Private Const KIO_CCOS_ID                    As Integer = 11
Private Const KIO_FC_ID_RET                  As Integer = 12

Private Const KICH_OPGI_ID              As Integer = 1
Private Const KICH_CUE_ID                As Integer = 2
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

Private Const KIE_OPGI_ID               As Integer = 1
Private Const KIE_CUE_ID                 As Integer = 2
Private Const KIE_MON_ID                 As Integer = 3
Private Const KIE_IMPORTE                As Integer = 4
Private Const KIE_IMPORTEORIGEN          As Integer = 5
Private Const KIE_DESCRIP                As Integer = 6

Private Const KICC_OPGI_ID               As Integer = 1
Private Const KICC_CUE_ID                 As Integer = 2
Private Const KICC_IMPORTE                As Integer = 3
Private Const KICC_IMPORTEORIGEN          As Integer = 4

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
Private m_Neto                         As Double
Private m_Otros                        As Double
Private m_Total                        As Double
Private m_lgj_id                       As Long
Private m_Legajo                       As String

Private m_Cotizacion                   As Double
Private m_ccos_id                      As Long
Private m_CentroCosto                  As String
Private m_suc_id                       As Long
Private m_Sucursal                     As String
Private m_Prov_id                      As Long
Private m_Proveedor                    As String
Private m_doc_id                       As Long
Private m_Documento                    As String
Private m_Doct_id                      As Long
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

Private m_ChequesDeleted      As String
Private m_TChequesDeleted     As String
Private m_EfectivoDeleted     As String
Private m_OtrosDeleted        As String
Private m_CtaCteDeleted       As String

Private m_Copy              As Boolean

Private m_GeneralConfig     As cGeneralConfig

Private m_DocEditable       As Boolean
Private m_DocEditMsg        As String

Private m_TaPropuesto       As Boolean
Private m_TaMascara         As String

Private m_iOrden            As Long

Private m_ObjApply          As cOrdenPagoAplic

Private m_FcIds()           As Long
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
'  On Error Resume Next
'  If Id <> csNO_ID Then
'    cIEditGeneric_Edit Id
'  End If
  m_Id = Id
  cIABMClient_Terminate
End Function

Public Sub ShowOrdenPago(ByVal ProvId As Long, ByRef vFcIds() As Long)
  On Error GoTo ControlError

  m_Prov_id = ProvId
  gDB.GetData csTProveedor, cscProvId, ProvId, cscProvNombre, m_Proveedor
  
  Dim i As Long
  ReDim m_FcIds(UBound(vFcIds) + 1)
  For i = 1 To UBound(vFcIds) + 1
    m_FcIds(i) = vFcIds(i - 1)
  Next
  
  If Not pInitMembers Then
    Exit Sub
  End If
  
  pShowStartWizard

  GoTo ExitProc
ControlError:
  MngError Err, "ShowOrdenPago", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Function pInitMembers() As Boolean
  Set cIEditGeneric_ObjAbm = New cABMGeneric
  Set cIEditGenericDoc_Footer = New cABMGeneric
  Set cIEditGenericDoc_Items = New cABMGeneric
  
  If Not DocSecurityCanAccess(csPreTsrNewOrdenPago, _
                              csNO_ID, _
                              csEDocTPreNew) Then
    Exit Function
  End If
  pInitMembers = True
End Function

' Implementacion de cIABMClient
Private Function cIABMClient_Copy() As Boolean

  If Not DocSecurityCanAccessEx(csPreTsrNewOrdenPago, _
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
  GetDocNumber m_LastDoc, m_ObjAbm, m_TaPropuesto, cscOpgNrodoc
  pSetEnabled
  
  ' Limpio los ids de cheques ya que no puedo reutilizar
  ' ni cheques propios ni de tercero
  pClearCheqId
  
End Function

Private Function cIABMClient_EditNew() As Boolean
  Dim Mouse As cMouseWait
  Set Mouse = New cMouseWait
  cIEditGeneric_Edit csNO_ID

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
  GetDocNumber m_LastDoc, m_ObjAbm, m_TaPropuesto, cscOpgNrodoc
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

  Doc.ClientTable = csTOrdenPago
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
        Case K_CHEQUES, K_CHEQUEST, K_EFECTIVO
          pShowPagoNeto
        Case K_OTROS
          pShowPagoOtro
      End Select
      pShowPagoTotal
      
    Case MSG_DOC_EDIT_STATE
      ShowEditState m_DocEditMsg, LNGGetText(1922, vbNullString) 'Orden de pago
    
    Case MSG_DOC_APPLY
      pShowApply
    
    Case MSG_DOC_DELETE
      If cIEditGeneric_Delete(m_Id) Then
        cIABMClient_MessageEx = True
        pMove MSG_DOC_NEXT
      End If
    
    Case MSG_DOC_ANULAR
      DocAnular m_Id, m_est_id, m_Estado, csPreTsrAnularOrdenPago, csPreTsrDesAnularOrdenPago, m_ObjAbm, m_DocEditable, m_DocEditMsg, "sp_DocOrdenPagoAnular", "sp_DocOrdenPagoEditableGet"
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
      DocumentSearch csEDT_OrdenPago, Me, Not CBool(Info)
  
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
        
          MsgInfo LNGGetText(1555, vbNullString) 'Este documento puede editarse normalmente
        Else
          
          If DocCanSave(m_ObjAbm, cscOpgFecha) Then
            
            Dim EditDoc As cEditDocEx
            Set EditDoc = New cEditDocEx
            
            Set EditDoc.ObjectClient = Me
            EditDoc.Edit m_Id, _
                         m_Doct_id, _
                         csTOrdenPago, _
                         cscOpgId, _
                         csTOrdenPagoItem, _
                         cscOpgiId, _
                         csPreTsrNewOrdenPago, _
                         csPreTsrEditOrdenPago, _
                         csNO_ID, m_Prov_id, _
                         True
          End If
          
        End If
      
      Else
        MsgInfo LNGGetText(1556, vbNullString)
                'Esta opción solo sirve para modificar documentos guardados y aplicados
      End If
      
    Case MSG_DOC_HISTORY
    
      If m_Id <> csNO_ID Then
    
        ShowHistory csOrdenPago, m_Id, m_Documento & " " & m_Nrodoc
      Else
        
        MsgInfo LNGGetText(1552, vbNullString) 'El documento aun no ha sido guardado
      End If
  
    Case MSG_EXPORT_GET_EMAIL
    
      cIABMClient_MessageEx = GetEmailFromProveedor(pGetProveedor())
  
    Case MSG_EXPORT_GET_FILE_NAME_POSTFIX
      
      cIABMClient_MessageEx = pGetFileNamePostFix()
  
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
        GetDocNumber m_LastDoc, m_ObjAbm, m_TaPropuesto, cscOpgNrodoc
        
      End If
      
      ' Defino el estado de edicion del comprobante
      '
      pSetEnabled
    
    Case K_PROV_ID
    
      pSetFilterColFactura
      
  End Select
End Function

Private Function cIABMClient_Save() As Boolean
  Dim register     As cRegister
  
  ' Save and State
  '
  If Not DocCanEdit(m_DocEditable, m_DocEditMsg) Then
    cIABMClient_Save = True
    Exit Function
  End If
  If Not DocCanSave(m_ObjAbm, cscOpgFecha) Then
    cIABMClient_Save = False
    Exit Function
  End If
  
  ' OJO -tsr
  If pGetCheques().Rows.count = 0 And _
     pGetTCheques().Rows.count = 0 And _
     pGetEfectivo().Rows.count = 0 And _
     pGetOtros().Rows.count = 0 Then
     
    MsgWarning LNGGetText(3903, vbNullString) 'El documento debe contener al menos un item
    cIABMClient_Save = False
    Exit Function
  End If
  
  Dim Mouse As cMouseWait
  Set Mouse = New cMouseWait
  
  DoEvents: DoEvents: DoEvents: DoEvents
  
  Set register = New cRegister
  register.fieldId = cscOpgTMPId
  register.Table = csTOrdenPagoTMP
  
  register.Id = csNew
    
  If m_Copy Then
    register.Fields.Add2 cscOpgId, csNew, csLong
  Else
    register.Fields.Add2 cscOpgId, m_Id, csLong
  End If
  
  If register.Id = csNew Then
    m_est_id = CSGeneralEx2.csEEstado.csEEst_Pendiente
  End If
  
  Dim IProperty As cIABMProperty
  For Each IProperty In m_ObjAbm.Properties
    With IProperty
      Select Case .Key
        Case K_NUMERO
          register.Fields.Add2 cscOpgNumero, .Value, csLong
        Case K_NRODOC
          register.Fields.Add2 cscOpgNrodoc, .Value, csText
        Case K_DESCRIP
          register.Fields.Add2 cscOpgDescrip, .Value, csText
        Case K_FECHA
          register.Fields.Add2 cscOpgFecha, .Value, csDate
        Case K_PROV_ID
          register.Fields.Add2 cscProvId, .HelpId, csId
        Case K_CCOS_ID
          register.Fields.Add2 cscCcosId, .HelpId, csId
        Case K_SUC_ID
          register.Fields.Add2 cscSucId, .HelpId, csId
        Case K_DOC_ID
          register.Fields.Add2 cscDocId, .HelpId, csId
        Case K_COTIZACION
          register.Fields.Add2 cscOpgCotizacion, .Value, csDouble
        Case K_LGJ_ID
          register.Fields.Add2 cscLgjId, .HelpId, csId
      End Select
    End With
  Next
  
  For Each IProperty In m_Footer.Properties
    With IProperty
      Select Case .Key
        Case K_NETO
          register.Fields.Add2 cscOpgNeto, Val(.Value), csCurrency
        Case K_OTROS
          register.Fields.Add2 cscOpgOtros, Val(.Value), csCurrency
        Case K_TOTAL
          register.Fields.Add2 cscOpgTotal, Val(.Value), csCurrency
      End Select
    End With
  Next
  
  register.Fields.Add2 cscOpgGrabarAsiento, 1, csBoolean
  register.Fields.Add2 cscEstId, m_est_id, csId
  
  register.Fields.HaveLastUpdate = True
  register.Fields.HaveWhoModify = True
  
  If Not register.BeginTrans(gDB) Then Exit Function
  
  If Not gDB.Save(register, , "cIABMClient_Save", C_Module, c_ErrorSave) Then Exit Function
  
  m_iOrden = 0
  
  If Not pSaveCheques(register.Id) Then Exit Function
  If Not pSaveTCheques(register.Id) Then Exit Function
  If Not pSaveEfectivo(register.Id) Then Exit Function
  If Not pSaveOtros(register.Id) Then Exit Function
  If Not pSaveCtaCte(register.Id) Then Exit Function
  
  If Not register.CommitTrans() Then Exit Function
  
  Dim sqlstmt As String
  Dim rs      As Recordset
  sqlstmt = "sp_DocOrdenPagoSave " & register.Id
  
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
  
  m_ObjTree.sqlstmt = "sp_lsdoc_OrdenPago"
  
  If m_IsNew Then
    m_ObjTree.AddLine m_Id
  Else
    m_ObjTree.RefreshLine m_Id
  End If
ControlError:
End Function

Private Property Get cIABMClient_Title() As String
  cIABMClient_Title = LNGGetText(1922, vbNullString) 'Orden de pago
End Property

Private Function cIABMClient_Validate() As Boolean
  Dim IProperty    As cIABMProperty

  For Each IProperty In m_ObjAbm.Properties
    With IProperty
      Select Case .Key
        Case K_FECHA
          If ValEmpty(.Value, csDate) Then
            MsgInfo LNGGetText(1558, vbNullString) 'Debe indicar una fecha
            Exit Function
          End If
        Case K_PROV_ID
          If ValEmpty(.HelpId, csId) Then
            MsgInfo LNGGetText(1860, vbNullString) 'Debe indicar un Proveedor
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
      End Select
    End With
  Next

  cIABMClient_Validate = True
End Function

Private Function cIABMClientGrid_IsEmptyRow(ByVal Key As Integer, Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  On Error GoTo ControlError

  Select Case Key
    Case K_CHEQUES
      cIABMClientGrid_IsEmptyRow = pIsEmptyRowCheques(Row, RowIndex)
    Case K_CHEQUEST
      cIABMClientGrid_IsEmptyRow = pIsEmptyRowTCheques(Row, RowIndex)
    Case K_OTROS
      cIABMClientGrid_IsEmptyRow = pIsEmptyRowOtros(Row, RowIndex)
    Case K_EFECTIVO
      cIABMClientGrid_IsEmptyRow = pIsEmptyRowEfectivo(Row, RowIndex)
    Case K_CTACTE
      cIABMClientGrid_IsEmptyRow = pIsEmptyRowCtaCte(Row, RowIndex)
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
  
  sqlstmt = "select doct_id, doc_id from OrdenPago where opg_id = " & Id
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
  cIEditGeneric_ShowList = SecurityCanAccess(csPreTsrListOrdenPago)
End Function

Private Property Set cIEditGeneric_ObjAbm(rhs As CSInterfacesABM.cIABMGeneric)
  
#If PREPROC_SFS Then
  Dim AbmGen      As cABMGeneric
#Else
  Dim AbmGen      As cABMGenericDocEx
#End If

  Set m_ObjAbm = rhs
  m_ObjAbm.IsDocument = True

#If Not PREPROC_SFS Then
  Set AbmGen = m_ObjAbm
  With AbmGen
    .FactoryObject = "CSABMInterface2.cFactory"
    .ObjForm = "CSABMInterface2.fOrdenPago"
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
                          csTOrdenPago, _
                          cscOpgId, _
                          doc_id) Then
      Exit Function
    End If
  End If
  
  If Not DocSecurityCanAccess( _
                  csPreTsrDeleteOrdenPago, _
                  doc_id, _
                  csEDocTPreDelete) Then
    Exit Function
  End If

  Dim sqlstmt As String
  
  sqlstmt = "sp_DocOrdenPagoDelete " & Id & "," & EmpId & "," & User.Id
  
  cIEditGeneric_Delete = gDB.Execute(sqlstmt, "cIEditGeneric_Delete", C_Module)
End Function

Private Function cIEditGeneric_Search(Id As Long, Cancela As Boolean) As Boolean

End Function

Private Function cIEditGeneric_Edit(Id As Long, Optional ByVal InModalWindow As Boolean) As Boolean
  On Error GoTo ControlError
  
  If Not DocSecurityCanAccess(csPreTsrListOrdenPago, GetdocIdFromObjAbm(m_ObjAbm), csEDocTPreList) Then Exit Function
  
                            ' Id = csDocChanged esto significa que se cambio
                            '                   el documento estando en un
                            '                   comprobante ya guardado
                            '
  m_IsNew = Id = csNO_ID Or Id = csDocChanged
  
  If Not Load(Id) Then Exit Function
  
  ' Solo muestro asistentes si el nuevo no se esta dando por
  ' un cambio de documento
  '
  If Id <> csDocChanged And m_IsNew Then
    pShowStartWizard
  
  Else
    
    If Not m_ObjAbm Is Nothing Then
    
      If m_ObjAbm.Properties.count = 0 Then
        If Not LoadCollection() Then Exit Function
      Else
        pRefreshProperties
      End If
    End If
  
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
    Case K_CHEQUES
      cIABMClientGrid_ColumnAfterUpdate = pColAUpdateCheque(pGetChequesProperty(), lRow, lCol)
    Case K_CHEQUEST
      cIABMClientGrid_ColumnAfterUpdate = pColAUpdateTCheque(pGetTChequesProperty(), lRow, lCol)
    Case K_OTROS
      cIABMClientGrid_ColumnAfterUpdate = pColAUpdateOtro(pGetOtrosProperty(), lRow, lCol)
    Case K_EFECTIVO
      cIABMClientGrid_ColumnAfterUpdate = pColAUpdateEfectivo(pGetEfectivoProperty(), lRow, lCol)
    Case K_CTACTE
      cIABMClientGrid_ColumnAfterUpdate = pColAUpdateCtaCte(pGetCtaCteProperty(), lRow, lCol)
  End Select

  GoTo ExitProc
ControlError:
  MngError Err, "cIABMClientGrid_ColumnAfterUpdate", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Private Function cIABMClientGrid_ColumnAfterEdit(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long, ByVal NewValue As Variant, ByVal NewValueID As Long) As Boolean
  cIABMClientGrid_ColumnAfterEdit = True
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
      Id = Val(pCell(Row, KICH_OPGI_ID).Value)
      If Id <> csNO_ID Then m_ChequesDeleted = m_ChequesDeleted & Id & ","
    Case K_CHEQUEST
      Id = Val(pCell(Row, KICH_OPGI_ID).Value)
      If Id <> csNO_ID Then m_TChequesDeleted = m_TChequesDeleted & Id & ","
    Case K_EFECTIVO
      Id = Val(pCell(Row, KIE_OPGI_ID).Value)
      If Id <> csNO_ID Then m_EfectivoDeleted = m_EfectivoDeleted & Id & ","
    Case K_OTROS
      Id = Val(pCell(Row, KIO_OPGI_ID).Value)
      If Id <> csNO_ID Then m_OtrosDeleted = m_OtrosDeleted & Id & ","
    Case K_CTACTE
      Id = Val(pCell(Row, KIO_OPGI_ID).Value)
      If Id <> csNO_ID Then m_CtaCteDeleted = m_CtaCteDeleted & Id & ","
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
    Case K_CHEQUES
      cIABMClientGrid_ValidateRow = pValidateRowCheques(Row, RowIndex)
    Case K_CHEQUEST
      cIABMClientGrid_ValidateRow = pValidateRowTCheques(Row, RowIndex)
    Case K_OTROS
      cIABMClientGrid_ValidateRow = pValidateRowOtros(Row, RowIndex)
    Case K_EFECTIVO
      cIABMClientGrid_ValidateRow = pValidateRowEfectivo(Row, RowIndex)
    Case K_CTACTE
      cIABMClientGrid_ValidateRow = pValidateRowCtaCte(Row, RowIndex)
  End Select
  
  GoTo ExitProc
ControlError:
  MngError Err, "cIABMClientGrid_ValidateRow", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
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
  
  Set AbmGen = m_ObjAbm
  AbmGen.ResetLayoutMembers
  
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
      .HelpId = m_doc_id
      .Value = m_Documento
      .HelpFilter = "'doct_id = " & csEDT_OrdenPago & "'"
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
    
    With .Add(Nothing, cscOpgFecha)
      .PropertyType = cspDate
      .Name = LNGGetText(1569, vbNullString) 'Fecha
      .LeftLabel = -580
      .Left = 800
      .Key = K_FECHA
      .Value = m_Fecha
    End With
    
    With .Add(Nothing, cscProvId)
      .PropertyType = cspHelp
      .Table = csProveedor
      .TopFromProperty = cscOpgFecha
      .Left = 3100
      .LeftLabel = -780
      .Name = LNGGetText(1151, vbNullString) 'Proveedor
      .Key = K_PROV_ID
      .HelpId = m_Prov_id
      .Value = m_Proveedor
    End With
    
    With .Add(Nothing, cscOpgNrodoc)
      .PropertyType = cspText
      .Name = LNGGetText(1065, vbNullString) 'Número
      .Size = 50
      .Key = K_NRODOC
      .Value = m_Nrodoc
      .TextMask = m_TaMascara
      .TextAlign = vbRightJustify
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
    
    With .Add(Nothing, cscOpgCotizacion)
      .PropertyType = cspNumeric
      .SubType = cspMoney
      .TopFromProperty = cscOpgNrodoc
      .Left = 6300
      .LeftLabel = -800
      .Name = LNGGetText(1635, vbNullString) 'Cotización
      .Format = m_GeneralConfig.FormatDecCotizacion
      .Key = K_COTIZACION
      .Value = m_Cotizacion
      .Width = 1000
    End With
    
    With .Add(Nothing, cscCcosId)
      .PropertyType = cspHelp
      .Table = csCentroCosto
      .Left = 9500
      .TopFromProperty = cscProvId
      .Name = LNGGetText(1057, vbNullString) 'Centro de Costo
      .Key = K_CCOS_ID
      .HelpId = m_ccos_id
      .Value = m_CentroCosto
    End With
    
    With .Add(Nothing, cscSucId)
      .PropertyType = cspHelp
      .Table = csSucursal
      .Name = LNGGetText(1281, vbNullString) 'Sucursal
      .Key = K_SUC_ID
      .HelpId = m_suc_id
      .Value = m_Sucursal
    End With
    
    With .Add(Nothing, cscOpgDescrip)
      .PropertyType = cspText
      .SubType = cspMemo
      .Name = LNGGetText(1211, vbNullString) 'Observ.
      .LeftLabel = -600
      .Size = 5000
      .Key = K_DESCRIP
      .Value = m_Descrip
      .LeftFromProperty = cscOpgFecha
      .TopFromProperty = cscOpgNrodoc
      .Width = 10970
      .Height = 800
      .TopToPrevious = 440
    End With
  End With
  
  If Not m_ObjAbm.Show(Me) Then Exit Function
      
'///////////////////////////////////////////////////////////////////
' ITEMS
'///////////////////////////////////////////////////////////////////

  Const c_TabCheque = 0
  Const c_TabEfectivo = 1
  Const c_TabChequeT = 2
  Const c_TabOtros = 3
  Const c_TabCtaCte = 4
  
  With m_Items.Tabs
    
    .Clear

    With .Add(Nothing)
      .Index = c_TabCheque
      .Name = LNGGetText(2099, vbNullString) 'Cheques
    End With
    
    With .Add(Nothing)
      .Index = c_TabEfectivo
      .Name = LNGGetText(2100, vbNullString) 'Efectivo
    End With
    
    With .Add(Nothing)
      .Index = c_TabChequeT
      .Name = LNGGetText(2195, vbNullString) 'Cheque de Tercero
    End With
    
    With .Add(Nothing)
      .Index = c_TabOtros
      .Name = LNGGetText(1070, vbNullString) 'Otros
    End With
    
    With .Add(Nothing)
      .Index = c_TabCtaCte
      .Name = LNGGetText(2102, vbNullString) 'Cta Corriente
    End With
  
  End With
    
  Set AbmGen = m_Items
  AbmGen.ResetLayoutMembers

  With m_Items.Properties
  
    .Clear
    
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
    ' EFECTIVO
    Set c = .Add(Nothing, c_Efectivo)
    With c
      .PropertyType = cspGrid
      .LeftLabel = -1
      If Not pLoadEfectivo(c) Then Exit Function
      .Name = c_Efectivo
      .Key = K_EFECTIVO
      .TabIndex = c_TabEfectivo
      .GridAdd = True
      .GridEdit = True
      .GridRemove = True
    End With
    
    m_EfectivoDeleted = vbNullString
  
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
    ' OTROS
    Set c = .Add(Nothing, c_Otros)
    With c
      .PropertyType = cspGrid
      .LeftLabel = -1
      If Not pLoadOtros(c) Then Exit Function
      .Name = c_Otros
      .Key = K_OTROS
      .TabIndex = c_TabOtros
      .GridAdd = True
      .GridEdit = True
      .GridRemove = True
    End With
    
    m_OtrosDeleted = vbNullString
    
    '/////////////////////////////////////////////////////////////////
    ' CTA CTE
    Set c = .Add(Nothing, c_CtaCte)
    With c
      .PropertyType = cspGrid
      .LeftLabel = -1
      If Not pLoadCtaCte(c) Then Exit Function
      .Name = c_CtaCte
      .Key = K_CTACTE
      .TabIndex = c_TabCtaCte
      .GridAdd = True
      .GridEdit = True
      .GridRemove = True
    End With
    
  End With
  
  m_CtaCteDeleted = vbNullString
  
  If Not m_Items.Show(Me) Then Exit Function
  
'///////////////////////////////////////////////////////////////////
' FOOTER
'///////////////////////////////////////////////////////////////////

  Set AbmGen = m_Footer
  AbmGen.ResetLayoutMembers
  
  With m_Footer.Properties
  
    .Clear
  
    With .Add(Nothing, cscOpgNeto)
      .PropertyType = cspNumeric
      .SubType = cspMoney
      .Name = LNGGetText(1581, vbNullString)  'Neto
      .Key = K_NETO
      .Value = m_Neto
      .Format = m_GeneralConfig.FormatDecImporte
      .Enabled = False
    End With
    
    With .Add(Nothing, cscOpgOtros)
      .PropertyType = cspNumeric
      .SubType = cspMoney
      .Name = LNGGetText(1070, vbNullString)  'Otros
      .Key = K_OTROS
      .Value = m_Otros
      .Format = m_GeneralConfig.FormatDecImporte
      .Enabled = False
    End With
    
    With .Add(Nothing, cscOpgTotal)
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
  
  ' Se hace al final para evitar que se muestre el
  ' form antes de tiempo
  '
  pSetFilterColFactura
  
  LoadCollection = True
End Function

Private Function pLoadOtros(ByRef Propiedad As cIABMProperty) As Boolean
  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  Dim Grid    As cIABMGrid
  
  sqlstmt = "sp_DocOrdenPagoGetItems " & m_Id & "," & csEOrdenPagoItemTipo.csEOpgiTOtros
  
  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, "pLoadOtros", C_Module) Then Exit Function
  
  Propiedad.Grid.Columns.Clear
  Propiedad.Grid.Rows.Clear
  
  Set Grid = Propiedad.Grid
  
  With Grid.Columns
    With .Add(Nothing)
      .Visible = False
      .Key = KIO_OPGI_ID
    End With
  
    With .Add(Nothing)
      .Name = LNGGetText(1267, vbNullString)  'Cuenta
      .PropertyType = cspHelp
      .Table = csCuenta
      .Width = 2200
      .Key = KIO_CUE_ID
      .HelpFilter = "(emp_id = " & EmpId & " or emp_id is null)"
    End With
    
    With .Add(Nothing)
      .Name = LNGGetText(1904, vbNullString)  'Debe
      .PropertyType = cspNumeric
      .Format = m_GeneralConfig.FormatDecImporte
      .SubType = cspMoney
      .Width = 920
      .Key = KIO_DEBE
    End With
    
    With .Add(Nothing)
      .Name = LNGGetText(1905, vbNullString)  'Haber
      .PropertyType = cspNumeric
      .Format = m_GeneralConfig.FormatDecImporte
      .SubType = cspMoney
      .Width = 920
      .Key = KIO_HABER
    End With
    
    With .Add(Nothing)
      .Name = LNGGetText(1901, vbNullString)  'Origen
      .PropertyType = cspNumeric
      .Format = m_GeneralConfig.FormatDecImporte
      .SubType = cspMoney
      .Width = 920
      .Key = KIO_IMPORTEORIGEN
    End With
    
    With .Add(Nothing)
      .Name = C_strDescrip
      .PropertyType = cspText
      .SubType = cspTextButtonEx
      .Width = 1000
      .Key = KIO_DESCRIP
    End With
    
    With .Add(Nothing)
      .Name = LNGGetText(1403, vbNullString)  'Retención
      .PropertyType = cspHelp
      .Table = csRetencion
      .Width = 1500
      .Key = KIO_RET_ID
    End With
    
    With .Add(Nothing)
      .Name = LNGGetText(2103, vbNullString)  'C. Retención
      .PropertyType = cspText
      .Width = 1200
      .Key = KIO_NRORETENCION
    End With
    
    With .Add(Nothing)
      .Name = LNGGetText(2104, vbNullString)  '% Retención
      .PropertyType = cspNumeric
      .SubType = cspPercent
      .Width = 1200
      .Key = KIO_PORCRETENCION
    End With
    
    With .Add(Nothing)
      .Name = LNGGetText(1634, vbNullString)  'Vto.
      .PropertyType = cspDate
      .Width = 920
      .Key = KIO_FECHARETENCION
    End With
    
    With .Add(Nothing)
      .Name = LNGGetText(1057, vbNullString)  'Centro de Costo
      .PropertyType = cspHelp
      .Table = csCentroCosto
      .Width = 1800
      .Key = KIO_CCOS_ID
    End With
  
    With .Add(Nothing, cscFcIdRet)
      .Name = LNGGetText(1866, vbNullString) ' Factura
      .PropertyType = cspHelp
      .Table = csFacturaCompra
      .Width = 1200
      .Key = KIO_FC_ID_RET
    End With
  End With
  
  Dim F  As cIABMGridRow
  Dim fv As cIABMGridCellValue
  
  While Not rs.EOF
  
    Set F = Propiedad.Grid.Rows.Add(Nothing, rs(cscOpgiId).Value)
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscOpgiId)
    fv.Key = KIO_OPGI_ID
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscCueNombre)
    fv.Id = gDB.ValField(rs.Fields, cscCueId)
    fv.Key = KIO_CUE_ID
    
    Set fv = F.Add(Nothing)
    If gDB.ValField(rs.Fields, cscOpgiOtroTipo) = csEItemOtroTipo.csEOtroHaber Then
      fv.Value = gDB.ValField(rs.Fields, cscOpgiImporte)
    Else
      fv.Value = 0
    End If
    fv.Key = KIO_DEBE

    Set fv = F.Add(Nothing)
    If gDB.ValField(rs.Fields, cscOpgiOtroTipo) = csEItemOtroTipo.csEOtroDebe Then
      fv.Value = gDB.ValField(rs.Fields, cscOpgiImporte)
    Else
      fv.Value = 0
    End If
    fv.Key = KIO_HABER

    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscOpgiImporteOrigen)
    fv.Key = KIO_IMPORTEORIGEN

    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscOpgiDescrip)
    fv.Key = KIO_DESCRIP

    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscRetNombre)
    fv.Id = gDB.ValField(rs.Fields, cscRetId)
    fv.Key = KIO_RET_ID
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscOpgiNroRetencion)
    fv.Key = KIO_NRORETENCION

    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscOpgiPorcRetencion)
    fv.Key = KIO_PORCRETENCION

    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscOpgiFechaRetencion)
    fv.Key = KIO_FECHARETENCION

    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscCcosNombre)
    fv.Id = gDB.ValField(rs.Fields, cscCcosId)
    fv.Key = KIO_CCOS_ID
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscFcNrodoc)
    fv.Id = gDB.ValField(rs.Fields, cscFcIdRet)
    fv.Key = KIO_FC_ID_RET
    
    rs.MoveNext
  Wend
  
  pLoadOtros = True
End Function

Private Function pLoadTCheques(ByRef Propiedad As cIABMProperty) As Boolean
  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  Dim Grid    As cIABMGrid
  
  sqlstmt = "sp_DocOrdenPagoGetItems " & m_Id & "," & csEOrdenPagoItemTipo.csEOpgiTChequesT
  
  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, "pLoadCheques", C_Module) Then Exit Function
  
  Propiedad.Grid.Columns.Clear
  Propiedad.Grid.Rows.Clear
  
  Set Grid = Propiedad.Grid

  With Grid.Columns
    With .Add(Nothing)
      .Visible = False
      .Key = KICHT_OPGI_ID
    End With
  
    With .Add(Nothing)
      .Name = LNGGetText(1267, vbNullString)  'Cuenta
      .PropertyType = cspHelp
      .Table = csCuenta
      
      '.HelpFilter = cscCuecId & "=" & csECuecDocEnCartera
      .HelpFilter = GetHelpFilterChequesT()
      
      .Width = 2200
      .Key = KICHT_CUE_ID
    End With
    
    With .Add(Nothing, c_ChequeT)
      .Name = LNGGetText(2059, vbNullString)  'Nr. Cheque
      .PropertyType = cspHelp
      .Table = csCheque
      .HelpFilter = "1 = 2"
      .SubType = cspInteger
      .Width = 1000
      .Key = KICHT_CHEQUE
    End With
    
    With .Add(Nothing)
      .Name = LNGGetText(1150, vbNullString)  'Cliente
      .PropertyType = cspText
      .Width = 2000
      .Key = KICHT_CLI_ID
    End With
    
    With .Add(Nothing)
      .Name = LNGGetText(1122, vbNullString)  'Banco
      .PropertyType = cspText
      .Width = 2000
      .Key = KICHT_BCO_ID
    End With
    
    With .Add(Nothing)
      .Name = LNGGetText(2063, vbNullString)  'Mon
      .PropertyType = cspHelp
      .Table = csMoneda
      .Width = 520
      .Key = KICHT_MON_ID
      .Enabled = False
    End With
    
    With .Add(Nothing)
      .Name = LNGGetText(1901, vbNullString)  'Origen
      .PropertyType = cspNumeric
      .Format = m_GeneralConfig.FormatDecImporte
      .SubType = cspMoney
      .Width = 920
      .Key = KICHT_IMPORTEORIGEN
      .Enabled = False
    End With
    
    With .Add(Nothing)
      .Name = LNGGetText(1228, vbNullString)  'Importe
      .PropertyType = cspNumeric
      .Format = m_GeneralConfig.FormatDecImporte
      .SubType = cspMoney
      .Width = 920
      .Key = KICHT_IMPORTE
      .Enabled = False
    End With
    
    With .Add(Nothing)
      .Name = LNGGetText(2065, vbNullString)  'Depositar el
      .PropertyType = cspDate
      .Width = 970
      .Key = KICHT_FECHACOBRO
      .Enabled = False
    End With
    
    With .Add(Nothing)
      .Name = LNGGetText(1901, vbNullString)  'Vto."
      .PropertyType = cspDate
      .Width = 970
      .Key = KICHT_FECHAVTO
      .Enabled = False
    End With
    
    With .Add(Nothing)
      .Name = LNGGetText(1083, vbNullString)  'Clering
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
  End With
  
  Dim F  As cIABMGridRow
  Dim fv As cIABMGridCellValue
  
  While Not rs.EOF
  
    Set F = Propiedad.Grid.Rows.Add(Nothing, rs(cscOpgiId).Value)
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscOpgiId)
    fv.Key = KICHT_OPGI_ID
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscCueNombre)
    fv.Id = gDB.ValField(rs.Fields, cscCueId)
    fv.Key = KICHT_CUE_ID
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscCheqNumeroDoc)
    fv.Id = gDB.ValField(rs.Fields, cscCheqId)
    fv.Key = KICHT_CHEQUE

    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscCliNombre)
    fv.Key = KICHT_CLI_ID
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscBcoNombre)
    fv.Key = KICHT_BCO_ID
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscMonNombre)
    fv.Id = gDB.ValField(rs.Fields, cscMonId)
    fv.Key = KICHT_MON_ID
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscOpgiImporteOrigen)
    fv.Key = KICHT_IMPORTEORIGEN
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscOpgiImporte)
    fv.Key = KICHT_IMPORTE
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscCheqFechaCobro)
    fv.Key = KICH_FECHACOBRO
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscCheqFechaVto)
    fv.Key = KICH_FECHAVTO

    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscCleNombre)
    fv.Key = KICH_CLE_ID
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscOpgiDescrip)
    fv.Key = KICH_DESCRIP
    
    rs.MoveNext
  Wend
  
  pLoadTCheques = True
End Function

Private Function pLoadCheques(ByRef Propiedad As cIABMProperty) As Boolean
  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  Dim Grid    As cIABMGrid
  
  sqlstmt = "sp_DocOrdenPagoGetItems " & m_Id & "," & csEOrdenPagoItemTipo.csEOpgiTCheques
  
  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, "pLoadCheques", C_Module) Then Exit Function
  
  Propiedad.Grid.Columns.Clear
  Propiedad.Grid.Rows.Clear
  
  Set Grid = Propiedad.Grid
  
  With Grid.Columns
    With .Add(Nothing)
      .Visible = False
      .Key = KICH_OPGI_ID
    End With
    
    With .Add(Nothing)
      .Name = LNGGetText(1267, vbNullString)  'Cuenta
      .PropertyType = cspHelp
      .Table = csCuenta
      
      '.HelpFilter = cscCuecId & "=" & csECuecBancos
      .HelpFilter = GetHelpFilterChequesP()
      
      .Width = 2200
      .Key = KICH_CUE_ID
    End With
    
    With .Add(Nothing)
      .Name = LNGGetText(2063, vbNullString)  'Mon
      .PropertyType = cspHelp
      .Table = csMoneda
      .Width = 520
      .Key = KICH_MON_ID
      .Enabled = False
    End With
    
    With .Add(Nothing)
      .Name = LNGGetText(1901, vbNullString)  'Origen
      .PropertyType = cspNumeric
      .Format = m_GeneralConfig.FormatDecImporte
      .SubType = cspMoney
      .Width = 920
      .Key = KICH_IMPORTEORIGEN
    End With
    
    With .Add(Nothing)
      .Name = LNGGetText(1228, vbNullString)  'Importe
      .PropertyType = cspNumeric
      .Format = m_GeneralConfig.FormatDecImporte
      .SubType = cspMoney
      .Width = 920
      .Key = KICH_IMPORTE
    End With
    
    With .Add(Nothing, c_Chequera)
      .Name = LNGGetText(2064, vbNullString)  'Chequera
      .PropertyType = cspHelp
      .Table = csChequera
      .Width = 1000
      .Key = KICH_CHEQUERA
    End With
    
    With .Add(Nothing)
      .Name = LNGGetText(2059, vbNullString)  'Nr. Cheque
      .PropertyType = cspText
      .Width = 1000
      .Key = KICH_CHEQUE
    End With
    
    With .Add(Nothing)
      .Name = LNGGetText(2058, vbNullString)  'Cheque
      .PropertyType = cspText
      .Width = 1000
      .Enabled = False
      .Key = KICH_CHEQ_ID
    End With
    
    With .Add(Nothing)
      .Name = LNGGetText(2065, vbNullString)  'Depositar el
      .PropertyType = cspDate
      Set .DefaultValue = New cABMGridRowValue
      .DefaultValue.Value = Date
      .Width = 970
      .Key = KICH_FECHACOBRO
    End With
    
    With .Add(Nothing)
      .Name = LNGGetText(1634, vbNullString)  'Vto.
      .PropertyType = cspDate
      .Width = 970
      Set .DefaultValue = New cABMGridRowValue
      .DefaultValue.Value = DateAdd("y", 1, Date)
      .Key = KICH_FECHAVTO
    End With
    
    With .Add(Nothing)
      .Name = LNGGetText(1083, vbNullString)  'Clering
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
  
  Dim F  As cIABMGridRow
  Dim fv As cIABMGridCellValue
  
  While Not rs.EOF
  
    Set F = Propiedad.Grid.Rows.Add(Nothing, rs(cscOpgiId).Value)
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscOpgiId)
    fv.Key = KICH_OPGI_ID
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscCueNombre)
    fv.Id = gDB.ValField(rs.Fields, cscCueId)
    fv.Key = KICH_CUE_ID
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscMonNombre)
    fv.Id = gDB.ValField(rs.Fields, cscMonId)
    fv.Key = KICH_MON_ID
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscOpgiImporteOrigen)
    fv.Key = KICH_IMPORTEORIGEN
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscOpgiImporte)
    fv.Key = KICH_IMPORTE

    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscChqCodigo)
    fv.Id = gDB.ValField(rs.Fields, cscChqId)
    fv.Key = KICH_CHEQUERA
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscCheqNumeroDoc)
    fv.Key = KICH_CHEQUE
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscCheqNumero)
    fv.Id = gDB.ValField(rs.Fields, cscCheqId)
    fv.Key = KICH_CHEQ_ID
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscCheqFechaCobro)
    fv.Key = KICH_FECHACOBRO
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscCheqFechaVto)
    fv.Key = KICH_FECHAVTO

    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscCleNombre)
    fv.Id = gDB.ValField(rs.Fields, cscCleId)
    fv.Key = KICH_CLE_ID
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscOpgiDescrip)
    fv.Key = KICH_DESCRIP
    
    rs.MoveNext
  Wend
  
  pLoadCheques = True
End Function

Private Function pLoadEfectivo(ByRef Propiedad As cIABMProperty) As Boolean
  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  Dim Grid    As cIABMGrid
  
  sqlstmt = "sp_DocOrdenPagoGetItems " & m_Id & "," & csEOrdenPagoItemTipo.csEOpgiTEfectivo
  
  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, "pLoadEfectivo", C_Module) Then Exit Function
  
  Propiedad.Grid.Columns.Clear
  Propiedad.Grid.Rows.Clear
  
  Set Grid = Propiedad.Grid
  
  With Grid.Columns
    With .Add(Nothing)
      .Visible = False
      .Key = KIE_OPGI_ID
    End With
  
    With .Add(Nothing)
      .Name = LNGGetText(1267, vbNullString)  'Cuenta
      .PropertyType = cspHelp
      .Table = csCuenta
      
      '.HelpFilter = cscCuecId & "=" & csECuecCaja
      .HelpFilter = GetHelpFilterEfectivo()
      
      .Width = 3000
      .Key = KIE_CUE_ID
    End With
    
    With .Add(Nothing)
      .Name = LNGGetText(2063, vbNullString)  'Mon
      .PropertyType = cspHelp
      .Table = csMoneda
      .Width = 520
      .Key = KIE_MON_ID
      .Enabled = False
    End With
    
    With .Add(Nothing)
      .Name = LNGGetText(1901, vbNullString)  'Origen
      .PropertyType = cspNumeric
      .Format = m_GeneralConfig.FormatDecImporte
      .SubType = cspMoney
      .Width = 920
      .Key = KIE_IMPORTEORIGEN
    End With
    
    With .Add(Nothing)
      .Name = LNGGetText(1228, vbNullString)  'Importe
      .PropertyType = cspNumeric
      .Format = m_GeneralConfig.FormatDecImporte
      .SubType = cspMoney
      .Width = 920
      .Key = KIE_IMPORTE
    End With
    
    With .Add(Nothing)
      .Name = C_strDescrip
      .PropertyType = cspText
      .SubType = cspTextButtonEx
      .Width = 2500
      .Key = KIE_DESCRIP
    End With
  End With
  
  Dim F  As cIABMGridRow
  Dim fv As cIABMGridCellValue
  
  While Not rs.EOF
  
    Set F = Propiedad.Grid.Rows.Add(Nothing, rs(cscOpgiId).Value)
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscOpgiId)
    fv.Key = KIE_OPGI_ID
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscCueNombre)
    fv.Id = gDB.ValField(rs.Fields, cscCueId)
    fv.Key = KIE_CUE_ID
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscMonNombre)
    fv.Id = gDB.ValField(rs.Fields, cscMonId)
    fv.Key = KIE_MON_ID
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscOpgiImporteOrigen)
    fv.Key = KIE_IMPORTEORIGEN
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscOpgiImporte)
    fv.Key = KIE_IMPORTE
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscOpgiDescrip)
    fv.Key = KIE_DESCRIP
    
    rs.MoveNext
  Wend
  
  pLoadEfectivo = True
End Function

Private Function pLoadCtaCte(ByRef Propiedad As cIABMProperty) As Boolean
  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  Dim Grid    As cIABMGrid
  
  sqlstmt = "sp_DocOrdenPagoGetItems " & m_Id & "," & csEOrdenPagoItemTipo.csEOpgiTCtaCte
  
  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, "pLoadCtaCte", C_Module) Then Exit Function
  
  Propiedad.Grid.Columns.Clear
  Propiedad.Grid.Rows.Clear
  
  Set Grid = Propiedad.Grid
  
  With Grid.Columns
    With .Add(Nothing)
      .Visible = False
      .Key = KICC_OPGI_ID
    End With
  
    With .Add(Nothing)
      .Name = LNGGetText(1267, vbNullString)  'Cuenta
      .PropertyType = cspHelp
      .Table = csCuenta
      .Width = 3000
      .Key = KICC_CUE_ID
    End With
    
    With .Add(Nothing)
      .Name = LNGGetText(1901, vbNullString)  'Origen
      .PropertyType = cspNumeric
      .Format = m_GeneralConfig.FormatDecImporte
      .SubType = cspMoney
      .Width = 920
      .Key = KICC_IMPORTEORIGEN
    End With
    
    With .Add(Nothing)
      .Name = LNGGetText(1228, vbNullString)  'Importe
      .PropertyType = cspNumeric
      .Format = m_GeneralConfig.FormatDecImporte
      .SubType = cspMoney
      .Width = 920
      .Key = KICC_IMPORTE
    End With
  End With
  
  Dim F  As cIABMGridRow
  Dim fv As cIABMGridCellValue
  
  While Not rs.EOF
  
    Set F = Propiedad.Grid.Rows.Add(Nothing, rs(cscOpgiId).Value)
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscOpgiId)
    fv.Key = KICC_OPGI_ID
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscCueNombre)
    fv.Id = gDB.ValField(rs.Fields, cscCueId)
    fv.Key = KICC_CUE_ID
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscOpgiImporteOrigen)
    fv.Key = KICC_IMPORTEORIGEN
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscOpgiImporte)
    fv.Key = KICC_IMPORTE
    
    rs.MoveNext
  Wend
  
  pLoadCtaCte = True
End Function

Private Function Load(ByVal Id As Long) As Boolean
  Dim sqlstmt     As String

  sqlstmt = "sp_DocOrdenPagoGet " & EmpId & "," & Id & "," & gDB.UserId
  
  Dim rs As Recordset

  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, C_LoadFunction, C_Module) Then Exit Function

  If Not rs.EOF Then
    
    m_IsNew = False
    
    m_Id = gDB.ValField(rs.Fields, cscOpgId)
    m_Numero = gDB.ValField(rs.Fields, cscOpgNumero)
    m_Nrodoc = gDB.ValField(rs.Fields, cscOpgNrodoc)
    m_Descrip = gDB.ValField(rs.Fields, cscOpgDescrip)
    m_Fecha = gDB.ValField(rs.Fields, cscOpgFecha)
    m_Neto = gDB.ValField(rs.Fields, cscOpgNeto)
    m_Total = gDB.ValField(rs.Fields, cscOpgTotal)
    m_Otros = gDB.ValField(rs.Fields, cscOpgOtros)
    m_Cotizacion = gDB.ValField(rs.Fields, cscOpgCotizacion)
    m_Prov_id = gDB.ValField(rs.Fields, cscProvId)
    m_Proveedor = gDB.ValField(rs.Fields, cscProvNombre)
    m_ccos_id = gDB.ValField(rs.Fields, cscCcosId)
    m_CentroCosto = gDB.ValField(rs.Fields, cscCcosNombre)
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
    m_Firmado = gDB.ValField(rs.Fields, cscOpgFirmado)
    m_DocEditable = gDB.ValField(rs.Fields, cscDocEditable)
    m_DocEditMsg = gDB.ValField(rs.Fields, cscDoceditMsg)

    ' Para ver documentos auxiliares
    '
    m_as_id = gDB.ValField(rs.Fields, cscAsId)
    
    m_TaPropuesto = gDB.ValField(rs.Fields, cscTa_Propuesto)
    m_TaMascara = gDB.ValField(rs.Fields, cscTa_Mascara)
    
    m_LastDoc = m_doc_id
    m_LastCli = m_Prov_id
    m_LastDocName = m_Documento
    m_LastCliName = m_Proveedor
    
  Else
    m_Id = csNO_ID
    m_Numero = 0
    m_Nrodoc = vbNullString
    m_Descrip = vbNullString
    m_Fecha = VDGetDateById(csToday)
    m_Neto = 0
    m_Total = 0
    m_Otros = 0
    m_Prov_id = csNO_ID
    m_Proveedor = vbNullString
    m_ccos_id = csNO_ID
    m_CentroCosto = vbNullString
    m_doc_id = csNO_ID
    m_Documento = vbNullString
    m_Doct_id = csNO_ID
    m_lgj_id = csNO_ID
    m_Legajo = vbNullString
    m_Cotizacion = 0
    m_Creado = csNoDate
    m_Modificado = csNoDate
    m_Modifico = 0
    m_est_id = csNO_ID
    m_Estado = vbNullString
    m_suc_id = User.suc_id
    m_Sucursal = User.Sucursal
    m_Firmado = False
  
    ' Para ver documentos auxiliares
    '
    m_as_id = csNO_ID
    
    m_TaPropuesto = False
    m_TaMascara = vbNullString
    
    m_doc_id = m_LastDoc
    m_Prov_id = m_LastCli
    m_Proveedor = m_LastCliName
    m_Documento = m_LastDocName
  
    DocEditableGet m_doc_id, m_DocEditable, m_DocEditMsg, csPreTsrNewOrdenPago
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
  m_Host.Server.AddMenu LNGGetText(2196, vbNullString), csPreTsrListOrdenPago, str_2048, 0, True, False, False, False, False, Me
                        '&Orden de Pago
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
  m_Host.MenuListDocClick "CSABMInterface2.cABMGeneric", "CSTesoreria2.cOrdenPago", "CSABMInterface2.CABMGenericListDoc", "CSTesoreria2.cOrdenPagoListDoc", Me, LNGGetText(1922, vbNullString), 0   'Orden de pago
#Else
  m_Host.MenuListDocClick "CSABMInterface2.cABMGenericDocEx", "CSTesoreria2.cOrdenPago", "CSABMInterface2.CABMGenericListDoc", "CSTesoreria2.cOrdenPagoListDoc", Me, LNGGetText(1922, vbNullString), 0
#End If
End Function

' Reglas del Objeto de Negocios
Private Sub pSetEnabled()
  Dim bState As Boolean
  Dim Prop   As cIABMProperty
  
  If m_DocEditable And ((Not m_IsNew) Or m_Copy) Then
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

Private Function pGetCueIdProveedor(ByRef cue_id As Long) As Boolean
  Dim sqlstmt As String
  Dim rs      As Recordset
  
  ' Cuenta contable del Proveedor
  sqlstmt = "sp_DocGetCueId " & m_LastCli & "," & m_LastDoc
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Function

  If rs.EOF Then Exit Function

  cue_id = gDB.ValField(rs.Fields, cscCueId)
  
  pGetCueIdProveedor = True
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
  
  sqlstmt = "sp_DocOrdenPagoFirmar " & m_Id & "," & Us_id
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Function
  
  m_est_id = gDB.ValField(rs.Fields, cscEstId)
  m_Estado = gDB.ValField(rs.Fields, cscEstNombre)
  
  Dim iProp As cIABMProperty
  Set iProp = m_ObjAbm.Properties(csDocEstateID)
  
  With iProp
    .HelpId = m_est_id
    .Value = m_Estado
  End With
  
  gDB.GetData csTOrdenPago, cscOpgId, m_Id, cscOpgFirmado, m_Firmado
  
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
  
  sqlstmt = "sp_DocOrdenPagoMover " & MoveTo & "," & m_Numero & "," & doc_id
  
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
        GetDocNumber m_LastDoc, m_ObjAbm, m_TaPropuesto, cscOpgNrodoc
    
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
  
  With m_ObjAbm.Properties
  
    Set c = .Item(cscDocId)
    c.HelpId = m_doc_id
    c.Value = m_Documento
    
    Set c = .Item(cscOpgFecha)
    c.Value = m_Fecha
    
    Set c = .Item(cscProvId)
    c.HelpId = m_Prov_id
    c.Value = m_Proveedor
    
    Set c = .Item(csDocNumberID)
    c.Value = m_Numero
    
    Set c = .Item(csDocEstateID)
    c.Value = m_Estado
    
    Set c = .Item(cscOpgNrodoc)
    c.Value = m_Nrodoc
    c.TextMask = m_TaMascara
    c.TextAlign = vbRightJustify
    
    Set c = .Item(cscOpgCotizacion)
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
    
    Set c = .Item(cscOpgDescrip)
    c.Value = m_Descrip
  
  End With
  
  Set AbmGen = m_ObjAbm
  AbmGen.ShowValues m_ObjAbm.Properties
  
  AbmGen.ResetChanged
  
  Set c = pGetChequesProperty()
  If Not pLoadCheques(c) Then Exit Sub
  
  m_ChequesDeleted = vbNullString
  
  Set c = pGetEfectivoProperty()
  If Not pLoadEfectivo(c) Then Exit Sub
  
  m_EfectivoDeleted = vbNullString
  
  Set c = pGetTChequesProperty()
  If Not pLoadTCheques(c) Then Exit Sub
  
  m_TChequesDeleted = vbNullString
  
  Set c = pGetOtrosProperty()
  If Not pLoadOtros(c) Then Exit Sub
  
  m_OtrosDeleted = vbNullString
  
  Set c = pGetCtaCteProperty()
  If Not pLoadCtaCte(c) Then Exit Sub
  
  m_CtaCteDeleted = vbNullString
  
  Set AbmGen = m_Items
  AbmGen.ShowValues m_Items.Properties
  
  pSetFilterColFactura
  
  With m_Footer.Properties
    
    Set c = .Item(cscOpgOtros)
    c.Value = m_Otros
    
    Set c = .Item(cscOpgNeto)
    c.Value = m_Neto
    
    Set c = .Item(cscOpgTotal)
    c.Value = m_Total
  
  End With
    
  Set AbmGen = m_Footer
  AbmGen.ShowValues m_Footer.Properties
  
  pSetEnabled
End Sub

Private Sub pShowStartWizard()
  On Error GoTo ControlError
  
  Dim oWizard As cOrdenPagoWizard
  Set oWizard = New cOrdenPagoWizard
  
  If Not oWizard.Load() Then Exit Sub

  With oWizard
    .prov_id = m_Prov_id
    .Proveedor = m_Proveedor
    .FcIds = m_FcIds
    Set .ObjClient = Me
  End With

  'Dim iEditGeneric As cIEditGeneric
  'Set iEditGeneric = oWizard
  'Set iEditGeneric.ObjTree = m_ObjTree
  
  Dim iObjWizard As cIWizardGeneric
#If PREPROC_SFS Then
  Dim oObjWizard   As cWizardGeneric
  Set iObjWizard = CSKernelClient2.CreateObject("CSABMInterface2.cWizardGeneric")

#Else
  Dim oObjWizard   As cWizardGenericDocEx
  Set iObjWizard = CSKernelClient2.CreateObject("CSABMInterface2.cWizardGenericDocEx")
#End If

  Set oObjWizard = iObjWizard
  Set oObjWizard.ObjClient = oWizard
  
  iObjWizard.Show "CSTesoreria2.cOrdenPagoWizard"
  
  oObjWizard.ObjAbm.ObjForm.ZOrder
  
  GoTo ExitProc
ControlError:
  MngError Err, "pShowStartWizard", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

' Construccion - Destruccion
Private Sub Class_Initialize()
  On Error GoTo ControlError
    
  c_ErrorSave = LNGGetText(1910, vbNullString) 'Error al grabar la orden de pago
    
  Set m_GeneralConfig = New cGeneralConfig
  m_GeneralConfig.Load
  ReDim m_FcIds(0)
  m_MonDefault = GetMonedaDefault()

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
  ReDim m_FcIds(0)

  GoTo ExitProc
ControlError:
  MngError Err, "Class_Terminate", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

'////////////////////////////////////////////////////////////
Private Function pSaveTCheques(ByVal Id As Long) As Boolean
  Dim register  As cRegister
  Dim Row       As cIABMGridRow
  Dim Cell      As cIABMGridCellValue
  
  For Each Row In pGetTCheques().Rows
    
    Set register = New cRegister
    register.fieldId = cscOpgiTMPId
    register.Table = csTOrdenPagoItemTMP
    register.Id = csNew
    
    For Each Cell In Row
      Select Case Cell.Key
        
        Case KICH_OPGI_ID
          If m_Copy Then
            register.Fields.Add2 cscOpgiId, csNew, csInteger
          Else
            register.Fields.Add2 cscOpgiId, Val(Cell.Value), csInteger
          End If
        Case KICHT_DESCRIP
          register.Fields.Add2 cscOpgiDescrip, Cell.Value, csText
        
        Case KICHT_CHEQUE
          register.Fields.Add2 cscCheqId, Cell.Id, csId
        
        Case KICHT_CLE_ID
          register.Fields.Add2 cscCleId, Cell.Id, csId
        
        Case KICHT_MON_ID
          register.Fields.Add2 cscMonId, Cell.Id, csId
        
        Case KICHT_FECHACOBRO
          register.Fields.Add2 cscOpgiTMPFechaCobro, Cell.Value, csDate
        
        Case KICHT_FECHAVTO
          register.Fields.Add2 cscOpgiTMPFechaVto, Cell.Value, csDate
        
        Case KICHT_CUE_ID
          register.Fields.Add2 cscCueId, Cell.Id, csId
        
        Case KICHT_IMPORTEORIGEN
          register.Fields.Add2 cscOpgiImporteOrigen, Val(Cell.Value), csCurrency
        
        Case KICHT_IMPORTE
          register.Fields.Add2 cscOpgiImporte, Val(Cell.Value), csCurrency
      End Select
    Next
    
    m_iOrden = m_iOrden + 1
    register.Fields.Add2 cscOpgiOrden, m_iOrden, csInteger
    register.Fields.Add2 cscOpgiTipo, csEOrdenPagoItemTipo.csEOpgiTChequesT, csInteger
    register.Fields.Add2 cscOpgTMPId, Id, csId
    register.Fields.Add2 cscOpgiId, csNew, csLong
    register.Fields.Add2 cscOpgiOtroTipo, csEItemOtroTipo.csEOtroHaber, csInteger
    
    register.Fields.HaveLastUpdate = False
    register.Fields.HaveWhoModify = False
                                                          
    If Not gDB.Save(register, , "pSaveTCheques", C_Module, c_ErrorSave) Then Exit Function
  Next
  
  Dim sqlstmt As String
  
  If LenB(m_TChequesDeleted) And m_Id <> csNO_ID And Not m_Copy Then
  
    Dim vDeletes As Variant
    Dim i As Long
    
    m_TChequesDeleted = RemoveLastColon(m_TChequesDeleted)
    vDeletes = Split(m_TChequesDeleted, ",")
    
    For i = 0 To UBound(vDeletes)
    
      Set register = New cRegister
      register.fieldId = cscOpgibTMPId
      register.Table = csTOrdenPagoItemBorradoTMP
      register.Id = csNew
      
      register.Fields.Add2 cscOpgiId, Val(vDeletes(i)), csInteger
      register.Fields.Add2 cscOpgId, m_Id, csId
      register.Fields.Add2 cscOpgTMPId, Id, csId
      
      register.Fields.HaveLastUpdate = False
      register.Fields.HaveWhoModify = False
                                                            
      If Not gDB.Save(register, , "pSaveTCheques", C_Module, c_ErrorSave) Then Exit Function
    Next
    
  End If
  
  pSaveTCheques = True
End Function

Private Function pSaveCheques(ByVal Id As Long) As Boolean
  Dim register  As cRegister
        
  Dim Row  As cIABMGridRow
  Dim Cell As cIABMGridCellValue
  
  For Each Row In pGetCheques().Rows
  
    Set register = New cRegister
    register.fieldId = cscOpgiTMPId
    register.Table = csTOrdenPagoItemTMP
    register.Id = csNew
    
    For Each Cell In Row
      Select Case Cell.Key
        
        Case KICH_OPGI_ID
          If m_Copy Then
            register.Fields.Add2 cscOpgiId, csNew, csInteger
          Else
            register.Fields.Add2 cscOpgiId, Val(Cell.Value), csInteger
          End If
        Case KICH_DESCRIP
          register.Fields.Add2 cscOpgiDescrip, Cell.Value, csText
        
        Case KICH_CHEQUERA
          register.Fields.Add2 cscChqId, Cell.Id, csId
        
        Case KICH_CHEQUE
          register.Fields.Add2 cscOpgiTMPCheque, Cell.Value, csText
        
        Case KICH_CHEQ_ID
          register.Fields.Add2 cscCheqId, Cell.Id, csId
          
        Case KICH_CLE_ID
          register.Fields.Add2 cscCleId, Cell.Id, csId
        
        Case KICH_MON_ID
          register.Fields.Add2 cscMonId, Cell.Id, csId
        Case KICH_FECHACOBRO
          register.Fields.Add2 cscOpgiTMPFechaCobro, Cell.Value, csDate
        Case KICH_FECHAVTO
          register.Fields.Add2 cscOpgiTMPFechaVto, Cell.Value, csDate
        
        Case KICH_CUE_ID
          register.Fields.Add2 cscCueId, Cell.Id, csId
        Case KICH_IMPORTEORIGEN
          register.Fields.Add2 cscOpgiImporteOrigen, Val(Cell.Value), csCurrency
        Case KICH_IMPORTE
          register.Fields.Add2 cscOpgiImporte, Val(Cell.Value), csCurrency
      End Select
    Next
    
    m_iOrden = m_iOrden + 1
    register.Fields.Add2 cscOpgiOrden, m_iOrden, csInteger
    register.Fields.Add2 cscOpgiTipo, csEOrdenPagoItemTipo.csEOpgiTCheques, csInteger
    register.Fields.Add2 cscOpgTMPId, Id, csId
    register.Fields.Add2 cscOpgiOtroTipo, csEItemOtroTipo.csEOtroHaber, csInteger
    
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
      register.fieldId = cscOpgibTMPId
      register.Table = csTOrdenPagoItemBorradoTMP
      register.Id = csNew
      
      register.Fields.Add2 cscOpgiId, Val(vDeletes(i)), csInteger
      register.Fields.Add2 cscOpgId, m_Id, csId
      register.Fields.Add2 cscOpgTMPId, Id, csId
      
      register.Fields.HaveLastUpdate = False
      register.Fields.HaveWhoModify = False
                                                            
      If Not gDB.Save(register, , "pSaveCheques", C_Module, c_ErrorSave) Then Exit Function
    Next
    
  End If
  
  pSaveCheques = True
End Function

Private Function pSaveOtros(ByVal Id As Long) As Boolean
  Dim register  As cRegister
  
  Dim Row  As cIABMGridRow
  Dim Cell As cIABMGridCellValue
  
  For Each Row In pGetOtros().Rows
  
    Set register = New cRegister
    register.fieldId = cscOpgiTMPId
    register.Table = csTOrdenPagoItemTMP
    register.Id = csNew
    
    For Each Cell In Row
      Select Case Cell.Key
        
        Case KICH_OPGI_ID
          If m_Copy Then
            register.Fields.Add2 cscOpgiId, csNew, csInteger
          Else
            register.Fields.Add2 cscOpgiId, Val(Cell.Value), csInteger
          End If
        Case KIO_DESCRIP
          register.Fields.Add2 cscOpgiDescrip, Cell.Value, csText
        Case KIO_RET_ID
          register.Fields.Add2 cscRetId, Cell.Id, csId
        Case KIO_NRORETENCION
          register.Fields.Add2 cscOpgiNroRetencion, Cell.Value, csText
        Case KIO_PORCRETENCION
          register.Fields.Add2 cscOpgiPorcRetencion, Val(Cell.Value), csDouble
        Case KIO_CCOS_ID
          register.Fields.Add2 cscCcosId, Cell.Id, csId
        Case KIO_FC_ID_RET
          register.Fields.Add2 cscFcIdRet, Cell.Id, csId
        Case KIO_CUE_ID
          register.Fields.Add2 cscCueId, Cell.Id, csId
        Case KIO_FECHARETENCION
          register.Fields.Add2 cscOpgiFechaRetencion, Cell.Value, csDate
        Case KIO_IMPORTEORIGEN
          register.Fields.Add2 cscOpgiImporteOrigen, Val(Cell.Value), csCurrency
        Case KIO_DEBE
          If Val(Cell.Value) <> 0 Then
            register.Fields.Add2 cscOpgiImporte, Val(Cell.Value), csCurrency
            register.Fields.Add2 cscOpgiOtroTipo, csEItemOtroTipo.csEOtroHaber, csInteger
          End If
        Case KIO_HABER
          If Val(Cell.Value) <> 0 Then
            register.Fields.Add2 cscOpgiImporte, Val(Cell.Value), csCurrency
            register.Fields.Add2 cscOpgiOtroTipo, csEItemOtroTipo.csEOtroDebe, csInteger
          End If
      End Select
    Next
    
    m_iOrden = m_iOrden + 1
    register.Fields.Add2 cscOpgiOrden, m_iOrden, csInteger
    register.Fields.Add2 cscOpgiTipo, csEOrdenPagoItemTipo.csEOpgiTOtros, csInteger
    register.Fields.Add2 cscOpgTMPId, Id, csId
    
    register.Fields.HaveLastUpdate = False
    register.Fields.HaveWhoModify = False
                                                        
    If Not gDB.Save(register, , "pSaveOtros", C_Module, c_ErrorSave) Then Exit Function
  Next
  
  Dim sqlstmt As String
  
  If m_OtrosDeleted <> vbNullString And m_Id <> csNO_ID And Not m_Copy Then
  
    Dim vDeletes As Variant
    Dim i As Long
    
    m_OtrosDeleted = RemoveLastColon(m_OtrosDeleted)
    vDeletes = Split(m_OtrosDeleted, ",")
    
    For i = 0 To UBound(vDeletes)
    
      Set register = New cRegister
      register.fieldId = cscOpgibTMPId
      register.Table = csTOrdenPagoItemBorradoTMP
      register.Id = csNew
      
      register.Fields.Add2 cscOpgiId, Val(vDeletes(i)), csInteger
      register.Fields.Add2 cscOpgId, m_Id, csId
      register.Fields.Add2 cscOpgTMPId, Id, csId
      
      register.Fields.HaveLastUpdate = False
      register.Fields.HaveWhoModify = False
                                                          
      If Not gDB.Save(register, , "pSaveOtros", C_Module, c_ErrorSave) Then Exit Function
    Next
    
  End If
  
  pSaveOtros = True
End Function

Private Function pSaveEfectivo(ByVal Id As Long) As Boolean
  Dim register  As cRegister
        
  Dim Row  As cIABMGridRow
  Dim Cell As cIABMGridCellValue
  
  For Each Row In pGetEfectivo().Rows
  
    Set register = New cRegister
    register.fieldId = cscOpgiTMPId
    register.Table = csTOrdenPagoItemTMP
    register.Id = csNew
    
    For Each Cell In Row
      Select Case Cell.Key
        
        Case KICH_OPGI_ID
          If m_Copy Then
            register.Fields.Add2 cscOpgiId, csNew, csInteger
          Else
            register.Fields.Add2 cscOpgiId, Val(Cell.Value), csInteger
          End If
        Case KIE_DESCRIP
          register.Fields.Add2 cscOpgiDescrip, Cell.Value, csText
        Case KIE_CUE_ID
          register.Fields.Add2 cscCueId, Cell.Id, csId
        Case KIE_IMPORTEORIGEN
          register.Fields.Add2 cscOpgiImporteOrigen, Val(Cell.Value), csCurrency
        Case KIE_IMPORTE
          register.Fields.Add2 cscOpgiImporte, Val(Cell.Value), csCurrency
      End Select
    Next
    
    m_iOrden = m_iOrden + 1
    register.Fields.Add2 cscOpgiOrden, m_iOrden, csInteger
    register.Fields.Add2 cscOpgiTipo, csEOrdenPagoItemTipo.csEOpgiTEfectivo, csInteger
    register.Fields.Add2 cscOpgTMPId, Id, csId
    register.Fields.Add2 cscOpgiOtroTipo, csEItemOtroTipo.csEOtroHaber, csInteger
    
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
      register.fieldId = cscOpgibTMPId
      register.Table = csTOrdenPagoItemBorradoTMP
      register.Id = csNew
      
      register.Fields.Add2 cscOpgiId, Val(vDeletes(i)), csInteger
      register.Fields.Add2 cscOpgId, m_Id, csId
      register.Fields.Add2 cscOpgTMPId, Id, csId
      
      register.Fields.HaveLastUpdate = False
      register.Fields.HaveWhoModify = False
                                                            
      If Not gDB.Save(register, , "pSaveEfectivo", C_Module, c_ErrorSave) Then Exit Function
    Next
    
  End If
  
  pSaveEfectivo = True
End Function

Private Function pSaveCtaCte(ByVal Id As Long) As Boolean
  Dim register  As cRegister
        
  Dim Row  As cIABMGridRow
  Dim Cell As cIABMGridCellValue
  
  For Each Row In pGetCtaCte().Rows
  
    Set register = New cRegister
    register.fieldId = cscOpgiTMPId
    register.Table = csTOrdenPagoItemTMP
    register.Id = csNew
    
    For Each Cell In Row
      Select Case Cell.Key
        
        Case KICH_OPGI_ID
          If m_Copy Then
            register.Fields.Add2 cscOpgiId, csNew, csInteger
          Else
            register.Fields.Add2 cscOpgiId, Val(Cell.Value), csInteger
          End If
        Case KICC_CUE_ID
          register.Fields.Add2 cscCueId, Cell.Id, csId
        Case KICC_IMPORTEORIGEN
          register.Fields.Add2 cscOpgiImporteOrigen, Val(Cell.Value), csCurrency
        Case KICC_IMPORTE
          register.Fields.Add2 cscOpgiImporte, Val(Cell.Value), csCurrency
      End Select
    Next
    
    m_iOrden = m_iOrden + 1
    register.Fields.Add2 cscOpgiOrden, m_iOrden, csInteger
    register.Fields.Add2 cscOpgiTipo, csEOrdenPagoItemTipo.csEOpgiTCtaCte, csInteger
    register.Fields.Add2 cscOpgTMPId, Id, csId
    register.Fields.Add2 cscOpgiOtroTipo, csEItemOtroTipo.csEOtroDebe, csInteger
    
    register.Fields.HaveLastUpdate = False
    register.Fields.HaveWhoModify = False
                                                         
    If Not gDB.Save(register, , "pSaveCtaCte", C_Module, c_ErrorSave) Then Exit Function
  Next
  
  Dim sqlstmt As String
  
  If m_CtaCteDeleted <> vbNullString And m_Id <> csNO_ID And Not m_Copy Then
  
    Dim vDeletes As Variant
    Dim i As Long
    
    m_CtaCteDeleted = RemoveLastColon(m_CtaCteDeleted)
    vDeletes = Split(m_CtaCteDeleted, ",")
    
    For i = 0 To UBound(vDeletes)
    
      Set register = New cRegister
      register.fieldId = cscOpgibTMPId
      register.Table = csTOrdenPagoItemBorradoTMP
      register.Id = csNew
      
      register.Fields.Add2 cscOpgiId, Val(vDeletes(i)), csInteger
      register.Fields.Add2 cscOpgId, m_Id, csId
      register.Fields.Add2 cscOpgTMPId, Id, csId
      
      register.Fields.HaveLastUpdate = False
      register.Fields.HaveWhoModify = False
                                                          
      If Not gDB.Save(register, , "pSaveCtaCte", C_Module, c_ErrorSave) Then Exit Function
    Next
    
  End If
  
  pSaveCtaCte = True
End Function

Private Sub pShowApply()
  
  If Not DocSecurityCanAccess(csPreTsrModifyAplic, m_doc_id, csEDocTPreAplicar) Then Exit Sub
  
  If m_ObjApply Is Nothing Then
    Set m_ObjApply = New cOrdenPagoAplic
  
  ' Edit Apply
  '
  Else
    If m_ObjApply.Id <> m_Id Then
      Set m_ObjApply.ObjectClient = Nothing
      Set m_ObjApply = New cOrdenPagoAplic
    End If
  End If

  ' Edit Apply
  '
  Set m_ObjApply.ObjectClient = Me
  
  If Not m_ObjApply.Show(m_Id, m_Total, m_Nrodoc, m_Proveedor) Then
    Set m_ObjApply = Nothing
  End If
End Sub

'//////////////////////////////////////////////////////////////////////////////
Private Function pGetTCheques() As cIABMGrid
  Set pGetTCheques = pGetTChequesProperty().Grid
End Function

Private Function pGetCheques() As cIABMGrid
  Set pGetCheques = pGetChequesProperty().Grid
End Function

Private Function pGetEfectivo() As cIABMGrid
  Set pGetEfectivo = pGetEfectivoProperty().Grid
End Function

Private Function pGetOtros() As cIABMGrid
  Set pGetOtros = pGetOtrosProperty().Grid
End Function

Private Function pGetCtaCte() As cIABMGrid
  Set pGetCtaCte = pGetCtaCteProperty().Grid
End Function

Private Function pGetTChequesProperty() As cIABMProperty
  Set pGetTChequesProperty = m_Items.Properties.Item(c_ChequesT)
End Function

Private Function pGetChequesProperty() As cIABMProperty
  Set pGetChequesProperty = m_Items.Properties.Item(c_Cheques)
End Function

Private Function pGetEfectivoProperty() As cIABMProperty
  Set pGetEfectivoProperty = m_Items.Properties.Item(c_Efectivo)
End Function

Private Function pGetOtrosProperty() As cIABMProperty
  Set pGetOtrosProperty = m_Items.Properties.Item(c_Otros)
End Function

Private Function pGetCtaCteProperty() As cIABMProperty
  Set pGetCtaCteProperty = m_Items.Properties.Item(c_CtaCte)
End Function
'//////////////////////////////
'  Codigo estandar de errores
'  On Error GoTo ControlError
'
'  GoTo ExitProc
'ControlError:
'  MngError err,"", C_Module, ""
'  If Err.Number Then Resume ExitProc
'ExitProc:
'  On Error Resume Next

Private Function pColAUpdateTCheque(ByRef IProperty As cIABMProperty, ByVal lRow As Long, ByVal lCol As Long) As Boolean
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
      
      Case KICHT_CUE_ID
        Dim MonId   As Long
        Dim CueId   As Long
        Dim Moneda  As String
        
        Set Row = .Rows(lRow)
        
        CueId = pCell(Row, KICHT_CUE_ID).Id
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
      
        pShowPagoNeto
        pShowPagoTotal
      
        pColAUpdateTCheque = True
        Exit Function
      
      Case Else
        pColAUpdateTCheque = True
        Exit Function
    End Select
  End With
  
  pColAUpdateTCheque = True
End Function

Private Function pColAUpdateCheque(ByRef IProperty As cIABMProperty, ByVal lRow As Long, ByVal lCol As Long) As Boolean
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
      
      Case KICH_CUE_ID
        Dim MonId   As Long
        Dim CueId   As Long
        Dim Moneda  As String
        
        Set Row = .Rows(lRow)
        
        CueId = pCell(Row, KICH_CUE_ID).Id
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
  
  pShowPagoNeto
  pShowPagoTotal
  pColAUpdateCheque = True
End Function

Private Function pColAUpdateCtaCte(ByRef IProperty As cIABMProperty, ByVal lRow As Long, ByVal lCol As Long) As Boolean
  pColAUpdateCtaCte = True
End Function

Private Function pColAUpdateEfectivo(ByRef IProperty As cIABMProperty, ByVal lRow As Long, ByVal lCol As Long) As Boolean
  Dim Row      As cIABMGridRow
  Dim Value    As Double
  
  With IProperty.Grid
    Select Case .Columns(lCol).Key
      Case KIE_IMPORTEORIGEN
        Set Row = .Rows(lRow)
        With pCell(Row, KIE_MON_ID)
          If .Id <> m_MonDefault Or .Id = 0 Then
            pCell(Row, KIE_IMPORTE).Value = Val(pCell(Row, KIE_IMPORTEORIGEN).Value) * Val(pGetCotizacion().Value)
          Else
            pCell(Row, KIE_IMPORTEORIGEN).Value = 0
          End If
        End With
      Case KIE_IMPORTE
        
      Case KIE_CUE_ID
        Dim MonId   As Long
        Dim Moneda  As String
        Set Row = .Rows(lRow)
        GetMonedaFromCuenta MonId, Moneda, pCell(Row, KIE_CUE_ID).Id
        With pCell(Row, KIE_MON_ID)
          .Value = Moneda
          .Id = MonId
        End With
      
        If MonId = m_MonDefault Or MonId = 0 Then
          pCell(Row, KIE_IMPORTEORIGEN).Value = 0
        End If
                
        pColAUpdateEfectivo = True
        Exit Function
      Case Else
        pColAUpdateEfectivo = True
        Exit Function
    End Select
  End With
  
  pShowPagoNeto
  pShowPagoTotal
  pColAUpdateEfectivo = True
End Function

Private Function pColAUpdateOtro(ByRef IProperty As cIABMProperty, ByVal lRow As Long, ByVal lCol As Long) As Boolean
  Dim Row      As cIABMGridRow
  Dim Value    As Double
  
  With IProperty.Grid
    Select Case .Columns(lCol).Key
      Case KIO_DEBE
        Set Row = .Rows(lRow)
        pCell(Row, KIO_IMPORTEORIGEN).Value = Val(pCell(Row, KIO_DEBE).Value)
        pCell(Row, KIO_HABER).Value = 0
      Case KIO_HABER
        Set Row = .Rows(lRow)
        pCell(Row, KIO_IMPORTEORIGEN).Value = Val(pCell(Row, KIO_HABER).Value)
        pCell(Row, KIO_DEBE).Value = 0
      Case Else
        pColAUpdateOtro = True
        Exit Function
    End Select
  End With
  
  pShowPagoOtro
  pShowPagoTotal
  pColAUpdateOtro = True
End Function

Private Function pGetCotizacion() As cIABMProperty
  Set pGetCotizacion = m_ObjAbm.Properties.Item(cscOpgCotizacion)
End Function

Private Sub pShowPagoNeto()
  Dim Row           As cIABMGridRow
  Dim Total         As Double
  Dim TotalOrigen   As Double
  
  For Each Row In pGetCheques().Rows
    Total = Total + Val(pCell(Row, KICH_IMPORTE).Value)
  Next
  
  For Each Row In pGetTCheques().Rows
    Total = Total + Val(pCell(Row, KICH_IMPORTE).Value)
  Next
  
  For Each Row In pGetEfectivo().Rows
    Total = Total + Val(pCell(Row, KIE_IMPORTE).Value)
  Next
  
  pGetPagoNeto().Value = Total
  m_Footer.ShowValue pGetPagoNeto
End Sub

Private Sub pShowPagoOtro()
  Dim Row           As cIABMGridRow
  Dim Total         As Double
  
  For Each Row In pGetOtros().Rows
    Total = Total + Val(pCell(Row, KIO_DEBE).Value) - Val(pCell(Row, KIO_HABER).Value)
  Next
  
  pGetPagoOtros().Value = Total
  m_Footer.ShowValue pGetPagoOtros
End Sub

Private Sub pShowPagoTotal()
  pGetPagoTotal.Value = Val(pGetPagoNeto().Value) + Val(pGetPagoOtros().Value)
  m_Footer.ShowValue pGetPagoTotal
End Sub

Private Function pGetPagoNeto() As cIABMProperty
  Set pGetPagoNeto = m_Footer.Properties.Item(cscOpgNeto)
End Function

Private Function pGetPagoOtros() As cIABMProperty
  Set pGetPagoOtros = m_Footer.Properties.Item(cscOpgOtros)
End Function

Private Function pGetPagoTotal() As cIABMProperty
  Set pGetPagoTotal = m_Footer.Properties.Item(cscOpgTotal)
End Function

Private Function pIsEmptyRowTCheques(ByRef Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  Dim Cell                  As cIABMGridCellValue
  Dim strRow                As String
  Dim bRowIsEmpty           As Boolean
  
  strRow = " (Fila " & RowIndex & ")"
  
  bRowIsEmpty = True
  
  For Each Cell In Row
    Select Case Cell.Key
      Case KICHT_CUE_ID, KICHT_MON_ID, KICHT_CLE_ID
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

Private Function pIsEmptyRowCheques(ByRef Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  Dim Cell                  As cIABMGridCellValue
  Dim strRow                As String
  Dim bRowIsEmpty           As Boolean
  
  strRow = " (Fila " & RowIndex & ")"
  
  bRowIsEmpty = True
  
  For Each Cell In Row
    Select Case Cell.Key
      Case KICH_CUE_ID, KICH_CHEQUERA, KICH_MON_ID, KICH_CLE_ID
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

Private Function pValidateRowTCheques(ByRef Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  Dim Cell                  As cIABMGridCellValue
  Dim strRow                As String
  Dim bOrigen               As Boolean
  
  strRow = " (Fila " & RowIndex & ")"
  
  For Each Cell In Row
    Select Case Cell.Key
      
      Case KICHT_CUE_ID
        If ValEmpty(Cell.Id, csId) Then
          MsgInfo LNGGetText(2113, vbNullString, strRow)  'Debe indicar una cuenta contable (1)
          Exit Function
        End If
      
      Case KICHT_CHEQUE
        If ValEmpty(Cell.Id, csId) Then
          MsgInfo LNGGetText(2197, vbNullString, strRow)  'Debe indicar un Cheque (1)
          Exit Function
        End If
    End Select
  Next
  
  pValidateRowTCheques = True
End Function

Private Function pValidateRowCheques(ByRef Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  Dim Cell                  As cIABMGridCellValue
  Dim strRow                As String
  Dim bOrigen               As Boolean
  Dim MonId                 As Long
  
  strRow = " (Fila " & RowIndex & ")"
  
  For Each Cell In Row
    Select Case Cell.Key
      
      Case KICH_CUE_ID
        If ValEmpty(Cell.Id, csId) Then
          MsgInfo LNGGetText(2113, vbNullString, strRow)  'Debe indicar una cuenta contable (1)
          Exit Function
        End If
        
      Case KICH_MON_ID
        If ValEmpty(Cell.Id, csId) Then
          MsgInfo LNGGetText(2114, vbNullString, strRow)  'Debe indicar una moneda (1)
          Exit Function
        End If
        MonId = Cell.Id
        
      Case KICH_CLE_ID
        If ValEmpty(Cell.Id, csId) Then
          MsgInfo LNGGetText(2115, vbNullString, strRow)  'Debe indicar un clearing (1)
          Exit Function
        End If
    
      Case KICH_IMPORTEORIGEN
        bOrigen = Not ValEmpty(Val(Cell.Value), csDouble)
      
      Case KICH_IMPORTE
        If ValEmpty(Val(Cell.Value), csDouble) Then
          MsgInfo LNGGetText(1897, vbNullString, strRow)  'Debe indicar un importe (1)
          Exit Function
        End If
      
      Case KICH_CHEQUERA
        If ValEmpty(Cell.Id, csId) Then
          MsgInfo LNGGetText(2193, vbNullString, strRow)  'Debe indicar una chequera (1)
          Exit Function
        End If
      
      Case KICH_CHEQUE
        If ValEmpty(Cell.Value, csText) Then
          MsgInfo LNGGetText(2116, vbNullString, strRow)  'Debe indicar una número de cheque (1)
          Exit Function
        End If
      
      Case KICH_FECHACOBRO
        If ValEmpty(Cell.Value, csDate) Then
          MsgInfo LNGGetText(2117, vbNullString, strRow)  'Debe indicar una fecha para depositar (1)
          Exit Function
        End If
      
      Case KICH_FECHAVTO
        If ValEmpty(Cell.Value, csDate) Then
          MsgInfo LNGGetText(1384, vbNullString, strRow)  'Debe indicar una fecha de vencimiento (1)
          Exit Function
        End If
    End Select
  Next
  
  If Not bOrigen And MonId <> m_MonDefault Then
    MsgInfo LNGGetText(2118, vbNullString, strRow)  'Debe indicar un importe para la moneda extranjera (1)
    Exit Function
  End If
  
  pValidateRowCheques = True
End Function

Private Function pIsEmptyRowOtros(ByRef Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  Dim Cell                  As cIABMGridCellValue
  Dim strRow                As String
  Dim bRowIsEmpty           As Boolean
  
  strRow = " (Fila " & RowIndex & ")"
  
  bRowIsEmpty = True
  
  For Each Cell In Row
    Select Case Cell.Key
      Case KIO_CUE_ID, KIO_CCOS_ID, KIO_RET_ID
        If Not ValEmpty(Cell.Id, csId) Then
          bRowIsEmpty = False
          Exit For
        End If
    
      Case KIO_DEBE, KIO_HABER, KIO_IMPORTEORIGEN, KIO_PORCRETENCION
        If Not ValEmpty(Val(Cell.Value), csDouble) Then
          bRowIsEmpty = True
          Exit For
        End If
      
      Case KIO_NRORETENCION, KIO_DESCRIP
        If Not ValEmpty(Cell.Value, csText) Then
          bRowIsEmpty = True
          Exit For
        End If
      
      Case KIO_FECHARETENCION
        If Not ValEmpty(Cell.Value, csDate) Then
          bRowIsEmpty = True
          Exit For
        End If
    End Select
  Next
  
  pIsEmptyRowOtros = bRowIsEmpty
End Function

Private Function pValidateRowOtros(ByRef Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  Dim Cell                  As cIABMGridCellValue
  Dim strRow                As String
  Dim bOrigen               As Boolean
  Dim bDebe                 As Boolean
  Dim bHaber                As Boolean
  Dim MonId                 As Long
  
  strRow = " (Fila " & RowIndex & ")"
  
  For Each Cell In Row
    Select Case Cell.Key
      
      Case KIO_CUE_ID
        If ValEmpty(Cell.Id, csId) Then
          MsgInfo LNGGetText(2113, vbNullString, strRow)  'Debe indicar una cuenta contable (1)
          Exit Function
        End If
      
        If Not gDB.GetData(csTCuenta, cscCueId, Cell.Id, cscMonId, MonId) Then Exit Function
        
      Case KIO_DEBE
        bDebe = Not ValEmpty(Val(Cell.Value), csDouble)
        
      Case KIO_HABER
        bHaber = Not ValEmpty(Val(Cell.Value), csDouble)
        
      Case KIO_IMPORTEORIGEN
        bOrigen = Not ValEmpty(Val(Cell.Value), csDouble)
        
    End Select
  Next
  
  If Not bDebe And Not bHaber Then
    MsgInfo LNGGetText(1898, vbNullString, strRow)
            'Debe indicar un importe en el debe o en el haber (1)
    Exit Function
  End If
  
  If Not bOrigen And MonId <> m_MonDefault Then
    MsgInfo LNGGetText(2118, vbNullString, strRow)
            'Debe indicar un importe para la moneda extranjera (1)
    Exit Function
  End If
  
  pValidateRowOtros = True
End Function

Private Function pIsEmptyRowCtaCte(ByRef Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  Dim Cell                  As cIABMGridCellValue
  Dim strRow                As String
  Dim bRowIsEmpty           As Boolean
  
  strRow = " (Fila " & RowIndex & ")"
  
  bRowIsEmpty = True
  
  For Each Cell In Row
    Select Case Cell.Key
      Case KICC_CUE_ID
        If Not ValEmpty(Cell.Id, csId) Then
          bRowIsEmpty = False
          Exit For
        End If
    
      Case KICC_IMPORTE, KICC_IMPORTEORIGEN
        If Not ValEmpty(Val(Cell.Value), csDouble) Then
          bRowIsEmpty = True
          Exit For
        End If
    End Select
  Next
  
  pIsEmptyRowCtaCte = bRowIsEmpty
End Function

Private Function pValidateRowCtaCte(ByRef Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  Dim Cell                  As cIABMGridCellValue
  Dim strRow                As String
  Dim bOrigen               As Boolean
  Dim MonId                 As Long
  
  strRow = " (Fila " & RowIndex & ")"
  
  For Each Cell In Row
    Select Case Cell.Key
      
      Case KICC_CUE_ID
        If ValEmpty(Cell.Id, csId) Then
          MsgInfo LNGGetText(2113, vbNullString, strRow)  'Debe indicar una cuenta contable (1)
          Exit Function
        End If
        
        If Not gDB.GetData(csTCuenta, cscCueId, Cell.Id, cscMonId, MonId) Then Exit Function
        
      Case KICC_IMPORTEORIGEN
        bOrigen = Not ValEmpty(Val(Cell.Value), csDouble)
      
      Case KICC_IMPORTE
        If ValEmpty(Val(Cell.Value), csDouble) Then
          MsgInfo LNGGetText(1897, vbNullString, strRow)  'Debe indicar un importe (1)
          Exit Function
        End If
    End Select
  Next
  
  If Not bOrigen And MonId <> m_MonDefault Then
    MsgInfo LNGGetText(2118, vbNullString, strRow)
            'Debe indicar un importe para la moneda extranjera (1)
    Exit Function
  End If
  
  pValidateRowCtaCte = True
End Function

Private Function pIsEmptyRowEfectivo(ByRef Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  Dim Cell                  As cIABMGridCellValue
  Dim strRow                As String
  Dim bRowIsEmpty           As Boolean
  
  strRow = " (Fila " & RowIndex & ")"
  
  bRowIsEmpty = True
  
  For Each Cell In Row
    Select Case Cell.Key
      Case KIE_CUE_ID
        If Not ValEmpty(Cell.Id, csId) Then
          bRowIsEmpty = False
          Exit For
        End If
    
      Case KIE_IMPORTE, KIE_IMPORTEORIGEN
        If Not ValEmpty(Val(Cell.Value), csDouble) Then
          bRowIsEmpty = True
          Exit For
        End If
      
      Case KIE_DESCRIP
        If Not ValEmpty(Cell.Value, csText) Then
          bRowIsEmpty = True
          Exit For
        End If
    End Select
  Next
  
  pIsEmptyRowEfectivo = bRowIsEmpty
End Function

Private Function pValidateRowEfectivo(ByRef Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  Dim Cell                  As cIABMGridCellValue
  Dim strRow                As String
  Dim bOrigen               As Boolean
  Dim MonId                 As Long
  
  strRow = " (Fila " & RowIndex & ")"
  
  For Each Cell In Row
    Select Case Cell.Key
      
      Case KIE_CUE_ID
        If ValEmpty(Cell.Id, csId) Then
          MsgInfo LNGGetText(2113, vbNullString, strRow)  'Debe indicar una cuenta contable (1)
          Exit Function
        End If
        
        If Not gDB.GetData(csTCuenta, cscCueId, Cell.Id, cscMonId, MonId) Then Exit Function
        
      Case KIE_IMPORTEORIGEN
        bOrigen = Not ValEmpty(Val(Cell.Value), csDouble)
      
      Case KIE_IMPORTE
        If ValEmpty(Val(Cell.Value), csDouble) Then
          MsgInfo LNGGetText(1897, vbNullString, strRow)  'Debe indicar un importe (1)
          Exit Function
        End If
    End Select
  Next
  
  If Not bOrigen And MonId <> m_MonDefault Then
    MsgInfo LNGGetText(2118, vbNullString, strRow)
            'Debe indicar un importe para la moneda extranjera (1)
    Exit Function
  End If
  
  pValidateRowEfectivo = True
End Function

Private Sub pClearCheqId()
  Dim Row  As cIABMGridRow
  For Each Row In pGetCheques().Rows
    pCell(Row, KICH_CHEQ_ID).Id = csNO_ID
  Next
  For Each Row In pGetTCheques().Rows
    pCell(Row, KICHT_CHEQUE).Id = csNO_ID
  Next
  Dim AbmObj As cABMGeneric
  Set AbmObj = m_Items
  AbmObj.ShowValue pGetChequesProperty(), True
  AbmObj.ShowValue pGetTChequesProperty(), True
End Sub

Private Sub pSetFilterColFactura()
  
  Dim AbmObj As cABMGeneric
  Set AbmObj = m_Items
  
  pCol(pGetOtros().Columns, KIO_FC_ID_RET).HelpFilter = "prov.prov_id = " & pGetProveedor()
  AbmObj.RefreshColumnProperties pGetOtrosProperty(), cscFcIdRet
  
End Sub

Private Function pGetProveedor() As Long
  pGetProveedor = m_ObjAbm.Properties.Item(cscProvId).HelpId
End Function

Private Function pGetFileNamePostFix() As String
  Dim rtn As String
  
  rtn = Left$(m_ObjAbm.Properties.Item(cscProvId).Value, 50) & "-" & _
                m_ObjAbm.Properties.Item(cscOpgNrodoc).Value
        
  pGetFileNamePostFix = rtn
End Function


