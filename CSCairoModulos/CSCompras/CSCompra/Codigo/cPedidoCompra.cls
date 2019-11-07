VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cPedidoCompra"
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
' cPedidoCompra
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
Private Const C_Module = "cPedidoCompra"

Private Const c_Items = "ITEMS"

' HIDECOLS
Private Const c_HideColsPc = "HideColsPc"

Private Const K_NUMERO                         As Integer = 1
Private Const K_NRODOC                         As Integer = 2
Private Const K_DESCRIP                        As Integer = 3
Private Const K_FECHA                          As Integer = 4
Private Const K_FECHAENTREGA                   As Integer = 5
Private Const K_NETO                           As Integer = 6
Private Const K_IVARI                          As Integer = 7
Private Const K_IVARNI                         As Integer = 8
Private Const K_TOTAL                          As Integer = 9
Private Const K_US_ID                          As Integer = 10
Private Const K_DOC_ID                         As Integer = 11
Private Const K_LP_ID                          As Integer = 13
Private Const K_ITEMS                          As Integer = 15
Private Const K_EST_ID                         As Integer = 17
Private Const K_CCOS_ID                        As Integer = 18
Private Const K_SUC_ID                         As Integer = 19
Private Const K_SUBTOTAL                       As Integer = 24
Private Const K_LGJ_ID                         As Integer = 27

' HIDECOLS
Private Const K_HIDECOLS                       As Integer = 41

Private Const KI_PC_ID                          As Integer = 1
Private Const KI_PCI_ID                         As Integer = 2
Private Const KI_ORDEN                          As Integer = 3
Private Const KI_CANTIDAD                       As Integer = 4
Private Const KI_DESCRIP                        As Integer = 6
Private Const KI_PRECIO                         As Integer = 7
Private Const KI_IMPORTE                        As Integer = 8
Private Const KI_NETO                           As Integer = 9
Private Const KI_IVARI                          As Integer = 10
Private Const KI_IVARNI                         As Integer = 11
Private Const KI_PR_ID                          As Integer = 13
Private Const KI_LPI_ID                         As Integer = 14
Private Const KI_LDI_ID                         As Integer = 15
Private Const KI_IVARIPercent                   As Integer = 16
Private Const KI_IVARNIPercent                  As Integer = 17
Private Const KI_UNIDAD                         As Integer = 19
Private Const KI_PRECIO_LP                      As Integer = 20
Private Const KI_PRECIO_USR                     As Integer = 21
Private Const KI_CCOS_ID                        As Integer = 22

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
Private m_Fechaentrega                 As Date
Private m_Neto                         As Double
Private m_Ivari                        As Double
Private m_Ivarni                       As Double
Private m_Total                        As Double
Private m_SubTotal                     As Double
Private m_ccos_id                      As Long
Private m_CentroCosto                  As String
Private m_suc_id                       As Long
Private m_Sucursal                     As String
Private m_Us_id                        As Long
Private m_Usuario                      As String
Private m_doc_id                       As Long
Private m_Documento                    As String
Private m_Doct_id                      As Long
Private m_Lp_id                        As Long
Private m_ListaPrecio                  As String
Private m_Creado                       As Date
Private m_Modificado                   As Date
Private m_Modifico                     As Long
Private m_Firmado                      As Boolean
Private m_lgj_id                       As Long
Private m_Legajo                       As String
Private m_Prov_id                      As Long

Private m_TaPropuesto                  As Boolean
Private m_TaMascara                    As String

Private m_Editing           As Boolean

Private m_Footer            As cIABMGeneric
Private m_Items             As cIABMGeneric
Private m_ObjAbm            As cIABMGeneric
Private m_ObjTree           As Object

Private m_LastDoc           As Long
Private m_LastUs            As Long
Private m_LastDocName       As String
Private m_LastUsName        As String

Private m_IsNew             As Boolean

Private m_BranchId          As Long
Private m_TreeId            As Long

Private m_Host              As CSMenu.cIMenuHost

Private m_ItemsDeleted      As String

Private m_Copy              As Boolean

Private m_GeneralConfig     As cGeneralConfig

Private m_bIva              As Boolean
Private m_bIvaRni           As Boolean

Private m_DocEditable       As Boolean
Private m_DocEditMsg        As String

Private m_ObjApply          As cPedidoCompraAplic

' Preferencias del Usuario
'
Private m_UserCfg           As cUsuarioConfig

' propiedades publicas
' propiedades privadas
' funciones publicas

' Edit Apply
'
Public Sub Refresh()
  Load m_Id
  pRefreshProperties
End Sub

' Implementacion de cIABMClient
Private Function cIABMClient_Copy() As Boolean
  
  If Not DocSecurityCanAccessEx(csPreCpraNewPedido, _
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
  GetDocNumber m_LastDoc, m_ObjAbm, m_TaPropuesto, cscPcNrodoc
  pSetEnabled
End Function

Private Function cIABMClient_EditNew() As Boolean
  
  cIABMClient_Terminate
  m_IsNew = True

  cIEditGeneric_Edit csNO_ID
  m_LastUs = csNO_ID

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
  GetDocNumber m_LastDoc, m_ObjAbm, m_TaPropuesto, cscPcNrodoc
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

  Doc.ClientTable = csTPedidoCompra
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
      pShowTotales GetItems(m_Items, c_Items).Grid.Rows
    
    Case MSG_DOC_EDIT_STATE
      ShowEditState m_DocEditMsg, LNGGetText(1935, vbNullString) 'Pedido de compra
      
    Case MSG_DOC_DELETE
      If cIEditGeneric_Delete(m_Id) Then
        cIABMClient_MessageEx = True
        pMove MSG_DOC_NEXT
      End If
    
    Case MSG_DOC_APPLY
      pShowApply
    
    Case MSG_DOC_ANULAR
      DocAnular m_Id, m_est_id, m_Estado, csPreCpraAnularPedido, _
                csPreCpraDesAnularPedido, m_ObjAbm, m_DocEditable, _
                m_DocEditMsg, "sp_DocPedidoCompraAnular", _
                "sp_DocPedidoCompraEditableGet"
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
      DocumentSearch csEDT_PedidoCompra, Me, Not CBool(Info)
      
    Case MSG_DOC_DOC_EDIT
      
      If m_Id Then
      
        If m_DocEditable Then
        
          MsgInfo LNGGetText(1555, vbNullString) 'Este documento puede editarse normalmente
        Else
          
          If DocCanSave(m_ObjAbm, cscPcFecha) Then
            
            Dim EditDoc As cEditDocEx
            Set EditDoc = New cEditDocEx
            
            Set EditDoc.ObjectClient = Me
            EditDoc.Edit m_Id, _
                         m_Doct_id, _
                         csTPedidoCompra, _
                         cscPcId, _
                         csTPedidoCompraItem, _
                         cscPciId, _
                         csPreCpraNewPedido, _
                         csPreCpraEditPedido, _
                         csNO_ID, m_Prov_id, _
                         True
          End If
          
        End If
      
      Else
        MsgInfo LNGGetText(1556, vbNullString)
                'Esta opcion solo sirve para modificar documentos guardados y aplicados
      End If
      
    Case MSG_DOC_DOC_ACTION
    
      If m_Id Then
        pShowOrdenCompra
      Else
        MsgInfo LNGGetText(1556, vbNullString)
                'Esta opción solo sirve para modificar documentos guardados y aplicados
      End If
    
    Case MSG_DOC_HISTORY
    
      If m_Id <> csNO_ID Then
    
        ShowHistory csPedidoCompra, m_Id, m_Documento & " " & m_Nrodoc
      Else
        
        MsgInfo LNGGetText(1552, vbNullString) ' El documento aun no ha sido guardado
      End If
  
    Case MSG_GRID_VIRTUAL_ROW

      cIABMClient_MessageEx = pProcessMultiRow(Info)
  
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
        GetDocNumber m_LastDoc, m_ObjAbm, m_TaPropuesto, cscPcNrodoc
        
      End If
      
      ' Defino el estado de edicion del comprobante
      '
      pSetEnabled
      
    ' HIDECOLS
    '
    Case K_HIDECOLS
    
      pShowHideCols False
  
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
  If Not DocCanSave(m_ObjAbm, cscPcFecha) Then
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
  register.fieldId = cscPcTMPId
  register.Table = csTPedidoCompraTMP
  
  register.Id = csNew
    
  If m_Copy Then
    register.fields.Add2 cscPcId, csNew, csLong
  Else
    register.fields.Add2 cscPcId, m_Id, csLong
  End If
  
  If register.Id = csNew Then
    m_est_id = CSGeneralEx2.csEEstado.csEEst_Pendiente
  End If
  
  Dim IProperty As cIABMProperty
  For Each IProperty In m_ObjAbm.Properties
    With IProperty
      Select Case .Key
        Case K_NUMERO
          register.fields.Add2 cscPcNumero, .Value, csLong
        Case K_NRODOC
          register.fields.Add2 cscPcNrodoc, .Value, csText
        Case K_DESCRIP
          register.fields.Add2 cscPcDescrip, .Value, csText
        Case K_FECHA
          register.fields.Add2 cscPcFecha, .Value, csDate
        Case K_FECHAENTREGA
          register.fields.Add2 cscPcFechaentrega, .Value, csDate
        Case K_US_ID
          register.fields.Add2 cscUsId, .HelpId, csId
        Case K_CCOS_ID
          register.fields.Add2 cscCcosId, .HelpId, csId
        Case K_LGJ_ID
          register.fields.Add2 cscLgjId, .HelpId, csId
        Case K_SUC_ID
          register.fields.Add2 cscSucId, .HelpId, csId
        Case K_DOC_ID
          register.fields.Add2 cscDocId, .HelpId, csId
        Case K_LP_ID
          register.fields.Add2 cscLpId, .HelpId, csId
      End Select
    End With
  Next
  
  For Each IProperty In m_Footer.Properties
    With IProperty
      Select Case .Key
        Case K_TOTAL
          register.fields.Add2 cscPcTotal, .Value, csCurrency
        Case K_NETO
          register.fields.Add2 cscPcNeto, .Value, csCurrency
        Case K_IVARI
          If m_bIva Then
            register.fields.Add2 cscPcIvari, .Value, csCurrency
          End If
        Case K_IVARNI
          If m_bIvaRni Then
            register.fields.Add2 cscPcIvarni, .Value, csCurrency
          End If
        Case K_SUBTOTAL
          register.fields.Add2 cscPcSubtotal, .Value, csCurrency
      End Select
    End With
  Next
  
  register.fields.Add2 cscEstId, m_est_id, csId
  
  register.fields.HaveLastUpdate = True
  register.fields.HaveWhoModify = True
  
  If Not register.BeginTrans(gDB) Then Exit Function
  
  If Not gDB.Save(register, , "cIABMClient_Save", C_Module, c_ErrorSave) Then Exit Function
  
  If Not pSaveItems(register.Id) Then Exit Function
  If Not register.CommitTrans() Then Exit Function
  
  
  Dim sqlstmt As String
  Dim rs      As Recordset
  sqlstmt = "sp_DocPedidoCompraSave " & register.Id
  
  If Not gDB.OpenRs(sqlstmt, rs, , , , "cIABMClient_Save", C_Module, c_ErrorSave) Then Exit Function
  
  If rs.EOF Then Exit Function
  
  Dim Id As Long
  If Not GetDocIDFromRecordset(rs, Id) Then Exit Function
  
  m_Copy = False
  
  cIABMClient_Save = Load(Id)
End Function

Private Function cIABMClient_Terminate() As Boolean
  m_Editing = False
  
  ' HIDECOLS
  '
  CSKernelClient2.SetRegistry csInterface, c_HideColsPc, Val(m_ObjAbm.Properties.Item(c_HideCols).Value)
  
  cIABMClient_Terminate = True
  ' Este objeto puede no cumplir con la interfaz esperada, asi que si hay un error no
  ' le doy bola
  On Error GoTo ControlError
  If m_Id = csNO_ID Then Exit Function
  If m_ObjTree Is Nothing Then Exit Function
  
  m_ObjTree.sqlstmt = "sp_lsdoc_PedidoCompra"
  
  If m_IsNew Then
    m_ObjTree.AddLine m_Id
  Else
    m_ObjTree.RefreshLine m_Id
  End If
ControlError:
End Function

Private Property Get cIABMClient_Title() As String
  cIABMClient_Title = LNGGetText(1937, vbNullString) 'Pedidos de Compra
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
        Case K_FECHAENTREGA
          If ValEmpty(.Value, csDate) Then
            MsgInfo LNGGetText(1564, vbNullString) 'Debe indicar una fecha de entrega
            Exit Function
          End If
        Case K_US_ID
          If ValEmpty(.HelpId, csId) Then
            MsgInfo LNGGetText(1938, vbNullString) 'Debe indicar un Usuario
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
  
  sqlstmt = "select doct_id, doc_id from PedidoCompra where pc_id = " & Id
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Function
  
  m_Id = Id
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
  cIEditGeneric_ShowList = SecurityCanAccess(csPreCpraListPedido)
End Function

Private Property Set cIEditGeneric_ObjAbm(rhs As CSInterfacesABM.cIABMGeneric)
  Set m_ObjAbm = rhs
  m_ObjAbm.IsDocument = True

#If Not PREPROC_SFS Then
  Dim AbmGen      As cABMGenericDocEx
  
  Set AbmGen = m_ObjAbm
  With AbmGen
    .FactoryObject = "CSABMInterface2.cFactory"
    .ObjForm = "CSABMInterface2.fPedidoCompra"
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
                          csTPedidoCompra, _
                          cscPcId, _
                          doc_id) Then
      Exit Function
    End If
  End If
  
  If Not DocSecurityCanAccess( _
                  csPreCpraDeletePedido, _
                  doc_id, _
                  csEDocTPreDelete) Then
    Exit Function
  End If

  Dim sqlstmt As String
  
  sqlstmt = "sp_DocPedidoCompraDelete " & Id & "," & EmpId & "," & User.Id
  
  cIEditGeneric_Delete = gDB.Execute(sqlstmt, "cIEditGeneric_Delete", C_Module)
End Function

Private Function cIEditGeneric_Search(Id As Long, Cancela As Boolean) As Boolean

End Function

Private Function cIEditGeneric_Edit(Id As Long, Optional ByVal InModalWindow As Boolean) As Boolean
  On Error GoTo ControlError
  
  If Not DocSecurityCanAccess(csPreCpraListPedido, GetdocIdFromObjAbm(m_ObjAbm), csEDocTPreList) Then Exit Function
  
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
      With GetItems(m_Items, c_Items)
        pShowImporteAndIva .Grid.Rows(lRow)
        pShowTotales .Grid.Rows
      End With
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
      cIABMClientGrid_ColumnAfterEdit = pColumnAfterEdit(GetItems(m_Items, c_Items), lRow, lCol, NewValue, NewValueID)
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
      cIABMClientGrid_ColumnBeforeEdit = pColumnBeforeEdit(GetItems(m_Items, c_Items), lRow, lCol, iKeyAscii)
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

Private Function pGetPrecioFromRow(ByVal Row As cIABMGridRow) As Double
  Dim Precio  As Double
  
  With pCell(Row, KI_PRECIO_USR)
    If IsNumeric(.Value) Then
      Precio = CDbl(.Value)
    Else
      Precio = 0
    End If
  End With
  
  pGetPrecioFromRow = Precio
End Function

Private Function pColumnAfterEdit(ByRef IProperty As cIABMProperty, ByVal lRow As Long, ByVal lCol As Long, ByVal NewValue As Variant, ByVal NewValueID As Long)
  Dim Row     As cIABMGridRow
  
  Select Case IProperty.Grid.Columns(lCol).Key
    Case KI_PR_ID
      Set Row = IProperty.Grid.Rows(lRow)
      pSetDataProducto Row, NewValueID
      pSetPrecios Row, NewValueID
      pSetTasasImpositivas Row, NewValueID, NewValue
      pCell(Row, KI_PRECIO).Value = pGetPrecioFromRow(Row)
      
    Case KI_PRECIO_USR
      Set Row = IProperty.Grid.Rows(lRow)
      pCell(Row, KI_PRECIO).Value = NewValue
      
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
  
  Id = Val(pCell(Row, KI_PCI_ID).Value)
  
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
  Dim bRowIsEmpty           As Boolean
  
  bRowIsEmpty = True
  
  For Each Cell In Row
    Select Case Cell.Key
      Case KI_CANTIDAD
        If Not ValEmpty(Cell.Value, csCurrency) Then
          If Val(Cell.Value) <> 1 Then
            bRowIsEmpty = False
            Exit For
          End If
        End If
      Case KI_PRECIO
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
  
  strRow = " (Fila " & RowIndex & ")"
  
  For Each Cell In Row
    Select Case Cell.Key
      Case KI_CANTIDAD
        If ValEmpty(Cell.Value, csCurrency) Then
          MsgInfo LNGGetText(1365, vbNullString, strRow) 'Debe indicar una cantidad (1)
          Exit Function
        End If
      Case KI_PR_ID
        If ValEmpty(Cell.Id, csId) Then
          MsgInfo LNGGetText(1899, vbNullString, strRow) 'Debe indicar un producto de compra (1)
          Exit Function
        End If
    End Select
  Next
  
  pValidateRow = True
End Function

' funciones privadas
Private Function LoadCollection() As Boolean
  Dim Filter  As String
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
        .HelpId = m_UserCfg.DocPcId
        .Value = m_UserCfg.DocPcNombre
        
        bValidateDocDefault = .HelpId <> csNO_ID
      End If
      
      .HelpFilter = pGetDocFilter
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
    
    With .Add(Nothing, cscPcFecha)
      .PropertyType = cspDate
      .Name = LNGGetText(1569, vbNullString) 'Fecha
      .LeftLabel = -580
      .Left = 700
      .Key = K_FECHA
      .Value = m_Fecha
    End With
    
    With .Add(Nothing, cscPcFechaentrega)
      .PropertyType = cspDate
      .Name = LNGGetText(1570, vbNullString) 'Entrega
      .Key = K_FECHAENTREGA
      .Value = m_Fechaentrega
    End With
    
    With .Add(Nothing, cscUsId)
      .PropertyType = cspHelp
      .Table = csUsuario
      .TopFromProperty = cscPcFecha
      .Left = 2900
      .LeftLabel = -800
      .Name = LNGGetText(1137, vbNullString) 'Usuario
      .Key = K_US_ID
      .HelpId = m_Us_id
      .Value = m_Usuario
      AbmGen.NewKeyPropFocus = cscUsId
    End With
    
    With .Add(Nothing, cscPcNrodoc)
      .PropertyType = cspText
      .Name = LNGGetText(1065, vbNullString) 'Número
      .Size = 50
      .Key = K_NRODOC
      .Value = m_Nrodoc
      .TextAlign = vbRightJustify
    End With
    
    With .Add(Nothing, cscLpId)
      .PropertyType = cspHelp
      .Table = csListaPrecio
      .Name = LNGGetText(1397, vbNullString) 'Lista de Precios
      .TopFromProperty = cscPcFecha
      .Left = 9400
      .Key = K_LP_ID
      .HelpId = m_Lp_id
      .Value = m_ListaPrecio
    End With
    
    With .Add(Nothing, cscCcosId)
      .PropertyType = cspHelp
      .Table = csCentroCosto
      .Name = LNGGetText(1057, vbNullString) 'Centro de Costo
      .Key = K_CCOS_ID
      .HelpId = m_ccos_id
      .Value = m_CentroCosto
    End With
    
    With .Add(Nothing, cscLgjId)
      .PropertyType = cspHelp
      .Table = csLegajo
      .Name = LNGGetText(1575, vbNullString) 'Legajo
      .Key = K_LGJ_ID
      .HelpId = m_lgj_id
      .Value = m_Legajo
    End With
    
    With .Add(Nothing, cscSucId)
      .PropertyType = cspHelp
      .Table = csSucursal
      .Name = LNGGetText(1281, vbNullString) 'Sucursal
      .Key = K_SUC_ID
      .HelpId = m_suc_id
      .Value = m_Sucursal
    End With
    
    With .Add(Nothing, cscPcDescrip)
      .PropertyType = cspText
      .SubType = cspMemo
      .Name = LNGGetText(1211, vbNullString) 'Observ.
      .LeftLabel = -600
      .Size = 5000
      .Key = K_DESCRIP
      .Value = m_Descrip
      .LeftFromProperty = cscPcFecha
      .TopFromProperty = cscPcNrodoc
      .Width = 7450
      .Height = 800
      .TopToPrevious = 440
    End With
  
    ' HIDECOLS
    '
    With .Add(Nothing)
      .PropertyType = cspLabel
      .BackColor = vbButtonShadow
      .Width = 2540
      .TopNotChange = True
      .LeftNotChange = True
      .Top = 3460
      .Left = 9210
      .Height = 330
    End With
    
    With .Add(Nothing)
      .PropertyType = cspLabel
      .BackColor = vbWindowBackground
      .Width = 2500
      .TopNotChange = True
      .LeftNotChange = True
      .Top = 3480
      .Left = 9220
      .Height = 300
    End With
  
    Dim iProp As cIABMProperty
    Dim oProp As cABMProperty
    Set iProp = .Add(Nothing, c_HideCols)
    Set oProp = iProp
    With iProp
      .PropertyType = cspCheck
      .Name = LNGGetText(3901, vbNullString)  'Ocultar Columnas
      .Key = K_HIDECOLS
      .Value = CInt(CSKernelClient2.GetRegistry(csInterface, c_HideColsPc, 1))
      .TopNotChange = True
      .LeftNotChange = True
      .Top = 3500
      .Left = 11120
      .LeftLabel = -1500
    End With
    oProp.IsEditProperty = False
    '
    ' HIDECOLS - fin
  
  End With
  
  If Not m_ObjAbm.Show(Me) Then Exit Function
      
  With m_Items.Tabs
  
    .Clear
    
    With .Add(Nothing)
      .Name = LNGGetText(1371, vbNullString) 'Items
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
    
    With .Add(Nothing, cscPcSubtotal)
      .PropertyType = cspNumeric
      .SubType = cspMoney
      .Name = LNGGetText(1579, vbNullString) 'Sub Total
      .Key = K_SUBTOTAL
      .Value = m_SubTotal
      .Format = m_GeneralConfig.FormatDecImporte
      .Enabled = False
    End With
    
    With .Add(Nothing, cscPcNeto)
      .PropertyType = cspNumeric
      .SubType = cspMoney
      .Name = LNGGetText(1581, vbNullString) 'Neto
      .Key = K_NETO
      .Value = m_Neto
      .Format = m_GeneralConfig.FormatDecImporte
      .Enabled = False
    End With
    
    With .Add(Nothing, cscPcIvari)
      .PropertyType = cspNumeric
      .Name = LNGGetText(1582, vbNullString) 'IVA RI
      .SubType = cspMoney
      .Key = K_IVARI
      .Value = m_Ivari
      .Format = m_GeneralConfig.FormatDecImporte
      .Enabled = False
    End With
    
    With .Add(Nothing, cscPcIvarni)
      .PropertyType = cspNumeric
      .Name = LNGGetText(1583, vbNullString) 'IVA RNI
      .SubType = cspMoney
      .Key = K_IVARNI
      .Value = m_Ivarni
      .Format = m_GeneralConfig.FormatDecImporte
      .Enabled = False
    End With
    
    With .Add(Nothing, cscPcTotal)
      .PropertyType = cspNumeric
      .Format = m_GeneralConfig.FormatDecImporte
      .Name = LNGGetText(1584, vbNullString) 'Total
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

Private Function pGetDocFilter() As String
  pGetDocFilter = "'doct_id = " & csEDT_PedidoCompra & _
                  " or doct_id = " & csEDT_DevolucionPedidoCpra & "'"
End Function

Private Function pLoadItems(ByRef Propiedad As cIABMProperty) As Boolean
  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  Dim oCol    As cABMGridColumn
  Dim iCol    As cIABMGridColumn
  
  ' HIDECOLS
  '
  Dim bColVisible As Boolean
  bColVisible = Val(m_ObjAbm.Properties.Item(c_HideCols).Value) = 0
  
  sqlstmt = "sp_DocPedidoCompraGetItems " & m_Id
  
  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, "pLoadItems", C_Module) Then Exit Function
  
  With Propiedad.Grid
  
    With .Columns
    
      .Clear
      
      With .Add(Nothing)
        .Visible = False
        .Key = KI_PCI_ID
      End With
      
      Set iCol = .Add(Nothing)
      Set oCol = iCol
      With iCol
        .Name = LNGGetText(1619, vbNullString)  'Producto
        .PropertyType = cspHelp
        .Table = csProductoCompra
        .Width = 1800
        .Key = KI_PR_ID
      End With
      If m_UserCfg.MultiSelect Then
        oCol.HelpType = csMultiSelect
      End If
      Set iCol = Nothing
      Set oCol = Nothing
      
      With .Add(Nothing)
        .Name = C_strDescrip
        .PropertyType = cspText
        .SubType = cspTextButtonEx
        .Width = 1200
        .Key = KI_DESCRIP
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(1374, vbNullString) 'Cantidad
        .Format = m_GeneralConfig.FormatDecCantidad
        .PropertyType = cspNumeric
        .SubType = cspDouble
        .Width = 1200
        .Key = KI_CANTIDAD
      
        Set .DefaultValue = New cABMGridRowValue
        .DefaultValue.Value = 1
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(1165, vbNullString) 'Unidad
        .PropertyType = cspText
        .Width = 1200
        .Key = KI_UNIDAD
        .Enabled = False
        .Visible = bColVisible ' HIDECOLS
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(1587, vbNullString) 'Precio (LP)
        .PropertyType = cspNumeric
        .SubType = cspMoney
        .Format = m_GeneralConfig.FormatDecImporte
        .Width = 1200
        .Key = KI_PRECIO_LP
        .Enabled = False
        .Visible = bColVisible ' HIDECOLS
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(1586, vbNullString) 'Precio
        .PropertyType = cspNumeric
        .SubType = cspMoney
        .Width = 1200
        .Format = m_GeneralConfig.FormatDecImporte
        .Key = KI_PRECIO_USR
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(1588, vbNullString) 'Precio c/desc.
        .PropertyType = cspNumeric
        .SubType = cspMoney
        .Width = 1200
        .Format = m_GeneralConfig.FormatDecImporte
        .Key = KI_PRECIO
        .Visible = False
        .Enabled = False
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(1581, vbNullString) 'Neto
        .PropertyType = cspNumeric
        .SubType = cspMoney
        .Format = m_GeneralConfig.FormatDecImporte
        .Width = 1200
        .Key = KI_NETO
        .Enabled = False
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(1582, vbNullString) 'IVA RI
        .PropertyType = cspNumeric
        .SubType = cspMoney
        .Format = m_GeneralConfig.FormatDecImporte
        .Width = 1200
        .Key = KI_IVARI
        .Enabled = False
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(1583, vbNullString) 'IVA RNI
        .PropertyType = cspNumeric
        .Format = m_GeneralConfig.FormatDecImporte
        .SubType = cspMoney
        .Width = 1200
        .Key = KI_IVARNI
        .Enabled = False
        .Visible = bColVisible ' HIDECOLS
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(1228, vbNullString) 'Importe
        .PropertyType = cspNumeric
        .Format = m_GeneralConfig.FormatDecImporte
        .SubType = cspMoney
        .Width = 1200
        .Key = KI_IMPORTE
        .Enabled = False
      End With
      
      With .Add(Nothing)
        .Visible = False
        .Key = KI_IVARIPercent
      End With
      
      With .Add(Nothing)
        .Visible = False
        .Key = KI_IVARNIPercent
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(1057, vbNullString) 'Centro de Costo
        .PropertyType = cspHelp
        .Table = csCentroCosto
        .Width = 1800
        .Key = KI_CCOS_ID
        .Visible = bColVisible ' HIDECOLS
      End With
      
    End With
  
    With .Rows
      
      .Clear
    
      While Not rs.EOF
      
        With .Add(Nothing, rs(cscPciId).Value)
        
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscPciId)
            .Key = KI_PCI_ID
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscPrNombrecompra)
            .Id = gDB.ValField(rs.fields, cscPrId)
            .Key = KI_PR_ID
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscPciDescrip)
            .Key = KI_DESCRIP
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscPciCantidad)
            .Key = KI_CANTIDAD
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscUnNombre)
            .Key = KI_UNIDAD
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscPciPrecioLista)
            .Key = KI_PRECIO_LP
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscPciPrecioUsr)
            .Key = KI_PRECIO_USR
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscPciPrecio)
            .Key = KI_PRECIO
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscPciNeto)
            .Key = KI_NETO
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscPciIvari)
            .Key = KI_IVARI
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscPciIvarni)
            .Key = KI_IVARNI
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscPciImporte)
            .Key = KI_IMPORTE
          End With
          
          With .Add(Nothing)
            If m_bIva Then
              .Value = gDB.ValField(rs.fields, "iva_ri_porcentaje")
            Else
              .Value = 0
            End If
            .Key = KI_IVARIPercent
          End With
          
          With .Add(Nothing)
            If m_bIvaRni Then
              .Value = gDB.ValField(rs.fields, "iva_rni_porcentaje")
            Else
              .Value = 0
            End If
            .Key = KI_IVARNIPercent
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscCcosNombre)
            .Id = gDB.ValField(rs.fields, cscCcosId)
            .Key = KI_CCOS_ID
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

  sqlstmt = "sp_DocPedidoCompraGet " & EmpId & "," & Id & "," & gDB.UserId
  
  Dim rs As Recordset

  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, C_LoadFunction, C_Module) Then Exit Function

  If Not rs.EOF Then

    m_Id = gDB.ValField(rs.fields, cscPcId)
    m_Numero = gDB.ValField(rs.fields, cscPcNumero)
    m_Nrodoc = gDB.ValField(rs.fields, cscPcNrodoc)
    m_Descrip = gDB.ValField(rs.fields, cscPcDescrip)
    m_Fecha = gDB.ValField(rs.fields, cscPcFecha)
    m_Fechaentrega = gDB.ValField(rs.fields, cscPcFechaentrega)
    m_Neto = gDB.ValField(rs.fields, cscPcNeto)
    m_Ivari = gDB.ValField(rs.fields, cscPcIvari)
    m_Ivarni = gDB.ValField(rs.fields, cscPcIvarni)
    m_Total = gDB.ValField(rs.fields, cscPcTotal)
    m_SubTotal = gDB.ValField(rs.fields, cscPcSubtotal)
    m_Us_id = gDB.ValField(rs.fields, cscUsId)
    m_Usuario = gDB.ValField(rs.fields, cscUsNombre)
    m_ccos_id = gDB.ValField(rs.fields, cscCcosId)
    m_CentroCosto = gDB.ValField(rs.fields, cscCcosNombre)
    m_suc_id = gDB.ValField(rs.fields, cscSucId)
    m_Sucursal = gDB.ValField(rs.fields, cscSucNombre)
    m_doc_id = gDB.ValField(rs.fields, cscDocId)
    m_Documento = gDB.ValField(rs.fields, cscDocNombre)
    m_Doct_id = gDB.ValField(rs.fields, cscDoctId)
    m_Lp_id = gDB.ValField(rs.fields, cscLpId)
    m_ListaPrecio = gDB.ValField(rs.fields, cscLpNombre)
    m_Creado = gDB.ValField(rs.fields, cscCreado)
    m_Modificado = gDB.ValField(rs.fields, cscModificado)
    m_Modifico = gDB.ValField(rs.fields, cscModifico)
    m_est_id = gDB.ValField(rs.fields, cscEstId)
    m_Estado = gDB.ValField(rs.fields, cscEstNombre)
    m_Firmado = gDB.ValField(rs.fields, cscPcFirmado)

    m_lgj_id = gDB.ValField(rs.fields, cscLgjId)
    m_Legajo = gDB.ValField(rs.fields, cscLgjCodigo)

    m_DocEditable = gDB.ValField(rs.fields, cscDocEditable)
    m_DocEditMsg = gDB.ValField(rs.fields, cscDoceditMsg)

    m_TaPropuesto = gDB.ValField(rs.fields, cscTa_Propuesto)
    m_TaMascara = gDB.ValField(rs.fields, cscTa_Mascara)

    m_bIva = gDB.ValField(rs.fields, cscbIvaRi)
    m_bIvaRni = gDB.ValField(rs.fields, cscbIvaRni)

    m_LastDoc = m_doc_id
    m_LastUs = m_Us_id
    m_LastDocName = m_Documento
    m_LastUsName = m_Usuario

  Else
    m_Id = csNO_ID
    m_Numero = 0
    m_Nrodoc = vbNullString
    m_Descrip = vbNullString
    m_Fecha = VDGetDateById(csToday)
    m_Fechaentrega = VDGetDateById(csTomorrow)
    m_Neto = 0
    m_Ivari = 0
    m_Ivarni = 0
    m_Total = 0
    m_SubTotal = 0
    m_Us_id = csNO_ID
    m_Usuario = vbNullString
    m_ccos_id = csNO_ID
    m_CentroCosto = vbNullString
    m_doc_id = csNO_ID
    m_Documento = vbNullString
    m_Doct_id = csNO_ID
    m_Lp_id = csNO_ID
    m_ListaPrecio = vbNullString
    m_Creado = csNoDate
    m_Modificado = csNoDate
    m_Modifico = 0
    m_est_id = csNO_ID
    m_Estado = vbNullString
    m_lgj_id = csNO_ID
    m_Legajo = vbNullString
    m_suc_id = User.suc_id
    m_Sucursal = User.Sucursal
    m_Firmado = False
  
    m_doc_id = m_LastDoc
    m_Us_id = m_LastUs
    m_Usuario = m_LastUsName
    m_Documento = m_LastDocName
  
    m_bIvaRni = False
    m_bIva = False
    
    m_TaPropuesto = False
    m_TaMascara = vbNullString
  
    DocEditableGet m_doc_id, m_DocEditable, m_DocEditMsg, csPreCpraNewPedido
  
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

Private Function cIMenuClient_Initialize(f As Object, Host As CSMenu.cIMenuHost) As Boolean
  On Error GoTo ControlError
  Dim str_1879 As String
  
  str_1879 = LNGGetText(1879, vbNullString)   'Com&pras
  
  Set m_Host = Host
  m_Host.Server.AddMenu str_1879, csMenuEnum.csMenuCompras, vbNullString, 1, False, False, False, True, False, Nothing
  m_Host.Server.AddMenu LNGGetText(1939, vbNullString), csPreCpraListPedido, str_1879, 0, True, False, False, False, False, Me
                        '&Pedidos de Compra
  cIMenuClient_Initialize = True
  
  GoTo ExitProc
ControlError:
  MngError Err, C_MenuClientInit, C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Private Function cIMenuClient_ProcessMenu(ByVal Id As Long) As Variant
#If PREPROC_SFS Then
  m_Host.MenuListDocClick "CSABMInterface2.cABMGeneric", "CSCompra2.cPedidoCompra", "CSABMInterface2.CABMGenericListDoc", "CSCompra2.cPedidoCompraListDoc", Me, LNGGetText(1937, vbNullString), 0
#Else
  m_Host.MenuListDocClick "CSABMInterface2.cABMGenericDocEx", "CSCompra2.cPedidoCompra", "CSABMInterface2.CABMGenericListDoc", "CSCompra2.cPedidoCompraListDoc", Me, LNGGetText(1939, vbNullString), 0
                                                                                                                                                                      'Pedidos de Compra
#End If
End Function

Private Function pSaveItems(ByVal Id As Long) As Boolean
  Dim register As cRegister
  Dim IProperty As cIABMProperty
  Dim iOrden As Long
  Dim Row  As cIABMGridRow
  Dim Cell As cIABMGridCellValue
  
  For Each Row In GetItems(m_Items, c_Items).Grid.Rows
    Set register = New cRegister
    register.fieldId = cscPciTMPId
    register.Table = csTPedidoCompraItemTMP
    register.Id = csNew
    
    For Each Cell In Row
      Select Case Cell.Key
        
        Case KI_PCI_ID
          If m_Copy Then
            register.fields.Add2 cscPciId, csNew, csInteger
          Else
            register.fields.Add2 cscPciId, Val(Cell.Value), csInteger
          End If
        Case KI_CANTIDAD
          register.fields.Add2 cscPciCantidad, Cell.Value, csDouble
        Case KI_DESCRIP
          register.fields.Add2 cscPciDescrip, Cell.Value, csText
        Case KI_PRECIO
          register.fields.Add2 cscPciPrecio, Cell.Value, csCurrency
        Case KI_PRECIO_LP
          register.fields.Add2 cscPciPrecioLista, Cell.Value, csCurrency
        Case KI_PRECIO_USR
          register.fields.Add2 cscPciPrecioUsr, Cell.Value, csCurrency
        Case KI_IMPORTE
          register.fields.Add2 cscPciImporte, Cell.Value, csCurrency
        Case KI_NETO
          register.fields.Add2 cscPciNeto, Cell.Value, csCurrency
        Case KI_IVARI
          register.fields.Add2 cscPciIvari, Cell.Value, csCurrency
        Case KI_IVARNI
          register.fields.Add2 cscPciIvarni, Cell.Value, csCurrency
        Case KI_IVARIPercent
          register.fields.Add2 cscPciIvariPorc, Cell.Value, csDouble
        Case KI_IVARNIPercent
          register.fields.Add2 cscPciIvarniPorc, Cell.Value, csDouble
        Case KI_PR_ID
          register.fields.Add2 cscPrId, Cell.Id, csId
        Case KI_CCOS_ID
          register.fields.Add2 cscCcosId, Cell.Id, csId
      End Select
    Next
    
    iOrden = iOrden + 1
    register.fields.Add2 cscPciOrden, iOrden, csInteger
    register.fields.Add2 cscPcTMPId, Id, csId
    
    register.fields.HaveLastUpdate = False
    register.fields.HaveWhoModify = False

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
      register.fieldId = cscPcibTMPId
      register.Table = csTPedidoCompraItemBorradoTMP
      register.Id = csNew
      
      register.fields.Add2 cscPciId, Val(vDeletes(i)), csInteger
      register.fields.Add2 cscPcId, m_Id, csId
      register.fields.Add2 cscPcTMPId, Id, csId
      
      register.fields.HaveLastUpdate = False
      register.fields.HaveWhoModify = False

      If Not gDB.Save(register, , "pSaveItems", C_Module, c_ErrorSave) Then Exit Function
    Next
    
  End If
  
  pSaveItems = True
End Function

' Reglas del Objeto de Negocios
Private Sub pShowImporteAndIva(ByRef Row As CSInterfacesABM.cIABMGridRow)
  Dim Importe As Double
  Dim Neto    As Double
  Dim IvaRi   As Double
  Dim IvaRni  As Double
  
  Neto = Val(pCell(Row, KI_CANTIDAD).Value) * Val(pCell(Row, KI_PRECIO).Value)
  If m_bIva Then
    IvaRi = (Neto * Val(pCell(Row, KI_IVARIPercent).Value)) / 100
  End If
  If m_bIvaRni Then
    IvaRni = (Neto * Val(pCell(Row, KI_IVARNIPercent).Value)) / 100
  End If
  Importe = Neto + IvaRi + IvaRni
  
  pCell(Row, KI_NETO).Value = Neto
  pCell(Row, KI_IVARI).Value = IvaRi
  pCell(Row, KI_IVARNI).Value = IvaRni
  pCell(Row, KI_IMPORTE).Value = Importe
End Sub
  
Private Sub pShowTotales(ByRef Rows As CSInterfacesABM.cIABMGridRows)
  Dim Neto      As Double
  Dim IvaRi     As Double
  Dim IvaRni    As Double
  
  Dim Row       As CSInterfacesABM.cIABMGridRow
  
  For Each Row In Rows
    Neto = Neto + Val(pCell(Row, KI_NETO).Value)
    IvaRi = IvaRi + Val(pCell(Row, KI_IVARI).Value)
    IvaRni = IvaRni + Val(pCell(Row, KI_IVARNI).Value)
  Next
  
  With m_Footer.Properties
    .Item(cscPcSubtotal).Value = Neto
    .Item(cscPcNeto).Value = Neto
    .Item(cscPcIvari).Value = IvaRi
    .Item(cscPcIvarni).Value = IvaRni
    .Item(cscPcTotal).Value = Neto + IvaRni + IvaRi
  End With
  
  m_Footer.RefreshControls
End Sub

Private Sub pSetTasasImpositivas(ByRef Row As CSInterfacesABM.cIABMGridRow, ByVal PR_ID As Long, ByVal pr_nombre As String)
  Dim ti_ri    As Long
  Dim ti_rni   As Long
  
  If PR_ID = 0 Then Exit Sub
  
  If Not GetTasaFromProducto(PR_ID, ti_ri, ti_rni, True) Then Exit Sub
  
  If ti_ri = 0 Then
    MsgWarning LNGGetText(1597, vbNullString, pr_nombre)
        'El producto [" & pr_nombre & "] no tiene definida su tasa impositiva de compras para el iva responsable inscripto
    Exit Sub
  End If
  
  If ti_rni = 0 Then
    MsgWarning LNGGetText(1598, vbNullString, pr_nombre)
          'El producto [" & pr_nombre & "] no tiene definida su tasa impositiva de compras para el iva responsable no inscripto
    Exit Sub
  End If
  
  Dim sqlstmt As String
  Dim rs      As Recordset
  
  If m_bIva Then
    sqlstmt = "select ti_porcentaje,cue_id from tasaimpositiva where ti_id = " & ti_ri
    If Not gDB.OpenRs(sqlstmt, rs) Then Exit Sub
    
    If Not rs.EOF Then
      pCell(Row, KI_IVARIPercent).Value = gDB.ValField(rs.fields, cscTiPorcentaje)
    End If
  Else
    pCell(Row, KI_IVARIPercent).Value = 0
  End If
  
  If m_bIvaRni Then
    sqlstmt = "select ti_porcentaje,cue_id from tasaimpositiva where ti_id = " & ti_rni
    If Not gDB.OpenRs(sqlstmt, rs) Then Exit Sub
    
    If Not rs.EOF Then
      pCell(Row, KI_IVARNIPercent).Value = gDB.ValField(rs.fields, cscTiPorcentaje)
    End If
  Else
    pCell(Row, KI_IVARNIPercent).Value = 0
  End If
End Sub

Private Sub pSetDataProducto(ByRef Row As CSInterfacesABM.cIABMGridRow, ByVal PR_ID As Long)
  Dim sqlstmt As String
  Dim rs      As Recordset
  
  sqlstmt = "select un_nombre, ccos_id_compra, ccos_nombre" & _
            " from producto" & _
            " left join unidad on un_id_compra = un_id" & _
            " left join centrocosto on ccos_id_compra = ccos_id" & _
            " where pr_id = " & PR_ID
  
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Sub
  
  If Not rs.EOF Then
    pCell(Row, KI_UNIDAD).Value = gDB.ValField(rs.fields, cscUnNombre)
  
    With pCell(Row, KI_CCOS_ID)
      .Value = gDB.ValField(rs.fields, cscCcosNombre)
      .Id = gDB.ValField(rs.fields, cscCcosIdCompra)
    End With
  End If
End Sub

Private Sub pSetPrecios(ByRef Row As CSInterfacesABM.cIABMGridRow, ByVal PR_ID As Long)
  Dim LP        As cListaPrecio
  Dim lp_id     As Long
  Dim Precio    As Double
  
  lp_id = m_ObjAbm.Properties(cscLpId).HelpId
    
  If lp_id <> 0 Then
    Set LP = New cListaPrecio
    Precio = LP.GetPrecio(lp_id, PR_ID)
  End If
  
  pCell(Row, KI_PRECIO_LP).Value = Precio
  pCell(Row, KI_PRECIO_USR).Value = Precio
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
                                                                              ' HIDECOLS
    If Prop.Key <> K_DOC_ID And Prop.Key <> K_NUMERO And Prop.Key <> K_EST_ID And Prop.Key <> K_HIDECOLS Then
    
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
  
  sqlstmt = "sp_DocPedidoCompraFirmar " & m_Id & "," & Us_id
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Function
  
  m_est_id = gDB.ValField(rs.fields, cscEstId)
  m_Estado = gDB.ValField(rs.fields, cscEstNombre)
  
  Dim iProp As cIABMProperty
  Set iProp = m_ObjAbm.Properties(csDocEstateID)
  
  With iProp
    .HelpId = m_est_id
    .Value = m_Estado
  End With
  
  gDB.GetData csTPedidoCompra, cscPcId, m_Id, cscPcFirmado, m_Firmado
  
  m_ObjAbm.ShowValue iProp
  
  pFirmar = True
End Function

Private Function pMove(ByVal MoveTo As ABM_MSG) As Boolean
  Dim sqlstmt As String
  Dim rs      As Recordset
  Dim doc_id  As Long
  
  doc_id = m_ObjAbm.Properties(cscDocId).HelpId
  
  If doc_id = csNO_ID Then MsgInfo LNGGetText(1595, vbNullString) 'Debe seleccionar un documento
  
  sqlstmt = "sp_DocPedidoCompraMover " & MoveTo & "," & m_Numero & "," & doc_id
  
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
        
        ' Limpio incluso el ultimo usuario
        '
        m_LastUs = csNO_ID
        m_LastUsName = vbNullString
        
        ' Cargo un registro vacio
        '
        Load csNO_ID
        
        ' Refresco el formulario
        '
        pRefreshProperties
    
        ' Obtengo un nuevo numero de comprobante
        '
        GetDocNumber m_LastDoc, m_ObjAbm, m_TaPropuesto, cscPcNrodoc
    
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
  
  With m_ObjAbm.Properties
  
    Set c = .Item(cscDocId)
    c.HelpId = m_doc_id
    c.Value = m_Documento
    
    Set c = .Item(cscPcFecha)
    c.Value = m_Fecha
    
    Set c = .Item(cscPcFechaentrega)
    c.Value = m_Fechaentrega
    
    Set c = .Item(cscUsId)
    c.HelpId = m_Us_id
    c.Value = m_Usuario
    
    Set c = .Item(csDocNumberID)
    c.Value = m_Numero
    
    Set c = .Item(csDocEstateID)
    c.Value = m_Estado
    
    Set c = .Item(cscPcNrodoc)
    c.Value = m_Nrodoc
    c.TextAlign = vbRightJustify
    
    Set c = .Item(cscLpId)
    c.HelpId = m_Lp_id
    c.Value = m_ListaPrecio
    
    Set c = .Item(cscCcosId)
    c.HelpId = m_ccos_id
    c.Value = m_CentroCosto
    
    Set c = .Item(cscSucId)
    c.HelpId = m_suc_id
    c.Value = m_Sucursal
    
    Set c = .Item(cscLgjId)
    c.HelpId = m_lgj_id
    c.Value = m_Legajo
    
    Set c = .Item(cscPcDescrip)
    c.Value = m_Descrip
  
  End With
  
  Set AbmGen = m_ObjAbm
  AbmGen.ShowValues m_ObjAbm.Properties
  
  AbmGen.ResetChanged
  
  Set c = GetItems(m_Items, c_Items)
  If Not pLoadItems(c) Then Exit Sub
  
  m_ItemsDeleted = vbNullString
  
  Set AbmGen = m_Items
  AbmGen.ShowValues m_Items.Properties
  
  With m_Footer.Properties
  
    Set c = .Item(cscPcSubtotal)
    c.Value = m_SubTotal
    
    Set c = .Item(cscPcNeto)
    c.Value = m_Neto
    
    Set c = .Item(cscPcIvari)
    c.Value = m_Ivari
    
    Set c = .Item(cscPcIvarni)
    c.Value = m_Ivarni
    
    Set c = .Item(cscPcTotal)
    c.Value = m_Total
  End With
  
  Set AbmGen = m_Footer
  AbmGen.ShowValues m_Footer.Properties
  
  pSetEnabled
End Sub

' Construccion - Destruccion
Private Sub Class_Initialize()
  On Error GoTo ControlError
  
  c_ErrorSave = LNGGetText(1936, vbNullString) 'Error al grabar el Pedido de Compra

  Set m_GeneralConfig = New cGeneralConfig
  m_GeneralConfig.Load

  ' Preferencias del Usuario
  '
  Set m_UserCfg = New cUsuarioConfig
  m_UserCfg.Load
  m_UserCfg.ValidatePC

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

Private Sub pShowApply()
  
  If Not DocSecurityCanAccess(csPreCpraModifyAplic, m_doc_id, csEDocTPreAplicar) Then Exit Sub

  If m_ObjApply Is Nothing Then
    Set m_ObjApply = New cPedidoCompraAplic
  
  ' Edit Apply
  '
  Else
    If m_ObjApply.Id <> m_Id Then
      Set m_ObjApply.ObjectClient = Nothing
      Set m_ObjApply = New cPedidoCompraAplic
    End If
  End If

  ' Edit Apply
  '
  Set m_ObjApply.ObjectClient = Me
  
  If Not m_ObjApply.Show(m_Id, _
                         m_Total, _
                         m_Nrodoc, _
                         m_Us_id, _
                         m_Usuario, _
                         m_suc_id, _
                         m_doc_id, _
                         m_Doct_id = csEDT_DevolucionPedidoCpra) Then
    Set m_ObjApply = Nothing
  End If
End Sub

Private Sub pShowOrdenCompra()
  On Error GoTo ControlError

  Dim o As CSCompra2.cOrdenCompra
  Set o = New CSCompra2.cOrdenCompra
  
  o.ShowOrdenPedido pGetPcIds()

  GoTo ExitProc
ControlError:
  MngError Err, "pShowOrdenCompra", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Function pGetPcIds() As Long()
  Dim rtn() As Long
  ReDim rtn(1)
  rtn(1) = m_Id
  pGetPcIds = rtn
End Function

Private Function pProcessMultiRow(ByVal Info As Variant) As Boolean
  
  Info.bAddRows = False
  
  Select Case Info.Key
    Case K_ITEMS
      With pGetItems()
        
        Dim Row As cIABMGridRow
        Set Row = .Grid.Rows(Info.lRow)

        If Row.Item(Info.lCol).Key = KI_PR_ID Then
          
          Dim oCell As cABMGridRowValue
          
          Set oCell = pCell(Row, KI_PR_ID)
          
          If LenB(oCell.HelpValueProcess) Then
            If InStr(1, oCell.HelpValueProcess, ",") Then
              AddMultiRowsCompras oCell.HelpValueProcess, Info, KI_CANTIDAD
              pProcessMultiRow = True
            End If
          End If
        End If
      End With
  End Select
  
End Function

'Private Sub pAddMultiRows(ByVal Ids As String, _
'                          ByRef Info As Variant)
'  Dim sqlstmt As String
'  Dim rs      As ADODB.Recordset
'
'  sqlstmt = "select pr_nombrecompra, pr_id from Producto where pr_id in (" & Ids & ")"
'  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Sub
'  If rs.EOF Then Exit Sub
'
'  Dim i As Long
'  Dim j As Long
'  Dim k As Long
'  Dim PR_ID As Long
'  Dim vIds  As Variant
'  Dim vIds2 As Variant
'  Dim bFound As Boolean
'
'  vIds2 = Split(Ids, ",")
'
'  ReDim vIds(UBound(vIds2))
'
'  For i = 0 To UBound(vIds2)
'    bFound = False
'    For j = 0 To UBound(vIds)
'
'      If vIds2(i) = vIds(j) Then
'        bFound = True
'        Exit For
'      End If
'
'    Next
'    If Not bFound Then
'      vIds(k) = vIds2(i)
'      k = k + 1
'    End If
'  Next
'
'  ReDim Preserve vIds(k - 1)
'
'  ' Ahora respeto el orden de seleccion
'  '
'  For i = 0 To UBound(vIds)
'
'    rs.MoveFirst
'
'    Do While Not rs.EOF
'
'      PR_ID = gDB.ValField(rs.fields, cscPrId)
'
'      If Val(vIds(i)) = PR_ID Then
'        Info.NewId.Add PR_ID
'        Info.NewValue.Add gDB.ValField(rs.fields, cscPrNombrecompra)
'        Exit Do
'      End If
'
'      rs.MoveNext
'    Loop
'
'  Next
'
'  ' No lo toquen, es mas 1 :( o explota todooo :P
'  ' ups al final no era jeje
'  '
'  Info.iAddRows = Info.NewId.Count '+ 1
'
'  Info.bAddRows = Info.iAddRows
'
'End Sub

Private Function pGetItems() As cIABMProperty
  Set pGetItems = m_Items.Properties.Item(c_Items)
End Function

' HIDECOLS
'
Private Sub pShowHideCols(ByVal bOnlyStock As Boolean)
  Dim Columns   As cIABMGridColumns
  Dim bVisible  As Boolean
  Dim AbmObj As cABMGeneric
  Set AbmObj = m_ObjAbm
  
  If AbmObj.InSave Then Exit Sub
  
  bVisible = Val(m_ObjAbm.Properties.Item(c_HideCols).Value) = 0
  
  Dim iProp As cIABMProperty
  Set iProp = pGetItems()
    
  AbmObj.DrawGrid iProp, False
  
  Dim i As Integer
  
  Set Columns = iProp.Grid.Columns
  For i = 1 To Columns.Count
    Select Case Columns(i).Key
      
      Case KI_UNIDAD, KI_PRECIO_LP, KI_IVARNI, KI_CCOS_ID
        
        ' Solo si la llamada fue para todas las columnas
        ' y no unicamente para las columnas de stock
        '
        If Not bOnlyStock Then
          Columns(i).Visible = bVisible
          AbmObj.RefreshColumnPropertiesByIndex iProp, i
        End If
            
    End Select
  Next
  
  AbmObj.DrawGrid iProp, True
End Sub
'
' HIDECOLS - fin

