VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cStockProveedor"
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
' cStockProveedor
' 13-01-2007

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cStockProveedor"

Private Const c_Items = "ITEMS"

Private Const K_NUMERO                         As Integer = 1
Private Const K_NRODOC                         As Integer = 2
Private Const K_DESCRIP                        As Integer = 3
Private Const K_FECHA                          As Integer = 4
Private Const K_DOC_ID                         As Integer = 5
Private Const K_PROV_ID                        As Integer = 10
Private Const K_ITEMS                          As Integer = 15
Private Const K_LGJ_ID                         As Integer = 18
Private Const K_SUC_ID                         As Integer = 19
Private Const K_DEPL_ID_ORIGEN                 As Integer = 20
Private Const K_DEPL_ID_DESTINO                As Integer = 21

Private Const KI_STI_ID                         As Integer = 2
Private Const KI_ORDEN                          As Integer = 3
Private Const KI_CANTIDAD                       As Integer = 4
Private Const KI_UNIDAD                         As Integer = 5
Private Const KI_DESCRIP                        As Integer = 6
Private Const KI_DEPL_ID                        As Integer = 7
Private Const KI_PR_ID                          As Integer = 13

Private Const KI_PR_LLEVANROSERIE               As Integer = 14
Private Const KI_ES_KIT                         As Integer = 15
Private Const KI_NROSERIE                       As Integer = 16
Private Const KI_GRUPO                          As Integer = 17

' Lote
'
Private Const KI_STL_ID                         As Integer = 26
Private Const KI_PR_LLEVALOTE                   As Integer = 27

Private Enum csEStiItemType
  csEItDestino = 1
  csEItOrigen = 2
End Enum

' pseudo-constantes
Private c_ErrorSave As String

' estructuras
' variables privadas
Private m_Id                           As Long
Private m_st_Id                        As Long
Private m_Numero                       As Long
Private m_Estado                       As String
Private m_est_id                       As Long
Private m_Nrodoc                       As String
Private m_Descrip                      As String
Private m_Fecha                        As Date
Private m_lgj_id                       As Long
Private m_Legajo                       As String

Private m_prov_id                      As Long
Private m_proveedor                    As String

Private m_depl_id_Origen               As Long
Private m_DepositoOrigen               As String

Private m_depl_id_Destino              As Long
Private m_DepositoDestino              As String

Private m_suc_id                       As Long
Private m_Sucursal                     As String
Private m_doc_id                       As Long
Private m_Documento                    As String
Private m_Doct_id                      As Long
Private m_Creado                       As Date
Private m_Modificado                   As Date
Private m_Modifico                     As Long

Private m_TaPropuesto                  As Boolean
Private m_TaMascara                    As String

' Para ver documentos auxiliares
'

Private m_Editing           As Boolean

Private m_Footer            As cIABMGeneric
Private m_Items             As cIABMGeneric
Private m_ObjAbm            As cIABMGeneric
Private m_ObjTree           As Object

Private m_LastDoc           As Long
Private m_LastDocName       As String
Private m_LastProv          As Long
Private m_LastProvName      As String

Private m_IsNew             As Boolean

Private m_BranchId          As Long
Private m_TreeId            As Long

Private m_Host              As CSMenu.cIMenuHost

Private m_Copy              As Boolean

Private m_GeneralConfig     As cGeneralConfig

Private m_DocEditable       As Boolean
Private m_DocEditMsg        As String

Private m_NrosSerie         As Collection
Private m_CollKitInfo       As Collection

' Lote
'
Private m_depf_id           As Long
Private m_StockConfig       As cStockConfig

' Preferencias del Usuario
'
Private m_UserCfg           As cUsuarioConfig

' propiedades publicas
' propiedades privadas
' funciones publicas

' Implementacion de cIABMClient
Private Function cIABMClient_Copy() As Boolean

  If Not DocSecurityCanAccessEx(csPreStNewStockProveedor, _
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
  GetDocNumber m_LastDoc, m_ObjAbm, m_TaPropuesto, cscStProvNrodoc
  pSetEnabled
End Function

Private Function cIABMClient_EditNew() As Boolean
  
  cIABMClient_Terminate
  m_IsNew = True

  cIEditGeneric_Edit csNO_ID
  m_LastProv = csNO_ID
  
  If Not m_DocEditable Then
    If LenB(m_DocEditMsg) Then
      MsgWarning m_DocEditMsg
    End If
  End If
  
  If m_ObjAbm.Properties.Item(cscDocId).HelpId = csNO_ID Then
    MsgInfo LNGGetText(1562, vbNullString)  'Debe indicar un documento
  End If
  
  ' Obtengo los datos por defecto del proveedor
  '
  pSetDatosProveedor

  ' Obtengo el numero para este comprobante
  '
  GetDocNumber m_LastDoc, m_ObjAbm, m_TaPropuesto, cscStProvNrodoc
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

  Doc.ClientTable = csTStockProveedor
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
  Dim Row As cIABMGridRow
  
  Select Case MessageID
    Case MSG_DOC_FIRST, MSG_DOC_PREVIOUS, MSG_DOC_NEXT, MSG_DOC_LAST
      
      ' Limpio incluso el ultimo cliente
      '
      m_LastProv = csNO_ID
      m_LastProvName = vbNullString
      
      cIABMClient_MessageEx = pMove(MessageID)
    Case MSG_DOC_SIGNATURE

    Case MSG_GRID_ROW_DELETED
      cIABMClient_MessageEx = True
    
    Case MSG_DOC_EDIT_STATE
      ShowEditState m_DocEditMsg, LNGGetText(2026, vbNullString) 'Transferencia de Stock a Proveedor
      
    Case MSG_DOC_DELETE
      If cIEditGeneric_Delete(m_Id) Then
        cIABMClient_MessageEx = True
        pMove MSG_DOC_NEXT
      End If
      
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
      DocumentSearch csEDT_StockProveedor, Me, Not CBool(Info)
  
    Case MSG_DOC_DOC_AUX
  
      If m_Id Then
      
        ShowDocAux m_st_Id, _
                   "CSStock2.cStock", _
                   "CSABMInterface2.cABMGeneric"
      Else
        MsgInfo LNGGetText(1620, vbNullString)
                'Debe editar un comprobante guardado para poder ver los documentos auxiliares
      End If
  
    Case MSG_DOC_HISTORY
    
      If m_Id <> csNO_ID Then
    
        ShowHistory csStockProveedor, m_Id, m_Documento & " " & m_Nrodoc
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
        GetDocNumber m_LastDoc, m_ObjAbm, m_TaPropuesto, cscStProvNrodoc
        
      End If
      
      ' Defino el estado de edicion del comprobante
      '
      pSetEnabled
  
    
    Case K_PROV_ID
      
      ' Obtengo los datos del proveedor
      '
      pSetDatosProveedor
    
    ' Lote
    '
    Case K_DEPL_ID_ORIGEN
    
      If m_StockConfig.StockXFisico Or m_StockConfig.NoControlaStock Then
        
        m_depf_id = csNO_ID
        
        If Not gDB.GetData(csTDepositoLogico, _
                           cscDeplId, _
                           pGetDeplId(), _
                           cscDepfId, _
                           m_depf_id) Then
        End If
      End If
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
  If Not DocCanSave(m_ObjAbm, cscStProvFecha) Then
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
  register.fieldId = cscStProvTMPId
  register.Table = csTStockProveedorTMP
  
  register.Id = csNew
    
  If m_Copy Then
    register.Fields.Add2 cscStProvId, csNew, csLong
  Else
    register.Fields.Add2 cscStProvId, m_Id, csLong
  End If
  
  Dim IProperty As cIABMProperty
  For Each IProperty In m_ObjAbm.Properties
    With IProperty
      Select Case .Key
        Case K_NUMERO
          register.Fields.Add2 cscStProvNumero, .Value, csLong
        Case K_NRODOC
          register.Fields.Add2 cscStProvNrodoc, .Value, csText
        Case K_DESCRIP
          register.Fields.Add2 cscStProvDescrip, .Value, csText
        Case K_FECHA
          register.Fields.Add2 cscStProvFecha, .Value, csDate
        Case K_PROV_ID
          register.Fields.Add2 cscProvId, .HelpId, csId
        Case K_LGJ_ID
          register.Fields.Add2 cscLgjId, .HelpId, csId
        Case K_SUC_ID
          register.Fields.Add2 cscSucId, .HelpId, csId
        Case K_DOC_ID
          register.Fields.Add2 cscDocId, .HelpId, csId
        Case K_DEPL_ID_ORIGEN
          register.Fields.Add2 cscDeplIdOrigen, .HelpId, csId
        Case K_DEPL_ID_DESTINO
          register.Fields.Add2 cscDeplIdDestino, .HelpId, csId
      End Select
    End With
  Next
  
  register.Fields.Add2 cscDoctId, csEDT_StockProveedor, csId
  
  register.Fields.HaveLastUpdate = True
  register.Fields.HaveWhoModify = True
  
  If Not gDB.Save(register, , "cIABMClient_Save", C_Module, c_ErrorSave) Then Exit Function
  
  Dim stProvTMP_id As Long
  
  stProvTMP_id = register.Id
  
'-----------------------------------------------------------------------------------------
  Set register = New cRegister
  register.fieldId = cscStTMPId
  register.Table = csTStockTMP
  
  register.Id = csNew
    
  If m_Copy Then
    register.Fields.Add2 cscStId, csNew, csLong
  Else
    register.Fields.Add2 cscStId, m_st_Id, csLong
  End If

  For Each IProperty In m_ObjAbm.Properties
    With IProperty
      Select Case .Key
        Case K_DESCRIP
          register.Fields.Add2 cscStDescrip, .Value, csText
        Case K_FECHA
          register.Fields.Add2 cscStFecha, .Value, csDate
        Case K_LGJ_ID
          register.Fields.Add2 cscLgjId, .HelpId, csId
        Case K_SUC_ID
          register.Fields.Add2 cscSucId, .HelpId, csId
        Case K_DOC_ID
          register.Fields.Add2 cscDocId, .HelpId, csId
        Case K_DEPL_ID_ORIGEN
          register.Fields.Add2 cscDeplIdOrigen, .HelpId, csId
        Case K_DEPL_ID_DESTINO
          register.Fields.Add2 cscDeplIdDestino, .HelpId, csId
      End Select
    End With
  Next
  
  register.Fields.Add2 cscStNumero, 0, csLong
  register.Fields.Add2 cscStNrodoc, vbNullString, csText
  register.Fields.Add2 cscDoctId, csEDT_TrasferenciaStock, csId
  
  register.Fields.HaveLastUpdate = True
  register.Fields.HaveWhoModify = True
'-----------------------------------------------------------------------------------------
  If Not register.BeginTrans(gDB) Then Exit Function
  
  If Not gDB.Save(register, , "cIABMClient_Save", C_Module, c_ErrorSave) Then Exit Function
  
  If Not pSaveItems(register.Id) Then Exit Function
  If Not register.CommitTrans() Then Exit Function
  
  Dim sqlstmt As String
  Dim rs      As Recordset
  sqlstmt = "sp_DocStockProveedorSave " & stProvTMP_id & "," & register.Id
  
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
  
  m_ObjTree.sqlstmt = "sp_lsdoc_StockProveedor"
  
  If m_IsNew Then
    m_ObjTree.AddLine m_Id
  Else
    m_ObjTree.RefreshLine m_Id
  End If
ControlError:
End Function

Private Property Get cIABMClient_Title() As String
  cIABMClient_Title = LNGGetText(2027, vbNullString) 'Transferencia a Proveedor
End Property

Private Function cIABMClient_Validate() As Boolean
  Dim dplIdOrigen  As Long
  Dim dplIdDestino As Long
  Dim deplOrigen   As String
  Dim deplDestino  As String
  Dim ProvId       As Long
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
            MsgInfo LNGGetText(1860, vbNullString) 'Debe indicar un proveedor
            Exit Function
          Else
            ProvId = .HelpId
          End If
        Case K_DOC_ID
          If ValEmpty(.HelpId, csId) Then
            MsgInfo LNGGetText(1562, vbNullString) 'Debe indicar un documento
            Exit Function
          End If
        Case K_DEPL_ID_ORIGEN
          If ValEmpty(.HelpId, csId) Then
            MsgInfo LNGGetText(2011, vbNullString) 'Debe indicar un origen
            Exit Function
          End If
          dplIdOrigen = .HelpId
          deplOrigen = .Value
        Case K_DEPL_ID_DESTINO
          If ValEmpty(.HelpId, csId) Then
            MsgInfo LNGGetText(2012, vbNullString) 'Debe indicar un destino
            Exit Function
          End If
          dplIdDestino = .HelpId
          deplDestino = .Value
        Case K_SUC_ID
          If ValEmpty(.HelpId, csId) Then
            MsgInfo LNGGetText(1560, vbNullString) 'Debe indicar una sucursal
            Exit Function
          End If
      End Select
    End With
  Next
  
  If dplIdDestino = dplIdOrigen Then
    MsgInfo LNGGetText(2013, vbNullString)
            'El deposito origen y el destino no pueden ser iguales
    Exit Function
  End If
  
  Dim ProvIdDepl As Long
  
  If Not gDB.GetData(csTDepositoLogico, _
                     cscDeplId, _
                     dplIdOrigen, _
                     cscProvId, _
                     ProvIdDepl) Then Exit Function
  
  If ProvId <> ProvIdDepl Then
    If ProvIdDepl <> csNO_ID Then
      MsgInfo LNGGetText(2028, vbNullString, deplOrigen)
              'El Depósito [" & deplOrigen & "] pertenece a otro Proveedor.
      Exit Function
    Else
      If Not gDB.GetData(csTDepositoLogico, _
                         cscDeplId, _
                         dplIdDestino, _
                         cscProvId, _
                         ProvIdDepl) Then Exit Function
      
      If ProvId <> ProvIdDepl Then
        If ProvIdDepl <> csNO_ID Then
          MsgInfo LNGGetText(2028, vbNullString, deplDestino)
                  'El Depósito [" & deplDestino & "] pertenece a otro Proveedor.
          Exit Function
        Else
          MsgInfo LNGGetText(2029, vbNullString)
                'Al menos uno de los dos Depósitos (Origen o Destino) debe pertenecer al Proveedor.
          Exit Function
        End If
      End If
    End If
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

Private Function cIDocumento_LoadForPrint(ByVal Id As Long) As Boolean
  On Error GoTo ControlError

  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  
  sqlstmt = "select doct_id, doc_id from StockProveedor where stprov_id = " & Id
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
  cIEditGeneric_ShowList = SecurityCanAccess(csPreStListStockProveedor)
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
                          csTStockProveedor, _
                          cscStProvId, _
                          doc_id) Then
      Exit Function
    End If
  End If
  
  If Not DocSecurityCanAccess( _
                  csPreStDeleteStockProveedor, _
                  doc_id, _
                  csEDocTPreDelete) Then
    Exit Function
  End If

  Dim sqlstmt As String
  
  sqlstmt = "sp_DocStockProveedorDelete " & Id & "," & EmpId & "," & User.Id
  
  cIEditGeneric_Delete = gDB.Execute(sqlstmt, "cIEditGeneric_Delete", C_Module)
End Function

Private Function cIEditGeneric_Search(Id As Long, Cancela As Boolean) As Boolean

End Function

Private Function cIEditGeneric_Edit(Id As Long, Optional ByVal InModalWindow As Boolean) As Boolean
  On Error GoTo ControlError
  
  If Not DocSecurityCanAccess(csPreStListStockProveedor, GetdocIdFromObjAbm(m_ObjAbm), csEDocTPreList) Then Exit Function
  
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
  Dim Row As cIABMGridRow
  
  Select Case IProperty.Grid.Columns(lCol).Key
    Case KI_NROSERIE
      Set Row = IProperty.Grid.Rows(lRow)
      If Not Row Is Nothing Then
        pColumnBeforeEdit = pCell(Row, KI_PR_LLEVANROSERIE).Id
      End If
    
    ' Lote
    '
    Case KI_STL_ID
      Set Row = IProperty.Grid.Rows(lRow)
      
      If Not Row Is Nothing Then
      
        If pCell(Row, KI_PR_LLEVALOTE).Id And _
           pCell(Row, KI_PR_LLEVANROSERIE).Id = 0 Then
           
          Dim pr_id_kit As Long
          If pCell(Row, KI_ES_KIT).Id Then
            pr_id_kit = pCell(Row, KI_PR_ID).Id
          End If
           
          With IProperty.Grid.Columns.Item(cscStlId)
            .HelpFilter = "'pr_id = " & _
                                  pCell(Row, KI_PR_ID).Id & _
                          " and " & GetStockLoteFilter( _
                                              pGetDeplId(), _
                                              m_StockConfig.StockXFisico, _
                                              pr_id_kit, _
                                              m_depf_id) & "'"
          End With
          
          Dim AbmObj As cABMGeneric
          Set AbmObj = m_ObjAbm
          
          AbmObj.RefreshColumnProperties IProperty, cscStlId
          
          pColumnBeforeEdit = True
        End If
      End If
    
    Case Else
      pColumnBeforeEdit = True
  End Select
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
  Dim Row As cIABMGridRow
  
  Select Case Key
    Case K_ITEMS
      With m_Items.Properties.Item(c_Items).Grid
        Select Case .Columns(lCol).Key
          Case KI_NROSERIE
            Set Row = .Rows(lRow)
            If pCell(Row, KI_PR_LLEVANROSERIE).Id Then
            
              Dim PrId As Long
              
              PrId = pCell(Row, KI_PR_ID).Id
            
              cIABMClientGrid_ColumnButtonClick = EditNroSerie(pCell(Row, KI_GRUPO).Id, _
                                                               Val(pCell(Row, KI_CANTIDAD).Value), _
                                                               Row, _
                                                               m_NrosSerie, _
                                                               KI_GRUPO, _
                                                               KI_NROSERIE, _
                                                               lRow, _
                                                               PrId, _
                                                               m_ObjAbm.Properties(cscDeplIdOrigen).HelpId, _
                                                               False, pCell(Row, KI_ES_KIT).Id, _
                                                               GetKitInfo(PrId, m_CollKitInfo), _
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

Private Function pValidateRow(ByRef Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  Dim Cell                  As cIABMGridCellValue
  Dim strRow                As String
  Dim bLlevaNroSerie        As Boolean
  
  strRow = " (Fila " & RowIndex & ")"
  
  For Each Cell In Row
    Select Case Cell.Key
      Case KI_CANTIDAD
        If ValEmpty(Cell.Value, csCurrency) Then
          MsgInfo LNGGetText(1365, vbNullString, strRow)   'Debe indicar una cantidad (1)
          Exit Function
        End If
      Case KI_PR_ID
        If ValEmpty(Cell.Id, csId) Then
          MsgInfo LNGGetText(1996, vbNullString, strRow)   'Debe indicar un producto de stock (1)
          Exit Function
        End If
      Case KI_NROSERIE
        bLlevaNroSerie = pCell(Row, KI_PR_LLEVANROSERIE).Id
        If ValEmpty(Cell.Value, csText) And bLlevaNroSerie Then
          MsgInfo LNGGetText(1630, vbNullString, strRow)   'Debe indicar un numero de serie (1)
          Exit Function
        End If
    
      ' Lote
      '
      Case KI_STL_ID
        If ValEmpty(Cell.Id, csId) And _
           pCell(Row, KI_PR_LLEVALOTE).Id And _
           pCell(Row, KI_PR_LLEVANROSERIE).Id = 0 Then
          MsgInfo LNGGetText(1632, vbNullString, strRow)   'Debe indicar un lote (1)
          Exit Function
        End If
    
    End Select
  Next
  
  pValidateRow = True
End Function

' funciones privadas
Private Function LoadCollection() As Boolean
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
      .Name = LNGGetText(1567, vbNullString)   'Documento
      .Key = K_DOC_ID
      
      If m_doc_id <> csNO_ID Then
        .HelpId = m_doc_id
        .Value = m_Documento
      Else
        ' Preferencias del usuario
        '
        .HelpId = m_UserCfg.DocStId
        .Value = m_UserCfg.DocStNombre
        
        bValidateDocDefault = .HelpId <> csNO_ID
      End If
      
      .HelpFilter = "'doct_id = " & csEDT_StockProveedor & "'"
    End With
    
    With .Add(Nothing, csDocNumberID)
      .PropertyType = cspNumeric
      .SubType = cspInteger
      .Name = LNGGetText(1065, vbNullString)   'Número
      .Key = K_NUMERO
      .Value = m_Numero
      .Enabled = False
    End With
    
    With .Add(Nothing, cscStProvFecha)
      .PropertyType = cspDate
      .Name = LNGGetText(1569, vbNullString)   'Fecha
      .LeftLabel = -580
      .Left = 1000
      .Key = K_FECHA
      .Value = m_Fecha
    End With
    
    With .Add(Nothing, cscProvId)
      .PropertyType = cspHelp
      .Table = csProveedor
      .TopFromProperty = cscStProvFecha
      .Left = 3700
      .LeftLabel = -800
      .Name = LNGGetText(1151, vbNullString)   'Proveedor
      .Key = K_PROV_ID
      .HelpId = m_prov_id
      .Value = m_proveedor
      AbmGen.NewKeyPropFocus = cscProvId
    End With
    
    With .Add(Nothing, cscStProvNrodoc)
      .PropertyType = cspText
      .Name = LNGGetText(1065, vbNullString)   'Número
      .Size = 50
      .Key = K_NRODOC
      .Value = m_Nrodoc
      .TextMask = m_TaMascara
      .TextAlign = vbRightJustify
    End With
    
    Dim filter As String
    filter = pGetDeplFilter()
    
    With .Add(Nothing, cscDeplIdOrigen)
      .PropertyType = cspHelp
      .Table = csDepositoLogico
      .TopFromProperty = cscStProvFecha
      .Left = 7300
      .Name = LNGGetText(2014, vbNullString)   'Deposito Origen
      .Key = K_DEPL_ID_ORIGEN
      .HelpId = m_depl_id_Origen
      .Value = m_DepositoOrigen
      .HelpFilter = filter
    End With
    
    With .Add(Nothing, cscDeplIdDestino)
      .PropertyType = cspHelp
      .Table = csDepositoLogico
      .Name = LNGGetText(2015, vbNullString)   'Deposito Destino
      .Key = K_DEPL_ID_DESTINO
      .HelpId = m_depl_id_Destino
      .Value = m_DepositoDestino
      .HelpFilter = filter
    End With
    
    With .Add(Nothing, cscSucId)
      .PropertyType = cspHelp
      .Table = csSucursal
      .Name = LNGGetText(1281, vbNullString)   'Sucursal
      .Key = K_SUC_ID
      .HelpId = m_suc_id
      .Value = m_Sucursal
    End With
    
    With .Add(Nothing, cscLgjId)
      .PropertyType = cspHelp
      .Table = csLegajo
      .Name = LNGGetText(1575, vbNullString)   'Legajo
      .Key = K_LGJ_ID
      .HelpId = m_lgj_id
      .Value = m_Legajo
    End With
    
    With .Add(Nothing, cscStProvDescrip)
      .PropertyType = cspText
      .SubType = cspMemo
      .Name = LNGGetText(1211, vbNullString)   'Observ.
      .LeftLabel = -600
      .Size = 5000
      .Key = K_DESCRIP
      .Value = m_Descrip
      .LeftFromProperty = cscStProvFecha
      .TopFromProperty = cscStProvNrodoc
      .Width = 4950
      .Height = 460
      .TopToPrevious = 440
    End With
  
  End With
  
  If Not m_ObjAbm.Show(Me) Then Exit Function
      
  With m_Items.Tabs
  
    .Clear
  
    With .Add(Nothing)
      .Name = LNGGetText(1371, vbNullString)   'Items
    End With
    
  End With
  
  Set AbmGen = m_Items
  AbmGen.ResetLayoutMembers
  
  With m_Items.Properties
  
    .Clear
  
    Set c = m_Items.Properties.Add(Nothing, c_Items)
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
  Dim coll    As Collection
  Dim rs      As ADODB.Recordset
  Dim PrId    As Long
  
  sqlstmt = "sp_DocStockGetItems " & m_st_Id
  
  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, "pLoadItems", C_Module) Then Exit Function
  
  With Propiedad.Grid
    
    With .Columns
      
      .Clear
      
      With .Add(Nothing)
        .Visible = False
        .Key = KI_STI_ID
      End With
      
      With .Add(Nothing)
        .Visible = False
        .Key = KI_DEPL_ID
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(1567, vbNullString)   'Articulo"
        .PropertyType = cspHelp
        .Table = csProductoStock
        .Width = 2500
        .Key = KI_PR_ID
      End With
      
      With .Add(Nothing)
        .Name = C_strDescrip
        .PropertyType = cspText
        .SubType = cspTextButtonEx
        .Width = 3000
        .Key = KI_DESCRIP
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(1374, vbNullString)   'Cantidad
        .Format = m_GeneralConfig.FormatDecCantidad
        .PropertyType = cspNumeric
        .SubType = cspDouble
        .Width = 1200
        .Key = KI_CANTIDAD
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(1165, vbNullString)   'Unidad
        .PropertyType = cspText
        .Width = 1200
        .Key = KI_UNIDAD
        .Enabled = False
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(1639, vbNullString)   'Nro. Serie
        .PropertyType = cspText
        .SubType = cspTextButton
        .Width = 3000
        .Key = KI_NROSERIE
      End With
      
      ' Lote
      '
      With .Add(Nothing, cscStlId)
        .Name = LNGGetText(1640, vbNullString)   'Lote
        .PropertyType = cspHelp
        .Table = csStockLote
        .Width = 2000
        .Key = KI_STL_ID
      End With
    
      ' Lote
      '
      With .Add(Nothing)
        .Visible = False
        .Key = KI_PR_LLEVALOTE
      End With
      
      With .Add(Nothing)
        .Visible = False
        .Key = KI_PR_LLEVANROSERIE
      End With
      
      With .Add(Nothing)
        .Visible = False
        .Key = KI_ES_KIT
      End With
      
      With .Add(Nothing)
        .Visible = False
        .Key = KI_GRUPO
      End With
      
    End With
    
    With .Rows
      
      .Clear
  
      While Not rs.EOF
      
        With .Add(Nothing, rs(cscStiId).Value)
        
          With .Add(Nothing)
            .Value = gDB.ValField(rs.Fields, cscStiId)
            .Key = KI_STI_ID
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.Fields, cscDeplId)
            .Key = KI_DEPL_ID
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.Fields, cscPrNombrecompra)
            .Id = gDB.ValField(rs.Fields, cscPrId)
            .Key = KI_PR_ID
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.Fields, cscStiDescrip)
            .Key = KI_DESCRIP
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.Fields, cscStiSalida)
            .Key = KI_CANTIDAD
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.Fields, cscUnNombre)
            .Key = KI_UNIDAD
          End With
          
          With .Add(Nothing)
            .Value = vbNullString
            .Key = KI_NROSERIE
          End With
          
          ' Lote
          '
          With .Add(Nothing)
            .Value = gDB.ValField(rs.Fields, cscStlCodigo)
            .Id = gDB.ValField(rs.Fields, cscStlId)
            .Key = KI_STL_ID
          End With
    
          ' Lote
          '
          With .Add(Nothing)
            .Id = gDB.ValField(rs.Fields, cscPrLlevaNroLote)
            .Key = KI_PR_LLEVALOTE
          End With
          
          With .Add(Nothing)
            .Id = gDB.ValField(rs.Fields, cscPrLlevaNroSerie)
            .Key = KI_PR_LLEVANROSERIE
          End With
          
          With .Add(Nothing)
            .Id = gDB.ValField(rs.Fields, cscPrEskit)
            .Key = KI_ES_KIT
          End With
          
          With .Add(Nothing)
            .Id = gDB.ValField(rs.Fields, cscStiGrupo)
            .Key = KI_GRUPO
          End With
          
        End With
        
        rs.MoveNext
      Wend
    End With
  End With
  
  '//////////////////////////////////////////////////
  ' Numeros de Serie
  '//////////////////////////////////////////////////
  
  Dim NroSerie  As cProductoSerieType
  Dim CurGroup  As Long
  Dim NrosSerie As String
    
  CollClear m_NrosSerie
  
  Set rs = rs.NextRecordset
  
  While Not rs.EOF
    
    ' Si cambie de grupo
    If CurGroup <> gDB.ValField(rs.Fields, cscStiGrupo) Then
    
      pSetNrosSerieInRow CurGroup, NrosSerie
      NrosSerie = vbNullString
    
      CurGroup = gDB.ValField(rs.Fields, cscStiGrupo)
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
      .pr_id_item = gDB.ValField(rs.Fields, cscPrId)
      .KitItem = gDB.ValField(rs.Fields, cscPrNombrecompra)
      
      NrosSerie = NrosSerie & .Codigo & ","
    End With
    
    ' Lo agrego a la bolsa
    coll.Add NroSerie, GetKey(NroSerie.prns_id)
    
    rs.MoveNext
  Wend
  
  pSetNrosSerieInRow CurGroup, NrosSerie
  NrosSerie = vbNullString
  
  '//////////////////////////////////////////////////
  ' Kit
  '//////////////////////////////////////////////////
  CollClear m_CollKitInfo
  
  Set rs = rs.NextRecordset
  
  While Not rs.EOF
    
    PrId = gDB.ValField(rs.Fields, cscPrId)
    Set coll = GetCollKitInfoXPrId(PrId, m_CollKitInfo)
    
    PrId = gDB.ValField(rs.Fields, cscPrIdItem)
    
    With GetKitInfoItem(coll, PrId)
      .pr_id = PrId
      .Nombre = gDB.ValField(rs.Fields, cscPrNombrecompra)
      .Cantidad = gDB.ValField(rs.Fields, "cantidad")
      .LlevaNroSerie = gDB.ValField(rs.Fields, cscPrLlevaNroSerie)
    End With
    rs.MoveNext
  Wend
  
  pLoadItems = True
End Function

Private Function Load(ByVal Id As Long) As Boolean

  Dim sqlstmt As String

  sqlstmt = "sp_DocStockProveedorGet " & EmpId & "," & Id & "," & gDB.UserId
  
  Dim rs As Recordset

  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, C_LoadFunction, C_Module) Then Exit Function

  If Not rs.EOF Then

    m_Id = gDB.ValField(rs.Fields, cscStProvId)
    m_st_Id = gDB.ValField(rs.Fields, cscStId)
    m_Numero = gDB.ValField(rs.Fields, cscStProvNumero)
    m_Nrodoc = gDB.ValField(rs.Fields, cscStProvNrodoc)
    m_Descrip = gDB.ValField(rs.Fields, cscStProvDescrip)
    m_Fecha = gDB.ValField(rs.Fields, cscStProvFecha)
    m_lgj_id = gDB.ValField(rs.Fields, cscLgjId)
    m_Legajo = gDB.ValField(rs.Fields, cscLgjCodigo)
    
    m_prov_id = gDB.ValField(rs.Fields, cscProvId)
    m_proveedor = gDB.ValField(rs.Fields, cscProvNombre)
    
    m_depl_id_Origen = gDB.ValField(rs.Fields, cscDeplIdOrigen)
    m_DepositoOrigen = gDB.ValField(rs.Fields, "Origen")
    m_depl_id_Destino = gDB.ValField(rs.Fields, cscDeplIdDestino)
    m_DepositoDestino = gDB.ValField(rs.Fields, "Destino")
    
    ' Lote
    '
    m_depf_id = gDB.ValField(rs.Fields, cscDepfId)
    
    m_suc_id = gDB.ValField(rs.Fields, cscSucId)
    m_Sucursal = gDB.ValField(rs.Fields, cscSucNombre)
    m_doc_id = gDB.ValField(rs.Fields, cscDocId)
    m_Documento = gDB.ValField(rs.Fields, cscDocNombre)
    m_Doct_id = gDB.ValField(rs.Fields, cscDoctId)
    m_Creado = gDB.ValField(rs.Fields, cscCreado)
    m_Modificado = gDB.ValField(rs.Fields, cscModificado)
    m_Modifico = gDB.ValField(rs.Fields, cscModifico)

    m_DocEditable = gDB.ValField(rs.Fields, cscDocEditable)
    m_DocEditMsg = gDB.ValField(rs.Fields, cscDoceditMsg)
    
    ' Para ver documentos auxiliares
    '
    
    m_TaPropuesto = gDB.ValField(rs.Fields, cscTa_Propuesto)
    m_TaMascara = gDB.ValField(rs.Fields, cscTa_Mascara)

    m_LastProv = m_prov_id
    m_LastDoc = m_doc_id
    m_LastDocName = m_Documento
    m_LastProvName = m_proveedor
    
  Else
    m_Id = csNO_ID
    m_st_Id = csNO_ID
    m_Numero = 0
    m_Nrodoc = vbNullString
    m_Descrip = vbNullString
    m_Fecha = VDGetDateById(csToday)
    m_lgj_id = csNO_ID
    m_Legajo = vbNullString
    
    m_prov_id = csNO_ID
    m_proveedor = vbNullString
    
    m_depl_id_Origen = csNO_ID
    m_DepositoOrigen = vbNullString
    m_depl_id_Destino = csNO_ID
    m_DepositoDestino = vbNullString
    
    ' Lote
    '
    m_depf_id = csNO_ID
    
    m_doc_id = csNO_ID
    m_Documento = vbNullString
    m_Doct_id = csNO_ID
    m_Creado = csNoDate
    m_Modificado = csNoDate
    m_Modifico = 0
    m_suc_id = User.suc_id
    m_Sucursal = User.Sucursal
  
    ' Para ver documentos auxiliares
    '
    
    m_TaPropuesto = False
    m_TaMascara = vbNullString
  
    m_prov_id = m_LastProv
    m_proveedor = m_LastProvName
    m_doc_id = m_LastDoc
    m_Documento = m_LastDocName
  
    DocEditableGet m_doc_id, m_DocEditable, m_DocEditMsg, csPreStNewStockProveedor
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
  Dim str_1998 As String
  
  str_1998 = LNGGetText(1998, vbNullString) 'S&tock
  
  Set m_Host = Host
  m_Host.Server.AddMenu str_1998, csMenuEnum.csMenuStock, vbNullString, 1, False, False, False, True, False, Nothing
  m_Host.Server.AddMenu LNGGetText(2030, vbNullString), csPreStListStockProveedor, str_1998, 0, True, False, True, False, False, Me
                        '&Transferencias de Stock a Proveedor
  
  cIMenuClient_Initialize = True
  
  GoTo ExitProc
ControlError:
  MngError Err, "cIMenuClient_Initialize", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Private Function cIMenuClient_ProcessMenu(ByVal Id As Long) As Variant
  m_Host.MenuListDocClick "CSABMInterface2.cABMGeneric", "CSStock2.cStockProveedor", "CSABMInterface2.CABMGenericListDoc", "CSStock2.cStockProveedorListDoc", Me, LNGGetText(2026, vbNullString), 0
                                                                                                                                                                  'Transferencia de Stock a Proveedor
End Function

Private Function pSaveItems(ByVal Id As Long) As Boolean
  Dim Row         As cIABMGridRow
  Dim KitS        As cKitInfo
  Dim i           As Long
  Dim PrIdKit     As Long
  Dim nGrupoSerie As Long
  Dim iOrden      As Long ' Utilizado para iterar por los items
                          ' Importante: Todos los items deben tener
                          ' un iOrden distinto y consecutivo
                          
  Dim iKitOrden   As Long ' Utilizado para identificar los kits
                          ' Por cada iKitOrden se genera un StockItemKit
  
  For Each Row In m_Items.Properties(c_Items).Grid.Rows
  
    ' Si es un Kit tengo que agregar un stockitem por cada
    ' componente que tenga el kit. y la cantidad es igual
    ' a la cantidad de kits multiplicada por la cantidad
    ' indicada en el componente
    '
    If pCell(Row, KI_ES_KIT).Id Then
      
      PrIdKit = pCell(Row, KI_PR_ID).Id
      iKitOrden = iKitOrden + 1
      
      For Each KitS In GetCollKitInfoXPrId(PrIdKit, m_CollKitInfo)
        
        ' Cambio el pr_id para que grabe el componente
        '
        pCell(Row, KI_PR_ID).Id = KitS.pr_id
        
                                      ' Tengo que mover los numeros de serie que corresponda
                                      '
        If Not pSaveItemAux(Id, iOrden, Row, PrIdKit, KitS.Cantidad * Val(pCell(Row, KI_CANTIDAD).Value), KitS.LlevaNroSerie, iKitOrden) Then Exit Function
      Next
      
      pCell(Row, KI_PR_ID).Id = PrIdKit
    
    Else
    
      ' Item comun
      If Not pSaveItemAux(Id, iOrden, Row, csNO_ID, 0, pCell(Row, KI_PR_LLEVANROSERIE).Id, 0) Then Exit Function
    End If
  
  Next
  
  pSaveItems = True
End Function

Private Function pSaveItemAux(ByVal Id As Long, ByRef iOrden As Long, _
                              ByRef Row As cIABMGridRow, _
                              ByVal PrIdKit As Long, _
                              ByVal CantidadKit As Long, _
                              ByVal bLlevaNroSerie As Boolean, _
                              ByVal iKitOrden As Long) As Boolean
  Dim i           As Long
  Dim register    As cRegister
  Dim oRow        As cABMGridRow
  Dim Cell        As cIABMGridCellValue
  Dim Cantidad    As Double

  ' Para las filas nuevas tengo que convertirla en dos
  ' una salida y otra destino
  For i = 1 To 2
  
    Set oRow = Row
  
    Set register = New cRegister
    register.fieldId = cscStiTMPId
    register.Table = csTStockItemTMP
    register.Id = csNew
    
    For Each Cell In Row
      Select Case Cell.Key
        
        Case KI_STI_ID
          If m_Copy Then
            register.Fields.Add2 cscStiId, csNew, csInteger
          Else
            register.Fields.Add2 cscStiId, Val(Cell.Value), csInteger
          End If
        Case KI_DESCRIP
          register.Fields.Add2 cscStiDescrip, Cell.Value, csText
        Case KI_PR_ID
          register.Fields.Add2 cscPrId, Cell.Id, csId
      
        ' Lote
        '
        Case KI_STL_ID
          register.Fields.Add2 cscStlId, Cell.Id, csId
      
      End Select
    Next

    ' Kits
    If PrIdKit <> csNO_ID Then
      register.Fields.Add2 cscPrIdKit, PrIdKit, csId
      register.Fields.Add2 cscStikOrden, iKitOrden, csInteger
      register.Fields.Add2 cscStikCantidad, Val(pCell(Row, KI_CANTIDAD).Value), csDouble
    End If

    register.Fields.Add2 cscStTMPId, Id, csId
    
    ' Si es el primero de esta dupla va Origen
    '
    If i = 1 Then
      
      ' Si es un kit tengo que enviar tantos numeros de serie
      ' como indica CantidadKit
      '
      If PrIdKit <> csNO_ID Then
        Cantidad = CantidadKit
      Else
        Cantidad = Val(pCell(Row, KI_CANTIDAD).Value)
      End If
      
      register.Fields.Add2 cscDeplId, m_ObjAbm.Properties.Item(cscDeplIdOrigen).HelpId, csId
      
      ' Salida
      '
      If Not pSaveItemNroSerie(Cantidad, Row, register, iOrden, csEItOrigen, bLlevaNroSerie) Then Exit Function
    
    ' Solo me queda que sea el segundo, osea el destino
    '
    Else
      register.Fields.Add2 cscDeplId, m_ObjAbm.Properties.Item(cscDeplIdDestino).HelpId, csId
      
      ' Ingreso
      '
      If Not pSaveItemNroSerie(Cantidad, Row, register, iOrden, csEItDestino, bLlevaNroSerie) Then Exit Function
    End If
  Next

  pSaveItemAux = True
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
    pCell(Row, KI_PR_LLEVANROSERIE).Id = gDB.ValField(rs.Fields, cscPrLlevaNroSerie)
    pCell(Row, KI_ES_KIT).Id = bEsKit
    
    ' Lote
    '
    pCell(Row, KI_PR_LLEVALOTE).Id = gDB.ValField(rs.Fields, cscPrLlevaNroLote)
    
    If bEsKit Then
    
      Dim coll    As Collection
    
      sqlstmt = "sp_StockProductoGetKitInfo " & pr_id
      If Not gDB.OpenRs(sqlstmt, rs) Then Exit Sub
      
      Set coll = GetCollKitInfoXPrId(pr_id, m_CollKitInfo)
      
      While Not rs.EOF
        pr_id = gDB.ValField(rs.Fields, cscPrId)
        With GetKitInfoItem(coll, pr_id)
          .pr_id = pr_id
          .Nombre = gDB.ValField(rs.Fields, cscPrNombrecompra)
          .Cantidad = gDB.ValField(rs.Fields, "cantidad")
          .LlevaNroSerie = gDB.ValField(rs.Fields, cscPrLlevaNroSerie)
        End With
        rs.MoveNext
      Wend
    End If
  End If

  ' Si cambio el producto borro los numeros de serie
  '
  If bChanged Or pCell(Row, KI_PR_LLEVANROSERIE).Id = 0 Then
      
      pCell(Row, KI_NROSERIE).Value = vbNullString
      If ExistsObjectInColl(m_NrosSerie, GetKey(pCell(Row, KI_GRUPO).Id)) Then
      
        m_NrosSerie.Remove GetKey(pCell(Row, KI_GRUPO).Id)
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
    If Prop.Key <> K_DOC_ID And _
       Prop.Key <> K_NUMERO Then
    
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
  
  sqlstmt = "sp_DocStockProveedorMover " & MoveTo & "," & m_Numero & "," & doc_id
  
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
        GetDocNumber m_LastDoc, m_ObjAbm, m_TaPropuesto, cscStProvNrodoc
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
    
    Set c = .Item(cscStProvFecha)
    c.Value = m_Fecha
    
    Set c = .Item(csDocNumberID)
    c.Value = m_Numero
    
    Set c = .Item(cscProvId)
    c.HelpId = m_prov_id
    c.Value = m_proveedor
    
    Set c = .Item(cscStProvNrodoc)
    c.Value = m_Nrodoc
    c.TextMask = m_TaMascara
    c.TextAlign = vbRightJustify
    
    Set c = .Item(cscDeplIdOrigen)
    c.HelpId = m_depl_id_Origen
    c.Value = m_DepositoOrigen
    
    Set c = .Item(cscDeplIdDestino)
    c.HelpId = m_depl_id_Destino
    c.Value = m_DepositoDestino
    
    Set c = .Item(cscSucId)
    c.HelpId = m_suc_id
    c.Value = m_Sucursal
  
    Set c = .Item(cscLgjId)
    c.HelpId = m_lgj_id
    c.Value = m_Legajo
    
    Set c = .Item(cscStProvDescrip)
    c.Value = m_Descrip
  
  End With
  
  Set AbmGen = m_ObjAbm
  AbmGen.ShowValues m_ObjAbm.Properties
  
  AbmGen.ResetChanged
  
  Set c = m_Items.Properties.Item(c_Items)
  If Not pLoadItems(c) Then Exit Sub
  
  Set AbmGen = m_Items
  AbmGen.ShowValues m_Items.Properties
  
  pSetEnabled
End Sub

' Construccion - Destruccion
Private Sub Class_Initialize()
  On Error GoTo ControlError
  
  c_ErrorSave = LNGGetText(2017, vbNullString) 'Error al grabar la transferencia de stock
  
  Set m_NrosSerie = New Collection
  Set m_GeneralConfig = New cGeneralConfig
  m_GeneralConfig.Load
  
  ' Lote
  '
  Set m_StockConfig = New cStockConfig
  m_StockConfig.Load
  
  ' Preferencias del Usuario
  '
  Set m_UserCfg = New cUsuarioConfig
  m_UserCfg.Load
  m_UserCfg.ValidateST
  
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
  Set m_Items = Nothing
  Set m_Footer = Nothing
  CollClear m_NrosSerie
  Set m_NrosSerie = Nothing

  ' Lote
  '
  Set m_StockConfig = Nothing
  
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

'/////////////////////////////////////////////////////////////////////////////////////////////////
Private Function pSaveItemNroSerie(ByVal Cantidad As Long, _
                                   ByRef Row As CSInterfacesABM.cIABMGridRow, _
                                   ByRef register As cRegister, _
                                   ByRef iOrden As Long, _
                                   ByVal iType As csEStiItemType, _
                                   ByVal bLlevaNroSerie As Boolean) As Boolean
  Dim Grupo           As Long
  Dim pt              As cProductoSerieType
  Dim RegisterSerie   As cRegister
  Dim fld             As cField
  Dim PrIdItem        As Long
  Dim n               As Long
  
  ' Si lleva numero de serie
  '
  If bLlevaNroSerie Then
  
    Grupo = pCell(Row, KI_GRUPO).Id
    
    If pCell(Row, KI_ES_KIT).Id Then
      PrIdItem = pCell(Row, KI_PR_ID).Id
    End If
  
    ' Obtengo los numeros de serie y guardo un Item por cada uno
    '
    For Each pt In m_NrosSerie.Item(GetKey(Grupo))
      
      ' Solo los numeros de serie de este item si es que
      ' estamos en un kit, sino todos los numeros de serie
      '                                                       ' Por ultimo solo envio
      '                                                       ' la cantidad indicada
      If (PrIdItem = pt.pr_id_item Or PrIdItem = csNO_ID) And n < Cantidad Then
      
        n = n + 1
      
        Set RegisterSerie = New cRegister
        
        ' Copio la cabecera
        '
        With RegisterSerie
          .fieldId = register.fieldId
          .Table = register.Table
          .Id = register.Id
        End With
        
        With RegisterSerie.Fields
          For Each fld In register.Fields
            .Add fld
          Next
          
          ' Si es nuevo lo pongo en positivo
          If Grupo < 0 Then
            .Add2 cscStiGrupo, Grupo * -1, csInteger
          Else
            .Add2 cscStiGrupo, Grupo, csInteger
          End If
          
          .Add2 cscPrnsId, pt.prns_id, csId
          .Add2 cscPrnsDescrip, pt.Descrip, csText
          .Add2 cscPrnsFechavto, pt.FechaVto, csDate
          
          Select Case iType
            Case csEItOrigen
              .Add2 cscStiSalida, 1, csDouble
            Case csEItDestino
              .Add2 cscStiIngreso, 1, csDouble
          End Select
          
          iOrden = iOrden + 1
          .Add2 cscStiOrden, iOrden, csInteger
          
          .HaveLastUpdate = False
          .HaveWhoModify = False
        End With
                                                                                
        If Not gDB.Save(RegisterSerie, , "pSaveItemNroSerie", C_Module, c_ErrorSave) Then Exit Function
      End If
    Next
  
  Else
  
    ' Si antes el articulo llevaba numero de serie
    ' tengo que borrar los items asociados a dichos numeros de serie
    '
    If pCell(Row, KI_GRUPO).Id Then
      ' TODO: Borrar items de numeros de serie
    End If
    
    Select Case iType
      Case csEItOrigen
        register.Fields.Add2 cscStiSalida, Cantidad, csDouble
      Case csEItDestino
        register.Fields.Add2 cscStiIngreso, Cantidad, csDouble
    End Select
    
    iOrden = iOrden + 1
    register.Fields.Add2 cscStiOrden, iOrden, csInteger
    
    register.Fields.HaveLastUpdate = False
    register.Fields.HaveWhoModify = False
                                                                        
    If Not gDB.Save(register, , "pSaveItemNroSerie", C_Module, c_ErrorSave) Then Exit Function
    
  End If
  
  pSaveItemNroSerie = True
End Function

Private Sub pSetNrosSerieInRow(ByVal CurrGroup As Long, ByVal NroSerie As String)
  Dim Row As cIABMGridRow
  
  If CurrGroup = 0 Then Exit Sub
  
  For Each Row In m_Items.Properties(c_Items).Grid.Rows
    If pCell(Row, KI_GRUPO).Id = CurrGroup Then
      pCell(Row, KI_NROSERIE).Value = RemoveLastColon(NroSerie)
      Exit Sub
    End If
  Next
End Sub

Private Function pGetDeplId() As Long
  pGetDeplId = m_ObjAbm.Properties(cscDeplIdOrigen).HelpId
End Function

Private Function pGetDeplIdDestino() As Long
  pGetDeplIdDestino = m_ObjAbm.Properties(cscDeplIdDestino).HelpId
End Function

Private Function pGetItems() As cIABMProperty
  Set pGetItems = m_Items.Properties(c_Items)
End Function

Private Sub pSetDatosProveedor()
  Dim iProp       As cIABMProperty
  Dim filter      As String
  
  With m_ObjAbm.Properties.Item(cscProvId)
    If m_LastProv = .HelpId Then
      Exit Sub
    End If
    m_LastProv = .HelpId
  End With
  
  ' TODO: Filtro por deposito
  filter = pGetDeplFilter()
  
  Set iProp = m_ObjAbm.Properties.Item(cscDeplIdOrigen)
  iProp.HelpFilter = filter
  m_ObjAbm.ShowValue iProp
  
  Set iProp = m_ObjAbm.Properties.Item(cscDeplIdDestino)
  iProp.HelpFilter = filter
  m_ObjAbm.ShowValue iProp
End Sub

Private Function pGetDeplFilter() As String
  pGetDeplFilter = "((prov_id is null or prov_id = " & m_LastProv & ") and cli_id is null)"
End Function

Private Sub pSetStock()

  If m_StockConfig.StockXFisico Or m_StockConfig.NoControlaStock Then
    
    m_depf_id = csNO_ID
    
    If Not gDB.GetData(csTDepositoLogico, _
                       cscDeplId, _
                       pGetDeplId(), _
                       cscDepfId, _
                       m_depf_id) Then
    End If
  End If

End Sub


