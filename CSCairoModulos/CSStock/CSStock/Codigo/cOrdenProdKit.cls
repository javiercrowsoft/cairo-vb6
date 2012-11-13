VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cOrdenProdKit"
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
' cOrdenProdKit
' 09-12-2007

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cOrdenProdKit"

Private Const c_Items = "ITEMS"
Private Const c_col_prfk = "prfk"

Private Const c_prk_id_desarme = -100

Private Const c_series = 1
Private Const c_lotes = 2
Private Const c_alts = 3
Private Const c_vars = 4

Private Const K_NUMERO                         As Integer = 1
Private Const K_NRODOC                         As Integer = 2
Private Const K_DESCRIP                        As Integer = 3
Private Const K_FECHA                          As Integer = 4
Private Const K_DOC_ID                         As Integer = 11
Private Const K_ITEMS                          As Integer = 15
Private Const K_EST_ID                         As Integer = 17
Private Const K_SUC_ID                         As Integer = 19
Private Const K_DEPL_ID                        As Integer = 20

Private Const KI_OPK_ID                         As Integer = 2
Private Const KI_ORDEN                          As Integer = 3
Private Const KI_CANTIDAD                       As Integer = 4
Private Const KI_DESCRIP                        As Integer = 6
Private Const KI_PR_ID                          As Integer = 13
Private Const KI_ES_KIT                         As Integer = 15
Private Const KI_UNIDAD                         As Integer = 19
Private Const KI_PRFK_ID                        As Integer = 20

' pseudo-constantes
Private c_ErrorSave As String

' estructuras
' variables privadas
Private m_Id                           As Long
Private m_Numero                       As Long
Private m_Nrodoc                       As String
Private m_Descrip                      As String
Private m_Fecha                        As Date
Private m_suc_id                       As Long
Private m_Sucursal                     As String
Private m_doc_id                       As Long
Private m_Documento                    As String
Private m_Doct_id                      As Long
Private m_Creado                       As Date
Private m_Modificado                   As Date
Private m_Modifico                     As Long
Private m_depl_id                      As Long
Private m_Deposito                     As String

' Para ver documentos auxiliares
'
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

Private m_TaPropuesto                  As Boolean
Private m_TaMascara                    As String

Private m_NrosSerie         As Collection
Private m_CollKitInfo       As Collection

Private m_cur_doct_id       As Long

'-----------------------------------------------------
' Coleccino de Kits con produccion resumida
'
Private m_Kits              As cKitLines

' Preferencias del Usuario
'
Private m_UserCfg           As cUsuarioConfig

' propiedades publicas
' propiedades privadas
' funciones publicas

' Implementacion de cIABMClient
Private Function cIABMClient_Copy() As Boolean

  If Not DocSecurityCanAccessEx(csPreStNewOrdenProdKit, _
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
  GetDocNumber m_LastDoc, m_ObjAbm, m_TaPropuesto, cscOpkNrodoc
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
  GetDocNumber m_LastDoc, m_ObjAbm, m_TaPropuesto, cscOpkNrodoc
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

  Doc.ClientTable = csTParteProdKit
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
      
    Case MSG_GRID_ROW_DELETED
      cIABMClient_MessageEx = True
    
    Case MSG_DOC_EDIT_STATE
      ShowEditState m_DocEditMsg, LNGGetText(3722, vbNullString)  'Ordenes de Producción de Kit
      
    Case MSG_DOC_DELETE
      If cIEditGeneric_Delete(m_Id) Then
        cIABMClient_MessageEx = True
        pMove MSG_DOC_NEXT
      End If
      
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
      DocumentSearch csEDT_ParteProdKit, Me, Not CBool(Info)
  
    Case MSG_DOC_DOC_AUX
           
    Case MSG_MENU_AUX
       
    Case MSG_DOC_HISTORY
    
      If m_Id <> csNO_ID Then
    
        ShowHistory csParteProdKit, m_Id, m_Documento & " " & m_Nrodoc
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
      
        ' Si cambie de documento obtengo el doct_id
        '
        If m_doc_id <> m_LastDoc Then pGetCurrentDocId
        
        ' Si cambie de documento y estaba en un comprobante ya guardado
        ' tengo que mostrar el formulario sin datos, para evitar
        ' que presione guardar y le cambie el doc_id al comprobante por error
        '
        If m_Id <> csNO_ID And m_doc_id <> m_LastDoc Then cIEditGeneric_Edit csDocChanged
      
        ' Obtengo el numero para este comprobante
        '
        GetDocNumber m_LastDoc, m_ObjAbm, m_TaPropuesto, cscOpkNrodoc
        
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
  
  If Not DocCanSave(m_ObjAbm, cscOpkFecha) Then
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
  register.fieldId = cscOpkTMPId
  register.Table = csTParteProdKitTMP
  
  register.Id = csNew
    
  If m_Copy Then
    register.Fields.Add2 cscOpkId, csNew, csLong
  Else
    register.Fields.Add2 cscOpkId, m_Id, csLong
  End If
  
  Dim IProperty As cIABMProperty
  For Each IProperty In m_ObjAbm.Properties
    With IProperty
      Select Case .Key
        Case K_NUMERO
          register.Fields.Add2 cscOpkNumero, .Value, csLong
        Case K_NRODOC
          register.Fields.Add2 cscOpkNrodoc, .Value, csText
        Case K_DESCRIP
          register.Fields.Add2 cscOpkDescrip, .Value, csText
        Case K_FECHA
          register.Fields.Add2 cscOpkFecha, .Value, csDate
        Case K_SUC_ID
          register.Fields.Add2 cscSucId, .HelpId, csId
        Case K_DOC_ID
          register.Fields.Add2 cscDocId, .HelpId, csId
        Case K_DEPL_ID
          register.Fields.Add2 cscDeplId, .HelpId, csId
      End Select
    End With
  Next
  
  register.Fields.Add2 cscDoctId, m_cur_doct_id, csId
  
  register.Fields.HaveLastUpdate = True
  register.Fields.HaveWhoModify = True
  
  If Not register.BeginTrans(gDB) Then Exit Function
  
  If Not gDB.Save(register, , "cIABMClient_Save", C_Module, c_ErrorSave) Then Exit Function
  
  If Not pSaveItems(register.Id) Then Exit Function
  If Not register.CommitTrans() Then Exit Function
  
  Dim sqlstmt As String
  Dim rs      As Recordset
  
  sqlstmt = "sp_DocOrdenProdKitSave " & register.Id
  
  ' Los partes son complejos asi que le damos
  ' unos cuantos minutos si o si
  '
  Dim TimeOut As Long
  TimeOut = DocGetTimeOut(m_NrosSerie)
  If Not gDB.SaveSp(sqlstmt, rs, IIf(TimeOut < 1200, _
                                     1200, _
                                     TimeOut), _
                "cIABMClient_Save", C_Module, c_ErrorSave) Then Exit Function
  
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
  
  m_ObjTree.sqlstmt = "sp_lsdoc_ParteProdKit"
  
  If m_IsNew Then
    m_ObjTree.AddLine m_Id
  Else
    m_ObjTree.RefreshLine m_Id
  End If
ControlError:
End Function

Private Property Get cIABMClient_Title() As String
  cIABMClient_Title = LNGGetText(3725, vbNullString)    'Orden de Producción Kit
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
        Case K_DEPL_ID
          If ValEmpty(.HelpId, csId) Then
            MsgInfo LNGGetText(1559, vbNullString)    'Debe indicar un deposito
            Exit Function
          End If
        Case K_SUC_ID
          If ValEmpty(.HelpId, csId) Then
            MsgInfo LNGGetText(1560, vbNullString)    'Debe indicar una sucursal
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
  
  sqlstmt = "select doct_id, doc_id from ParteProdKit where rs_id = " & Id
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
  cIEditGeneric_ShowList = SecurityCanAccess(csPreStListOrdenProdKit)
End Function

Private Property Set cIEditGeneric_ObjAbm(rhs As CSInterfacesABM.cIABMGeneric)
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
                          csTOrdenProdKit, _
                          cscOpkId, _
                          doc_id) Then
      Exit Function
    End If
  End If
  
  If Not DocSecurityCanAccess( _
                  csPreStDeleteOrdenProdKit, _
                  doc_id, _
                  csEDocTPreDelete) Then
    Exit Function
  End If

  Dim sqlstmt As String
  
  sqlstmt = "sp_DocOrdenProdKitDelete " & Id & "," & EmpId & "," & User.Id
  
  cIEditGeneric_Delete = gDB.Execute(sqlstmt, "cIEditGeneric_Delete", C_Module)
End Function

Private Function cIEditGeneric_Search(Id As Long, Cancela As Boolean) As Boolean

End Function

Private Function cIEditGeneric_Edit(Id As Long, Optional ByVal InModalWindow As Boolean) As Boolean
  On Error GoTo ControlError
  
  If Not DocSecurityCanAccess(csPreStListOrdenProdKit, GetdocIdFromObjAbm(m_ObjAbm), csEDocTPreList) Then Exit Function
  
                            ' Id = csDocChanged esto significa que se cambio
                            '                   el documento estando en un
                            '                   comprobante ya guardado
                            '
  m_IsNew = Id = csNO_ID Or Id = csDocChanged

  If Not Load(Id) Then Exit Function
  
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
      cIABMClientGrid_ColumnAfterUpdate = True
  End Select

  GoTo ExitProc
ControlError:
  MngError Err, "cIABMClientGrid_ColumnAfterUpdate", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Private Function cIABMClientGrid_ColumnAfterEdit(ByVal Key As Integer, _
                                                 ByVal lRow As Long, _
                                                 ByVal lCol As Long, _
                                                 ByVal NewValue As Variant, _
                                                 ByVal NewValueID As Long) As Boolean
  On Error GoTo ControlError

  Select Case Key
    Case K_ITEMS
      cIABMClientGrid_ColumnAfterEdit = pColumnAfterEdit( _
                                          m_Items.Properties(c_Items), _
                                          lRow, lCol, _
                                          NewValue, NewValueID)
  End Select
  
  GoTo ExitProc
ControlError:
  MngError Err, "cIABMClientGrid_ColumnAfterEdit", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Private Function cIABMClientGrid_ColumnBeforeEdit(ByVal Key As Integer, _
                                                  ByVal lRow As Long, _
                                                  ByVal lCol As Long, _
                                                  ByVal iKeyAscii As Integer) As Boolean
  On Error GoTo ControlError

  Select Case Key
    Case K_ITEMS
      cIABMClientGrid_ColumnBeforeEdit = pColumnBeforeEdit( _
                                           m_Items.Properties(c_Items), _
                                           lRow, lCol, iKeyAscii)
  End Select
  
  GoTo ExitProc
ControlError:
  MngError Err, "cIABMClientGrid_ColumnBeforeEdit", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Private Function pColumnBeforeEdit(ByRef IProperty As cIABMProperty, _
                                   ByVal lRow As Long, _
                                   ByVal lCol As Long, _
                                   ByVal iKeyAscii As Integer) As Boolean
  Dim Row As cIABMGridRow
  
  Select Case IProperty.Grid.Columns(lCol).Key
    
    Case KI_PRFK_ID
      pColumnBeforeEdit = pBeforeEditPRFK(lRow, lCol)
      
    Case Else
      pColumnBeforeEdit = True
  End Select
End Function

Private Function pColumnAfterEdit(ByRef IProperty As cIABMProperty, _
                                  ByVal lRow As Long, _
                                  ByVal lCol As Long, _
                                  ByVal NewValue As Variant, _
                                  ByVal NewValueID As Long) As Boolean
  Dim Row     As cIABMGridRow
  
  With IProperty.Grid
    Select Case .Columns(lCol).Key
      Case KI_PR_ID
        Set Row = .Rows(lRow)
        pSetDataProducto Row, NewValueID
        
    End Select
  End With
  
  pColumnAfterEdit = True
End Function

Private Function cIABMClientGrid_ColumnButtonClick(ByVal Key As Integer, _
                                                   ByVal lRow As Long, _
                                                   ByVal lCol As Long, _
                                                   ByVal iKeyAscii As Integer) As Boolean
  
End Function

Private Sub cIABMClientGrid_ColumnCancelEdit(ByVal Key As Integer)

End Sub

Private Sub cIABMClientGrid_ColumnClick(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long)

End Sub

Private Sub cIABMClientGrid_DblClick(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long)

End Sub

Private Function cIABMClientGrid_DeleteRow(ByVal Key As Integer, Row As CSInterfacesABM.cIABMGridRow, ByVal lRow As Long) As Boolean
  Dim Id As Long
  
  Id = Val(pCell(Row, KI_OPK_ID).Value)
  
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
      Case KI_CANTIDAD
        If Not ValEmpty(Cell.Value, csCurrency) Then
          bRowIsEmpty = False
          Exit For
        End If
      Case KI_PR_ID
        If Not ValEmpty(Cell.Id, csId) Then
          bRowIsEmpty = False
          Exit For
        End If
    End Select
  Next
  
  pIsEmptyRow = bRowIsEmpty
End Function

Private Function pValidateRow(ByRef Row As CSInterfacesABM.cIABMGridRow, _
                              ByVal RowIndex As Long) As Boolean
  Dim Cell                  As cIABMGridCellValue
  Dim strRow                As String
  
  strRow = " (Fila " & RowIndex & ")"
  
  For Each Cell In Row
    Select Case Cell.Key
      Case KI_PR_ID
        If ValEmpty(Cell.Id, csId) Then
          MsgInfo LNGGetText(1996, vbNullString, strRow)   'Debe indicar un producto de stock (1)
          Exit Function
        End If
    End Select
  Next
  
  pValidateRow = True
End Function

' funciones privadas
Private Function LoadCollection() As Boolean
  Dim filter  As String
  Dim c       As cIABMProperty
  Dim AbmGen  As cABMGeneric
  
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
        .HelpId = m_UserCfg.DocPpkId
        .Value = m_UserCfg.DocOpkNombre
        
        bValidateDocDefault = .HelpId <> csNO_ID
      End If
      
      .HelpFilter = pGetDocFilter()
    End With
    
    With .Add(Nothing, csDocNumberID)
      .PropertyType = cspNumeric
      .SubType = cspInteger
      .Name = LNGGetText(1065, vbNullString)    'Número
      .Key = K_NUMERO
      .Value = m_Numero
      .Enabled = False
    End With
    
    With .Add(Nothing, cscOpkFecha)
      .PropertyType = cspDate
      .Name = LNGGetText(1569, vbNullString)    'Fecha
      .LeftLabel = -580
      .Left = 700
      .Key = K_FECHA
      .Value = m_Fecha
    End With
    
    With .Add(Nothing, cscOpkNrodoc)
      .PropertyType = cspText
      .Name = LNGGetText(1065, vbNullString)    'Número
      .Size = 50
      .Key = K_NRODOC
      .Value = m_Nrodoc
      .TextMask = m_TaMascara
      .TextAlign = vbRightJustify
    End With
    
    With .Add(Nothing, cscDeplId)
      .PropertyType = cspHelp
      .Table = csDepositoLogico
      .TopFromProperty = cscOpkFecha
      .Left = 4800
      .Name = LNGGetText(1574, vbNullString)    'Deposito
      .Key = K_DEPL_ID
      
      If m_depl_id <> csNO_ID Then
        .HelpId = m_depl_id
        .Value = m_Deposito
      Else
        ' Preferencias del usuario
        '
        .HelpId = m_UserCfg.DeplId
        .Value = m_UserCfg.DeplNombre
      End If
      
      AbmGen.NewKeyPropFocus = cscDeplId
    End With
    
    With .Add(Nothing, cscSucId)
      .PropertyType = cspHelp
      .Table = csSucursal
      .Name = LNGGetText(1281, vbNullString)    'Sucursal
      .Key = K_SUC_ID
      .HelpId = m_suc_id
      .Value = m_Sucursal
    End With
    
    With .Add(Nothing, cscOpkDescrip)
      .PropertyType = cspText
      .SubType = cspMemo
      .Name = LNGGetText(1211, vbNullString)    'Observ.
      .LeftLabel = -600
      .Size = 5000
      .Key = K_DESCRIP
      .Value = m_Descrip
      .LeftFromProperty = cscOpkFecha
      .TopFromProperty = cscOpkNrodoc
      .Width = 7450
      .Height = 800
      .TopToPrevious = 440
    End With
  End With
  
  If Not m_ObjAbm.Show(Me) Then Exit Function
      
  With m_Items.Tabs
  
    .Clear
  
    With .Add(Nothing)
      .Name = LNGGetText(1371, vbNullString)    'Items
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
  
  m_Footer.Properties.Clear
  
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
  Dim PrId    As Long
  Dim rs      As ADODB.Recordset
  
  sqlstmt = "sp_DocOrdenProdKitGetItems " & m_Id
  
  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, "pLoadItems", C_Module) Then Exit Function
  
  With Propiedad.Grid
  
    .Columns.Clear
    .Rows.Clear
  
    With .Columns
      With .Add(Nothing)
        .Visible = False
        .Key = KI_OPK_ID
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(1367, vbNullString)    'Articulo
        .PropertyType = cspHelp
        .Table = csProductoStock
        .HelpFilter = "pr_eskit <> 0"
        .Width = 2500
        .Key = KI_PR_ID
      End With
      
      With .Add(Nothing)
        .Name = C_strDescrip
        .PropertyType = cspText
        .SubType = cspTextButtonEx
        .Width = 2500
        .Key = KI_DESCRIP
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(1374, vbNullString)    'Cantidad
        .Format = m_GeneralConfig.FormatDecCantidad
        .PropertyType = cspNumeric
        .SubType = cspDouble
        .Width = 1200
        .Key = KI_CANTIDAD
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(1165, vbNullString)    'Unidad
        .PropertyType = cspText
        .Width = 1200
        .Key = KI_UNIDAD
        .Enabled = False
      End With
      
      With .Add(Nothing, c_col_prfk)
        .Name = LNGGetText(1354, vbNullString)    'Fórmula
        .PropertyType = cspHelp
        .Table = csProductoFormulaKit
        .HelpFilter = "1=2" ' Para que no pueda seleccionar
                            ' formulas hasta no haber seleccionado
                            ' un producto
        .Width = 3000
        .Key = KI_PRFK_ID
      End With
            
      With .Add(Nothing)
        .Visible = False
        .Key = KI_ES_KIT
      End With
      
    End With
  
    With .Rows
  
      While Not rs.EOF
      
        With .Add(Nothing, rs(cscOpkiId).Value)
        
          With .Add(Nothing)
            .Value = gDB.ValField(rs.Fields, cscOpkiId)
            .Key = KI_OPK_ID
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.Fields, cscPrNombrecompra)
            .Id = gDB.ValField(rs.Fields, cscPrId)
            .Key = KI_PR_ID
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.Fields, cscOpkiDescrip)
            .Key = KI_DESCRIP
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.Fields, cscOpkiCantidad)
            .Key = KI_CANTIDAD
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.Fields, cscUnNombre)
            .Key = KI_UNIDAD
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.Fields, cscPrfkNombre)
            .Id = gDB.ValField(rs.Fields, cscPrfkId)
            .Key = KI_PRFK_ID
          End With
          
          With .Add(Nothing)
            .Id = gDB.ValField(rs.Fields, cscPrEskit)
            .Key = KI_ES_KIT
          End With
          
        End With
        
        rs.MoveNext
      Wend
      
    End With
  
  End With
  
  pLoadItems = True
End Function

Private Function Load(ByVal Id As Long) As Boolean
  Dim sqlstmt As String

  sqlstmt = "sp_DocOrdenProdKitGet " & EmpId & "," & Id & "," & gDB.UserId
  
  Dim rs As Recordset

  m_Kits.Clear

  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, C_LoadFunction, C_Module) Then Exit Function

  If Not rs.EOF Then

    m_Id = gDB.ValField(rs.Fields, cscOpkId)
    m_Numero = gDB.ValField(rs.Fields, cscOpkNumero)
    m_Nrodoc = gDB.ValField(rs.Fields, cscOpkNrodoc)
    m_Descrip = gDB.ValField(rs.Fields, cscOpkDescrip)
    m_Fecha = gDB.ValField(rs.Fields, cscOpkFecha)
    m_suc_id = gDB.ValField(rs.Fields, cscSucId)
    m_Sucursal = gDB.ValField(rs.Fields, cscSucNombre)
    m_doc_id = gDB.ValField(rs.Fields, cscDocId)
    m_Documento = gDB.ValField(rs.Fields, cscDocNombre)
    m_Doct_id = gDB.ValField(rs.Fields, cscDoctId)
    m_Creado = gDB.ValField(rs.Fields, cscCreado)
    m_Modificado = gDB.ValField(rs.Fields, cscModificado)
    m_Modifico = gDB.ValField(rs.Fields, cscModifico)
    m_Deposito = gDB.ValField(rs.Fields, cscDeplNombre)
    m_depl_id = gDB.ValField(rs.Fields, cscDeplId)
    m_DocEditable = gDB.ValField(rs.Fields, cscDocEditable)
    m_DocEditMsg = gDB.ValField(rs.Fields, cscDoceditMsg)
    
    ' Para ver documentos auxiliares
    '
    m_TaPropuesto = gDB.ValField(rs.Fields, cscTa_Propuesto)
    m_TaMascara = gDB.ValField(rs.Fields, cscTa_Mascara)
    
    m_LastDoc = m_doc_id
    m_LastDocName = m_Documento
    
    m_cur_doct_id = m_Doct_id

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
    m_suc_id = User.suc_id
    m_Sucursal = User.Sucursal
    m_Deposito = vbNullString
    m_depl_id = csNO_ID
    m_doc_id = m_LastDoc
    m_Documento = m_LastDocName
  
    ' Para ver documentos auxiliares
    '
    
    m_TaPropuesto = False
    m_TaMascara = vbNullString
    
    pGetCurrentDocId
  
    DocEditableGet m_doc_id, m_DocEditable, m_DocEditMsg, csPreStNewOrdenProdKit
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
  Dim str_1998    As String
  
  str_1998 = LNGGetText(1998, vbNullString)   'S&tock
  
  Set m_Host = Host
  m_Host.Server.AddMenu str_1998, csMenuEnum.csMenuStock, vbNullString, 1, False, False, False, True, False, Nothing
  m_Host.Server.AddMenu LNGGetText(3723, vbNullString), csPreStListOrdenProdKit, str_1998, 0, True, False, False, False, False, Me
                          '&Orden de Producción de Kit
  cIMenuClient_Initialize = True
  
  GoTo ExitProc
ControlError:
  MngError Err, "cIMenuClient_Initialize", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Private Function cIMenuClient_ProcessMenu(ByVal Id As Long) As Variant
  m_Host.MenuListDocClick "CSABMInterface2.CABMGeneric", "CSStock2.cOrdenProdKit", "CSABMInterface2.CABMGenericListDoc", "CSStock2.cOrdenProdKitListDoc", Me, LNGGetText(2000, vbNullString), 0
                                                                                                                                                              'Parte de Producción de Kit
End Function

Private Function pSaveItems(ByVal opkTMP_Id As Long) As Boolean
  
  ' Generales
  '
  Dim register  As cRegister
  Dim iOrden    As Long
  Dim Row       As cIABMGridRow
  Dim Cell      As cIABMGridCellValue
  
  
  Dim lRow As Long
  
  For Each Row In m_Items.Properties(c_Items).Grid.Rows
  
    lRow = lRow + 1
  
    Set register = New cRegister
    With register
    
      .fieldId = cscOpkiTMPId
      .Table = csTParteProdKitItemTMP
      .Id = csNew
    
      With .Fields
    
        For Each Cell In Row
          Select Case Cell.Key
            
            Case KI_OPK_ID
              If m_Copy Then
                .Add2 cscOpkiId, csNew, csInteger
              Else
                .Add2 cscOpkiId, Val(Cell.Value), csInteger
              End If
            Case KI_CANTIDAD
              .Add2 cscOpkiCantidad, Cell.Value, csDouble
            Case KI_DESCRIP
              .Add2 cscOpkiDescrip, Cell.Value, csText
            Case KI_PR_ID
              .Add2 cscPrId, Cell.Id, csId
            Case KI_PRFK_ID
              .Add2 cscPrfkId, Cell.Id, csId
          End Select
        Next
        
        iOrden = iOrden + 1
        .Add2 cscOpkiOrden, iOrden, csInteger
        .Add2 cscOpkTMPId, opkTMP_Id, csId
        .Add2 cscDeplId, m_ObjAbm.Properties.Item(cscDeplId).HelpId, csId
        
        .HaveLastUpdate = False
        .HaveWhoModify = False
        
      End With
    
      If Not gDB.Save(register, , _
                      "pSaveItems", _
                      C_Module, _
                      c_ErrorSave) Then Exit Function
      
         
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
      register.fieldId = cscOpkibTMPId
      register.Table = csTParteProdKitItemBorradoTMP
      register.Id = csNew
      
      register.Fields.Add2 cscOpkiId, Val(vDeletes(i)), csInteger
      register.Fields.Add2 cscOpkId, m_Id, csId
      register.Fields.Add2 cscOpkTMPId, opkTMP_Id, csId
      
      register.Fields.HaveLastUpdate = False
      register.Fields.HaveWhoModify = False
                                                                
      If Not gDB.Save(register, , "pSaveItems", C_Module, c_ErrorSave) Then Exit Function
    Next
    
  End If
  
  pSaveItems = True
End Function

' Reglas del Objeto de Negocios
Private Sub pSetDataProducto(ByRef Row As CSInterfacesABM.cIABMGridRow, _
                             ByVal pr_id As Long)
  Dim sqlstmt As String
  Dim rs      As Recordset
  Dim bEsKit  As Boolean
  
  Dim bChanged As Boolean
  
  bChanged = pr_id <> pCell(Row, KI_PR_ID).Id
  
  sqlstmt = "sp_StockProductoGetData " & pr_id
  
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Sub
  
  If Not rs.EOF Then
    bEsKit = gDB.ValField(rs.Fields, cscPrEskit)
    
    pCell(Row, KI_UNIDAD).Value = gDB.ValField(rs.Fields, cscUnNombre)
    pCell(Row, KI_ES_KIT).Id = bEsKit
    
    If bChanged Then
      With pCell(Row, KI_PRFK_ID)
        .Id = gDB.ValField(rs.Fields, cscPrfkId)
        .Value = gDB.ValField(rs.Fields, cscPrfkNombre)
      End With
    End If
    
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
  
  Dim AbmGen  As cABMGeneric
  
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
  
  sqlstmt = "sp_DocOrdenProdKitMover " & MoveTo & "," & m_Numero & "," & doc_id
  
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
        GetDocNumber m_LastDoc, m_ObjAbm, m_TaPropuesto, cscOpkNrodoc
    
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
  Dim filter  As String
  
  With m_ObjAbm.Properties
    
    Set c = .Item(cscDocId)
    c.HelpId = m_doc_id
    c.Value = m_Documento
    
    Set c = .Item(cscOpkFecha)
    c.Value = m_Fecha
    
    Set c = .Item(csDocNumberID)
    c.Value = m_Numero
    
    Set c = .Item(cscOpkNrodoc)
    c.Value = m_Nrodoc
    c.TextMask = m_TaMascara
    c.TextAlign = vbRightJustify
    
    Set c = .Item(cscDeplId)
    If m_depl_id <> csNO_ID Then
      c.HelpId = m_depl_id
      c.Value = m_Deposito
    Else
      ' Preferencias del usuario
      '
      c.HelpId = m_UserCfg.DeplId
      c.Value = m_UserCfg.DeplNombre
    End If
    
    Set c = .Item(cscSucId)
    c.HelpId = m_suc_id
    c.Value = m_Sucursal
    
    Set c = .Item(cscOpkDescrip)
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
  
  Set AbmGen = m_Footer
  AbmGen.ShowValues m_Footer.Properties
  
  pSetEnabled
End Sub

Private Function pGetDocFilter() As String
  pGetDocFilter = "'doct_id = " & csEDT_ParteProdKit & " or " & _
                  "doct_id = " & csEDT_ParteDesarmeKit & "'"
End Function

' Construccion - Destruccion
Private Sub Class_Initialize()
  On Error GoTo ControlError
  
  c_ErrorSave = LNGGetText(3724, vbNullString) 'Error al grabar la Orden de Producción de Kit
  
  Set m_Kits = New cKitLines
  Set m_NrosSerie = New Collection
  Set m_GeneralConfig = New cGeneralConfig
  m_GeneralConfig.Load

  ' Preferencias del Usuario
  '
  Set m_UserCfg = New cUsuarioConfig
  m_UserCfg.Load
  m_UserCfg.ValidateOPK

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
  
  Set m_Kits = Nothing
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

Private Sub pGetCurrentDocId()
  Dim DocId As Long
  
  If m_ObjAbm.Properties.Item(cscDocId) Is Nothing Then Exit Sub
  
  DocId = m_ObjAbm.Properties.Item(cscDocId).HelpId
  
  gDB.GetData csTDocumento, cscDocId, DocId, cscDoctId, m_cur_doct_id
End Sub

'////////////////////////////////////////////////////////////////////////////////
' Kits Edición de la Nueva Versión
'

Private Function pBeforeEditPRFK(ByVal lRow As Long, _
                                 ByVal lCol As Long) As Boolean
  On Error GoTo ControlError
  
  Dim o       As cIABMGridColumn
  Dim iProp   As cIABMProperty
  Dim Row     As cIABMGridRow
  
  Set iProp = m_Items.Properties.Item(c_Items)
  Set o = iProp.Grid.Columns(lCol)
  
  If o.Key = KI_PRFK_ID Then
  
    Set Row = iProp.Grid.Rows(lRow)
    
    o.HelpFilter = pGetFilter(Row)
    
    Dim AbmObj As cABMGeneric
    Set AbmObj = m_Items
    AbmObj.RefreshColumnProperties iProp, c_col_prfk
  
  End If
  
  pBeforeEditPRFK = True
  
  GoTo ExitProc
ControlError:
  MngError Err, "pBeforeEditPRFK ", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Private Function pGetFilter(ByVal Row As cIABMGridRow) As String
  pGetFilter = cscPrId & " = " & pCell(Row, KI_PR_ID).Id
End Function

Private Function pGetDeplId() As Long
  pGetDeplId = m_ObjAbm.Properties(cscDeplId).HelpId
End Function

Private Function pGetItems() As cIABMProperty
  Set pGetItems = m_Items.Properties.Item(c_Items)
End Function

