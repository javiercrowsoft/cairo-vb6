VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cResolucionCupon"
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
' cResolucionCupon
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
Private Const C_Module = "cResolucionCupon"

Private Const c_colcupon = "cupon"
Private Const c_colcuenta = "cuenta"
Private Const c_colcuota = "cuota"

Private Const c_Items = "ITEMS"

Private Const cscCuePresentado As String = "cue_presentado"
Private Const cscCueBanco      As String = "cue_banco"
Private Const cscCueRechazo    As String = "cue_rechazo"

Private Const K_NUMERO                         As Integer = 1
Private Const K_NRODOC                         As Integer = 2
Private Const K_DESCRIP                        As Integer = 3
Private Const K_FECHA                          As Integer = 4
Private Const K_TOTAL                          As Integer = 9
Private Const K_DOC_ID                         As Integer = 11
Private Const K_DOCT_ID                        As Integer = 12
Private Const K_ITEMS                          As Integer = 15
Private Const K_EST_ID                         As Integer = 17
Private Const K_SUC_ID                         As Integer = 19
Private Const K_LGJ_ID                         As Integer = 27

Private Const KI_RCUPI_ID                       As Integer = 2
Private Const KI_ORDEN                          As Integer = 3
Private Const KI_DESCRIP                        As Integer = 4
Private Const KI_CUOTAS                         As Integer = 5
Private Const KI_CUOTA                          As Integer = 6
Private Const KI_CUOTACOMISION                  As Integer = 7
Private Const KI_TARJETACOMISION                As Integer = 8
Private Const KI_COMISION                       As Integer = 9
Private Const KI_IMPORTECUPON                   As Integer = 10
Private Const KI_IMPORTE                        As Integer = 11
Private Const KI_IMPORTE_ORIGEN                 As Integer = 12
Private Const KI_TJCC_ID                        As Integer = 23
Private Const KI_CUPON                          As Integer = 24
Private Const KI_CUE_ID_PRESENTADO              As Integer = 25
Private Const KI_RECHAZADO                      As Integer = 26
Private Const KI_CUE_ID                         As Integer = 27
Private Const KI_BCO_ID                         As Integer = 28
Private Const KI_TJCC_ID_SAVED                  As Integer = 29

Private Const KI_CUE_ID_BANCO                   As Integer = 30
Private Const KI_CUE_ID_RECHAZO                 As Integer = 31

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

Private m_suc_id                       As Long
Private m_Sucursal                     As String
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
Private m_LastDocName       As String

Private m_IsNew             As Boolean

Private m_BranchId          As Long
Private m_TreeId            As Long

Private m_Host              As CSMenu.cIMenuHost

Private m_ItemsDeleted      As String

Private m_Copy              As Boolean

Private m_GeneralConfig     As cGeneralConfig

Private m_DocEditable       As Boolean
Private m_DocEditMsg        As String

Private m_TaPropuesto       As Boolean
Private m_TaMascara         As String

' propiedades publicas
' propiedades privadas
' funciones publicas
' Implementacion de cIABMClient
Private Function cIABMClient_Copy() As Boolean

  If Not DocSecurityCanAccessEx(csPreTsrNewResolucionCupon, _
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
  GetDocNumber m_LastDoc, m_ObjAbm, m_TaPropuesto, cscRcupNrodoc
  pSetEnabled
End Function

Private Function cIABMClient_EditNew() As Boolean
  
  cIABMClient_Terminate
  m_IsNew = True

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
  GetDocNumber m_LastDoc, m_ObjAbm, m_TaPropuesto, cscRcupNrodoc
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

  Doc.ClientTable = csTResolucionCupon
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
      ShowEditState m_DocEditMsg, LNGGetText(2233, vbNullString)  'Resolución de Cupones
      
    Case MSG_DOC_DELETE
      If cIEditGeneric_Delete(m_Id) Then
        cIABMClient_MessageEx = True
        pMove MSG_DOC_NEXT
      End If
    
    Case MSG_DOC_ANULAR
      DocAnular m_Id, m_est_id, m_Estado, csPreTsrAnularResolucionCupon, csPreTsrDesAnularResolucionCupon, m_ObjAbm, m_DocEditable, m_DocEditMsg, "sp_DocResolucionCuponAnular", "sp_DocResolucionCuponEditableGet"
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
      DocumentSearch csEDT_ResolucionCupon, Me, Not CBool(Info)
  
    Case MSG_DOC_DOC_AUX
      
      If m_Id Then
      
        ShowDocAux m_as_id, _
                   "CSContabilidad2.cAsiento", _
                   "CSABMInterface2.cABMGeneric"
      Else
        MsgInfo LNGGetText(1620, vbNullString)
                'Debe editar un comprobante guardado para poder ver los documentos auxiliares
      End If
  
    Case MSG_DOC_HISTORY
    
      If m_Id <> csNO_ID Then
    
        ShowHistory csResolucionCupon, m_Id, m_Documento & " " & m_Nrodoc
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
        GetDocNumber m_LastDoc, m_ObjAbm, m_TaPropuesto, cscRcupNrodoc
        
      End If
      
      ' Defino el estado de edicion del comprobante
      '
      pSetEnabled
  End Select
End Function

Private Function cIABMClient_Save() As Boolean
  Dim register     As cRegister
  Dim bMonedaLegal As Boolean
  
  ' Save and State
  '
  If Not DocCanEdit(m_DocEditable, m_DocEditMsg) Then
    cIABMClient_Save = True
    Exit Function
  End If
  If Not DocCanSave(m_ObjAbm, cscRcupFecha) Then
    cIABMClient_Save = False
    Exit Function
  End If
  
  ' OJO -tsr
  If pGetItems().Grid.Rows.count = 0 Then
    MsgWarning LNGGetText(3903, vbNullString) 'El documento debe contener al menos un item
    cIABMClient_Save = False
    Exit Function
  End If
  
  Dim Mouse As cMouseWait
  Set Mouse = New cMouseWait
  
  DoEvents: DoEvents: DoEvents: DoEvents
  
  Set register = New cRegister
  register.fieldId = cscRcupTMPId
  register.Table = csTResolucionCuponTMP
  
  register.Id = csNew
    
  If m_Copy Then
    register.Fields.Add2 cscRcupId, csNew, csLong
  Else
    register.Fields.Add2 cscRcupId, m_Id, csLong
  End If
  
  If register.Id = csNew Then
    m_est_id = CSGeneralEx2.csEEstado.csEEst_Pendiente
  End If
  
  Dim IProperty As cIABMProperty
  For Each IProperty In m_ObjAbm.Properties
    With IProperty
      Select Case .Key
        Case K_NUMERO
          register.Fields.Add2 cscRcupNumero, .Value, csLong
        Case K_NRODOC
          register.Fields.Add2 cscRcupNrodoc, .Value, csText
        Case K_DESCRIP
          register.Fields.Add2 cscRcupDescrip, .Value, csText
        Case K_FECHA
          register.Fields.Add2 cscRcupFecha, .Value, csDate
        Case K_SUC_ID
          register.Fields.Add2 cscSucId, .HelpId, csId
        Case K_DOC_ID
          register.Fields.Add2 cscDocId, .HelpId, csId
        Case K_LGJ_ID
          register.Fields.Add2 cscLgjId, .HelpId, csId
      End Select
    End With
  Next
  
  For Each IProperty In m_Footer.Properties
    With IProperty
      Select Case .Key
        Case K_TOTAL
          register.Fields.Add2 cscRcupTotal, Val(.Value), csCurrency
      End Select
    End With
  Next
  
  register.Fields.Add2 cscRcupGrabarasiento, 1, csBoolean
  register.Fields.Add2 cscEstId, m_est_id, csId
  
  register.Fields.HaveLastUpdate = True
  register.Fields.HaveWhoModify = True
  
  If Not register.BeginTrans(gDB) Then Exit Function
  
  If Not gDB.Save(register, , "cIABMClient_Save", C_Module, c_ErrorSave) Then Exit Function
  
  If Not pSaveItems(register.Id) Then Exit Function
  If Not register.CommitTrans() Then Exit Function
  
  Dim sqlstmt As String
  Dim rs      As Recordset
  sqlstmt = "sp_DocResolucionCuponSave " & register.Id
  
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
  
  m_ObjTree.sqlstmt = "sp_lsdoc_ResolucionCupon"
  
  If m_IsNew Then
    m_ObjTree.AddLine m_Id
  Else
    m_ObjTree.RefreshLine m_Id
  End If
ControlError:
End Function

Private Property Get cIABMClient_Title() As String
  cIABMClient_Title = LNGGetText(2233, vbNullString)  'Resolución de Cupones
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

Private Function cIDocumento_LoadForPrint(ByVal Id As Long) As Boolean
  On Error GoTo ControlError

  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  
  sqlstmt = "select doct_id, doc_id from ResolucionCupon where rcup_id = " & Id
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
  cIEditGeneric_ShowList = SecurityCanAccess(csPreTsrListResolucionCupon)
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
                          csTResolucionCupon, _
                          cscRcupId, _
                          doc_id) Then
      Exit Function
    End If
  End If
  
  If Not DocSecurityCanAccess( _
                  csPreTsrDeleteResolucionCupon, _
                  doc_id, _
                  csEDocTPreDelete) Then
    Exit Function
  End If

  Dim sqlstmt As String
  
  sqlstmt = "sp_DocResolucionCuponDelete " & Id & "," & EmpId & "," & User.Id
  
  cIEditGeneric_Delete = gDB.Execute(sqlstmt, "cIEditGeneric_Delete", C_Module)
End Function

Private Function cIEditGeneric_Search(Id As Long, Cancela As Boolean) As Boolean

End Function

Private Function cIEditGeneric_Edit(Id As Long, Optional ByVal InModalWindow As Boolean) As Boolean
  On Error GoTo ControlError
  
  If Not DocSecurityCanAccess(csPreTsrListResolucionCupon, GetdocIdFromObjAbm(m_ObjAbm), csEDocTPreList) Then Exit Function
  
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
    Case K_ITEMS
      With m_Items.Properties.Item(c_Items)
        pShowTotales .Grid.Rows
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
    Case K_ITEMS
      cIABMClientGrid_ColumnAfterEdit = pColumnAfterEdit(m_Items.Properties.Item(c_Items), lRow, lCol, NewValue, NewValueID)
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
      cIABMClientGrid_ColumnBeforeEdit = pColumnBeforeEdit(m_Items.Properties.Item(c_Items), lRow, lCol, iKeyAscii)
  End Select
  
  GoTo ExitProc
ControlError:
  MngError Err, "cIABMClientGrid_ColumnBeforeEdit", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Private Function pColumnBeforeEdit(ByRef IProperty As cIABMProperty, ByVal lRow As Long, ByVal lCol As Long, ByVal iKeyAscii As Integer)
  Dim Row     As cIABMGridRow
  
  With IProperty.Grid
    Select Case .Columns(lCol).Key
      Case KI_CUE_ID
        Set Row = .Rows(lRow)
        pSetFilterCuenta pCell(Row, KI_RECHAZADO).Id, IProperty
      Case KI_CUOTA
        Set Row = .Rows(lRow)
        pSetListCuota Val(pCell(Row, KI_CUOTAS).Value)
    End Select
  End With
  
  pColumnBeforeEdit = True
End Function

Private Function pColumnAfterEdit(ByRef IProperty As cIABMProperty, ByVal lRow As Long, ByVal lCol As Long, ByVal NewValue As Variant, ByVal NewValueID As Long)
  Dim Row     As cIABMGridRow
  
  Select Case IProperty.Grid.Columns(lCol).Key
    Case KI_TJCC_ID
      Set Row = IProperty.Grid.Rows(lRow)
      pSetCuponData Row, NewValueID
    Case KI_RECHAZADO
      Set Row = IProperty.Grid.Rows(lRow)
      pSetCuponDataEx IProperty, lRow, Row, NewValueID
    Case KI_CUOTA
      pSetImporteYComision IProperty, lRow, Row, NewValueID
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
  
  Id = Val(pCell(Row, KI_RCUPI_ID).Value)
  
  If Id <> csNO_ID Then m_ItemsDeleted = m_ItemsDeleted & Id & ","
  
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
  
  strRow = " (Fila " & RowIndex & ")"
  
  For Each Cell In Row
    Select Case Cell.Key
      Case KI_IMPORTE
        If ValEmpty(Cell.Value, csCurrency) Then
          MsgInfo LNGGetText(1897, vbNullString, strRow) 'Debe indicar un importe (1)
          Exit Function
        End If
      Case KI_TJCC_ID
        If ValEmpty(Cell.Id, csId) Then
          MsgInfo LNGGetText(2182, vbNullString, strRow) 'Debe indicar un cupon (1)
          Exit Function
        End If
    End Select
  Next
  
  pValidateRow = True
End Function

' funciones privadas
Private Function LoadCollection() As Boolean
  Dim Filter      As String
  Dim c           As cIABMProperty
  Dim AbmGen      As cABMGeneric
  
  Set AbmGen = m_ObjAbm
  AbmGen.ResetLayoutMembers

  With m_ObjAbm.Properties
  
    .Clear
    
    With .Add(Nothing, cscDocId)
      .PropertyType = cspHelp
      .Table = CSDocumento2.CSDocumento
      .Name = LNGGetText(1567, vbNullString)  'Documento
      .Key = K_DOC_ID
      .HelpId = m_doc_id
      .Value = m_Documento
      .HelpFilter = "'doct_id = " & csEDT_ResolucionCupon & "'"
    End With
    
    With .Add(Nothing, csDocNumberID)
      .PropertyType = cspNumeric
      .SubType = cspInteger
      .Name = LNGGetText(1065, vbNullString)  'Número
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
    
    With .Add(Nothing, cscRcupFecha)
      .PropertyType = cspDate
      .Name = LNGGetText(1569, vbNullString)  'Fecha
      .LeftLabel = -580
      .Left = 700
      .Key = K_FECHA
      .Value = m_Fecha
    End With
    
    With .Add(Nothing, cscRcupNrodoc)
      .PropertyType = cspText
      .Name = LNGGetText(1065, vbNullString)   'Número
      .Size = 50
      .Key = K_NRODOC
      .Value = m_Nrodoc
      .TextMask = m_TaMascara
      .TextAlign = vbRightJustify
    End With
    
    With .Add(Nothing, cscLgjId)
      .PropertyType = cspHelp
      .Table = csLegajo
      .TopFromProperty = cscRcupFecha
      .Left = 5000
      .Name = LNGGetText(1575, vbNullString)  'Legajo
      .Key = K_LGJ_ID
      .HelpId = m_lgj_id
      .Value = m_Legajo
    End With
    
    With .Add(Nothing, cscSucId)
      .PropertyType = cspHelp
      .Table = csSucursal
      .Name = LNGGetText(1281, vbNullString)  'Sucursal
      .Key = K_SUC_ID
      .HelpId = m_suc_id
      .Value = m_Sucursal
    End With
    
    With .Add(Nothing, cscRcupDescrip)
      .PropertyType = cspText
      .SubType = cspMemo
      .Name = LNGGetText(1211, vbNullString)  'Observ.
      .LeftLabel = -600
      .Size = 5000
      .Key = K_DESCRIP
      .Value = m_Descrip
      .LeftFromProperty = cscRcupFecha
      .TopFromProperty = cscRcupNrodoc
      .Width = 6580
      .Height = 800
      .TopToPrevious = 440
    End With
  
  End With
  
  If Not m_ObjAbm.Show(Me) Then Exit Function
      
  With m_Items.Tabs
  
    .Clear
  
    With .Add(Nothing)
      .Name = LNGGetText(1371, vbNullString)  'Items
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
      .Key = K_ITEMS
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
  
    Set c = .Add(Nothing, cscRcupTotal)
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
  
  LoadCollection = True
End Function

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

Private Function pLoadItems(ByRef Propiedad As cIABMProperty) As Boolean
  Dim sqlstmt As String
  
  Dim rs As ADODB.Recordset
  
  sqlstmt = "sp_DocResolucionCuponGetItems " & m_Id
  
  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, "pLoadItems", C_Module) Then Exit Function
  
  Dim o               As cIABMGridColumn
  Dim ColCupon       As cIABMGridColumn
  Dim ColTjccFilter   As String
  
  With Propiedad.Grid.Columns
    .Clear
    Propiedad.Grid.Rows.Clear
  
    Set o = .Add(Nothing)
    o.Visible = False
    o.Key = KI_RCUPI_ID
    
    Set o = .Add(Nothing)
    o.Visible = False
    o.Key = KI_TJCC_ID_SAVED
    
    Set o = .Add(Nothing)
    o.Name = LNGGetText(1267, vbNullString)  'Cuenta
    o.PropertyType = cspHelp
    o.Table = csCuenta
    o.Width = 2200
    o.Enabled = False
    o.Key = KI_CUE_ID_PRESENTADO
    
    Set o = .Add(Nothing, c_colcupon)
    o.Name = LNGGetText(1065, vbNullString)  'Número
    o.PropertyType = cspHelp
    o.Table = csTarjetaCreditoCupon
    o.Width = 900
    o.Key = KI_TJCC_ID
    Set ColCupon = o
    
    Set o = .Add(Nothing)
    o.Name = LNGGetText(2105, vbNullString)  'Cupon
    o.Enabled = False
    o.Key = KI_CUPON
    
    Set o = .Add(Nothing)
    o.Visible = False
    o.Key = KI_TARJETACOMISION
    
    Set o = .Add(Nothing)
    o.Visible = False
    o.Key = KI_CUOTACOMISION
    
    Set o = .Add(Nothing)
    o.Name = LNGGetText(1473, vbNullString)  'Cuotas
    o.Enabled = False
    o.Key = KI_CUOTAS
    
    Set o = .Add(Nothing, c_colcuota)
    o.Name = LNGGetText(1463, vbNullString)  'Cuota
    o.PropertyType = cspList
    o.Key = KI_CUOTA
    
    Set o = .Add(Nothing)
    o.Name = LNGGetText(2050, vbNullString)  'Rechazado
    o.PropertyType = cspCheck
    o.Key = KI_RECHAZADO
    
    Set o = .Add(Nothing, c_colcuenta)
    o.Name = LNGGetText(1267, vbNullString)  'Cuenta
    o.PropertyType = cspHelp
    o.Table = csCuenta
    o.Width = 2200
    o.HelpFilter = "cuec_id = " & csECuecBancos
    o.Key = KI_CUE_ID
    
    Set o = .Add(Nothing)
    o.Name = LNGGetText(1122, vbNullString)  'Banco
    o.PropertyType = cspText
    o.Width = 1800
    o.Key = KI_BCO_ID
    o.Enabled = False
    
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
    o.Visible = False
    o.Key = KI_IMPORTECUPON
    
    Set o = .Add(Nothing)
    o.Name = LNGGetText(1228, vbNullString)  'Importe
    o.PropertyType = cspNumeric
    o.Format = m_GeneralConfig.FormatDecImporte
    o.SubType = cspMoney
    o.Width = 1200
    o.Key = KI_IMPORTE
    
    Set o = .Add(Nothing)
    o.Name = LNGGetText(1091, vbNullString)   'Comision
    o.PropertyType = cspNumeric
    o.Format = m_GeneralConfig.FormatDecImporte
    o.SubType = cspMoney
    o.Width = 1200
    o.Key = KI_COMISION
    
    Set o = .Add(Nothing)
    o.Visible = False
    o.Key = KI_CUE_ID_BANCO
  
    Set o = .Add(Nothing)
    o.Visible = False
    o.Key = KI_CUE_ID_RECHAZO
  End With
  
  Dim F  As cIABMGridRow
  Dim fv As cIABMGridCellValue
  
  While Not rs.EOF
  
    Set F = Propiedad.Grid.Rows.Add(Nothing, rs(cscRcupiId).Value)
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscRcupiId)
    fv.Key = KI_RCUPI_ID
    
    Set fv = F.Add(Nothing)
    fv.Id = gDB.ValField(rs.Fields, cscTjccId)
    fv.Key = KI_TJCC_ID_SAVED
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, "cue_presentado")
    fv.Id = gDB.ValField(rs.Fields, "cue_id_presentado")
    fv.Key = KI_CUE_ID_PRESENTADO
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscTjccNumero)
    fv.Id = gDB.ValField(rs.Fields, cscTjccId)
    fv.Key = KI_TJCC_ID
    
    ColTjccFilter = ColTjccFilter & fv.Id & C_StrColon
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscTjccNumeroDoc)
    fv.Key = KI_CUPON
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscTjcComision)
    fv.Key = KI_TARJETACOMISION
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscTjccuComision)
    fv.Key = KI_CUOTACOMISION
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscTjccuCantidad)
    fv.Key = KI_CUOTAS
    
    Set fv = F.Add(Nothing)
    fv.Id = gDB.ValField(rs.Fields, cscRcupiCuota)
    fv.Key = KI_CUOTA
    
    Set fv = F.Add(Nothing)
    fv.Id = gDB.ValField(rs.Fields, cscRcupiRechazado)
    fv.Key = KI_RECHAZADO
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscCueNombre)
    fv.Id = gDB.ValField(rs.Fields, cscCueId)
    fv.Key = KI_CUE_ID
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscBcoNombre)
    fv.Key = KI_BCO_ID
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscRcupiDescrip)
    fv.Key = KI_DESCRIP
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscRcupiImporteOrigen)
    fv.Key = KI_IMPORTE_ORIGEN
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscTjccImporte)
    fv.Key = KI_IMPORTECUPON
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscRcupiImporte)
    fv.Key = KI_IMPORTE
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscRcupiComision)
    fv.Key = KI_COMISION
    
    Set fv = F.Add(Nothing)
    fv.Id = gDB.ValField(rs.Fields, cscCueIdBanco)
    fv.Value = gDB.ValField(rs.Fields, cscCueBanco)
    fv.Key = KI_CUE_ID_BANCO
    
    Set fv = F.Add(Nothing)
    fv.Id = gDB.ValField(rs.Fields, cscCueIdRechazo)
    fv.Value = gDB.ValField(rs.Fields, cscCueRechazo)
    fv.Key = KI_CUE_ID_RECHAZO
    
    rs.MoveNext
  Wend
  
  ColCupon.HelpFilter = pGetFilterCupon(RemoveLastColon(ColTjccFilter))
  
  pLoadItems = True
End Function

Private Function Load(ByVal Id As Long) As Boolean
  Dim sqlstmt     As String

  sqlstmt = "sp_DocResolucionCuponGet " & EmpId & "," & Id & "," & gDB.UserId
  
  Dim rs As Recordset

  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, C_LoadFunction, "cResolucionLogico") Then Exit Function

  If Not rs.EOF Then

    m_Id = gDB.ValField(rs.Fields, cscRcupId)
    m_Numero = gDB.ValField(rs.Fields, cscRcupNumero)
    m_Nrodoc = gDB.ValField(rs.Fields, cscRcupNrodoc)
    m_Descrip = gDB.ValField(rs.Fields, cscRcupDescrip)
    m_Fecha = gDB.ValField(rs.Fields, cscRcupFecha)
    m_Total = gDB.ValField(rs.Fields, cscRcupTotal)
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
    m_Firmado = gDB.ValField(rs.Fields, cscRcupFirmado)
    m_DocEditable = gDB.ValField(rs.Fields, cscDocEditable)
    m_DocEditMsg = gDB.ValField(rs.Fields, cscDoceditMsg)
    
    ' Para ver documentos auxiliares
    '
    m_as_id = gDB.ValField(rs.Fields, cscAsId)
    
    m_TaPropuesto = gDB.ValField(rs.Fields, cscTa_Propuesto)
    m_TaMascara = gDB.ValField(rs.Fields, cscTa_Mascara)

    m_LastDoc = m_doc_id
    m_LastDocName = m_Documento
    
  Else
    m_Id = csNO_ID
    m_Numero = 0
    m_Nrodoc = vbNullString
    m_Descrip = vbNullString
    m_Fecha = VDGetDateById(csToday)
    m_Total = 0
    m_doc_id = csNO_ID
    m_Documento = vbNullString
    m_Doct_id = csNO_ID
    m_lgj_id = csNO_ID
    m_Legajo = vbNullString
    m_Creado = csNoDate
    m_Modificado = csNoDate
    m_Modifico = 0
    m_est_id = csNO_ID
    m_Estado = vbNullString
    m_suc_id = User.suc_id
    m_Sucursal = User.Sucursal
    m_Firmado = False
  
    m_doc_id = m_LastDoc
    m_Documento = m_LastDocName
  
    ' Para ver documentos auxiliares
    '
    m_as_id = csNO_ID
    
    m_TaPropuesto = False
    m_TaMascara = vbNullString
  
    DocEditableGet m_doc_id, m_DocEditable, m_DocEditMsg, csPreTsrNewResolucionCupon
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
  Dim str_2048  As String
  
  str_2048 = LNGGetText(2048, vbNullString) 'T&esoreria
  Set m_Host = Host
  m_Host.Server.AddMenu str_2048, csMenuEnum.csMenuTesoreria, vbNullString, 1, False, False, False, True, False, Nothing
  m_Host.Server.AddMenu LNGGetText(2234, vbNullString), csPreTsrListResolucionCupon, str_2048, 0, True, False, False, False, False, Me
                          '&Resolución de Cupones
  cIMenuClient_Initialize = True
  
  GoTo ExitProc
ControlError:
  MngError Err, "cIMenuClient_Initialize", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Private Function cIMenuClient_ProcessMenu(ByVal Id As Long) As Variant
  m_Host.MenuListDocClick "CSABMInterface2.cABMGeneric", "CSTesoreria2.cResolucionCupon", "CSABMInterface2.CABMGenericListDoc", "CSTesoreria2.cResolucionCuponListDoc", Me, LNGGetText(2233, vbNullString), 0   'Resolución de Cupones
End Function

Private Function pSaveItems(ByVal Id As Long) As Boolean
  Dim register  As cRegister
  Dim iOrden    As Long
        
  Dim Row  As cIABMGridRow
  Dim Cell As cIABMGridCellValue
  
  For Each Row In m_Items.Properties(c_Items).Grid.Rows
  
    Set register = New cRegister
    register.fieldId = cscRcupiTMPId
    register.Table = csTResolucionCuponItemTMP
    register.Id = csNew
    
    For Each Cell In Row
      Select Case Cell.Key
        
        Case KI_RCUPI_ID
          If m_Copy Then
            register.Fields.Add2 cscRcupiId, csNew, csInteger
          Else
            register.Fields.Add2 cscRcupiId, Val(Cell.Value), csInteger
          End If
        Case KI_DESCRIP
          register.Fields.Add2 cscRcupiDescrip, Cell.Value, csText
        Case KI_CUE_ID
          register.Fields.Add2 cscCueId, Cell.Id, csId
        Case KI_CUOTA
          register.Fields.Add2 cscRcupiCuota, Cell.Id, csLong
        Case KI_TJCC_ID
          register.Fields.Add2 cscTjccId, Cell.Id, csId
        Case KI_IMPORTE
          register.Fields.Add2 cscRcupiImporte, Val(Cell.Value), csCurrency
        Case KI_IMPORTE_ORIGEN
          register.Fields.Add2 cscRcupiImporteOrigen, Val(Cell.Value), csCurrency
        Case KI_COMISION
          register.Fields.Add2 cscRcupiComision, Val(Cell.Value), csCurrency
      End Select
    Next
    
    iOrden = iOrden + 1
    register.Fields.Add2 cscRcupiOrden, iOrden, csInteger
    register.Fields.Add2 cscRcupTMPId, Id, csId
    
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
      register.fieldId = cscRcupibTMPId
      register.Table = csTResolucionCuponItemBorradoTMP
      register.Id = csNew
      
      register.Fields.Add2 cscRcupiId, Val(vDeletes(i)), csInteger
      register.Fields.Add2 cscRcupId, m_Id, csId
      register.Fields.Add2 cscRcupTMPId, Id, csId
      
      register.Fields.HaveLastUpdate = False
      register.Fields.HaveWhoModify = False
      
      If Not gDB.Save(register, , "pSaveItems", C_Module, c_ErrorSave) Then Exit Function
    Next
    
  End If
  
  pSaveItems = True
End Function

' Reglas del Objeto de Negocios
Private Sub pShowTotales(ByRef Rows As CSInterfacesABM.cIABMGridRows)
  Dim Total     As Double
  Dim Row       As CSInterfacesABM.cIABMGridRow
  
  For Each Row In Rows
    Total = Total + Val(pCell(Row, KI_IMPORTE).Value)
  Next
  
  m_Footer.Properties(cscRcupTotal).Value = Total
  
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
  
  sqlstmt = "sp_DocResolucionCuponFirmar " & m_Id & "," & Us_id
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Function
  
  m_est_id = gDB.ValField(rs.Fields, cscEstId)
  m_Estado = gDB.ValField(rs.Fields, cscEstNombre)
  
  Dim iProp As cIABMProperty
  Set iProp = m_ObjAbm.Properties(csDocEstateID)
  
  With iProp
    .HelpId = m_est_id
    .Value = m_Estado
  End With
  
  gDB.GetData csTResolucionCupon, cscRcupId, m_Id, cscRcupFirmado, m_Firmado
  
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
  
  sqlstmt = "sp_DocResolucionCuponMover " & MoveTo & "," & m_Numero & "," & doc_id
  
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
        GetDocNumber m_LastDoc, m_ObjAbm, m_TaPropuesto, cscRcupNrodoc
    
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
  
  With m_ObjAbm.Properties
  
    Set c = .Item(cscDocId)
    c.HelpId = m_doc_id
    c.Value = m_Documento
    
    Set c = .Item(cscRcupFecha)
    c.Value = m_Fecha
    
    Set c = .Item(csDocNumberID)
    c.Value = m_Numero
    
    Set c = .Item(csDocEstateID)
    c.Value = m_Estado
    
    Set c = .Item(cscRcupNrodoc)
    c.Value = m_Nrodoc
    c.TextMask = m_TaMascara
    c.TextAlign = vbRightJustify
    
    Set c = .Item(cscSucId)
    c.HelpId = m_suc_id
    c.Value = m_Sucursal
    
    Set c = .Item(cscLgjId)
    c.HelpId = m_lgj_id
    c.Value = m_Legajo
    
    Set c = .Item(cscRcupDescrip)
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
  
  AbmGen.RefreshColumnProperties c, c_colcupon
  
  Set c = m_Footer.Properties.Item(cscRcupTotal)
  c.Value = m_Total
  
  Set AbmGen = m_Footer
  AbmGen.ShowValues m_Footer.Properties
  
  pSetEnabled
End Sub

Private Function pGetFilterCupon(ByVal TjccIds As String) As String
  Dim rtn As String
  
  rtn = GetHelpFilterCupon()
  
  If TjccIds <> vbNullString Then
    rtn = "(" & rtn & ") Or (Tjcc_id in (" & TjccIds & "))"
  End If
  
  pGetFilterCupon = rtn
End Function

Private Sub pSetCuponData(ByRef Row As cIABMGridRow, ByVal Tjcc_id As Long)
  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  
  If Tjcc_id = pCell(Row, KI_TJCC_ID_SAVED).Id Then Exit Sub
  
  sqlstmt = "sp_cuponGetData " & Tjcc_id
  
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Sub
  
  If Not rs.EOF Then
  
    With pCell(Row, KI_CUE_ID)
      If pCell(Row, KI_RECHAZADO).Id Then
        .Id = gDB.ValField(rs.Fields, cscCueIdRechazo)
        .Value = gDB.ValField(rs.Fields, cscCueRechazo)
      Else
        .Id = gDB.ValField(rs.Fields, cscCueIdBanco)
        .Value = gDB.ValField(rs.Fields, cscCueBanco)
      End If
    End With
  
    With pCell(Row, KI_CUE_ID_BANCO)
      .Id = gDB.ValField(rs.Fields, cscCueIdBanco)
      .Value = gDB.ValField(rs.Fields, cscCueBanco)
    End With
  
    With pCell(Row, KI_CUE_ID_RECHAZO)
      .Id = gDB.ValField(rs.Fields, cscCueIdRechazo)
      .Value = gDB.ValField(rs.Fields, cscCueRechazo)
    End With
  
    With pCell(Row, KI_CUE_ID_PRESENTADO)
      .Id = gDB.ValField(rs.Fields, cscCueIdPresentado)
      .Value = gDB.ValField(rs.Fields, cscCuePresentado)
    End With
    
    With pCell(Row, KI_CUPON)
      .Value = gDB.ValField(rs.Fields, cscTjccNumeroDoc)
    End With
  
    With pCell(Row, KI_BCO_ID)
      .Value = gDB.ValField(rs.Fields, cscBcoNombre)
    End With
    
    pCell(Row, KI_CUOTAS).Value = gDB.ValField(rs.Fields, cscTjccuCantidad)
    pCell(Row, KI_CUOTACOMISION).Value = gDB.ValField(rs.Fields, cscTjccuComision)
    pCell(Row, KI_TARJETACOMISION).Value = gDB.ValField(rs.Fields, cscTjcComision)
    
    pCell(Row, KI_IMPORTE).Value = gDB.ValField(rs.Fields, cscTjccImporte)
    pCell(Row, KI_IMPORTE_ORIGEN).Value = gDB.ValField(rs.Fields, cscTjccImporteOrigen)
  
  Else
    
    With pCell(Row, KI_CUE_ID)
      .Id = csNO_ID
      .Value = vbNullString
    End With
  
    With pCell(Row, KI_CUE_ID_PRESENTADO)
      .Id = csNO_ID
      .Value = vbNullString
    End With
  
    With pCell(Row, KI_CUE_ID_BANCO)
      .Id = csNO_ID
      .Value = vbNullString
    End With
  
    With pCell(Row, KI_CUE_ID_RECHAZO)
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

Private Function ValidateCuenta(ByVal bRechazado, ByVal Cue_id As Long) As Boolean
  If Cue_id = csNO_ID Then Exit Function
  Dim cuec_id As Long
  If Not gDB.GetData(csTCuenta, cscCueId, Cue_id, cscCuecId, cuec_id) Then Exit Function
  
  If bRechazado Then
    If cuec_id <> csECuecPatrimoniales Then Exit Function
  Else
    If cuec_id <> csECuecBancos Then Exit Function
  End If
  ValidateCuenta = True
End Function

Private Sub pSetImporteYComision(ByRef IProperty As cIABMProperty, ByVal lRow As Long, ByRef Row As cIABMGridRow, ByVal Cuota As Integer)
  Dim bRechazado As Boolean
  Dim importe    As Double
  
  bRechazado = pCell(Row, KI_RECHAZADO).Id
  importe = pCell(Row, KI_IMPORTECUPON).Value
  
  If bRechazado Then
    pCell(Row, KI_COMISION).Value = 0
    pCell(Row, KI_IMPORTE).Value = importe
  Else
    If Cuota <> 0 Then
      importe = DivideByCero(importe, Val(pCell(Row, KI_CUOTAS).Value))
    End If
    pCell(Row, KI_COMISION).Value = (importe * Val(pCell(Row, KI_CUOTACOMISION)) / 100) _
                                    + (importe * Val(pCell(Row, KI_TARJETACOMISION)) / 100)
    pCell(Row, KI_IMPORTE).Value = importe
  End If
End Sub

Private Sub pSetCuponDataEx(ByRef IProperty As cIABMProperty, ByVal lRow As Long, ByRef Row As cIABMGridRow, ByVal bRechazado As Boolean)
  With pCell(Row, KI_CUE_ID)
    If Not ValidateCuenta(bRechazado, .Id) Then
      If bRechazado Then
        .Id = pCell(Row, KI_CUE_ID_RECHAZO).Id
        .Value = pCell(Row, KI_CUE_ID_RECHAZO).Value
      Else
        .Id = pCell(Row, KI_CUE_ID_BANCO).Id
        .Value = pCell(Row, KI_CUE_ID_BANCO).Value
      End If
    End If
    pSetFilterCuenta bRechazado, IProperty
  End With
End Sub

Private Sub pSetListCuota(ByVal Cuotas As Integer)
  Dim AbmObj    As cABMGeneric
  Dim IProperty As cIABMProperty
  Dim i         As Integer
  
  Set AbmObj = m_Items
  Set IProperty = m_Items.Properties.Item(c_Items)
  
  With IProperty.Grid.Columns(c_colcuota).List
    .Clear
    With .Add(Nothing)
      .Id = 0
      .Value = "(Todas)"
    End With
    For i = 1 To Cuotas
      With .Add(Nothing)
        .Id = i
        .Value = Format(i, "00")
      End With
    Next
  End With
  
  AbmObj.RefreshColumnProperties IProperty, c_colcuota
End Sub

Private Sub pSetFilterCuenta(ByVal bRechazado As Boolean, ByRef IProperty As cIABMProperty)
  Dim AbmObj As cABMGeneric
  Set AbmObj = m_Items
  If bRechazado Then
    IProperty.Grid.Columns(c_colcuenta).HelpFilter = "cuec_id = " & csECuecPatrimoniales
  Else
    IProperty.Grid.Columns(c_colcuenta).HelpFilter = "cuec_id = " & csECuecBancos
  End If
  AbmObj.RefreshColumnProperties IProperty, c_colcuenta
End Sub

' Construccion - Destruccion
Private Sub Class_Initialize()
  On Error GoTo ControlError
    
  c_ErrorSave = LNGGetText(2247, vbNullString)  'Error al grabar la Resolución de Cupones
    
  Set m_GeneralConfig = New cGeneralConfig
  m_GeneralConfig.Load
  
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

  GoTo ExitProc
ControlError:
  MngError Err, "Class_Terminate", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Function pGetItems() As cIABMProperty
  Set pGetItems = m_Items.Properties.Item(c_Items)
End Function

