VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cRendicion"
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
' cRendicion
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
Private Const C_Module = "cRendicion"

Private Const c_Items = "Items"

Private Const K_NUMERO                         As Integer = 1
Private Const K_NRODOC                         As Integer = 2
Private Const K_DESCRIP                        As Integer = 3
Private Const K_FECHA                          As Integer = 4
Private Const K_TOTAL                          As Integer = 9
Private Const K_CLI_ID                         As Integer = 10
Private Const K_DOC_ID                         As Integer = 11
Private Const K_DOCT_ID                        As Integer = 12
Private Const K_EST_ID                         As Integer = 17
Private Const K_CCOS_ID                        As Integer = 18
Private Const K_SUC_ID                         As Integer = 19
Private Const K_LGJ_ID                         As Integer = 27
Private Const K_ITEMS                          As Integer = 28

Private Const KI_RENDI_ID                    As Integer = 1
Private Const KI_IMPORTE                     As Integer = 2
Private Const KI_MF_ID                       As Integer = 3
Private Const KI_FECHA                       As Integer = 4
Private Const KI_CUE_ID                      As Integer = 5
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
Private Const KI_MFD_ID                      As Integer = 16
Private Const KI_CCOS_ID                     As Integer = 18
Private Const KI_MON_ID                      As Integer = 19

Private Const csLegajo = 15001

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

Private m_ItemsDeleted        As String

Private m_Copy              As Boolean

Private m_GeneralConfig     As cGeneralConfig

Private m_DocEditable       As Boolean
Private m_DocEditMsg        As String

Private m_TaPropuesto       As Boolean
Private m_TaMascara         As String

Private m_iOrden            As Long

Private m_ObjApply          As cRendicionAplic

Private m_MfIds()           As Long
' propiedades publicas

' propiedades privadas
' funciones publicas
' Edit Apply
'
Public Sub Refresh()
  Load m_Id
  pRefreshProperties
End Sub

Public Sub ShowRendicion(ByVal CliId As Long, ByRef vMfIds() As Long)
  On Error GoTo ControlError

  m_Cli_id = CliId
  gDB.GetData csTCliente, cscCliId, CliId, cscCliNombre, m_Cliente
  
  Dim i As Long
  ReDim m_MfIds(UBound(vMfIds))
  For i = 0 To UBound(vMfIds)
    m_MfIds(i) = vMfIds(i)
  Next
  
  cIEditGeneric_Edit csNO_ID

  GoTo ExitProc
ControlError:
  MngError Err, "ShowRendicion", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

' Implementacion de cIABMClient
Private Function cIABMClient_Copy() As Boolean

  If Not DocSecurityCanAccessEx(csPreTsrNewRendicion, _
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
  GetDocNumber m_LastDoc, m_ObjAbm, m_TaPropuesto, cscRendNrodoc
  pSetEnabled
End Function

Private Function cIABMClient_EditNew() As Boolean
  Dim Mouse As cMouseWait
  Set Mouse = New cMouseWait
  cIEditGeneric_Edit csNO_ID

  ' Obtengo el numero para este comprobante
  '
  GetDocNumber m_LastDoc, m_ObjAbm, m_TaPropuesto, cscRendNrodoc
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

  Doc.ClientTable = csTRendicion
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
      ShowEditState m_DocEditMsg, "Rendición"
    
    Case MSG_DOC_APPLY
      pShowApply
    
    Case MSG_DOC_DELETE
      If cIEditGeneric_Delete(m_Id) Then
        cIABMClient_MessageEx = True
        pMove MSG_DOC_NEXT
      End If
    
    Case MSG_DOC_ANULAR
      DocAnular m_Id, m_est_id, m_Estado, csPreTsrAnularRendicion, csPreTsrDesAnularRendicion, m_ObjAbm, m_DocEditable, m_DocEditMsg, "sp_DocRendicionAnular", "sp_DocRendicionEditableGet"
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
      DocumentSearch csEDT_Rendicion, Me, Not CBool(Info)
  
    Case MSG_DOC_DOC_AUX
      
      If m_Id Then
      
        ShowDocAux m_as_id, _
                   "CSContabilidad2.cAsiento", _
                   "CSABMInterface2.cABMGeneric"
      Else
        MsgInfo "Debe editar un comprobante guardado para poder ver los documentos auxiliares"
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
        GetDocNumber m_LastDoc, m_ObjAbm, m_TaPropuesto, cscRendNrodoc
        
      End If
      
      ' Defino el estado de edicion del comprobante
      '
      pSetEnabled
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
  If Not DocCanSave(m_ObjAbm, cscRendFecha) Then
    cIABMClient_Save = False
    Exit Function
  End If
  
  Dim Mouse As cMouseWait
  Set Mouse = New cMouseWait
  
  DoEvents: DoEvents: DoEvents: DoEvents
  
  Set register = New cRegister
  register.fieldId = cscRendTMPId
  register.Table = csTRendicionTMP
  
  register.id = csNew
    
  If m_Copy Then
    register.Fields.Add2 cscRendId, csNew, csLong
  Else
    register.Fields.Add2 cscRendId, m_Id, csLong
  End If
  
  If register.id = csNew Then
    m_est_id = CSGeneralEx2.csEEstado.csEEst_Pendiente
  End If
  
  Dim IProperty As cIABMProperty
  For Each IProperty In m_ObjAbm.Properties
    With IProperty
      Select Case .Key
        Case K_NUMERO
          register.Fields.Add2 cscRendNumero, .Value, csLong
        Case K_NRODOC
          register.Fields.Add2 cscRendNrodoc, .Value, csText
        Case K_DESCRIP
          register.Fields.Add2 cscRendDescrip, .Value, csText
        Case K_FECHA
          register.Fields.Add2 cscRendFecha, .Value, csDate
        Case K_CLI_ID
          register.Fields.Add2 cscCliId, .HelpId, csId
        Case K_CCOS_ID
          register.Fields.Add2 cscCcosId, .HelpId, csId
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
          register.Fields.Add2 cscRendTotal, Val(.Value), csCurrency
      End Select
    End With
  Next
  
  register.Fields.Add2 cscRendGrabarAsiento, 1, csBoolean
  register.Fields.Add2 cscEstId, m_est_id, csId
  
  register.Fields.HaveLastUpdate = True
  register.Fields.HaveWhoModify = True
  
  If Not register.BeginTrans(gDB) Then Exit Function
  
  Const c_ErrorSave = "Error al grabar la Rendicion"
  
  If Not gDB.Save(register, , "cIABMClient_Save", C_Module, c_ErrorSave) Then Exit Function
  
  m_iOrden = 0
  If Not pSaveItems(register.id) Then Exit Function
  
  If Not register.CommitTrans() Then Exit Function
  
  Dim sqlstmt As String
  Dim rs      As Recordset
  sqlstmt = "sp_DocRendicionSave " & register.id
  
  If Not gDB.OpenRs(sqlstmt, rs, , , , "cIABMClient_Save", C_Module, c_ErrorSave) Then Exit Function
  
  If rs.EOF Then Exit Function
  
  Dim id As Long
  If Not GetDocIDFromRecordset(rs, id) Then Exit Function
  
  m_Copy = False
  
  cIABMClient_Save = Load(id)
End Function

Private Function cIABMClient_Terminate() As Boolean
  m_Editing = False
  
  cIABMClient_Terminate = True
  ' Este objeto puede no cumplir con la interfaz esperada, asi que si hay un error no
  ' le doy bola
  On Error GoTo ControlError
  If m_Id = csNO_ID Then Exit Function
  If m_ObjTree Is Nothing Then Exit Function
  
  m_ObjTree.sqlstmt = "sp_lsdoc_Rendicion"
  
  If m_IsNew Then
    m_ObjTree.AddLine m_Id
  Else
    m_ObjTree.RefreshLine m_Id
  End If
ControlError:
End Function

Private Property Get cIABMClient_Title() As String
  cIABMClient_Title = "Rendición"
End Property

Private Function cIABMClient_Validate() As Boolean
  Dim IProperty    As cIABMProperty

  For Each IProperty In m_ObjAbm.Properties
    With IProperty
      Select Case .Key
        Case K_FECHA
          If ValEmpty(.Value, csDate) Then
            MsgInfo "Debe indicar una fecha"
            Exit Function
          End If
        Case K_CLI_ID
          If ValEmpty(.HelpId, csId) Then
            MsgInfo "Debe indicar un cliente"
            Exit Function
          End If
        Case K_DOC_ID
          If ValEmpty(.HelpId, csId) Then
            MsgInfo "Debe indicar un documento"
            Exit Function
          End If
        Case K_SUC_ID
          If ValEmpty(.HelpId, csId) Then
            MsgInfo "Debe indicar una sucursal"
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
      cIABMClientGrid_IsEmptyRow = pIsEmptyRowItems(Row, RowIndex)
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

Private Function cIDocumento_LoadForPrint(ByVal id As Long) As Boolean
  On Error GoTo ControlError

  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  
  sqlstmt = "select doct_id, doc_id from Rendicion where mf_id = " & id
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Function
  
  m_Id = id
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
  cIEditGeneric_ShowList = SecurityCanAccess(csPreTsrListRendicion)
End Function

Private Property Set cIEditGeneric_ObjAbm(rhs As CSInterfacesABM.cIABMGeneric)
  Set m_ObjAbm = rhs
  m_ObjAbm.IsDocument = True
End Property

Private Property Get cIEditGeneric_Editing() As Boolean
  cIEditGeneric_Editing = m_Editing
End Property

Private Function cIEditGeneric_Delete(id As Long) As Boolean
  Dim doc_id As Long
  
  If Not m_ObjAbm Is Nothing Then
    doc_id = GetdocIdFromObjAbm(m_ObjAbm)
  Else
    If Not GetDocIdFromId(id, _
                          csTRendicion, _
                          cscRendId, _
                          doc_id) Then
      Exit Function
    End If
  End If
  
  If Not DocSecurityCanAccess( _
                  csPreTsrDeleteRendicion, _
                  doc_id, _
                  csEDocTPreDelete) Then
    Exit Function
  End If

  Dim sqlstmt As String
  
  sqlstmt = "sp_DocRendicionDelete " & id
  
  cIEditGeneric_Delete = gDB.Execute(sqlstmt, "cIEditGeneric_Delete", C_Module)
End Function

Private Function cIEditGeneric_Search(id As Long, Cancela As Boolean) As Boolean

End Function

Private Function cIEditGeneric_Edit(id As Long, Optional ByVal InModalWindow As Boolean) As Boolean
  On Error GoTo ControlError
  
  If Not DocSecurityCanAccess(csPreTsrListRendicion, GetdocIdFromObjAbm(m_ObjAbm), csEDocTPreList) Then Exit Function
  
                            ' Id = csDocChanged esto significa que se cambio
                            '                   el documento estando en un
                            '                   comprobante ya guardado
                            '
  m_IsNew = id = csNO_ID Or id = csDocChanged
  
  If Not Load(id) Then Exit Function
  
  If m_ObjAbm.Properties.Count = 0 Then
    If Not LoadCollection() Then Exit Function
  Else
    pRefreshProperties
  End If
  
  ' Solo muestro asistentes si el nuevo no se esta dando por
  ' un cambio de documento
  '
  If id <> csDocChanged And m_IsNew Then
    pShowStartWizard
  End If
  
  m_Editing = True
  m_Copy = False
  
  cIEditGeneric_Edit = True
  Exit Function
ControlError:
  MngError Err, "cIEditGeneric_Edit", C_Module, vbNullString
End Function

Private Function cIEditGeneric_PrintObj(ByVal id As Long) As Boolean

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

Private Function cIEditGeneric_Preview(ByVal id As Long) As Boolean

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
  pColumnBeforeEdit = True
End Function

Private Function pColumnAfterEdit(ByRef IProperty As cIABMProperty, ByVal lRow As Long, ByVal lCol As Long, ByVal NewValue As Variant, ByVal NewValueID As Long)
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
  Dim id As Long
  
  id = Val(pCell(Row, KI_RENDI_ID).Value)
  
  If id <> csNO_ID Then m_ItemsDeleted = m_ItemsDeleted & id & ","
  
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
      cIABMClientGrid_ValidateRow = pValidateRowItems(Row, RowIndex)
  End Select
  
  GoTo ExitProc
ControlError:
  MngError Err, "cIABMClientGrid_ValidateRow", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Private Function pIsEmptyRowItems(ByRef Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  Dim Cell                  As cIABMGridCellValue
  Dim strRow                As String
  Dim bRowIsEmpty           As Boolean
  
  strRow = " (Fila " & RowIndex & ")"
  
  bRowIsEmpty = True
  
  For Each Cell In Row
    Select Case Cell.Key
      Case KI_CUE_ID
        If Not ValEmpty(Cell.id, csId) Then
          bRowIsEmpty = False
          Exit For
        End If
    End Select
  Next
  
  pIsEmptyRowItems = bRowIsEmpty
End Function

Private Function pValidateRowItems(ByRef Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  Dim Cell                  As cIABMGridCellValue
  Dim strRow                As String
  
  strRow = " (Fila " & RowIndex & ")"
  
  For Each Cell In Row
    Select Case Cell.Key
      Case KI_CUE_ID
        If ValEmpty(Cell.id, csId) Then
          MsgInfo "Debe indicar una cuenta" & strRow
          Exit Function
        End If
    End Select
  Next
  
  pValidateRowItems = True
End Function

' funciones privadas
Private Function LoadCollection() As Boolean
  Dim Filter      As String
  Dim c           As cIABMProperty
  Dim AbmGen      As cABMGeneric
  Dim Cotizacion  As Double
  
  Set AbmGen = m_ObjAbm
  AbmGen.ResetLayoutMembers
  
  With m_ObjAbm.Tabs
  
    .Clear
  
    With .Add(Nothing)
      .Index = 0
      .Name = "General"
    End With
    
    With .Add(Nothing)
      .Index = 1
      .Name = "Adicionales"
    End With
    
  End With
  
  With m_ObjAbm.Properties
  
    .Clear
    
    With .Add(Nothing, cscDocId)
      .PropertyType = cspHelp
      .Table = CSDocumento2.CSDocumento
      .Name = "Documento"
      .Key = K_DOC_ID
      .HelpId = m_doc_id
      .Value = m_Documento
      .HelpFilter = "'doct_id = " & csEDT_Rendicion & "'"
    End With
    
    With .Add(Nothing, csDocNumberID)
      .PropertyType = cspNumeric
      .SubType = cspInteger
      .Name = "Número"
      .Key = K_NUMERO
      .Value = m_Numero
      .Enabled = False
    End With
    
    With .Add(Nothing, csDocEstateID)
      .PropertyType = cspText
      .Name = "Estado"
      .Key = K_EST_ID
      .Value = m_Estado
      .Enabled = False
    End With
    
    With .Add(Nothing, cscRendFecha)
      .PropertyType = cspDate
      .Name = "Fecha"
      .LeftLabel = -580
      .Left = 700
      .Key = K_FECHA
      .Value = m_Fecha
    End With
    
    With .Add(Nothing, cscCliId)
      .PropertyType = cspHelp
      .Table = csCliente
      .TopFromProperty = cscRendFecha
      .Left = 2700
      .LeftLabel = -580
      .Name = "Cliente"
      .Key = K_CLI_ID
      .HelpId = m_Cli_id
      .Value = m_Cliente
    End With
    
    With .Add(Nothing, cscRendNrodoc)
      .PropertyType = cspText
      .Name = "Número"
      .Size = 50
      .Key = K_NRODOC
      .Value = m_Nrodoc
      .TextMask = m_TaMascara
      .TextAlign = vbRightJustify
    End With
    
    With .Add(Nothing, cscLgjId)
      .PropertyType = cspHelp
      .Table = csLegajo
      .Name = "Legajo"
      .Key = K_LGJ_ID
      .HelpId = m_lgj_id
      .Value = m_Legajo
      .TabIndex = 1
    End With
    
    With .Add(Nothing, cscCcosId)
      .PropertyType = cspHelp
      .Table = csCentroCosto
      .Left = 9500
      .TopFromProperty = cscCliId
      .Name = "Centro de Costo"
      .Key = K_CCOS_ID
      .HelpId = m_ccos_id
      .Value = m_CentroCosto
    End With
    
    With .Add(Nothing, cscSucId)
      .PropertyType = cspHelp
      .Table = csSucursal
      .Name = "Sucursal"
      .Key = K_SUC_ID
      .HelpId = m_suc_id
      .Value = m_Sucursal
    End With
    
    With .Add(Nothing, cscRendDescrip)
      .PropertyType = cspText
      .SubType = cspMemo
      .Name = "Observ."
      .LeftLabel = -600
      .Size = 5000
      .Key = K_DESCRIP
      .Value = m_Descrip
      .LeftFromProperty = cscRendFecha
      .TopFromProperty = cscRendNrodoc
      .Width = 11070
      .Height = 800
      .TopToPrevious = 440
    End With
  End With
  
  If Not m_ObjAbm.Show(Me) Then Exit Function
      
'///////////////////////////////////////////////////////////////////
' ITEMS
'///////////////////////////////////////////////////////////////////
  
  Const c_TabItem = 0
  
  With m_Items.Tabs
    .Clear
    
    With .Add(Nothing)
      .Index = c_TabItem
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
      .Key = K_ITEMS
      .TabIndex = c_TabItem
      .GridAdd = True
      .GridEdit = True
      .GridRemove = True
    End With
  End With
  
  m_ItemsDeleted = vbNullString
  
  If Not m_Items.Show(Me) Then Exit Function
  
'///////////////////////////////////////////////////////////////////
' FOOTER
'///////////////////////////////////////////////////////////////////

  Set AbmGen = m_Footer
  AbmGen.ResetLayoutMembers
  
  With m_Footer.Properties
  
    .Clear
    
    Set c = .Add(Nothing, cscRendTotal)
    With c
      .PropertyType = cspNumeric
      .Format = m_GeneralConfig.FormatDecImporte
      .Name = "Total"
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

Private Function pLoadItems(ByRef Propiedad As cIABMProperty) As Boolean
  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  Dim Grid    As cIABMGrid
  
  sqlstmt = "sp_DocRendicionGetItems " & m_Id
  
  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, "pLoadItems", C_Module) Then Exit Function
  
  Propiedad.Grid.Columns.Clear
  Propiedad.Grid.Rows.Clear
  
  Set Grid = Propiedad.Grid
  
  With Grid.Columns
    With .Add(Nothing)
      .Visible = False
      .Key = KI_RENDI_ID
    End With
  
    With .Add(Nothing)
      .Name = "Cuenta"
      .PropertyType = cspHelp
      .Table = csCuenta
      .HelpFilter = cscCuecId & "=" & csECuecBancos
      .Width = 2200
      .Key = KI_CUE_ID
    End With
    
    With .Add(Nothing)
      .Name = "Mon"
      .PropertyType = cspHelp
      .Table = csMoneda
      .Width = 520
      .Key = KI_MON_ID
      .Enabled = False
    End With
    
    With .Add(Nothing)
      .Name = "Origen"
      .PropertyType = cspNumeric
      .Format = m_GeneralConfig.FormatDecImporte
      .SubType = cspMoney
      .Width = 920
      .Key = KI_IMPORTEORIGEN
    End With
    
    With .Add(Nothing)
      .Name = "Importe"
      .PropertyType = cspNumeric
      .Format = m_GeneralConfig.FormatDecImporte
      .SubType = cspMoney
      .Width = 920
      .Key = KI_IMPORTE
    End With
    
    With .Add(Nothing)
      .Name = "Descripción"
      .PropertyType = cspText
      .SubType = cspTextButtonEx
      .Width = 1600
      .Key = KI_DESCRIP
    End With
  End With
  
  Dim F  As cIABMGridRow
  Dim fv As cIABMGridCellValue
  
  While Not rs.EOF
  
    Set F = Propiedad.Grid.Rows.Add(Nothing, rs(cscRendiId).Value)
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscRendiId)
    fv.Key = KI_RENDI_ID
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscCueNombre)
    fv.id = gDB.ValField(rs.Fields, cscCueId)
    fv.Key = KI_CUE_ID
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscMonNombre)
    fv.id = gDB.ValField(rs.Fields, cscMonId)
    fv.Key = KI_MON_ID
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscRendiImporteOrigen)
    fv.Key = KI_IMPORTEORIGEN
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscRendiImporte)
    fv.Key = KI_IMPORTE

    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscRendiDescrip)
    fv.Key = KI_DESCRIP
    
    rs.MoveNext
  Wend
  
  pLoadItems = True
End Function

Private Function Load(ByVal id As Long) As Boolean
  Dim sqlstmt     As String

  sqlstmt = "sp_DocRendicionGet " & EmpId & "," & id & "," & gDB.UserId
  
  Dim rs As Recordset

  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, C_LoadFunction, C_Module) Then Exit Function

  If Not rs.EOF Then

    m_IsNew = False

    m_Id = gDB.ValField(rs.Fields, cscRendId)
    m_Numero = gDB.ValField(rs.Fields, cscRendNumero)
    m_Nrodoc = gDB.ValField(rs.Fields, cscRendNrodoc)
    m_Descrip = gDB.ValField(rs.Fields, cscRendDescrip)
    m_Fecha = gDB.ValField(rs.Fields, cscRendFecha)
    m_Total = gDB.ValField(rs.Fields, cscRendTotal)
    m_Cli_id = gDB.ValField(rs.Fields, cscCliId)
    m_Cliente = gDB.ValField(rs.Fields, cscCliNombre)
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
    m_Firmado = gDB.ValField(rs.Fields, cscRendFirmado)
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
    m_Total = 0
    m_Cli_id = csNO_ID
    m_Cliente = vbNullString
    m_ccos_id = csNO_ID
    m_CentroCosto = vbNullString
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
  
    ' Para ver documentos auxiliares
    '
    m_as_id = csNO_ID
    
    m_TaPropuesto = False
    m_TaMascara = vbNullString
    
    m_doc_id = m_LastDoc
    m_Cli_id = m_LastCli
    m_Cliente = m_LastCliName
    m_Documento = m_LastDocName
  
    DocEditableGet m_doc_id, m_DocEditable, m_DocEditMsg, csPreTsrNewRendicion
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
  m_Host.Server.AddMenu "T&esoreria", csMenuEnum.csMenuTesoreria, vbNullString, 1, False, False, False, True, False, Nothing
  m_Host.Server.AddMenu "&Rendicion", csPreTsrListRendicion, "T&esoreria", 0, True, False, False, False, False, Me
  cIMenuClient_Initialize = True
  
  GoTo ExitProc
ControlError:
  MngError Err, "cIMenuClient_Initialize", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Private Function cIMenuClient_ProcessMenu(ByVal id As Long) As Variant
  m_Host.MenuListDocClick "CSABMInterface2.CABMGeneric", "CSTesoreria2.cRendicion", "CSABMInterface2.CABMGenericListDoc", "CSTesoreria2.cRendicionListDoc", Me, "Rendicion", 0
End Function

' Reglas del Objeto de Negocios
Private Sub pShowTotales(ByRef Rows As CSInterfacesABM.cIABMGridRows)
  Dim Neto      As Double
  Dim Row       As CSInterfacesABM.cIABMGridRow
  
  For Each Row In Rows
    Neto = Neto + Val(pCell(Row, KI_IMPORTE).Value)
  Next
  
  m_Footer.Properties(cscRendTotal).Value = Neto
  
  m_Footer.RefreshControls
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
  
  Dim AbmGen  As cABMGeneric
  
  Set AbmGen = m_Items
  AbmGen.RefreshEnabledState m_Items.Properties

  Set AbmGen = m_ObjAbm
  AbmGen.RefreshEnabledState m_ObjAbm.Properties

End Sub

Private Function pGetCueIdCliente(ByRef Cue_id As Long) As Boolean
  Dim sqlstmt As String
  Dim rs      As Recordset
  
  ' Cuenta contable del cliente
  sqlstmt = "sp_DocGetCueId " & m_LastCli & "," & m_LastDoc
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Function

  If rs.EOF Then Exit Function

  Cue_id = gDB.ValField(rs.Fields, cscCueId)
  
  pGetCueIdCliente = True
End Function

Private Function pFirmar() As Boolean
  Dim Doc     As cDocumento
  Dim Us_id   As Long
  
  Set Doc = New cDocumento
  
  If m_Id = csNO_ID Then
    MsgWarning "Antes de poder firmar el documento debe guardarlo."
    Exit Function
  End If
  
  If m_Firmado Then
    If Not Ask("El documento ya ha sido firmado desea borrar la firma", vbYes, "Firmar") Then
      Exit Function
    End If
  End If
  
  If Not Doc.Firmar(m_doc_id, Us_id) Then Exit Function
  
  Dim sqlstmt As String
  Dim rs      As Recordset
  
  sqlstmt = "sp_DocRendicionFirmar " & m_Id & "," & Us_id
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Function
  
  m_est_id = gDB.ValField(rs.Fields, cscEstId)
  m_Estado = gDB.ValField(rs.Fields, cscEstNombre)
  
  Dim iProp As cIABMProperty
  Set iProp = m_ObjAbm.Properties(csDocEstateID)
  
  With iProp
    .HelpId = m_est_id
    .Value = m_Estado
  End With
  
  gDB.GetData csTRendicion, cscRendId, m_Id, cscRendFirmado, m_Firmado
  
  m_ObjAbm.ShowValue iProp
  
  pFirmar = True
End Function

Private Function pMove(ByVal MoveTo As ABM_MSG) As Boolean
  Dim sqlstmt As String
  Dim rs      As Recordset
  Dim doc_id  As Long
  
  doc_id = m_ObjAbm.Properties(cscDocId).HelpId
  
  If doc_id = csNO_ID Then MsgInfo "Debe seleccionar un documento"
  
  sqlstmt = "sp_DocRendicionMover " & MoveTo & "," & m_Numero & "," & doc_id
  
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
        GetDocNumber m_LastDoc, m_ObjAbm, m_TaPropuesto, cscRendNrodoc
    
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
    
    Set c = .Item(cscRendFecha)
    c.Value = m_Fecha
    
    Set c = .Item(cscCliId)
    c.HelpId = m_Cli_id
    c.Value = m_Cliente
    
    Set c = .Item(csDocNumberID)
    c.Value = m_Numero
    
    Set c = .Item(csDocEstateID)
    c.Value = m_Estado
    
    Set c = .Item(cscRendNrodoc)
    c.Value = m_Nrodoc
    c.TextMask = m_TaMascara
    c.TextAlign = vbRightJustify
    
    Set c = .Item(cscCcosId)
    c.HelpId = m_ccos_id
    c.Value = m_CentroCosto
    
    Set c = .Item(cscSucId)
    c.HelpId = m_suc_id
    c.Value = m_Sucursal
    
    Set c = .Item(cscLgjId)
    c.HelpId = m_lgj_id
    c.Value = m_Legajo
    
    Set c = .Item(cscRendDescrip)
    c.Value = m_Descrip
  
  End With
  
  Set AbmGen = m_ObjAbm
  AbmGen.ShowValues m_ObjAbm.Properties
  
  Set c = m_Items.Properties.Item(c_Items)
  If Not pLoadItems(c) Then Exit Sub
  
  m_ItemsDeleted = vbNullString
  
  Set AbmGen = m_Items
  AbmGen.ShowValues m_Items.Properties
  
  Set c = m_Footer.Properties.Item(cscRendTotal)
  c.Value = m_Total
  
  Set AbmGen = m_Footer
  AbmGen.ShowValues m_Footer.Properties
  
  pSetEnabled
End Sub

Private Sub pShowStartWizard()
  On Error GoTo ControlError
  
  Dim oWizard As cRendicionWizard
  Set oWizard = New cRendicionWizard
  
  If Not oWizard.Load() Then Exit Sub

  With oWizard
    .cli_id = m_Cli_id
    .Cliente = m_Cliente
    .MfIds = m_MfIds
  End With
  
  'Dim iEditGeneric As cIEditGeneric
  'Set iEditGeneric = oWizard
  'Set iEditGeneric.ObjTree = m_ObjTree
  
  Dim iObjWizard As cIWizardGeneric
  Dim oObjWizard   As cWizardGeneric
  
  Set iObjWizard = CSKernelClient2.CreateObject("CSABMInterface2.cWizardGeneric")
  Set oObjWizard = iObjWizard
  Set oObjWizard.ObjClient = oWizard
  
  iObjWizard.Show "CSTesoreria2.cRendicionWizard"
  
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
  
  Set m_GeneralConfig = New cGeneralConfig
  m_GeneralConfig.Load
  ReDim m_MfIds(0)

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
  ReDim m_MfIds(0)

  GoTo ExitProc
ControlError:
  MngError Err, "Class_Terminate", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

'////////////////////////////////////////////////////////////
Private Function pSaveItems(ByVal id As Long) As Boolean
  Dim register  As cRegister
  Dim IProperty As cIABMProperty
        
  Dim Row  As cIABMGridRow
  Dim Cell As cIABMGridCellValue
  
  For Each Row In pGetItems().Rows
  
    Set register = New cRegister
    register.fieldId = cscRendiTMPId
    register.Table = csTRendicionItemTMP
    register.id = csNew
    
    For Each Cell In Row
      Select Case Cell.Key
        
        Case KI_DESCRIP
          register.Fields.Add2 cscRendiDescrip, Cell.Value, csText
        Case KI_MON_ID
          register.Fields.Add2 cscMonId, Cell.id, csId
        Case KI_CUE_ID
          register.Fields.Add2 cscCueId, Cell.id, csId
        Case KI_IMPORTEORIGEN
          register.Fields.Add2 cscRendiImporteOrigen, Val(Cell.Value), csCurrency
        Case KI_IMPORTE
          register.Fields.Add2 cscRendiImporte, Val(Cell.Value), csCurrency
      End Select
    Next
    
    m_iOrden = m_iOrden + 1
    register.Fields.Add2 cscRendiOrden, m_iOrden, csInteger
    register.Fields.Add2 cscRendTMPId, id, csId
    register.Fields.Add2 cscRendiId, id, csLong
    
    register.Fields.HaveLastUpdate = False
    register.Fields.HaveWhoModify = False
    
    If Not gDB.Save(register, , "pSaveItems", C_Module, "Error al grabar la Rendicion") Then Exit Function
  Next
  
  Dim sqlstmt As String
  
  If m_ItemsDeleted <> vbNullString And m_Id <> csNO_ID And Not m_Copy Then
  
    Dim vDeletes As Variant
    Dim i As Long
    
    m_ItemsDeleted = RemoveLastColon(m_ItemsDeleted)
    vDeletes = Split(m_ItemsDeleted, ",")
    
    For i = 0 To UBound(vDeletes)
    
      Set register = New cRegister
      register.fieldId = cscRendibTMPId
      register.Table = csTRendicionItemBorradoTMP
      register.id = csNew
      
      register.Fields.Add2 cscRendiId, Val(vDeletes(i)), csInteger
      register.Fields.Add2 cscRendId, m_Id, csId
      register.Fields.Add2 cscRendTMPId, id, csId
      
      register.Fields.HaveLastUpdate = False
      register.Fields.HaveWhoModify = False
      
      If Not gDB.Save(register, , "pSaveTarjetas", C_Module, "Error al grabar la Rendicion") Then Exit Function
    Next
    
  End If
  
  pSaveItems = True
End Function

Private Sub pShowApply()
  
  If Not DocSecurityCanAccess(csPreTsrModifyAplic, m_doc_id, csEDocTPreAplicar) Then Exit Sub
  
  If m_ObjApply Is Nothing Then
    Set m_ObjApply = New cRendicionAplic
  
  ' Edit Apply
  '
  Else
    If m_ObjApply.id <> m_Id Then
      Set m_ObjApply.ObjectClient = Nothing
      Set m_ObjApply = New cRendicionAplic
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
Private Function pGetItems() As cIABMGrid
  Set pGetItems = m_ObjAbm.Properties.Item(c_Items).Grid
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
