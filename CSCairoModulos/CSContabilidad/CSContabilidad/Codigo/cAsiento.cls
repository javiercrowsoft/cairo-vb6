VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cAsiento"
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
' cAsiento
' 28-01-2004

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cAsiento"

Private Const c_Items = "ITEMS"
Private Const c_Origen = "ORIGEN"

Private Const c_AsTotalDebe                    As String = "as_totaldebe"
Private Const c_AsTotalHaber                   As String = "as_totalhaber"

Private Const K_NUMERO                         As Integer = 1
Private Const K_NRODOC                         As Integer = 2
Private Const K_DESCRIP                        As Integer = 3
Private Const K_FECHA                          As Integer = 4
Private Const K_DOC_ID                         As Integer = 11
Private Const K_DOCT_ID                        As Integer = 12
Private Const K_ITEMS                          As Integer = 15
Private Const K_TOTAL_DEBE                     As Integer = 20
Private Const K_TOTAL_HABER                    As Integer = 21

Private Const K_ID_CLIENTE                     As Integer = 22

Private Const KI_ASI_ID                         As Integer = 2
Private Const KI_ORDEN                          As Integer = 3
Private Const KI_DESCRIP                        As Integer = 6
Private Const KI_HABER                          As Integer = 20
Private Const KI_DEBE                           As Integer = 21
Private Const KI_CCOS_ID                        As Integer = 22
Private Const KI_CUE_ID                         As Integer = 23
Private Const KI_ORIGEN                         As Integer = 24

' pseudo-constantes
Private c_ErrorSave As String
Private c_strTitle  As String

' estructuras
' variables privadas
Private m_Id                           As Long
Private m_Numero                       As Long
Private m_Nrodoc                       As String
Private m_Descrip                      As String
Private m_Fecha                        As Date
Private m_doc_id                       As Long
Private m_Documento                    As String
Private m_Doct_id                      As Long
Private m_Creado                       As Date
Private m_Modificado                   As Date
Private m_Modifico                     As Long
Private m_Firmado                      As Boolean
Private m_TotalDebe                    As Double
Private m_TotalHaber                   As Double

' Para ver documentos auxiliares
'
Private m_id_cliente                   As Long
Private m_doct_id_cliente              As Long

Private m_doc_cliente                  As String

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

  If Not DocSecurityCanAccessEx(csPreConNewAsiento, _
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
  GetDocNumber m_LastDoc, m_ObjAbm, m_TaPropuesto, cscAsNrodoc
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
  GetDocNumber m_LastDoc, m_ObjAbm, m_TaPropuesto, cscAsNrodoc
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

  Doc.ClientTable = csTAsiento
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
      cIABMClient_MessageEx = False
    Case MSG_GRID_ROW_DELETED
      cIABMClient_MessageEx = True
      pShowTotales m_Items.Properties(c_Items).Grid.Rows
    
    Case MSG_DOC_EDIT_STATE
      ShowEditState m_DocEditMsg, c_strTitle
      
    Case MSG_DOC_DELETE
      If cIEditGeneric_Delete(m_Id) Then
        cIABMClient_MessageEx = True
        pMove MSG_DOC_NEXT
      End If
    Case MSG_DOC_ANULAR
      cIABMClient_MessageEx = False
  
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
      DocumentSearch csEDT_AsientoContable, Me, Not CBool(Info)
  
    Case MSG_DOC_DOC_AUX
      
      If m_Id Then
      
          Dim ObjEditName As String
          
          Select Case m_doct_id_cliente
            Case 1, 7, 9 ' FacturaVenta, Nota de Credito, Nota de Debito
              ObjEditName = "CSVenta2.cFacturaVenta"
            Case 2, 8, 9 ' FacturaCompra, Nota de Credito, Nota de Debito
              ObjEditName = "CSCompra2.cFacturaCompra"
            Case 13 ' Cobranza
              ObjEditName = "CSTesoreria2.cCobranza"
            Case 16 ' Orden de Pago
              ObjEditName = "CSTesoreria2.cOrdenPago"
            Case 26 ' Movimiento de Fondo
              ObjEditName = "CSTesoreria2.cMovimientoFondo"
            Case 32 ' DepositoCupon
              ObjEditName = "CSTesoreria2.cDepositoCupon"
            Case 17 ' Deposito Banco
              ObjEditName = "CSTesoreria2.cDepositoBanco"
            Case 33 ' Resolucion de Cupon
              ObjEditName = "CSTesoreria2.cResolucionCupon"
            Case 0 ' Es un asiento directo
              Exit Function
          End Select
          
          If ObjEditName = vbNullString Then
            MsgWarning LNGGetText(1956, vbNullString)
                      'No hay un documento asociado al doct_id " & m_doct_id_cliente &
                      'Comuniquese con soporte de CrowSoft para obtener asistencia técnica.
            Exit Function
          End If
      
          ShowDocAux m_id_cliente, _
                    ObjEditName, _
                    "CSABMInterface2.cABMGeneric"
      
      Else
        MsgInfo LNGGetText(1620, vbNullString)
                'Debe editar un comprobante guardado para poder ver los documentos auxiliares
      End If
  
    Case MSG_DOC_HISTORY
    
      If m_Id <> csNO_ID Then
    
        ShowHistory csAsiento, m_Id, m_Documento & " " & m_Nrodoc
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
        GetDocNumber m_LastDoc, m_ObjAbm, m_TaPropuesto, cscAsNrodoc
        
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
  If Not DocCanSave(m_ObjAbm, cscAsFecha) Then
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
  register.fieldId = cscAsTMPId
  register.Table = csTAsientoTMP
  
  register.ID = csNew
    
  If m_Copy Then
    register.fields.Add2 cscAsId, csNew, csLong
  Else
    register.fields.Add2 cscAsId, m_Id, csLong
  End If
  
  Dim IProperty As cIABMProperty
  For Each IProperty In m_ObjAbm.Properties
    With IProperty
      Select Case .Key
        Case K_NUMERO
          register.fields.Add2 cscAsNumero, .Value, csLong
        Case K_NRODOC
          register.fields.Add2 cscAsNrodoc, .Value, csText
        Case K_DESCRIP
          register.fields.Add2 cscAsDescrip, .Value, csText
        Case K_FECHA
          register.fields.Add2 cscAsFecha, .Value, csDate
        Case K_DOC_ID
          register.fields.Add2 cscDocId, .HelpId, csId
        Case K_DOCT_ID
          register.fields.Add2 cscDoctId, .HelpId, csId
      End Select
    End With
  Next
   
  register.fields.Add2 cscDoctId, csEDT_AsientoContable, csId
  
  register.fields.HaveLastUpdate = True
  register.fields.HaveWhoModify = True
  
  If Not register.BeginTrans(gDB) Then Exit Function
  
  If Not gDB.Save(register, , "cIABMClient_Save", C_Module, c_ErrorSave) Then Exit Function
  
  If Not pSaveItems(register.ID) Then Exit Function
  If Not register.CommitTrans() Then Exit Function
  
  
  Dim sqlstmt As String
  Dim rs      As Recordset
  sqlstmt = "sp_DocAsientoSave " & register.ID
  
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
  
  m_ObjTree.sqlstmt = "sp_lsdoc_asiento"
  
  If m_IsNew Then
    m_ObjTree.AddLine m_Id
  Else
    m_ObjTree.RefreshLine m_Id
  End If
ControlError:
End Function

Private Property Get cIABMClient_Title() As String
  cIABMClient_Title = c_strTitle
End Property

Private Function cIABMClient_Validate() As Boolean
  Dim IProperty As cIABMProperty

  For Each IProperty In m_ObjAbm.Properties
    With IProperty
      Select Case .Key
        Case K_FECHA
          If ValEmpty(.Value, csDate) Then
            MsgInfo LNGGetText(1558, vbNullString)    'Debe indicar una fecha
            Exit Function
          End If
        Case K_DOC_ID
          If ValEmpty(.HelpId, csId) Then
            MsgInfo LNGGetText(1562, vbNullString)    'Debe indicar un documento
            Exit Function
          End If
      End Select
    End With
  Next
  
  If m_TotalDebe <> m_TotalHaber Then
    MsgInfo LNGGetText(1957, vbNullString)    'El debe y el haber deben coincidir para que el asiento balancee
    Exit Function
  End If

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
  
  sqlstmt = "select doct_id, doc_id from Asiento where as_id = " & ID
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Function
  
  m_Id = ID
  m_doc_id = gDB.ValField(rs.fields, cscDocId)
  m_Doct_id = gDB.ValField(rs.fields, cscDoctId)
  
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
  cIEditGeneric_ShowList = SecurityCanAccess(csPreConListAsiento)
End Function

Private Property Set cIEditGeneric_ObjAbm(rhs As CSInterfacesABM.cIABMGeneric)
  Set m_ObjAbm = rhs
  m_ObjAbm.IsDocument = True

#If Not PREPROC_SFS Then
  Dim AbmGen      As cABMGenericDocEx

  Set AbmGen = m_ObjAbm
  With AbmGen
    .FactoryObject = "CSABMInterface2.cFactory"
    .ObjForm = "CSABMInterface2.fAsiento"
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
                          csTAsiento, _
                          cscAsId, _
                          doc_id) Then
      Exit Function
    End If
  End If
  
  If Not DocSecurityCanAccess( _
                  csPreConDeleteAsiento, _
                  doc_id, _
                  csEDocTPreDelete) Then
    Exit Function
  End If

  Dim sqlstmt As String
  
  sqlstmt = "sp_DocAsientoDelete " & ID & "," & EmpId & "," & User.ID
  
  cIEditGeneric_Delete = gDB.Execute(sqlstmt, "cIEditGeneric_Delete", C_Module)
End Function

Private Function cIEditGeneric_Search(ID As Long, Cancela As Boolean) As Boolean

End Function

Private Function cIEditGeneric_Edit(ID As Long, Optional ByVal InModalWindow As Boolean) As Boolean
  On Error GoTo ControlError
  
  If Not DocSecurityCanAccess(csPreConListAsiento, GetdocIdFromObjAbm(m_ObjAbm), csEDocTPreList) Then Exit Function
  
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
  Dim CellDebe     As cIABMGridCellValue
  Dim CellHaber    As cIABMGridCellValue
  Dim IProperty    As cIABMProperty
  Dim Row          As cIABMGridRow
  
  Set IProperty = m_Items.Properties.Item(c_Items)
  
  Select Case Key
    Case K_ITEMS
      Select Case IProperty.Grid.Columns(lCol).Key
        Case KI_DEBE
          Set Row = IProperty.Grid.Rows(lRow)
          Set CellDebe = pGetCellFromKey(Row, KI_DEBE)
          Set CellHaber = pGetCellFromKey(Row, KI_HABER)
          If Val(CellDebe.Value) < 0 Then CellDebe.Value = 0
          If Val(CellDebe.Value) > 0 Then CellHaber.Value = 0
        Case KI_HABER
          Set Row = IProperty.Grid.Rows(lRow)
          Set CellDebe = pGetCellFromKey(Row, KI_DEBE)
          Set CellHaber = pGetCellFromKey(Row, KI_HABER)
          If Val(CellHaber.Value) < 0 Then CellHaber.Value = 0
          If Val(CellHaber.Value) > 0 Then CellDebe.Value = 0
      End Select
  
      pShowTotales IProperty.Grid.Rows
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

Private Function pColumnAfterEdit(ByRef IProperty As cIABMProperty, _
                                  ByVal lRow As Long, _
                                  ByVal lCol As Long, _
                                  ByVal NewValue As Variant, _
                                  ByVal NewValueID As Long)
  Dim Column As cIABMGridColumn
  
  Set Column = IProperty.Grid.Columns.Item(lCol)
  
  Select Case Column.Key
    
    Case KI_CUE_ID
      
      If Not pIsMonDefault(NewValueID) And _
         NewValueID <> csNO_ID Then
         
        IProperty.Grid.Columns.Item(c_Origen).Visible = True
#If PREPROC_SFS Then
        Dim AbmObj As cABMGeneric
#Else
        Dim AbmObj As cABMGenericDocEx
#End If
        Set AbmObj = m_ObjAbm
        AbmObj.RefreshColumnProperties IProperty, c_Origen
      End If
  
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
  
  ID = Val(pCell(Row, KI_ASI_ID).Value)
  
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
      Case KI_CUE_ID
        If Not ValEmpty(Cell.ID, csId) Then
          bRowIsEmpty = False
          Exit For
        End If
      
      Case KI_DEBE
        If Not ValEmpty(Cell.Value, csCurrency) Then
          bRowIsEmpty = False
          Exit For
        End If
      
      Case KI_HABER
        If Not ValEmpty(Cell.Value, csCurrency) Then
          bRowIsEmpty = False
          Exit For
        End If
    
      Case KI_ORIGEN
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
  Dim bDebe                 As Boolean
  Dim bHaber                As Boolean
  Dim cue_id                As Long
  
  strRow = " (Fila " & RowIndex & ")"
  
  For Each Cell In Row
    Select Case Cell.Key
      Case KI_CUE_ID
        If ValEmpty(Cell.ID, csId) Then
          MsgInfo LNGGetText(1388, vbNullString, strRow)  'Debe indicar una cuenta (1)
          Exit Function
        End If
        cue_id = Cell.ID
        
      Case KI_DEBE
        If Not ValEmpty(Cell.Value, csCurrency) Then
          bDebe = True
        End If
      Case KI_HABER
        If Not ValEmpty(Cell.Value, csCurrency) Then
          bHaber = True
        End If
      Case KI_ORIGEN
        If m_Items.Properties(c_Items).Grid.Columns(c_Origen).Visible Then
        
          If Not pIsMonDefault(cue_id) Then
        
            If ValEmpty(Cell.Value, csCurrency) Then
              MsgInfo LNGGetText(1958, vbNullString, strRow)
                      'Debe indicar el importe en la moneda de la cuenta (1)
              Exit Function
            End If
          End If
        End If
    End Select
  Next
  
  If bDebe And bHaber Then
    MsgInfo LNGGetText(1959, vbNullString, strRow)
          'Debe indicar un importe en el Debe o en el Haber, no en ambas columnas (1)
    Exit Function
  End If
  
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
  
  AbmGen.NoButtons1 = BUTTON_ANULAR + BUTTON_DOC_APLIC
  AbmGen.NoButtons2 = BUTTON_DOC_ACTION
  AbmGen.InitButtons
  
  With m_ObjAbm.Properties
    .Clear
    With .Add(Nothing, cscDocId)
      .PropertyType = cspHelp
      .Table = CSDocumento2.CSDocumento
      .Name = LNGGetText(1567, vbNullString)    'Documento
      .Key = K_DOC_ID
      
      If m_doc_id <> csNO_ID Then
        .HelpId = m_doc_id
        .Value = m_Documento
      Else
        ' Preferencias del usuario
        '
        .HelpId = m_UserCfg.DocAsId
        .Value = m_UserCfg.DocAsNombre
        
        bValidateDocDefault = .HelpId <> csNO_ID
      End If
      
      .HelpFilter = "'doct_id = " & csEDT_AsientoContable & "'"
    End With
  
    With .Add(Nothing, csDocNumberID)
      .PropertyType = cspNumeric
      .SubType = cspInteger
      .Name = LNGGetText(1065, vbNullString)   'Número
      .Key = K_NUMERO
      .Value = m_Numero
      .Enabled = False
    End With
  
    With .Add(Nothing, cscAsFecha)
      .PropertyType = cspDate
      .Name = LNGGetText(1569, vbNullString)   'Fecha
      .LeftLabel = -1100
      .Left = 1300
      .Key = K_FECHA
      .Value = m_Fecha
    End With
    
    With .Add(Nothing, cscAsNrodoc)
      .PropertyType = cspText
      .Name = LNGGetText(1065, vbNullString)   'Número
      .Size = 50
      .Key = K_NRODOC
      .Value = m_Nrodoc
      .TextMask = m_TaMascara
      .TextAlign = vbRightJustify
    End With
    
    With .Add(Nothing, cscAsDescrip)
      .PropertyType = cspText
      .SubType = cspMemo
      .Name = LNGGetText(1211, vbNullString)   'Observ.
      .Size = 5000
      .Key = K_DESCRIP
      .Value = m_Descrip
      .LeftFromProperty = cscAsFecha
      .TopFromProperty = cscAsNrodoc
      .LeftLabel = -1100
      .Width = 7450
      .Height = 460
      .TopToPrevious = 420
    End With
  
    With .Add(Nothing, cscAsDocCliente)
      .PropertyType = cspText
      .LeftFromProperty = cscAsFecha
      .TopFromProperty = cscAsDescrip
      .LeftLabel = -1100
      .TopToPrevious = 580
      .Name = LNGGetText(1960, vbNullString)   'Generado Por
      .Key = K_ID_CLIENTE
      .Value = m_doc_cliente
      .Enabled = False
      .Width = 7450
    End With
  
  End With
  
  If Not m_ObjAbm.Show(Me) Then Exit Function
      
  m_Items.Tabs.Clear
  
  Set iTab = m_Items.Tabs.Add(Nothing)
  iTab.Index = 0
  iTab.Name = LNGGetText(1371, vbNullString)   'Items
  
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
  
  With m_Footer.Properties
    .Clear
  
    With .Add(Nothing, c_AsTotalDebe)
      .PropertyType = cspNumeric
      .SubType = cspMoney
      .Name = LNGGetText(1961, vbNullString)   'Total Debe
      .Key = K_TOTAL_DEBE
      .Value = m_TotalDebe
      .Format = m_GeneralConfig.FormatDecImporte
      .Enabled = False
    End With
    
    With .Add(Nothing, c_AsTotalHaber)
      .PropertyType = cspNumeric
      .SubType = cspMoney
      .Name = LNGGetText(1962, vbNullString)   'Total Haber
      .Key = K_TOTAL_HABER
      .Value = m_TotalHaber
      .Format = m_GeneralConfig.FormatDecImporte
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

Private Function pLoadItems(ByRef Propiedad As cIABMProperty) As Boolean
  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  
  sqlstmt = "sp_DocAsientoGetItems " & m_Id
  
  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, "pLoadItems", C_Module) Then Exit Function
  
  Dim iCol    As cIABMGridColumn
  Dim Origen  As Double
  
  m_TotalDebe = 0
  m_TotalHaber = 0
  
  With Propiedad.Grid
  
    .Columns.Clear
    .Rows.Clear
    
    With .Columns
  
      With .Add(Nothing)
        .Visible = False
        .Key = KI_ASI_ID
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(1267, vbNullString)   'Cuenta
        .PropertyType = cspHelp
        .Table = csCuenta
        .Width = 3000
        .Key = KI_CUE_ID
        .HelpFilter = GetHelpFilterCuenta()
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(1904, vbNullString)   'Debe
        .Format = m_GeneralConfig.FormatDecImporte
        .PropertyType = cspNumeric
        .SubType = cspMoney
        .Width = 1200
        .Key = KI_DEBE
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(1905, vbNullString)   'Haber
        .Format = m_GeneralConfig.FormatDecImporte
        .PropertyType = cspNumeric
        .SubType = cspMoney
        .Width = 1200
        .Key = KI_HABER
      End With
      
      Set iCol = .Add(Nothing, c_Origen)
      With iCol
        .Name = LNGGetText(1963, vbNullString)   'Moneda Origen
        .Format = m_GeneralConfig.FormatDecImporte
        .PropertyType = cspNumeric
        .SubType = cspMoney
        .Width = 1500
        .Visible = False
        .Key = KI_ORIGEN
      End With
      
      With .Add(Nothing)
        .Name = C_strDescrip
        .PropertyType = cspText
        .SubType = cspTextButtonEx
        .Width = 2300
        .Key = KI_DESCRIP
      End With
      
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
      
        With .Add(Nothing, rs(cscAsiId).Value)
        
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscAsiId)
            .Key = KI_ASI_ID
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscCueNombre)
            .ID = gDB.ValField(rs.fields, cscCueId)
            .Key = KI_CUE_ID
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscAsiDebe)
            .Key = KI_DEBE
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscAsiHaber)
            .Key = KI_HABER
          End With
          
          Origen = gDB.ValField(rs.fields, cscAsiOrigen)
          With .Add(Nothing)
            .Value = Origen
            .Key = KI_ORIGEN
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscAsiDescrip)
            .Key = KI_DESCRIP
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscCcosNombre)
            .ID = gDB.ValField(rs.fields, cscCcosId)
            .Key = KI_CCOS_ID
          End With
        End With
        
        m_TotalDebe = m_TotalDebe + gDB.ValField(rs.fields, cscAsiDebe)
        m_TotalHaber = m_TotalHaber + gDB.ValField(rs.fields, cscAsiHaber)
        
        If Origen <> 0 Then iCol.Visible = True
        
        rs.MoveNext
      Wend
    
    End With
  End With
  
  pLoadItems = True
End Function

Private Function Load(ByVal ID As Long) As Boolean

  Dim sqlstmt As String

  sqlstmt = "sp_DocAsientoGet " & EmpId & "," & ID & "," & gDB.UserId
  
  Dim rs As Recordset

  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, C_LoadFunction, C_Module) Then Exit Function

  If Not rs.EOF Then

    m_Id = gDB.ValField(rs.fields, cscAsId)
    m_Numero = gDB.ValField(rs.fields, cscAsNumero)
    m_Nrodoc = gDB.ValField(rs.fields, cscAsNrodoc)
    m_Descrip = gDB.ValField(rs.fields, cscAsDescrip)
    m_Fecha = gDB.ValField(rs.fields, cscAsFecha)
    m_doc_id = gDB.ValField(rs.fields, cscDocId)
    m_Documento = gDB.ValField(rs.fields, cscDocNombre)
    m_Doct_id = gDB.ValField(rs.fields, cscDoctId)
    m_Creado = gDB.ValField(rs.fields, cscCreado)
    m_Modificado = gDB.ValField(rs.fields, cscModificado)
    m_Modifico = gDB.ValField(rs.fields, cscModifico)

    ' Para ver documentos auxiliares
    '
    m_id_cliente = gDB.ValField(rs.fields, cscIdCliente)
    m_doct_id_cliente = gDB.ValField(rs.fields, cscDoctIdCliente)
    
    m_doc_cliente = gDB.ValField(rs.fields, "doc_cliente")
    
    m_TaPropuesto = gDB.ValField(rs.fields, cscTa_Propuesto)
    m_TaMascara = gDB.ValField(rs.fields, cscTa_Mascara)
    
    m_DocEditable = gDB.ValField(rs.fields, cscDocEditable)
    m_DocEditMsg = gDB.ValField(rs.fields, cscDoceditMsg)

    m_LastDoc = m_doc_id
    m_LastDocName = m_Documento

  Else
    m_Id = csNO_ID
    m_Numero = 0
    m_Nrodoc = vbNullString
    m_Descrip = vbNullString
    m_Fecha = VDGetDateById(csToday)
    m_doc_id = csNO_ID
    m_Documento = vbNullString
    m_Doct_id = csNO_ID
    m_Creado = csNoDate
    m_Modificado = csNoDate
    m_Modifico = 0

    m_doc_id = m_LastDoc
    m_Documento = m_LastDocName
  
    ' Para ver documentos auxiliares
    '
    m_id_cliente = csNO_ID
    m_doct_id_cliente = csNO_ID
    
    m_doc_cliente = vbNullString
    
    m_TaPropuesto = False
    m_TaMascara = vbNullString
    
    DocEditableGet m_doc_id, m_DocEditable, m_DocEditMsg, csPreConNewAsiento
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
  Dim str_1742    As String
  
  str_1742 = LNGGetText(1742, vbNullString)   'Con&tabilidad
  
  Set m_Host = Host
  m_Host.Server.AddMenu str_1742, csMenuEnum.csMenuContabilidad, vbNullString, 1, False, False, False, True, False, Nothing
  m_Host.Server.AddMenu LNGGetText(1964, vbNullString), csPreConListAsiento, str_1742, 0, True, False, False, False, False, Me
                        '&Asiento Contable
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
  m_Host.MenuListDocClick "CSABMInterface2.cABMGeneric", "CSContabilidad2.cAsiento", "CSABMInterface2.CABMGenericListDoc", "CSContabilidad2.cAsientoListDoc", Me, c_strTitle, 0
#Else
  m_Host.MenuListDocClick "CSABMInterface2.cABMGenericDocEx", "CSContabilidad2.cAsiento", "CSABMInterface2.CABMGenericListDoc", "CSContabilidad2.cAsientoListDoc", Me, c_strTitle, 0
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
            register.fieldId = cscAsiTMPId
            register.Table = csTAsientoItemTMP
            register.ID = csNew
            
            For Each Cell In Row
              Select Case Cell.Key
                
                Case KI_ASI_ID
                  If m_Copy Then
                    register.fields.Add2 cscAsiId, csNew, csInteger
                  Else
                    register.fields.Add2 cscAsiId, Val(Cell.Value), csInteger
                  End If
                Case KI_CUE_ID
                  register.fields.Add2 cscCueId, Cell.ID, csId
                Case KI_DESCRIP
                  register.fields.Add2 cscAsiDescrip, Cell.Value, csText
                Case KI_DEBE
                  register.fields.Add2 cscAsiDebe, Cell.Value, csCurrency
                Case KI_HABER
                  register.fields.Add2 cscAsiHaber, Cell.Value, csCurrency
                Case KI_CCOS_ID
                  register.fields.Add2 cscCcosId, Cell.ID, csId
                Case KI_ORIGEN
                  register.fields.Add2 cscAsiOrigen, Cell.Value, csCurrency
              End Select
            Next
            
            iOrden = iOrden + 1
            register.fields.Add2 cscAsiOrden, iOrden, csInteger
            register.fields.Add2 cscAsTMPId, ID, csId
            
            register.fields.HaveLastUpdate = False
            register.fields.HaveWhoModify = False
                                                                
            If Not gDB.Save(register, , "pSaveItems", C_Module, c_ErrorSave) Then Exit Function
          Next
      End Select
    End With
  Next
  
  Dim sqlstmt As String
  
  If LenB(m_ItemsDeleted) And m_Id <> csNO_ID And Not m_Copy Then
  
    Dim vDeletes As Variant
    Dim i As Long
    
    m_ItemsDeleted = RemoveLastColon(m_ItemsDeleted)
    vDeletes = Split(m_ItemsDeleted, ",")
    
    For i = 0 To UBound(vDeletes)
    
      Set register = New cRegister
      register.fieldId = cscAsibTMPId
      register.Table = csTAsientoItemBorradoTMP
      register.ID = csNew
      
      register.fields.Add2 cscAsiId, Val(vDeletes(i)), csInteger
      register.fields.Add2 cscAsId, m_Id, csId
      register.fields.Add2 cscAsTMPId, ID, csId
      
      register.fields.HaveLastUpdate = False
      register.fields.HaveWhoModify = False
                                                          'Error al grabar el Asiento contable
      If Not gDB.Save(register, , "pSaveItems", C_Module, LNGGetText(1965, vbNullString)) Then Exit Function
    Next
    
  End If
  
  pSaveItems = True
End Function

' Reglas del Objeto de Negocios
Private Sub pShowTotales(ByRef Rows As CSInterfacesABM.cIABMGridRows)
  Dim Debe      As Double
  Dim Haber     As Double
  
  Dim Row       As CSInterfacesABM.cIABMGridRow
  
  For Each Row In Rows
    Debe = Debe + Val(pGetCellFromKey(Row, KI_DEBE).Value)
    Haber = Haber + Val(pGetCellFromKey(Row, KI_HABER).Value)
  Next
  
  m_Footer.Properties(c_AsTotalDebe).Value = Debe
  m_Footer.Properties(c_AsTotalHaber).Value = Haber
  
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
    If Prop.Key <> K_DOC_ID And _
       Prop.Key <> K_NUMERO And _
       Prop.Key <> K_ID_CLIENTE Then
    
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

Private Function pMove(ByVal MoveTo As ABM_MSG) As Boolean
  Dim sqlstmt As String
  Dim rs      As Recordset
  Dim doc_id  As Long
  
  doc_id = m_ObjAbm.Properties(cscDocId).HelpId
  
  If doc_id = csNO_ID Then MsgInfo LNGGetText(1595, vbNullString) 'Debe seleccionar un documento
  
  sqlstmt = "sp_DocAsientoMover " & MoveTo & "," & m_Numero & "," & doc_id
  
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
        GetDocNumber m_LastDoc, m_ObjAbm, m_TaPropuesto, cscAsNrodoc
    
    End Select
    
  Else
    If Not Load(gDB.ValField(rs.fields, 0)) Then Exit Function
    
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
  
  Set c = m_ObjAbm.Properties.Item(cscDocId)
  c.HelpId = m_doc_id
  c.Value = m_Documento
  
  Set c = m_ObjAbm.Properties.Item(cscAsFecha)
  c.Value = m_Fecha
  
  Set c = m_ObjAbm.Properties.Item(csDocNumberID)
  c.Value = m_Numero
  
  Set c = m_ObjAbm.Properties.Item(cscAsNrodoc)
  c.Value = m_Nrodoc
  c.TextMask = m_TaMascara
  c.TextAlign = vbRightJustify
  
  Set c = m_ObjAbm.Properties.Item(cscAsDocCliente)
  c.Value = m_doc_cliente
  
  Set c = m_ObjAbm.Properties.Item(cscAsDescrip)
  c.Value = m_Descrip
  
  Set AbmGen = m_ObjAbm
  AbmGen.ShowValues m_ObjAbm.Properties
  
  AbmGen.ResetChanged
  
  Set c = m_Items.Properties.Item(c_Items)
  If Not pLoadItems(c) Then Exit Sub
  
#If PREPROC_SFS Then
  Dim AbmObj As cABMGeneric
#Else
  Dim AbmObj As cABMGenericDocEx
#End If

  Set AbmObj = m_ObjAbm
  AbmObj.RefreshColumnProperties c, c_Origen

  m_ItemsDeleted = vbNullString
  
  Set AbmGen = m_Items
  AbmGen.ShowValues m_Items.Properties
  
  Set c = m_Footer.Properties.Item(c_AsTotalDebe)
  c.Value = m_TotalDebe
  
  Set c = m_Footer.Properties.Item(c_AsTotalHaber)
  c.Value = m_TotalHaber
  
  Set AbmGen = m_Footer
  AbmGen.ShowValues m_Footer.Properties
  
  pSetEnabled
End Sub

Private Function pIsMonDefault(ByVal cue_id As Long) As Boolean
  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  
  sqlstmt = "select moneda.mon_id from cuenta, moneda" & _
            " where cuenta.mon_id = moneda.mon_id " & _
            " and cue_id = " & cue_id & _
            " and mon_legal <> 0"
  
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Function
  
  pIsMonDefault = Not rs.EOF
End Function

' Construccion - Destruccion
Private Sub Class_Initialize()
  On Error GoTo ControlError
  
  c_ErrorSave = LNGGetText(1965, vbNullString) 'Error al grabar el Asiento Contable
  c_strTitle = LNGGetText(1955, vbNullString) 'Asientos Contables
  
  Set m_GeneralConfig = New cGeneralConfig
  m_GeneralConfig.Load
  
  ' Preferencias del Usuario
  '
  Set m_UserCfg = New cUsuarioConfig
  m_UserCfg.Load
  m_UserCfg.ValidateAS
  
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

Private Function pGetItems() As cIABMProperty
  Set pGetItems = m_Items.Properties.Item(c_Items)
End Function

