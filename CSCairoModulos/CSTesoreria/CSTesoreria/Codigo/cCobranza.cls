VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cCobranza"
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
' cCobranza
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
Private Const C_Module = "cCobranza"

Private Const c_Cheques = "Cheques"
Private Const c_Efectivo = "Efectivo"
Private Const c_Tarjeta = "Tarjetas"
Private Const c_Otros = "Otros"
Private Const c_CtaCte = "Cuenta Corriente"
Private Const c_Cuotas = "Cuotas"

Private Const K_NUMERO                         As Integer = 1
Private Const K_NRODOC                         As Integer = 2
Private Const K_DESCRIP                        As Integer = 3
Private Const K_FECHA                          As Integer = 4
Private Const K_NETO                           As Integer = 6
Private Const K_TOTAL                          As Integer = 9
Private Const K_CLI_ID                         As Integer = 10
Private Const K_DOC_ID                         As Integer = 11
Private Const K_DOCT_ID                        As Integer = 12
Private Const K_CHEQUES                        As Integer = 15
Private Const K_EST_ID                         As Integer = 17
Private Const K_CCOS_ID                        As Integer = 18
Private Const K_SUC_ID                         As Integer = 19
Private Const K_OTROS                          As Integer = 24
Private Const K_COTIZACION                     As Integer = 25
Private Const K_COB_ID                         As Integer = 26
Private Const K_LGJ_ID                         As Integer = 27
Private Const K_EFECTIVO                       As Integer = 28
Private Const K_TARJETA                        As Integer = 29
Private Const K_CTACTE                         As Integer = 30

Private Const KI_IMPORTE                     As Integer = 1
Private Const KI_FV_ID                       As Integer = 2
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

Private Const KIO_COBZI_ID                   As Integer = 1
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
Private Const KIO_FV_ID_RET                  As Integer = 12

Private Const KICH_COBZI_ID              As Integer = 1
Private Const KICH_CUE_ID                As Integer = 2
Private Const KICH_IMPORTE               As Integer = 3
Private Const KICH_IMPORTEORIGEN         As Integer = 4
Private Const KICH_BCO_ID                As Integer = 5
Private Const KICH_CHEQUE                As Integer = 6
Private Const KICH_CHEQ_ID               As Integer = 7
Private Const KICH_MON_ID                As Integer = 8
Private Const KICH_FECHACOBRO            As Integer = 9
Private Const KICH_FECHAVTO              As Integer = 10
Private Const KICH_CLE_ID                As Integer = 11
Private Const KICH_DESCRIP               As Integer = 12
Private Const KICH_PROPIO                As Integer = 13

Private Const KIE_COBZI_ID               As Integer = 1
Private Const KIE_CUE_ID                 As Integer = 2
Private Const KIE_MON_ID                 As Integer = 3
Private Const KIE_IMPORTE                As Integer = 4
Private Const KIE_IMPORTEORIGEN          As Integer = 5
Private Const KIE_DESCRIP                As Integer = 6

Private Const KIT_COBZI_ID                As Integer = 1
Private Const KIT_CUPON                   As Integer = 2
Private Const KIT_TJC_ID                  As Integer = 3
Private Const KIT_IMPORTE                 As Integer = 4
Private Const KIT_IMPORTEORIGEN           As Integer = 5
Private Const KIT_FECHAVTO                As Integer = 7
Private Const KIT_NROTARJETA              As Integer = 8
Private Const KIT_NROAUTORIZACION         As Integer = 9
Private Const KIT_TITULAR                 As Integer = 10
Private Const KIT_MON_ID                  As Integer = 11
Private Const KIT_DESCRIP                 As Integer = 12
Private Const KIT_TARJETA_TIPO            As Integer = 13
Private Const KIT_TJCC_ID                 As Integer = 14
Private Const KIT_TJCCU_ID                As Integer = 15

Private Const KICC_COBZI_ID               As Integer = 1
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
Private m_cob_id                       As Long
Private m_Cobrador                     As String
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
Private m_EfectivoDeleted     As String
Private m_TarjetasDeleted     As String
Private m_OtrosDeleted        As String
Private m_CtaCteDeleted       As String

Private m_Copy              As Boolean

Private m_GeneralConfig     As cGeneralConfig

Private m_DocEditable       As Boolean
Private m_DocEditMsg        As String

Private m_TaPropuesto       As Boolean
Private m_TaMascara         As String

Private m_iOrden            As Long

Private m_ObjApply          As cCobranzaAplic

Private m_lColCuotas        As Long

Private m_FvIds()           As Long

Private m_CliIds()          As Long
Private m_FvIdsxCliId()     As Long
Private m_CobranzaInfo      As cCobranzaInfo

' Wizard Automatico
'
Private m_bPushVirtualNext         As Boolean
Private m_bCloseWizardAfterSave    As Boolean
Private m_bWizardCompleteSuccess   As Boolean

' propiedades publicas
Public Property Let PushVirtualNext(ByVal rhs As Boolean)
  m_bPushVirtualNext = rhs
End Property

Public Property Let CloseWizardAfterSave(ByVal rhs As Boolean)
  m_bCloseWizardAfterSave = rhs
End Property

Public Property Get WizardCompleteSuccess() As Boolean
  WizardCompleteSuccess = m_bWizardCompleteSuccess
End Property

' propiedades privadas
' funciones publicas

Public Function SetWizardCompleteSuccess(ByVal rhs As Boolean)
  m_bWizardCompleteSuccess = rhs
End Function

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

Public Sub ShowCobranza(ByVal CliId As Long, ByRef vFvIds() As Long)
  On Error GoTo ControlError

  m_Cli_id = CliId
  gDB.GetData csTCliente, cscCliId, CliId, cscCliNombre, m_Cliente
  
  Dim i As Long
  ReDim m_FvIds(UBound(vFvIds) + 1)
  For i = 1 To UBound(vFvIds) + 1
    m_FvIds(i) = vFvIds(i - 1)
  Next
  
  If Not pInitMembers Then
    Exit Sub
  End If
  
  pShowStartWizard False

  GoTo ExitProc
ControlError:
  MngError Err, "ShowCobranza", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Public Sub ShowCobranzaEx(ByRef vCliIds() As Long, _
                          ByRef vFvIdsxCliId() As Long)
  On Error GoTo ControlError
  
  Dim i As Long
  Dim j As Long
  
  ReDim m_CliIds(UBound(vCliIds))
  For i = 1 To UBound(vCliIds)
    m_CliIds(i) = vCliIds(i)
  Next
  
  ReDim m_FvIdsxCliId(UBound(vFvIdsxCliId, 1), UBound(vFvIdsxCliId, 2))
  For i = 1 To UBound(vFvIdsxCliId, 1)
    For j = 1 To UBound(vFvIdsxCliId, 2)
      m_FvIdsxCliId(i, j) = vFvIdsxCliId(i, j)
    Next
  Next
  
  If Not pInitMembers Then
    Exit Sub
  End If
  
  pShowStartWizard False

  GoTo ExitProc
ControlError:
  MngError Err, "ShowCobranzaEx", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

' Solo para Hojas de Ruta
'
Public Sub ShowCobranzaEx2(ByRef vCliIds() As Long, _
                           ByRef CobranzaInfo As cCobranzaInfo)
  On Error GoTo ControlError
  
  Dim i As Long
  
  ReDim m_CliIds(UBound(vCliIds))
  For i = 1 To UBound(vCliIds)
    m_CliIds(i) = vCliIds(i)
  Next
  
  Set m_CobranzaInfo = CobranzaInfo
  
  If Not pInitMembers Then
    Exit Sub
  End If
  
  pShowStartWizard True

  GoTo ExitProc
ControlError:
  MngError Err, "ShowCobranzaEx2", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Function pInitMembers() As Boolean
  Set cIEditGeneric_ObjAbm = New cABMGeneric
  Set cIEditGenericDoc_Footer = New cABMGeneric
  Set cIEditGenericDoc_Items = New cABMGeneric
  
  If Not DocSecurityCanAccess(csPreTsrNewCobranza, _
                              csNO_ID, _
                              csEDocTPreNew) Then
    Exit Function
  End If
  pInitMembers = True
End Function

' Implementacion de cIABMClient
Private Function cIABMClient_Copy() As Boolean

  If Not DocSecurityCanAccessEx(csPreTsrNewCobranza, _
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
  GetDocNumber m_LastDoc, m_ObjAbm, m_TaPropuesto, cscCobzNrodoc
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
  GetDocNumber m_LastDoc, m_ObjAbm, m_TaPropuesto, cscCobzNrodoc
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

  Doc.ClientTable = csTCobranza
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
        Case K_CHEQUES, K_EFECTIVO, K_TARJETA
          pShowCobroNeto
        Case K_OTROS
          pShowCobroOtro
      End Select
      pShowCobroTotal
    
    Case MSG_DOC_EDIT_STATE
      ShowEditState m_DocEditMsg, LNGGetText(2060, vbNullString) 'Cobranza
    
    Case MSG_DOC_APPLY
      pShowApply
    
    Case MSG_DOC_DELETE
      If cIEditGeneric_Delete(m_Id) Then
        cIABMClient_MessageEx = True
        pMove MSG_DOC_NEXT
      End If
    
    Case MSG_DOC_ANULAR
      DocAnular m_Id, m_est_id, m_Estado, csPreTsrAnularCobranza, csPreTsrDesAnularCobranza, m_ObjAbm, m_DocEditable, m_DocEditMsg, "sp_DocCobranzaAnular", "sp_DocCobranzaEditableGet"
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
      DocumentSearch csEDT_Cobranza, Me, Not CBool(Info)
  
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
          
          If DocCanSave(m_ObjAbm, cscCobzFecha) Then
            
            Dim EditDoc As cEditDocEx
            Set EditDoc = New cEditDocEx
            
            Set EditDoc.ObjectClient = Me
            EditDoc.Edit m_Id, _
                         m_Doct_id, _
                         csTCobranza, _
                         cscCobzId, _
                         csTCobranzaItem, _
                         cscCobziId, _
                         csPreTsrNewCobranza, _
                         csPreTsrEditCobranza, _
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
    
        ShowHistory csCobranza, m_Id, m_Documento & " " & m_Nrodoc
      Else
        
        MsgInfo LNGGetText(1552, vbNullString) 'El documento aun no ha sido guardado
      End If
  
    Case MSG_EXPORT_GET_EMAIL
    
      cIABMClient_MessageEx = GetEmailFromCliente(pGetCliente())
  
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
        GetDocNumber m_LastDoc, m_ObjAbm, m_TaPropuesto, cscCobzNrodoc
        
      End If
      
      ' Defino el estado de edicion del comprobante
      '
      pSetEnabled
  
    Case K_CLI_ID
    
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
  If Not DocCanSave(m_ObjAbm, cscCobzFecha) Then
    cIABMClient_Save = False
    Exit Function
  End If
  
  ' OJO -tsr
  If pGetCheques().Rows.count = 0 And _
     pGetTarjetas().Rows.count = 0 And _
     pGetOtros().Rows.count = 0 And _
     pGetEfectivo().Rows.count = 0 Then
     
    MsgWarning LNGGetText(3903, vbNullString) 'El documento debe contener al menos un item
    cIABMClient_Save = False
    Exit Function
  End If
  
  Dim Mouse As cMouseWait
  Set Mouse = New cMouseWait
  
  DoEvents: DoEvents: DoEvents: DoEvents
  
  Set register = New cRegister
  register.fieldId = cscCobzTMPId
  register.Table = csTCobranzaTMP
  
  register.Id = csNew
    
  If m_Copy Then
    register.Fields.Add2 cscCobzId, csNew, csLong
  Else
    register.Fields.Add2 cscCobzId, m_Id, csLong
  End If
  
  If register.Id = csNew Then
    m_est_id = CSGeneralEx2.csEEstado.csEEst_Pendiente
  End If
  
  Dim IProperty As cIABMProperty
  For Each IProperty In m_ObjAbm.Properties
    With IProperty
      Select Case .Key
        Case K_NUMERO
          register.Fields.Add2 cscCobzNumero, .Value, csLong
        Case K_NRODOC
          register.Fields.Add2 cscCobzNrodoc, .Value, csText
        Case K_DESCRIP
          register.Fields.Add2 cscCobzDescrip, .Value, csText
        Case K_FECHA
          register.Fields.Add2 cscCobzFecha, .Value, csDate
        Case K_CLI_ID
          register.Fields.Add2 cscCliId, .HelpId, csId
        Case K_CCOS_ID
          register.Fields.Add2 cscCcosId, .HelpId, csId
        Case K_SUC_ID
          register.Fields.Add2 cscSucId, .HelpId, csId
        Case K_DOC_ID
          register.Fields.Add2 cscDocId, .HelpId, csId
        Case K_COTIZACION
          register.Fields.Add2 cscCobzCotizacion, .Value, csDouble
        Case K_COB_ID
          register.Fields.Add2 cscCobId, .HelpId, csId
        Case K_LGJ_ID
          register.Fields.Add2 cscLgjId, .HelpId, csId
      End Select
    End With
  Next
  
  For Each IProperty In m_Footer.Properties
    With IProperty
      Select Case .Key
        Case K_NETO
          register.Fields.Add2 cscCobzNeto, Val(.Value), csCurrency
        Case K_OTROS
          register.Fields.Add2 cscCobzOtros, Val(.Value), csCurrency
        Case K_TOTAL
          register.Fields.Add2 cscCobzTotal, Val(.Value), csCurrency
      End Select
    End With
  Next
  
  register.Fields.Add2 cscCobzGrabarAsiento, 1, csBoolean
  register.Fields.Add2 cscEstId, m_est_id, csId
  
  register.Fields.HaveLastUpdate = True
  register.Fields.HaveWhoModify = True
  
  If Not register.BeginTrans(gDB) Then Exit Function
  
  If Not gDB.Save(register, , "cIABMClient_Save", C_Module, c_ErrorSave) Then Exit Function
  
  m_iOrden = 0
  If Not pSaveCheques(register.Id) Then Exit Function
  If Not pSaveEfectivo(register.Id) Then Exit Function
  If Not pSaveOtros(register.Id) Then Exit Function
  If Not pSaveTarjetas(register.Id) Then Exit Function
  If Not pSaveCtaCte(register.Id) Then Exit Function
  
  If Not register.CommitTrans() Then Exit Function
  
  Dim sqlstmt As String
  Dim rs      As Recordset
  sqlstmt = "sp_DocCobranzaSave " & register.Id
  
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
  
  m_ObjTree.sqlstmt = "sp_lsdoc_Cobranza"
  
  If m_IsNew Then
    m_ObjTree.AddLine m_Id
  Else
    m_ObjTree.RefreshLine m_Id
  End If
ControlError:
End Function

Private Property Get cIABMClient_Title() As String
  cIABMClient_Title = LNGGetText(2060, vbNullString)  'Cobranza
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
        Case K_CLI_ID
          If ValEmpty(.HelpId, csId) Then
            MsgInfo LNGGetText(1563, vbNullString)  'Debe indicar un cliente
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
    Case K_TARJETA
      cIABMClientGrid_IsEmptyRow = pIsEmptyRowTarjetas(Row, RowIndex)
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
  
  sqlstmt = "select doct_id, doc_id from Cobranza where cobz_id = " & Id
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
  cIEditGeneric_ShowList = SecurityCanAccess(csPreTsrListCobranza)
End Function

Private Property Set cIEditGeneric_ObjAbm(rhs As CSInterfacesABM.cIABMGeneric)
  Set m_ObjAbm = rhs
  m_ObjAbm.IsDocument = True

#If Not PREPROC_SFS Then
  Dim AbmGen      As cABMGenericDocEx
  
  Set AbmGen = m_ObjAbm
  With AbmGen
    .FactoryObject = "CSABMInterface2.cFactory"
    .ObjForm = "CSABMInterface2.fCobranza"
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
                          csTCobranza, _
                          cscCobzId, _
                          doc_id) Then
      Exit Function
    End If
  End If
  
  If Not DocSecurityCanAccess( _
                  csPreTsrDeleteCobranza, _
                  doc_id, _
                  csEDocTPreDelete) Then
    Exit Function
  End If

  Dim sqlstmt As String
  
  sqlstmt = "sp_DocCobranzaDelete " & Id & "," & EmpId & "," & User.Id
  
  cIEditGeneric_Delete = gDB.Execute(sqlstmt, "cIEditGeneric_Delete", C_Module)
End Function

Private Function cIEditGeneric_Search(Id As Long, Cancela As Boolean) As Boolean

End Function

Private Function cIEditGeneric_Edit(Id As Long, Optional ByVal InModalWindow As Boolean) As Boolean
  On Error GoTo ControlError
  
  If Not DocSecurityCanAccess(csPreTsrListCobranza, GetdocIdFromObjAbm(m_ObjAbm), csEDocTPreList) Then Exit Function
  
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
  
    If Not DocSecurityCanAccess(csPreTsrNewCobranza, GetdocIdFromObjAbm(m_ObjAbm), csEDocTPreNew) Then Exit Function
  
    pShowStartWizard False
  
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
      cIABMClientGrid_ColumnAfterUpdate = pColAUpdateCheque(m_Items.Properties(c_Cheques), lRow, lCol)
    Case K_TARJETA
      cIABMClientGrid_ColumnAfterUpdate = pColAUpdateTarjeta(m_Items.Properties(c_Tarjeta), lRow, lCol)
    Case K_OTROS
      cIABMClientGrid_ColumnAfterUpdate = pColAUpdateOtro(m_Items.Properties(c_Otros), lRow, lCol)
    Case K_EFECTIVO
      cIABMClientGrid_ColumnAfterUpdate = pColAUpdateEfectivo(m_Items.Properties(c_Efectivo), lRow, lCol)
    Case K_CTACTE
      cIABMClientGrid_ColumnAfterUpdate = pColAUpdateCtaCte(m_Items.Properties(c_CtaCte), lRow, lCol)
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
    Case K_CHEQUES, K_EFECTIVO, K_TARJETA, K_OTROS, K_CTACTE
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
    Case K_CHEQUES
      cIABMClientGrid_ColumnBeforeEdit = True
    Case K_TARJETA
      cIABMClientGrid_ColumnBeforeEdit = pColBeforeEditTarjeta(Key, lRow, lCol, iKeyAscii)
    Case K_OTROS
      cIABMClientGrid_ColumnBeforeEdit = True
    Case K_EFECTIVO
      cIABMClientGrid_ColumnBeforeEdit = True
    Case K_CTACTE
      cIABMClientGrid_ColumnBeforeEdit = True
  End Select
  
  GoTo ExitProc
ControlError:
  MngError Err, "cIABMClientGrid_ColumnBeforeEdit", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Private Function pColBeforeEditTarjeta(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long, ByVal iKeyAscii As Integer) As Boolean
  Dim Row As cIABMGridRow
  Dim IProperty As cIABMProperty
  Set IProperty = m_Items.Properties(c_Tarjeta)
  With IProperty.Grid
    Select Case .Columns(lCol).Key
      Case KIT_TJCCU_ID
        Set Row = .Rows(lRow)
        SetFilterCuotas Row, IProperty, m_Items, KIT_TJC_ID
    End Select
  End With
  pColBeforeEditTarjeta = True
End Function

Private Function pColumnBeforeEdit(ByRef IProperty As cIABMProperty, ByVal lRow As Long, ByVal lCol As Long, ByVal iKeyAscii As Integer)
  pColumnBeforeEdit = True
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
      Id = Val(pCell(Row, KICH_COBZI_ID).Value)
      If Id <> csNO_ID Then m_ChequesDeleted = m_ChequesDeleted & Id & ","
    Case K_TARJETA
      Id = Val(pCell(Row, KIT_COBZI_ID).Value)
      If Id <> csNO_ID Then m_TarjetasDeleted = m_TarjetasDeleted & Id & ","
    Case K_EFECTIVO
      Id = Val(pCell(Row, KIE_COBZI_ID).Value)
      If Id <> csNO_ID Then m_EfectivoDeleted = m_EfectivoDeleted & Id & ","
    Case K_OTROS
      Id = Val(pCell(Row, KIO_COBZI_ID).Value)
      If Id <> csNO_ID Then m_OtrosDeleted = m_OtrosDeleted & Id & ","
    Case K_CTACTE
      Id = Val(pCell(Row, KIO_COBZI_ID).Value)
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
    Case K_TARJETA
      cIABMClientGrid_ValidateRow = pValidateRowTarjetas(Row, RowIndex)
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
  Dim iTab        As cIABMTabItem
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
  
  m_ObjAbm.Properties.Clear

  m_ObjAbm.Tabs.Clear
  
  Set iTab = m_ObjAbm.Tabs.Add(Nothing)
  iTab.Index = 0
  iTab.Name = C_strGeneral
  
  
  Set iTab = m_ObjAbm.Tabs.Add(Nothing)
  iTab.Index = 1
  iTab.Name = LNGGetText(1566, vbNullString)  'Adicionales
  

  Set c = m_ObjAbm.Properties.Add(Nothing, cscDocId)
  c.PropertyType = cspHelp
  c.Table = CSDocumento2.CSDocumento
  c.Name = LNGGetText(1567, vbNullString)  'Documento
  c.Key = K_DOC_ID
  c.HelpId = m_doc_id
  c.Value = m_Documento
  c.HelpFilter = "'doct_id = " & csEDT_Cobranza & "'"
  
  
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
  
  
  Set c = m_ObjAbm.Properties.Add(Nothing, cscCobzFecha)
  c.PropertyType = cspDate
  c.Name = LNGGetText(1569, vbNullString)  'Fecha
  c.LeftLabel = -580
  c.Left = 700
  c.Key = K_FECHA
  c.Value = m_Fecha
  
  
  Set c = m_ObjAbm.Properties.Add(Nothing, cscCliId)
  c.PropertyType = cspHelp
  c.Table = csCliente
  c.TopFromProperty = cscCobzFecha
  c.Left = 2700
  c.LeftLabel = -580
  c.Name = LNGGetText(1150, vbNullString)  'Cliente
  c.Key = K_CLI_ID
  c.HelpId = m_Cli_id
  c.Value = m_Cliente
  
  
  Set c = m_ObjAbm.Properties.Add(Nothing, cscCobzNrodoc)
  c.PropertyType = cspText
  c.Name = LNGGetText(1065, vbNullString)  'Número
  c.Size = 50
  c.Key = K_NRODOC
  c.Value = m_Nrodoc
  c.TextMask = m_TaMascara
  c.TextAlign = vbRightJustify
  
  
  Set c = m_ObjAbm.Properties.Add(Nothing, cscCobId)
  c.PropertyType = cspHelp
  c.Table = csCobrador
  c.TopFromProperty = cscCliId
  c.Left = 5900
  c.LeftLabel = -800
  c.Name = LNGGetText(1088, vbNullString)  'Cobrador
  c.Key = K_COB_ID
  c.HelpId = m_cob_id
  c.Value = m_Cobrador
  
  
  Set c = m_ObjAbm.Properties.Add(Nothing, cscLgjId)
  c.PropertyType = cspHelp
  c.Table = csLegajo
  c.Name = LNGGetText(1575, vbNullString)  'Legajo
  c.Key = K_LGJ_ID
  c.HelpId = m_lgj_id
  c.Value = m_Legajo
  c.TabIndex = 1
  
  
  Set c = m_ObjAbm.Properties.Add(Nothing, cscCobzCotizacion)
  c.PropertyType = cspNumeric
  c.SubType = cspMoney
  c.LeftLabel = -800
  c.Name = LNGGetText(1635, vbNullString)  'Cotización
  c.Format = m_GeneralConfig.FormatDecCotizacion
  c.Key = K_COTIZACION
  c.Value = m_Cotizacion
  c.Width = 1000
  
  
  Set c = m_ObjAbm.Properties.Add(Nothing, cscCcosId)
  c.PropertyType = cspHelp
  c.Table = csCentroCosto
  c.Left = 9500
  c.TopFromProperty = cscCliId
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
  
  
  Set c = m_ObjAbm.Properties.Add(Nothing, cscCobzDescrip)
  c.PropertyType = cspText
  c.SubType = cspMemo
  c.Name = LNGGetText(1211, vbNullString)  'Observ.
  c.LeftLabel = -600
  c.Size = 5000
  c.Key = K_DESCRIP
  c.Value = m_Descrip
  c.LeftFromProperty = cscCobzFecha
  c.TopFromProperty = cscCobzNrodoc
  c.Width = 11070
  c.Height = 800
  c.TopToPrevious = 440
  
  
  If Not m_ObjAbm.Show(Me) Then Exit Function
      
'///////////////////////////////////////////////////////////////////
' ITEMS
'///////////////////////////////////////////////////////////////////

  m_Items.Tabs.Clear
  
  Const c_TabCheque = 0
  Const c_TabEfectivo = 1
  Const c_TabTarjeta = 2
  Const c_TabOtros = 3
  Const c_TabCtaCte = 4
  
  Set iTab = m_Items.Tabs.Add(Nothing)
  iTab.Index = c_TabCheque
  iTab.Name = LNGGetText(2099, vbNullString)  'Cheques
  
  
  Set iTab = m_Items.Tabs.Add(Nothing)
  iTab.Index = c_TabEfectivo
  iTab.Name = LNGGetText(2100, vbNullString)  'Efectivo
  
  
  Set iTab = m_Items.Tabs.Add(Nothing)
  iTab.Index = c_TabTarjeta
  iTab.Name = LNGGetText(2101, vbNullString)  'Tarjetas
  
  
  Set iTab = m_Items.Tabs.Add(Nothing)
  iTab.Index = c_TabOtros
  iTab.Name = LNGGetText(1070, vbNullString)  'Otros
  
  
  Set iTab = m_Items.Tabs.Add(Nothing)
  iTab.Index = c_TabCtaCte
  iTab.Name = LNGGetText(2102, vbNullString)  'Cta Corriente
  
  
  Set AbmGen = m_Items
  AbmGen.ResetLayoutMembers
  m_Items.Properties.Clear
  
  '/////////////////////////////////////////////////////////////////
  ' CHEQUES
  Set c = m_Items.Properties.Add(Nothing, c_Cheques)
  c.PropertyType = cspGrid
  c.LeftLabel = -1
  
  If Not pLoadCheques(c) Then Exit Function
  c.Name = c_Cheques
  c.Key = K_CHEQUES
  c.TabIndex = c_TabCheque
  c.GridAdd = True
  c.GridEdit = True
  c.GridRemove = True
  
  
  m_ChequesDeleted = vbNullString
  
  '/////////////////////////////////////////////////////////////////
  ' EFECTIVO
  Set c = m_Items.Properties.Add(Nothing, c_Efectivo)
  c.PropertyType = cspGrid
  c.LeftLabel = -1
  
  If Not pLoadEfectivo(c) Then Exit Function
  c.Name = c_Efectivo
  c.Key = K_EFECTIVO
  c.TabIndex = c_TabEfectivo
  c.GridAdd = True
  c.GridEdit = True
  c.GridRemove = True
  
  
  m_EfectivoDeleted = vbNullString
  
  '/////////////////////////////////////////////////////////////////
  ' TARJETAS
  Set c = m_Items.Properties.Add(Nothing, c_Tarjeta)
  c.PropertyType = cspGrid
  c.LeftLabel = -1
  
  If Not pLoadTarjetas(c) Then Exit Function
  c.Name = c_Tarjeta
  c.Key = K_TARJETA
  c.TabIndex = c_TabTarjeta
  c.GridAdd = True
  c.GridEdit = True
  c.GridRemove = True
  
  
  m_TarjetasDeleted = vbNullString
  
  '/////////////////////////////////////////////////////////////////
  ' OTROS
  Set c = m_Items.Properties.Add(Nothing, c_Otros)
  c.PropertyType = cspGrid
  c.LeftLabel = -1
  
  If Not pLoadOtros(c) Then Exit Function
  c.Name = c_Otros
  c.Key = K_OTROS
  c.TabIndex = c_TabOtros
  c.GridAdd = True
  c.GridEdit = True
  c.GridRemove = True
  
  
  m_OtrosDeleted = vbNullString
  
  '/////////////////////////////////////////////////////////////////
  ' CTA CTE
  Set c = m_Items.Properties.Add(Nothing, c_CtaCte)
  c.PropertyType = cspGrid
  c.LeftLabel = -1
  
  If Not pLoadCtaCte(c) Then Exit Function
  c.Name = c_CtaCte
  c.Key = K_CTACTE
  c.TabIndex = c_TabCtaCte
  c.GridAdd = True
  c.GridEdit = True
  c.GridRemove = True
  
  
  m_CtaCteDeleted = vbNullString
  
  If Not m_Items.Show(Me) Then Exit Function
  
'///////////////////////////////////////////////////////////////////
' FOOTER
'///////////////////////////////////////////////////////////////////

  Set AbmGen = m_Footer
  AbmGen.ResetLayoutMembers
  m_Footer.Properties.Clear
  
  Set c = m_Footer.Properties.Add(Nothing, cscCobzNeto)
  c.PropertyType = cspNumeric
  c.SubType = cspMoney
  c.Name = LNGGetText(1581, vbNullString)  'Neto
  c.Key = K_NETO
  c.Value = m_Neto
  c.Format = m_GeneralConfig.FormatDecImporte
  c.Enabled = False
  
  
  Set c = m_Footer.Properties.Add(Nothing, cscCobzOtros)
  c.PropertyType = cspNumeric
  c.SubType = cspMoney
  c.Name = LNGGetText(1070, vbNullString)  'Otros
  c.Key = K_OTROS
  c.Value = m_Otros
  c.Format = m_GeneralConfig.FormatDecImporte
  c.Enabled = False
  
  
  Set c = m_Footer.Properties.Add(Nothing, cscCobzTotal)
  c.PropertyType = cspNumeric
  c.Format = m_GeneralConfig.FormatDecImporte
  c.Name = LNGGetText(1584, vbNullString)  'Total
  c.SubType = cspMoney
  c.Key = K_TOTAL
  c.Value = m_Total
  c.Enabled = False
  
  
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
  
  sqlstmt = "sp_DocCobranzaGetItems " & m_Id & "," & csECobranzaItemTipo.csECobziTOtros
  
  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, "pLoadOtros", C_Module) Then Exit Function
  
  Propiedad.Grid.Columns.Clear
  Propiedad.Grid.Rows.Clear
  
  Set Grid = Propiedad.Grid
  
  With Grid.Columns
    With .Add(Nothing)
      .Visible = False
      .Key = KIO_COBZI_ID
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
  
    With .Add(Nothing, cscFvIdRet)
      .Name = LNGGetText(1866, vbNullString) ' Factura
      .PropertyType = cspHelp
      .Table = csFacturaVenta
      .Width = 1200
      .Key = KIO_FV_ID_RET
    End With
  End With
  
  Dim F  As cIABMGridRow
  Dim fv As cIABMGridCellValue
  
  While Not rs.EOF
  
    Set F = Propiedad.Grid.Rows.Add(Nothing, rs(cscCobziId).Value)
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscCobziId)
    fv.Key = KIO_COBZI_ID
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscCueNombre)
    fv.Id = gDB.ValField(rs.Fields, cscCueId)
    fv.Key = KIO_CUE_ID
    
    Set fv = F.Add(Nothing)
    If gDB.ValField(rs.Fields, cscCobziOtroTipo) = csEItemOtroTipo.csEOtroDebe Then
      fv.Value = gDB.ValField(rs.Fields, cscCobziImporte)
    Else
      fv.Value = 0
    End If
    fv.Key = KIO_DEBE

    Set fv = F.Add(Nothing)
    If gDB.ValField(rs.Fields, cscCobziOtroTipo) = csEItemOtroTipo.csEOtroHaber Then
      fv.Value = gDB.ValField(rs.Fields, cscCobziImporte)
    Else
      fv.Value = 0
    End If
    fv.Key = KIO_HABER

    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscCobziImporteOrigen)
    fv.Key = KIO_IMPORTEORIGEN

    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscCobziDescrip)
    fv.Key = KIO_DESCRIP

    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscRetNombre)
    fv.Id = gDB.ValField(rs.Fields, cscRetId)
    fv.Key = KIO_RET_ID

    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscCobziNroRetencion)
    fv.Key = KIO_NRORETENCION

    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscCobziPorcRetencion)
    fv.Key = KIO_PORCRETENCION

    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscCobziFechaRetencion)
    fv.Key = KIO_FECHARETENCION

    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscCcosNombre)
    fv.Id = gDB.ValField(rs.Fields, cscCcosId)
    fv.Key = KIO_CCOS_ID
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscFvNrodoc)
    fv.Id = gDB.ValField(rs.Fields, cscFvIdRet)
    fv.Key = KIO_FV_ID_RET
    
    rs.MoveNext
  Wend
  
  pLoadOtros = True
End Function

Private Function pLoadCheques(ByRef Propiedad As cIABMProperty) As Boolean
  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  
  sqlstmt = "sp_DocCobranzaGetItems " & m_Id & "," & csECobranzaItemTipo.csECobziTCheques
  
  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, "pLoadCheques", C_Module) Then Exit Function
  
  With Propiedad.Grid
    
    .Columns.Clear
    .Rows.Clear
  
    With .Columns
      
      With .Add(Nothing)
        .Visible = False
        .Key = KICH_COBZI_ID
      End With
    
      With .Add(Nothing)
        .Name = LNGGetText(1267, vbNullString)  'Cuenta
        .PropertyType = cspHelp
        .Table = csCuenta
        
        '.HelpFilter = "(" & cscCuecId & "=" & csECuecBancos & " or " & _
                            cscCuecId & "=" & csECuecDocEnCartera & ")"
        .HelpFilter = GetHelpFilterCheques()
        
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
      
      With .Add(Nothing)
        .Name = LNGGetText(1122, vbNullString)  'Banco
        .PropertyType = cspHelp
        .Table = csBanco
        .Width = 1620
        .Key = KICH_BCO_ID
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(2059, vbNullString)  'Nro. Cheque
        .PropertyType = cspText
        .Width = 1000
        .Key = KICH_CHEQUE
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(2058, vbNullString)  'Cheque
        .PropertyType = cspText
        .Width = 1000
        .Key = KICH_CHEQ_ID
        .Enabled = False
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(3719, vbNullString)  'Propio
        .PropertyType = cspCheck
        .Width = 800
        .Key = KICH_PROPIO
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
        .DefaultValue.Value = DateAdd("m", 1, Date)
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
    
    With .Rows
      
      While Not rs.EOF
      
        With .Add(Nothing, rs(cscCobziId).Value)
        
          With .Add(Nothing)
            .Value = gDB.ValField(rs.Fields, cscCobziId)
            .Key = KICH_COBZI_ID
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.Fields, cscCueNombre)
            .Id = gDB.ValField(rs.Fields, cscCueId)
            .Key = KICH_CUE_ID
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.Fields, cscMonNombre)
            .Id = gDB.ValField(rs.Fields, cscMonId)
            .Key = KICH_MON_ID
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.Fields, cscCobziImporteOrigen)
            .Key = KICH_IMPORTEORIGEN
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.Fields, cscCobziImporte)
            .Key = KICH_IMPORTE
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.Fields, cscBcoNombre)
            .Id = gDB.ValField(rs.Fields, cscBcoId)
            .Key = KICH_BCO_ID
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
            .Id = gDB.ValField(rs.Fields, "cheq_propio")
            .Key = KICH_PROPIO
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
            .Value = gDB.ValField(rs.Fields, cscCobziDescrip)
            .Key = KICH_DESCRIP
          End With
        End With
        
        rs.MoveNext
      Wend
    End With
  End With
  
  pLoadCheques = True
End Function

Private Function pLoadEfectivo(ByRef Propiedad As cIABMProperty) As Boolean
  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  Dim Grid    As cIABMGrid
  
  sqlstmt = "sp_DocCobranzaGetItems " & m_Id & "," & csECobranzaItemTipo.csECobziTEfectivo
  
  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, "pLoadEfectivo", C_Module) Then Exit Function
  
  Propiedad.Grid.Columns.Clear
  Propiedad.Grid.Rows.Clear
  
  Set Grid = Propiedad.Grid
  
  With Grid.Columns
    With .Add(Nothing)
      .Visible = False
      .Key = KIE_COBZI_ID
    End With
    
    With .Add(Nothing)
      .Name = LNGGetText(1267, vbNullString)  'Cuenta
      .PropertyType = cspHelp
      .Table = csCuenta
      
      '.HelpFilter = cscCuecId & "=" & csECuecCaja & " or " & cscCuecId & "=" & csECuecBancos
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
  
    Set F = Propiedad.Grid.Rows.Add(Nothing, rs(cscCobziId).Value)
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscCobziId)
    fv.Key = KIE_COBZI_ID
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscCueNombre)
    fv.Id = gDB.ValField(rs.Fields, cscCueId)
    fv.Key = KIE_CUE_ID
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscMonNombre)
    fv.Id = gDB.ValField(rs.Fields, cscMonId)
    fv.Key = KIE_MON_ID
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscCobziImporteOrigen)
    fv.Key = KIE_IMPORTEORIGEN
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscCobziImporte)
    fv.Key = KIE_IMPORTE
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscCobziDescrip)
    fv.Key = KIE_DESCRIP
    
    rs.MoveNext
  Wend
  
  pLoadEfectivo = True
End Function

Private Function pLoadTarjetas(ByRef Propiedad As cIABMProperty) As Boolean
  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  Dim Grid    As cIABMGrid
  
  sqlstmt = "sp_DocCobranzaGetItems " & m_Id & "," & csECobranzaItemTipo.csECobziTTarjeta
  
  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, "pLoadTarjetas", C_Module) Then Exit Function
  
  Propiedad.Grid.Columns.Clear
  Propiedad.Grid.Rows.Clear
  
  Set Grid = Propiedad.Grid
  
  With Grid.Columns
    With .Add(Nothing)
      .Visible = False
      .Key = KIT_COBZI_ID
    End With
  
    With .Add(Nothing)
      .Name = LNGGetText(1065, vbNullString)  'Número
      .PropertyType = cspText
      .Width = 900
      .Key = KIT_TJCC_ID
    End With
  
    With .Add(Nothing)
      .Name = LNGGetText(2105, vbNullString)  'Cupon
      .PropertyType = cspText
      .Width = 1500
      .Key = KIT_CUPON
    End With
  
    With .Add(Nothing)
      .Name = LNGGetText(2106, vbNullString)  'Tarjeta
      .PropertyType = cspHelp
      .Table = csTarjetaCredito
      .Width = 1800
      .Key = KIT_TJC_ID
    End With
    
    With .Add(Nothing, c_Cuotas)
      .Name = LNGGetText(1473, vbNullString)  'Cuotas
      .PropertyType = cspHelp
      .Table = csTarjetaCreditoCuota
      .Width = 1800
      .Key = KIT_TJCCU_ID
    End With
    m_lColCuotas = .count

    With .Add(Nothing)
      .Name = LNGGetText(2063, vbNullString)  'Mon
      .PropertyType = cspHelp
      .Table = csMoneda
      .Width = 520
      .Key = KIT_MON_ID
    End With
    
    With .Add(Nothing)
      .Name = LNGGetText(1901, vbNullString)  'Origen
      .PropertyType = cspNumeric
      .Format = m_GeneralConfig.FormatDecImporte
      .SubType = cspMoney
      .Width = 920
      .Key = KIT_IMPORTEORIGEN
    End With
    
    With .Add(Nothing)
      .Name = LNGGetText(1228, vbNullString)  'Importe
      .PropertyType = cspNumeric
      .Format = m_GeneralConfig.FormatDecImporte
      .SubType = cspMoney
      .Width = 920
      .Key = KIT_IMPORTE
    End With
    
    With .Add(Nothing)
      .Name = LNGGetText(1634, vbNullString)  'Vto.
      .PropertyType = cspDate
      Set .DefaultValue = New cABMGridRowValue
      .DefaultValue.Value = DateAdd("d", 1, Date)
      .Width = 970
      .Key = KIT_FECHAVTO
    End With
    
    With .Add(Nothing)
      .Name = LNGGetText(2107, vbNullString)  'Nro. Tarjeta
      .PropertyType = cspText
      .Width = 1300
      .Key = KIT_NROTARJETA
    End With
    
    With .Add(Nothing)
      .Name = LNGGetText(2123, vbNullString)  'Cod. Autoriz.
      .PropertyType = cspText
      .Width = 1000
      .Key = KIT_NROAUTORIZACION
    End With
    
    With .Add(Nothing)
      .Name = LNGGetText(2108, vbNullString)  'Operacion
      .PropertyType = cspList
      With .List.Add(Nothing)
        .Id = csECuponPosnet
        .Value = LNGGetText(2110, vbNullString)  'Posnet
      End With
      With .List.Add(Nothing)
        .Id = csECuponManual
        .Value = LNGGetText(2111, vbNullString)  'Manual
      End With
      Set .DefaultValue = New cABMGridRowValue
      .DefaultValue.Id = csECuponPosnet
      .Width = 1000
      .Key = KIT_TARJETA_TIPO
    End With
    
    With .Add(Nothing)
      .Name = LNGGetText(2109, vbNullString)  'Titular
      .PropertyType = cspText
      .Width = 1000
      .Key = KIT_TITULAR
    End With
    
    With .Add(Nothing)
      .Name = C_strDescrip
      .PropertyType = cspText
      .SubType = cspTextButtonEx
      .Width = 1300
      .Key = KIT_DESCRIP
    End With
  End With
  
  Dim F  As cIABMGridRow
  Dim fv As cIABMGridCellValue
  
  While Not rs.EOF
  
    Set F = Propiedad.Grid.Rows.Add(Nothing, rs(cscCobziId).Value)
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscCobziId)
    fv.Key = KIT_COBZI_ID
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscTjccNumero)
    fv.Id = gDB.ValField(rs.Fields, cscTjccId)
    fv.Key = KIT_TJCC_ID
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscTjccNumeroDoc)
    fv.Key = KIT_CUPON
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscTjcNombre)
    fv.Id = gDB.ValField(rs.Fields, cscTjcId)
    fv.Key = KIT_TJC_ID
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscTjccuCantidad)
    fv.Id = gDB.ValField(rs.Fields, cscTjccuId)
    fv.Key = KIT_TJCCU_ID
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscMonNombre)
    fv.Id = gDB.ValField(rs.Fields, cscMonId)
    fv.Key = KIT_MON_ID
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscCobziImporteOrigen)
    fv.Key = KIT_IMPORTEORIGEN
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscCobziImporte)
    fv.Key = KIT_IMPORTE
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscTjccFechavto)
    fv.Key = KIT_FECHAVTO
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscTjccNroTarjeta)
    fv.Key = KIT_NROTARJETA
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscTjccNroAutorizacion)
    fv.Key = KIT_NROAUTORIZACION
    
    Set fv = F.Add(Nothing)
    fv.Id = gDB.ValField(rs.Fields, cscCobziTarjetaTipo)
    fv.Key = KIT_TARJETA_TIPO
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscTjccTitular)
    fv.Key = KIT_TITULAR
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscCobziDescrip)
    fv.Key = KIT_DESCRIP

    rs.MoveNext
  Wend
  
  pLoadTarjetas = True
End Function

Private Function pLoadCtaCte(ByRef Propiedad As cIABMProperty) As Boolean
  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  Dim Grid    As cIABMGrid
  
  sqlstmt = "sp_DocCobranzaGetItems " & m_Id & "," & csECobranzaItemTipo.csECobziTCtaCte
  
  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, "pLoadCtaCte", C_Module) Then Exit Function
  
  Propiedad.Grid.Columns.Clear
  Propiedad.Grid.Rows.Clear
  
  Set Grid = Propiedad.Grid
  
  With Grid.Columns
    With .Add(Nothing)
      .Visible = False
      .Key = KICC_COBZI_ID
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
  
    Set F = Propiedad.Grid.Rows.Add(Nothing, rs(cscCobziId).Value)
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscCobziId)
    fv.Key = KICC_COBZI_ID
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscCueNombre)
    fv.Id = gDB.ValField(rs.Fields, cscCueId)
    fv.Key = KICC_CUE_ID
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscCobziImporteOrigen)
    fv.Key = KICC_IMPORTEORIGEN
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscCobziImporte)
    fv.Key = KICC_IMPORTE
    
    rs.MoveNext
  Wend
  
  pLoadCtaCte = True
End Function

Private Function Load(ByVal Id As Long) As Boolean
  Dim sqlstmt     As String

  sqlstmt = "sp_DocCobranzaGet " & EmpId & "," & Id & "," & gDB.UserId
  
  Dim rs As Recordset

  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, C_LoadFunction, C_Module) Then Exit Function

  If Not rs.EOF Then
    
    m_IsNew = False

    m_Id = gDB.ValField(rs.Fields, cscCobzId)
    m_Numero = gDB.ValField(rs.Fields, cscCobzNumero)
    m_Nrodoc = gDB.ValField(rs.Fields, cscCobzNrodoc)
    m_Descrip = gDB.ValField(rs.Fields, cscCobzDescrip)
    m_Fecha = gDB.ValField(rs.Fields, cscCobzFecha)
    m_Neto = gDB.ValField(rs.Fields, cscCobzNeto)
    m_Total = gDB.ValField(rs.Fields, cscCobzTotal)
    m_Otros = gDB.ValField(rs.Fields, cscCobzOtros)
    m_Cotizacion = gDB.ValField(rs.Fields, cscCobzCotizacion)
    m_Cli_id = gDB.ValField(rs.Fields, cscCliId)
    m_Cliente = gDB.ValField(rs.Fields, cscCliNombre)
    m_ccos_id = gDB.ValField(rs.Fields, cscCcosId)
    m_CentroCosto = gDB.ValField(rs.Fields, cscCcosNombre)
    m_suc_id = gDB.ValField(rs.Fields, cscSucId)
    m_Sucursal = gDB.ValField(rs.Fields, cscSucNombre)
    m_doc_id = gDB.ValField(rs.Fields, cscDocId)
    m_Documento = gDB.ValField(rs.Fields, cscDocNombre)
    m_Doct_id = gDB.ValField(rs.Fields, cscDoctId)
    m_cob_id = gDB.ValField(rs.Fields, cscCobId)
    m_Cobrador = gDB.ValField(rs.Fields, cscCobNombre)
    m_lgj_id = gDB.ValField(rs.Fields, cscLgjId)
    m_Legajo = gDB.ValField(rs.Fields, cscLgjCodigo)
    m_Creado = gDB.ValField(rs.Fields, cscCreado)
    m_Modificado = gDB.ValField(rs.Fields, cscModificado)
    m_Modifico = gDB.ValField(rs.Fields, cscModifico)
    m_est_id = gDB.ValField(rs.Fields, cscEstId)
    m_Estado = gDB.ValField(rs.Fields, cscEstNombre)
    m_Firmado = gDB.ValField(rs.Fields, cscCobzFirmado)
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
    
  Else
    m_Id = csNO_ID
    m_Numero = 0
    m_Nrodoc = vbNullString
    m_Descrip = vbNullString
    m_Fecha = VDGetDateById(csToday)
    m_Neto = 0
    m_Total = 0
    m_Otros = 0
    m_Cli_id = csNO_ID
    m_Cliente = vbNullString
    m_ccos_id = csNO_ID
    m_CentroCosto = vbNullString
    m_doc_id = csNO_ID
    m_Documento = vbNullString
    m_Doct_id = csNO_ID
    m_cob_id = csNO_ID
    m_Cobrador = vbNullString
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
    m_Cli_id = m_LastCli
    m_Cliente = m_LastCliName
    m_Documento = m_LastDocName
  
    DocEditableGet m_doc_id, m_DocEditable, m_DocEditMsg, csPreTsrNewCobranza
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
  
  str_2048 = LNGGetText(2048, vbNullString) 'T&esoreria
  Set m_Host = Host
  m_Host.Server.AddMenu str_2048, csMenuEnum.csMenuTesoreria, vbNullString, 1, False, False, False, True, False, Nothing
  m_Host.Server.AddMenu LNGGetText(2112, vbNullString), csPreTsrListCobranza, str_2048, 0, True, False, False, False, False, Me
                        '&Cobranza
  cIMenuClient_Initialize = True
  
  GoTo ExitProc
ControlError:
  MngError Err, "cIMenuClient_Initialize", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Private Function cIMenuClient_ProcessMenu(ByVal Id As Long) As Variant
#If PREPROC_SFS Then                                                                                                                                          'Cobranza
  m_Host.MenuListDocClick "CSABMInterface2.cABMGeneric", "CSTesoreria2.cCobranza", "CSABMInterface2.CABMGenericListDoc", "CSTesoreria2.cCobranzaListDoc", Me, LNGGetText(2060, vbNullString), 0
#Else
  m_Host.MenuListDocClick "CSABMInterface2.cABMGenericDocEx", "CSTesoreria2.cCobranza", "CSABMInterface2.CABMGenericListDoc", "CSTesoreria2.cCobranzaListDoc", Me, LNGGetText(2060, vbNullString), 0
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

Private Function pGetCueIdCliente(ByRef cue_id As Long) As Boolean
  Dim sqlstmt As String
  Dim rs      As Recordset
  
  ' Cuenta contable del cliente
  sqlstmt = "sp_DocGetCueId " & m_LastCli & "," & m_LastDoc
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Function

  If rs.EOF Then Exit Function

  cue_id = gDB.ValField(rs.Fields, cscCueId)
  
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
  
  sqlstmt = "sp_DocCobranzaFirmar " & m_Id & "," & Us_id
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Function
  
  m_est_id = gDB.ValField(rs.Fields, cscEstId)
  m_Estado = gDB.ValField(rs.Fields, cscEstNombre)
  
  Dim iProp As cIABMProperty
  Set iProp = m_ObjAbm.Properties(csDocEstateID)
  
  With iProp
    .HelpId = m_est_id
    .Value = m_Estado
  End With
  
  gDB.GetData csTCobranza, cscCobzId, m_Id, cscCobzFirmado, m_Firmado
  
  m_ObjAbm.ShowValue iProp
  
  pFirmar = True
End Function

Private Function pMove(ByVal MoveTo As ABM_MSG) As Boolean
  Dim sqlstmt As String
  Dim rs      As Recordset
  Dim doc_id  As Long
  
  doc_id = m_ObjAbm.Properties(cscDocId).HelpId
  
  If doc_id = csNO_ID Then MsgInfo LNGGetText(1595, vbNullString) 'Debe seleccionar un documento
  
  sqlstmt = "sp_DocCobranzaMover " & MoveTo & "," & m_Numero & "," & doc_id
  
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
        GetDocNumber m_LastDoc, m_ObjAbm, m_TaPropuesto, cscCobzNrodoc
    
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
    
    Set c = .Item(cscCobzFecha)
    c.Value = m_Fecha
    
    Set c = .Item(cscCliId)
    c.HelpId = m_Cli_id
    c.Value = m_Cliente
    
    Set c = .Item(csDocNumberID)
    c.Value = m_Numero
    
    Set c = .Item(csDocEstateID)
    c.Value = m_Estado
    
    Set c = .Item(cscCobzNrodoc)
    c.Value = m_Nrodoc
    c.TextMask = m_TaMascara
    c.TextAlign = vbRightJustify
    
    Set c = .Item(cscCobId)
    c.HelpId = m_cob_id
    c.Value = m_Cobrador
    
    Set c = .Item(cscCobzCotizacion)
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
    
    Set c = .Item(cscCobzDescrip)
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
  
  Set c = pGetTarjetasProperty()
  If Not pLoadTarjetas(c) Then Exit Sub
  
  m_TarjetasDeleted = vbNullString
  
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
  
    Set c = .Item(cscCobzOtros)
    c.Value = m_Otros
    
    Set c = .Item(cscCobzNeto)
    c.Value = m_Neto
    
    Set c = .Item(cscCobzTotal)
    c.Value = m_Total
  
  End With
  
  Set AbmGen = m_Footer
  AbmGen.ShowValues m_Footer.Properties
  
  pSetEnabled
End Sub

Private Sub pShowStartWizard(ByVal isHojaRuta As Boolean)
  On Error GoTo ControlError
  
  Dim oWizard As cCobranzaWizard
  Set oWizard = New cCobranzaWizard
  
  If Not oWizard.Load() Then Exit Sub

  With oWizard
    
    .cli_id = m_Cli_id
    .Cliente = m_Cliente
    .FvIds = m_FvIds
    .CliIds = m_CliIds
    .FvIdsxCliId = m_FvIdsxCliId
    .isHojaRuta = isHojaRuta
    
    Set .CobranzaInfo = m_CobranzaInfo
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
  oObjWizard.PushVirtualNext = m_bPushVirtualNext
  oObjWizard.CloseWizardAfterSave = m_bCloseWizardAfterSave

  iObjWizard.Show "CSTesoreria2.cCobranzaWizard"
  
  If Not oObjWizard.WizardClosed Then
  
    oObjWizard.ObjAbm.ObjForm.ZOrder
  
  End If
  
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
  
  c_ErrorSave = LNGGetText(2098, vbNullString) 'Error al grabar la Cobranza
  
  Set m_GeneralConfig = New cGeneralConfig
  m_GeneralConfig.Load
  ReDim m_FvIds(0)
  ReDim m_CliIds(0)
  ReDim m_FvIdsxCliId(0, 0)
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
  ReDim m_FvIds(0)
  ReDim m_CliIds(0)
  ReDim m_FvIdsxCliId(0, 0)
  Set m_CobranzaInfo = Nothing

  GoTo ExitProc
ControlError:
  MngError Err, "Class_Terminate", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

'////////////////////////////////////////////////////////////
Private Function pSaveCheques(ByVal Id As Long) As Boolean
  Dim register  As cRegister
  Dim Row       As cIABMGridRow
  Dim Cell      As cIABMGridCellValue
  
  For Each Row In pGetCheques().Rows
  
    Set register = New cRegister
    register.fieldId = cscCobziTMPId
    register.Table = csTCobranzaItemTMP
    register.Id = csNew
    
    For Each Cell In Row
      Select Case Cell.Key
      
        Case KICH_COBZI_ID
          If m_Copy Then
            register.Fields.Add2 cscCobziId, csNew, csInteger
          Else
            register.Fields.Add2 cscCobziId, Val(Cell.Value), csInteger
          End If
        
        Case KICH_DESCRIP
          register.Fields.Add2 cscCobziDescrip, Cell.Value, csText
        
        Case KICH_CHEQ_ID
          register.Fields.Add2 cscCheqId, Cell.Id, csId
        
        Case KICH_CHEQUE
          register.Fields.Add2 cscCobziTMPCheque, Cell.Value, csText
        
        Case KICH_CLE_ID
          register.Fields.Add2 cscCleId, Cell.Id, csId
        
        Case KICH_BCO_ID
          register.Fields.Add2 cscBcoId, Cell.Id, csId
        
        Case KICH_MON_ID
          register.Fields.Add2 cscMonId, Cell.Id, csId
        
        Case KICH_PROPIO
          register.Fields.Add2 cscCobziTMPPropio, Cell.Id, csBoolean
        
        Case KICH_FECHACOBRO
          register.Fields.Add2 cscCobziTMPFechaCobro, Cell.Value, csDate
        
        Case KICH_FECHAVTO
          register.Fields.Add2 cscCobziTMPFechaVto, Cell.Value, csDate
        
        Case KICH_CUE_ID
          register.Fields.Add2 cscCueId, Cell.Id, csId
        
        Case KICH_IMPORTEORIGEN
          register.Fields.Add2 cscCobziImporteOrigen, Val(Cell.Value), csCurrency
        
        Case KICH_IMPORTE
          register.Fields.Add2 cscCobziImporte, Val(Cell.Value), csCurrency
      End Select
    Next
    
    m_iOrden = m_iOrden + 1
    register.Fields.Add2 cscCobziOrden, m_iOrden, csInteger
    register.Fields.Add2 cscCobziTipo, csECobranzaItemTipo.csECobziTCheques, csInteger
    register.Fields.Add2 cscCobzTMPId, Id, csId
    register.Fields.Add2 cscCobziOtroTipo, csEItemOtroTipo.csEOtroDebe, csInteger
    
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
      register.fieldId = cscCobzibTMPId
      register.Table = csTCobranzaItemBorradoTMP
      register.Id = csNew
      
      register.Fields.Add2 cscCobziId, Val(vDeletes(i)), csInteger
      register.Fields.Add2 cscCobzId, m_Id, csId
      register.Fields.Add2 cscCobzTMPId, Id, csId
      
      register.Fields.HaveLastUpdate = False
      register.Fields.HaveWhoModify = False
                                                            
      If Not gDB.Save(register, , "pSaveTarjetas", C_Module, c_ErrorSave) Then Exit Function
    Next
    
  End If
  
  pSaveCheques = True
End Function

Private Function pSaveTarjetas(ByVal Id As Long) As Boolean
  Dim register  As cRegister
  Dim Row       As cIABMGridRow
  Dim Cell      As cIABMGridCellValue
  
  For Each Row In pGetTarjetas().Rows
  
    Set register = New cRegister
    register.fieldId = cscCobziTMPId
    register.Table = csTCobranzaItemTMP
    register.Id = csNew
    
    For Each Cell In Row
      Select Case Cell.Key
        
        Case KIT_COBZI_ID
          If m_Copy Then
            register.Fields.Add2 cscCobziId, csNew, csInteger
          Else
            register.Fields.Add2 cscCobziId, Val(Cell.Value), csInteger
          End If
        Case KIT_DESCRIP
          register.Fields.Add2 cscCobziDescrip, Cell.Value, csText
        Case KIT_TJCC_ID
          register.Fields.Add2 cscTjccId, Cell.Id, csId
        Case KIT_CUPON
          register.Fields.Add2 cscCobziTMPCupon, Cell.Value, csText
        Case KIT_TJC_ID
          register.Fields.Add2 cscTjcId, Cell.Id, csId
        Case KIT_TJCCU_ID
          register.Fields.Add2 cscTjccuId, Cell.Id, csId
        Case KIT_MON_ID
          register.Fields.Add2 cscMonId, Cell.Id, csId
        Case KIT_FECHAVTO
          register.Fields.Add2 cscCobziTMPFechaVto, Cell.Value, csDate
        Case KIT_TITULAR
          register.Fields.Add2 cscCobziTMPTitular, Cell.Value, csText
        Case KIT_NROTARJETA
          register.Fields.Add2 cscCobziTMPNroTarjeta, Cell.Value, csText
        Case KIT_NROAUTORIZACION
          register.Fields.Add2 cscCobziTMPAutorizacion, Cell.Value, csText
        Case KIT_TARJETA_TIPO
          register.Fields.Add2 cscCobziTarjetaTipo, Cell.Id, csLong
        Case KIT_IMPORTEORIGEN
          register.Fields.Add2 cscCobziImporteOrigen, Val(Cell.Value), csCurrency
        Case KIT_IMPORTE
          register.Fields.Add2 cscCobziImporte, Val(Cell.Value), csCurrency
      End Select
    Next
    
    m_iOrden = m_iOrden + 1
    register.Fields.Add2 cscCobziOrden, m_iOrden, csInteger
    register.Fields.Add2 cscCobziTipo, csECobranzaItemTipo.csECobziTTarjeta, csInteger
    register.Fields.Add2 cscCobzTMPId, Id, csId
    register.Fields.Add2 cscCobziOtroTipo, csEItemOtroTipo.csEOtroDebe, csInteger
    
    register.Fields.HaveLastUpdate = False
    register.Fields.HaveWhoModify = False
                                                          
    If Not gDB.Save(register, , "pSaveTarjetas", C_Module, c_ErrorSave) Then Exit Function
  Next
  
  Dim sqlstmt As String
  
  If m_TarjetasDeleted <> vbNullString And m_Id <> csNO_ID And Not m_Copy Then
  
    Dim vDeletes As Variant
    Dim i As Long
    
    m_TarjetasDeleted = RemoveLastColon(m_TarjetasDeleted)
    vDeletes = Split(m_TarjetasDeleted, ",")
    
    For i = 0 To UBound(vDeletes)
    
      Set register = New cRegister
      register.fieldId = cscCobzibTMPId
      register.Table = csTCobranzaItemBorradoTMP
      register.Id = csNew
      
      register.Fields.Add2 cscCobziId, Val(vDeletes(i)), csInteger
      register.Fields.Add2 cscCobzId, m_Id, csId
      register.Fields.Add2 cscCobzTMPId, Id, csId
      
      register.Fields.HaveLastUpdate = False
      register.Fields.HaveWhoModify = False
                                                            
      If Not gDB.Save(register, , "pSaveTarjetas", C_Module, c_ErrorSave) Then Exit Function
    Next
    
  End If
  
  pSaveTarjetas = True
End Function

Private Function pSaveOtros(ByVal Id As Long) As Boolean
  Dim register  As cRegister
  Dim Row       As cIABMGridRow
  Dim Cell      As cIABMGridCellValue
  
  For Each Row In pGetOtros().Rows
  
    Set register = New cRegister
    register.fieldId = cscCobziTMPId
    register.Table = csTCobranzaItemTMP
    register.Id = csNew
    
    For Each Cell In Row
      Select Case Cell.Key
        
        Case KIO_COBZI_ID
          If m_Copy Then
            register.Fields.Add2 cscCobziId, csNew, csInteger
          Else
            register.Fields.Add2 cscCobziId, Val(Cell.Value), csInteger
          End If
        Case KIO_DESCRIP
          register.Fields.Add2 cscCobziDescrip, Cell.Value, csText
        Case KIO_RET_ID
          register.Fields.Add2 cscRetId, Cell.Id, csId
        Case KIO_NRORETENCION
          register.Fields.Add2 cscCobziNroRetencion, Cell.Value, csText
        Case KIO_PORCRETENCION
          register.Fields.Add2 cscCobziPorcRetencion, Val(Cell.Value), csDouble
        Case KIO_CCOS_ID
          register.Fields.Add2 cscCcosId, Cell.Id, csId
        Case KIO_FV_ID_RET
          register.Fields.Add2 cscFvIdRet, Cell.Id, csId
        Case KIO_CUE_ID
          register.Fields.Add2 cscCueId, Cell.Id, csId
        Case KIO_FECHARETENCION
          register.Fields.Add2 cscCobziFechaRetencion, Cell.Value, csDate
        Case KIO_IMPORTEORIGEN
          register.Fields.Add2 cscCobziImporteOrigen, Val(Cell.Value), csCurrency
        Case KIO_DEBE
          If Val(Cell.Value) <> 0 Then
            register.Fields.Add2 cscCobziImporte, Val(Cell.Value), csCurrency
            register.Fields.Add2 cscCobziOtroTipo, csEItemOtroTipo.csEOtroDebe, csInteger
          End If
        Case KIO_HABER
          If Val(Cell.Value) <> 0 Then
            register.Fields.Add2 cscCobziImporte, Val(Cell.Value), csCurrency
            register.Fields.Add2 cscCobziOtroTipo, csEItemOtroTipo.csEOtroHaber, csInteger
          End If
      End Select
    Next
    
    m_iOrden = m_iOrden + 1
    register.Fields.Add2 cscCobziOrden, m_iOrden, csInteger
    register.Fields.Add2 cscCobziTipo, csECobranzaItemTipo.csECobziTOtros, csInteger
    register.Fields.Add2 cscCobzTMPId, Id, csId
    
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
      register.fieldId = cscCobzibTMPId
      register.Table = csTCobranzaItemBorradoTMP
      register.Id = csNew
      
      register.Fields.Add2 cscCobziId, Val(vDeletes(i)), csInteger
      register.Fields.Add2 cscCobzId, m_Id, csId
      register.Fields.Add2 cscCobzTMPId, Id, csId
      
      register.Fields.HaveLastUpdate = False
      register.Fields.HaveWhoModify = False
                                                          
      If Not gDB.Save(register, , "pSaveOtros", C_Module, c_ErrorSave) Then Exit Function
    Next
    
  End If
  
  pSaveOtros = True
End Function

Private Function pSaveEfectivo(ByVal Id As Long) As Boolean
  Dim register  As cRegister
  Dim Row       As cIABMGridRow
  Dim Cell      As cIABMGridCellValue
  
  For Each Row In pGetEfectivo().Rows
  
    Set register = New cRegister
    register.fieldId = cscCobziTMPId
    register.Table = csTCobranzaItemTMP
    register.Id = csNew
    
    For Each Cell In Row
      Select Case Cell.Key
        
        Case KIE_COBZI_ID
          If m_Copy Then
            register.Fields.Add2 cscCobziId, csNew, csInteger
          Else
            register.Fields.Add2 cscCobziId, Val(Cell.Value), csInteger
          End If
        Case KIE_DESCRIP
          register.Fields.Add2 cscCobziDescrip, Cell.Value, csText
        Case KIE_CUE_ID
          register.Fields.Add2 cscCueId, Cell.Id, csId
        Case KIE_IMPORTEORIGEN
          register.Fields.Add2 cscCobziImporteOrigen, Val(Cell.Value), csCurrency
        Case KIE_IMPORTE
          register.Fields.Add2 cscCobziImporte, Val(Cell.Value), csCurrency
      End Select
    Next
    
    m_iOrden = m_iOrden + 1
    register.Fields.Add2 cscCobziOrden, m_iOrden, csInteger
    register.Fields.Add2 cscCobziTipo, csECobranzaItemTipo.csECobziTEfectivo, csInteger
    register.Fields.Add2 cscCobzTMPId, Id, csId
    register.Fields.Add2 cscCobziOtroTipo, csEItemOtroTipo.csEOtroDebe, csInteger
    
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
      register.fieldId = cscCobzibTMPId
      register.Table = csTCobranzaItemBorradoTMP
      register.Id = csNew
      
      register.Fields.Add2 cscCobziId, Val(vDeletes(i)), csInteger
      register.Fields.Add2 cscCobzId, m_Id, csId
      register.Fields.Add2 cscCobzTMPId, Id, csId
      
      register.Fields.HaveLastUpdate = False
      register.Fields.HaveWhoModify = False
                                                            
      If Not gDB.Save(register, , "pSaveEfectivo", C_Module, c_ErrorSave) Then Exit Function
    Next
    
  End If
  
  pSaveEfectivo = True
End Function

Private Function pSaveCtaCte(ByVal Id As Long) As Boolean
  Dim register  As cRegister
  Dim Row       As cIABMGridRow
  Dim Cell      As cIABMGridCellValue
  
  For Each Row In pGetCtaCte().Rows
  
    Set register = New cRegister
    register.fieldId = cscCobziTMPId
    register.Table = csTCobranzaItemTMP
    register.Id = csNew
    
    For Each Cell In Row
      Select Case Cell.Key
        
        Case KICC_COBZI_ID
          If m_Copy Then
            register.Fields.Add2 cscCobziId, csNew, csInteger
          Else
            register.Fields.Add2 cscCobziId, Val(Cell.Value), csInteger
          End If
        Case KICC_CUE_ID
          register.Fields.Add2 cscCueId, Cell.Id, csId
        Case KICC_IMPORTEORIGEN
          register.Fields.Add2 cscCobziImporteOrigen, Val(Cell.Value), csCurrency
        Case KICC_IMPORTE
          register.Fields.Add2 cscCobziImporte, Val(Cell.Value), csCurrency
      End Select
    Next
    
    m_iOrden = m_iOrden + 1
    register.Fields.Add2 cscCobziOrden, m_iOrden, csInteger
    register.Fields.Add2 cscCobziTipo, csECobranzaItemTipo.csECobziTCtaCte, csInteger
    register.Fields.Add2 cscCobzTMPId, Id, csId
    register.Fields.Add2 cscCobziOtroTipo, csEItemOtroTipo.csEOtroHaber, csInteger
    
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
      register.fieldId = cscCobzibTMPId
      register.Table = csTCobranzaItemBorradoTMP
      register.Id = csNew
      
      register.Fields.Add2 cscCobziId, Val(vDeletes(i)), csInteger
      register.Fields.Add2 cscCobzId, m_Id, csId
      register.Fields.Add2 cscCobzTMPId, Id, csId
      
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
    Set m_ObjApply = New cCobranzaAplic
  
  ' Edit Apply
  '
  Else
    If m_ObjApply.Id <> m_Id Then
      Set m_ObjApply.ObjectClient = Nothing
      Set m_ObjApply = New cCobranzaAplic
    End If
  End If

  ' Edit Apply
  '
  Set m_ObjApply.ObjectClient = Me
  
  If Not m_ObjApply.Show(m_Id, m_Total, m_Nrodoc, m_Cliente) Then
    Set m_ObjApply = Nothing
  End If
End Sub

'//////////////////////////////////////////////////////////////////////////////
Private Function pGetCheques() As cIABMGrid
  Set pGetCheques = pGetChequesProperty().Grid
End Function

Private Function pGetTarjetas() As cIABMGrid
  Set pGetTarjetas = pGetTarjetasProperty().Grid
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

Private Function pGetChequesProperty() As cIABMProperty
  Set pGetChequesProperty = m_Items.Properties.Item(c_Cheques)
End Function

Private Function pGetTarjetasProperty() As cIABMProperty
  Set pGetTarjetasProperty = m_Items.Properties.Item(c_Tarjeta)
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
        Dim Moneda  As String
        Set Row = .Rows(lRow)
        GetMonedaFromCuenta MonId, Moneda, pCell(Row, KICH_CUE_ID).Id
        With pCell(Row, KICH_MON_ID)
          .Value = Moneda
          .Id = MonId
        End With
      
        If MonId = m_MonDefault Or MonId = 0 Then
          pCell(Row, KICH_IMPORTEORIGEN).Value = 0
        End If
        pColAUpdateCheque = True
        Exit Function
      Case Else
        pColAUpdateCheque = True
        Exit Function
    End Select
  End With
  
  pShowCobroNeto
  pShowCobroTotal
  pColAUpdateCheque = True
End Function

Private Function pColAUpdateTarjeta(ByRef IProperty As cIABMProperty, ByVal lRow As Long, ByVal lCol As Long) As Boolean
  Dim Row      As cIABMGridRow
  Dim Value    As Double
  
  With IProperty.Grid
    Select Case .Columns(lCol).Key
      Case KIT_IMPORTEORIGEN
        Set Row = .Rows(lRow)
        pCell(Row, KIT_IMPORTE).Value = Val(pCell(Row, KIT_IMPORTEORIGEN).Value) * Val(pGetCotizacion().Value)
      Case KIT_IMPORTE
      
      Case KIT_TJC_ID
        Dim TjcId  As Long
        Dim AbmObj As cABMGeneric
        
        Set AbmObj = m_ObjAbm
        Set Row = .Rows(lRow)
        
        TjcId = pCell(Row, KIT_TJC_ID).Id
        SetFilterCuotas Row, IProperty, m_ObjAbm, KIT_TJC_ID
        
        With pCell(Row, KIT_TJCCU_ID)
          If Not ValidateCuota(TjcId, .Id) Then
            .Id = csNO_ID
            .Value = vbNullString
            AbmObj.ShowCellValue IProperty, lRow, m_lColCuotas
          End If
        End With
        
        pColAUpdateTarjeta = True
        Exit Function
        
      Case Else
        pColAUpdateTarjeta = True
        Exit Function
    End Select
  End With
  
  pShowCobroNeto
  pShowCobroTotal
  pColAUpdateTarjeta = True
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
  
  pShowCobroNeto
  pShowCobroTotal
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
  
  pShowCobroOtro
  pShowCobroTotal
  pColAUpdateOtro = True
End Function

Private Function pGetCotizacion() As cIABMProperty
  Set pGetCotizacion = m_ObjAbm.Properties(cscCobzCotizacion)
End Function

Private Sub pShowCobroNeto()
  Dim Row           As cIABMGridRow
  Dim Total         As Double
  Dim TotalOrigen   As Double
  
  For Each Row In pGetCheques().Rows
    Total = Total + Val(pCell(Row, KICH_IMPORTE).Value)
  Next
  
  For Each Row In pGetEfectivo().Rows
    Total = Total + Val(pCell(Row, KIE_IMPORTE).Value)
  Next
  
  For Each Row In pGetTarjetas().Rows
    Total = Total + Val(pCell(Row, KIE_IMPORTE).Value)
  Next
  
  pGetCobroNeto().Value = Total
  m_Footer.ShowValue pGetCobroNeto
End Sub

Private Sub pShowCobroTotal()
  pGetCobroTotal.Value = Val(pGetCobroNeto().Value) + Val(pGetCobroOtros().Value)
  m_Footer.ShowValue pGetCobroTotal
End Sub

Private Sub pShowCobroOtro()
  Dim Row           As cIABMGridRow
  Dim Total         As Double
  
  For Each Row In pGetOtros().Rows
    Total = Total + Val(pCell(Row, KIO_DEBE).Value) - Val(pCell(Row, KIO_HABER).Value)
  Next
  
  pGetCobroOtros().Value = Total
  m_Footer.ShowValue pGetCobroOtros
End Sub

Private Function pGetCobroNeto() As cIABMProperty
  Set pGetCobroNeto = m_Footer.Properties.Item(cscCobzNeto)
End Function

Private Function pGetCobroOtros() As cIABMProperty
  Set pGetCobroOtros = m_Footer.Properties.Item(cscCobzOtros)
End Function

Private Function pGetCobroTotal() As cIABMProperty
  Set pGetCobroTotal = m_Footer.Properties.Item(cscCobzTotal)
End Function

'///////////////////////////////////////////////////////////////////
' Validaciones de Filas de Instrumentos de cobro
Private Function pIsEmptyRowCheques(ByRef Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  Dim Cell                  As cIABMGridCellValue
  Dim strRow                As String
  Dim bRowIsEmpty           As Boolean
  
  strRow = " (Fila " & RowIndex & ")"
  
  bRowIsEmpty = True
  
  For Each Cell In Row
    Select Case Cell.Key
      Case KICH_CUE_ID, KICH_BCO_ID, KICH_MON_ID, KICH_CLE_ID
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
          MsgInfo LNGGetText(2113, vbNullString, strRow) 'Debe indicar una Cuenta Contable (1)
          Exit Function
        End If
        
      Case KICH_BCO_ID
        If ValEmpty(Cell.Id, csId) Then
          MsgInfo LNGGetText(2094, vbNullString, strRow) 'Debe indicar un banco (1)
          Exit Function
        End If
        
      Case KICH_MON_ID
        If ValEmpty(Cell.Id, csId) Then
          MsgInfo LNGGetText(2114, vbNullString, strRow) 'Debe indicar una moneda (1)
          Exit Function
        End If
        MonId = Cell.Id
        
      Case KICH_CLE_ID
        If ValEmpty(Cell.Id, csId) Then
          MsgInfo LNGGetText(2115, vbNullString, strRow) 'Debe indicar un clearing (1)
          Exit Function
        End If
    
      Case KICH_IMPORTEORIGEN
        bOrigen = Not ValEmpty(Val(Cell.Value), csDouble)
      
      Case KICH_IMPORTE
        If ValEmpty(Val(Cell.Value), csDouble) Then
          MsgInfo LNGGetText(2116, vbNullString, strRow) 'Debe indicar un número de Cheque (1)
          Exit Function
        End If
      
      Case KICH_CHEQUE
        If ValEmpty(Cell.Value, csText) Then
          MsgInfo LNGGetText(2116, vbNullString, strRow) 'Debe indicar un número de cheque (1)
          Exit Function
        End If
      
      Case KICH_FECHACOBRO
        If ValEmpty(Cell.Value, csDate) Then
          MsgInfo LNGGetText(2117, vbNullString, strRow) 'Debe indicar una fecha para depositar (1)
          Exit Function
        End If
      
      Case KICH_FECHAVTO
        If ValEmpty(Cell.Value, csDate) Then
          MsgInfo LNGGetText(1384, vbNullString, strRow) 'Debe indicar una fecha de vencimiento (1)
          Exit Function
        End If
    End Select
  Next
  
  If Not bOrigen And MonId <> m_MonDefault Then
    MsgInfo LNGGetText(2118, vbNullString, strRow)
            'Debe indicar un importe para la moneda extranjera (1)
    Exit Function
  End If
  
  pValidateRowCheques = True
End Function

Private Function pIsEmptyRowTarjetas(ByRef Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  Dim Cell                  As cIABMGridCellValue
  Dim strRow                As String
  Dim bRowIsEmpty           As Boolean
  
  strRow = " (Fila " & RowIndex & ")"
  
  bRowIsEmpty = True
  
  For Each Cell In Row
    Select Case Cell.Key
      Case KIT_TJC_ID, KIT_MON_ID, KIT_TJCCU_ID
        If Not ValEmpty(Cell.Id, csId) Then
          bRowIsEmpty = False
          Exit For
        End If
    
      Case KIT_IMPORTE, KIT_IMPORTEORIGEN
        If Not ValEmpty(Val(Cell.Value), csDouble) Then
          bRowIsEmpty = True
          Exit For
        End If
      
      Case KIT_NROTARJETA, KIT_NROAUTORIZACION, KIT_TITULAR, KIT_DESCRIP
        If Not ValEmpty(Cell.Value, csText) Then
          bRowIsEmpty = True
          Exit For
        End If
      
      Case KIT_FECHAVTO
        If Not ValEmpty(Cell.Value, csDate) Then
          bRowIsEmpty = True
          Exit For
        End If
    End Select
  Next
  
  pIsEmptyRowTarjetas = bRowIsEmpty
End Function

Private Function pValidateRowTarjetas(ByRef Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  Dim Cell                  As cIABMGridCellValue
  Dim strRow                As String
  Dim bOrigen               As Boolean
  Dim MonId                 As Long
  
  strRow = " (Fila " & RowIndex & ")"
  
  For Each Cell In Row
    Select Case Cell.Key
      
      Case KIT_TJC_ID
        If ValEmpty(Cell.Id, csId) Then
          MsgInfo LNGGetText(2119, vbNullString, strRow)  'Debe indicar una Tarjeta de Crédito (1)
          Exit Function
        End If
        
      Case KIT_MON_ID
        If ValEmpty(Cell.Id, csId) Then
          MsgInfo LNGGetText(2114, vbNullString, strRow)  'Debe indicar una moneda (1)
          Exit Function
        End If
        MonId = Cell.Id
        
      Case KIT_IMPORTEORIGEN
        bOrigen = Not ValEmpty(Val(Cell.Value), csDouble)
      
      Case KIT_IMPORTE
        If ValEmpty(Val(Cell.Value), csDouble) Then
          MsgInfo LNGGetText(1897, vbNullString, strRow)  'Debe indicar un importe (1)
          Exit Function
        End If
      
      Case KIT_NROTARJETA
        If ValEmpty(Cell.Value, csText) Then
          MsgInfo LNGGetText(2120, vbNullString, strRow)  'Debe indicar un número tarjeta (1)
          Exit Function
        End If
      
      Case KIT_NROAUTORIZACION
        If ValEmpty(Cell.Value, csText) Then
          MsgInfo LNGGetText(2121, vbNullString, strRow)  'Debe indicar un número autorización (1)
          Exit Function
        End If
      
      Case KIT_FECHAVTO
        If ValEmpty(Cell.Value, csDate) Then
          MsgInfo LNGGetText(1384, vbNullString, strRow)  'Debe indicar una fecha de vencimiento (1)
          Exit Function
        End If
      
      Case KIT_TITULAR
        If ValEmpty(Cell.Value, csText) Then
          MsgInfo LNGGetText(2122, vbNullString, strRow)  'Debe indicar un Titular (1)
          Exit Function
        End If
    End Select
  Next
  
  If Not bOrigen And MonId <> m_MonDefault Then
    MsgInfo LNGGetText(2118, vbNullString, strRow)
            'Debe indicar un importe para la moneda extranjera (1)
    Exit Function
  End If
  
  pValidateRowTarjetas = True
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
          MsgInfo LNGGetText(2116, vbNullString, strRow)
                  'Debe indicar una número de cheque (1)
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
          MsgInfo LNGGetText(2113, vbNullString, strRow)
                  'Debe indicar una cuenta contable (1)
          Exit Function
        End If
        
        If Not gDB.GetData(csTCuenta, cscCueId, Cell.Id, cscMonId, MonId) Then Exit Function
        
      Case KIE_IMPORTEORIGEN
        bOrigen = Not ValEmpty(Val(Cell.Value), csDouble)
      
      Case KIE_IMPORTE
        If ValEmpty(Val(Cell.Value), csDouble) Then
          MsgInfo LNGGetText(1897, vbNullString, strRow)
                  'Debe indicar un importe (1)
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
  For Each Row In pGetTarjetas().Rows
    pCell(Row, KIT_TJCC_ID).Id = csNO_ID
  Next
  Dim AbmObj As cABMGeneric
  Set AbmObj = m_Items
  AbmObj.ShowValue pGetChequesProperty(), True
  AbmObj.ShowValue pGetTarjetasProperty(), True
End Sub

Private Sub pSetFilterColFactura()
  
  Dim AbmObj As cABMGeneric
  Set AbmObj = m_Items
  
  pCol(pGetOtros().Columns, KIO_FV_ID_RET).HelpFilter = "cli.cli_id = " & pGetCliente()
  AbmObj.RefreshColumnProperties pGetOtrosProperty(), cscFvIdRet
  
End Sub

Private Function pGetCliente() As Long
  pGetCliente = m_ObjAbm.Properties.Item(cscCliId).HelpId
End Function

Private Function pGetFileNamePostFix() As String
  Dim rtn As String
  
  rtn = Left$(m_ObjAbm.Properties.Item(cscCliId).Value, 50) & "-" & _
                m_ObjAbm.Properties.Item(cscCobzNrodoc).Value
        
  pGetFileNamePostFix = rtn
End Function


