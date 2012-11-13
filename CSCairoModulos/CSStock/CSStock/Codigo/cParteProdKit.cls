VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cParteProdKit"
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
' cParteProdKit
' 06-08-2004

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cParteProdKit"

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

Private Const KI_PPK_ID                         As Integer = 2
Private Const KI_ORDEN                          As Integer = 3
Private Const KI_CANTIDAD                       As Integer = 4
Private Const KI_DESCRIP                        As Integer = 6
Private Const KI_PR_ID                          As Integer = 13
Private Const KI_PR_LLEVANROSERIE               As Integer = 14
Private Const KI_ES_KIT                         As Integer = 15
Private Const KI_NROSERIE                       As Integer = 16
Private Const KI_GRUPO                          As Integer = 17
Private Const KI_UNIDAD                         As Integer = 19
Private Const KI_PRFK_ID                        As Integer = 20
Private Const KI_RESUMIDO                       As Integer = 21
Private Const KI_ALTERNATIVAS                   As Integer = 22
Private Const KI_IDENTIDAD                      As Integer = 23

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
Private m_st_id1                       As Long
Private m_st_id2                       As Long

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

  If Not DocSecurityCanAccessEx(csPreStNewParteProdKit, _
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
  GetDocNumber m_LastDoc, m_ObjAbm, m_TaPropuesto, cscPpkNrodoc
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
  GetDocNumber m_LastDoc, m_ObjAbm, m_TaPropuesto, cscPpkNrodoc
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
      ShowEditState m_DocEditMsg, LNGGetText(1993, vbNullString)  'Partes de Producción de Kit
      
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
      
      If m_Id Then
      
        Dim AbmObj As cABMGeneric
        Set AbmObj = m_ObjAbm
      
        AbmObj.ShowPopMenu LNGGetText(1714, vbNullString) & "~1|" & LNGGetText(1716, vbNullString) & "~2|" & LNGGetText(1994, vbNullString) & "~3"
                          'Ver &Consumo~1|Ver &Producción~2|Ver &Ambos~3
      Else
        MsgInfo LNGGetText(1620, vbNullString)
              'Debe editar un comprobante guardado para poder ver los documentos auxiliares
      End If
      
    Case MSG_MENU_AUX
      
      Select Case Val(Info)
        Case 1 ' Consumo
          ShowDocAux m_st_id2, _
                     "CSStock2.cStock", _
                     "CSABMInterface2.cABMGeneric"

        Case 2 ' Produccion
          ShowDocAux m_st_id1, _
                     "CSStock2.cStock", _
                     "CSABMInterface2.cABMGeneric"
        
        Case 3 ' Ambos
          ShowDocAux m_st_id1, _
                     "CSStock2.cStock", _
                     "CSABMInterface2.cABMGeneric"
          ShowDocAux m_st_id2, _
                     "CSStock2.cStock", _
                     "CSABMInterface2.cABMGeneric"

      End Select
  
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
        GetDocNumber m_LastDoc, m_ObjAbm, m_TaPropuesto, cscPpkNrodoc
        
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
  If Not pGNGAux() Then
  If Not DocCanEdit(m_DocEditable, m_DocEditMsg) Then
    cIABMClient_Save = True
    Exit Function
  End If
  End If
  If Not DocCanSave(m_ObjAbm, cscPpkFecha) Then
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
  register.fieldId = cscPpkTMPId
  register.Table = csTParteProdKitTMP
  
  register.Id = csNew
    
  If m_Copy Then
    register.Fields.Add2 cscPpkId, csNew, csLong
  Else
    register.Fields.Add2 cscPpkId, m_Id, csLong
  End If
  
  Dim IProperty As cIABMProperty
  For Each IProperty In m_ObjAbm.Properties
    With IProperty
      Select Case .Key
        Case K_NUMERO
          register.Fields.Add2 cscPpkNumero, .Value, csLong
        Case K_NRODOC
          register.Fields.Add2 cscPpkNrodoc, .Value, csText
        Case K_DESCRIP
          register.Fields.Add2 cscPpkDescrip, .Value, csText
        Case K_FECHA
          register.Fields.Add2 cscPpkFecha, .Value, csDate
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
  
  sqlstmt = "sp_DocParteProdKitSave " & register.Id
  
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
  cIABMClient_Title = LNGGetText(1995, vbNullString)    'Parte Producción Kit
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
  cIEditGeneric_ShowList = SecurityCanAccess(csPreStListParteProdKit)
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
                          csTParteProdKit, _
                          cscPpkId, _
                          doc_id) Then
      Exit Function
    End If
  End If
  
  If Not DocSecurityCanAccess( _
                  csPreStDeleteParteProdKit, _
                  doc_id, _
                  csEDocTPreDelete) Then
    Exit Function
  End If

  Dim sqlstmt As String
  
  sqlstmt = "sp_DocParteProdKitDelete " & Id & "," & EmpId & "," & User.Id
  
  cIEditGeneric_Delete = gDB.Execute(sqlstmt, "cIEditGeneric_Delete", C_Module)
End Function

Private Function cIEditGeneric_Search(Id As Long, Cancela As Boolean) As Boolean

End Function

Private Function cIEditGeneric_Edit(Id As Long, Optional ByVal InModalWindow As Boolean) As Boolean
  On Error GoTo ControlError
  
  If Not DocSecurityCanAccess(csPreStListParteProdKit, GetdocIdFromObjAbm(m_ObjAbm), csEDocTPreList) Then Exit Function
  
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
    
    Case KI_NROSERIE
      Set Row = IProperty.Grid.Rows(lRow)
      If Not Row Is Nothing Then
        pColumnBeforeEdit = pCell(Row, KI_PR_LLEVANROSERIE).Id _
                         Or pCell(Row, KI_ALTERNATIVAS).Id
      End If
    
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
        
      Case KI_CANTIDAD
        
        Dim bLlevaSerie As Boolean
        Dim bIdentidad  As Boolean
        Dim bAlts       As Boolean
        
        Set Row = .Rows(lRow)
        
        bLlevaSerie = pCell(Row, KI_PR_LLEVANROSERIE).Id
        bIdentidad = pCell(Row, KI_IDENTIDAD).Id
        bAlts = pCell(Row, KI_ALTERNATIVAS).Id
        
        If bIdentidad Or bAlts Then

          If Not pNroSerieCantidadChanged(Row, _
                                          lRow, _
                                          NewValue, _
                                          bAlts, _
                                          bIdentidad) Then Exit Function
        ElseIf bLlevaSerie Then
        
          Dim PrId As Long
          
          PrId = pCell(Row, KI_PR_ID).Id
        
          If Not NroSerieCantidadChanged(Row, _
                                         lRow, _
                                         KI_CANTIDAD, _
                                         NewValue, _
                                         KI_GRUPO, _
                                         m_NrosSerie, _
                                         KI_PR_ID, _
                                         KI_NROSERIE, _
                                         PrId, _
                                         pGetDeplId(), _
                                         False, _
                                         csNO_ID) Then Exit Function
        End If
    End Select
  End With
  
  pColumnAfterEdit = True
End Function

Private Function cIABMClientGrid_ColumnButtonClick(ByVal Key As Integer, _
                                                   ByVal lRow As Long, _
                                                   ByVal lCol As Long, _
                                                   ByVal iKeyAscii As Integer) As Boolean
  Dim Row         As cIABMGridRow
  Dim bLlevaSerie As Boolean
  Dim bIdentidad  As Boolean
  Dim bAlts       As Boolean
  
  Select Case Key
    Case K_ITEMS
      With m_Items.Properties.Item(c_Items).Grid
        Select Case .Columns(lCol).Key
          
          Case KI_NROSERIE
            
            Set Row = .Rows(lRow)
            bLlevaSerie = pCell(Row, KI_PR_LLEVANROSERIE).Id
            bIdentidad = pCell(Row, KI_IDENTIDAD).Id
            bAlts = pCell(Row, KI_ALTERNATIVAS).Id
            
            If bIdentidad Or bAlts Then
            
              cIABMClientGrid_ColumnButtonClick = pEditKits(Row, _
                                                            bAlts, _
                                                            bIdentidad, _
                                                            lRow, _
                                                            False, _
                                                            Val(pCell(Row, KI_CANTIDAD).Value))
            
            ElseIf bLlevaSerie Then
            
              Dim PrId As Long
              
              PrId = pCell(Row, KI_PR_ID).Id
              
              If m_cur_doct_id = csEDT_ParteDesarmeKit Then
            
                cIABMClientGrid_ColumnButtonClick = EditNroSeriePDK(pCell(Row, KI_GRUPO).Id, _
                                                                    Val(pCell(Row, KI_CANTIDAD).Value), _
                                                                    Row, _
                                                                    m_NrosSerie, _
                                                                    KI_GRUPO, _
                                                                    KI_NROSERIE, _
                                                                    lRow, _
                                                                    PrId, _
                                                                    pGetDeplId(), _
                                                                    False, True, GetKitInfo(PrId, m_CollKitInfo))
              Else
              
                cIABMClientGrid_ColumnButtonClick = EditNroSeriePPK(pCell(Row, KI_GRUPO).Id, _
                                                                    Val(pCell(Row, KI_CANTIDAD).Value), _
                                                                    Row, _
                                                                    m_NrosSerie, _
                                                                    KI_GRUPO, _
                                                                    KI_NROSERIE, _
                                                                    lRow, _
                                                                    PrId, _
                                                                    pGetDeplId(), _
                                                                    False, True, GetKitInfo(PrId, m_CollKitInfo))
              End If
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
  Dim Id As Long
  
  Id = Val(pCell(Row, KI_PPK_ID).Value)
  
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
  Dim bLlevaNroSerie        As Boolean
  
  strRow = " (Fila " & RowIndex & ")"
  
  For Each Cell In Row
    Select Case Cell.Key
      Case KI_CANTIDAD
        If ValEmpty(Cell.Value, csLong) Then
          MsgInfo LNGGetText(1365, vbNullString, strRow)   'Debe indicar una cantidad (1)
          Exit Function
        Else
          If Not pValidateItemCantidad(Row, RowIndex, Val(Cell.Value)) Then
            Exit Function
          End If
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
    End Select
  Next
  
  pValidateRow = True
End Function

Private Function pValidateItemCantidad(ByRef Row As CSInterfacesABM.cIABMGridRow, _
                                       ByVal lRow As Long, _
                                       ByVal Cantidad As Long) As Boolean
  
  Dim bLlevaSerie As Boolean
  Dim bIdentidad  As Boolean
  Dim bAlts       As Boolean
  
  Dim c_msg As String
  
  c_msg = LNGGetText(2275, vbNullString) & " "
          'Debe indicar los numeros de serie/alternativas (Fila"
  
  bLlevaSerie = pCell(Row, KI_PR_LLEVANROSERIE).Id
  bIdentidad = pCell(Row, KI_IDENTIDAD).Id
  bAlts = pCell(Row, KI_ALTERNATIVAS).Id
  
  If bIdentidad Or bAlts Then
    
    Dim KitLn As cKitLine
    Set KitLn = pGetKitLn(Row, lRow)
    
    If KitLn.Items.Count <> Cantidad Then
      MsgWarning c_msg & lRow & ")"
      Exit Function
    End If
  
  ElseIf bLlevaSerie Then
  
    Dim Grupo         As Long
    Dim NroSerieCount As Long
    
    Grupo = pCell(Row, KI_GRUPO).Id
    NroSerieCount = GetNroSerieCount(m_NrosSerie, Grupo)

    If NroSerieCount <> Cantidad Then
      MsgWarning c_msg & lRow & ")"
      Exit Function
    End If
  End If
  
  pValidateItemCantidad = True
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
        .Value = m_UserCfg.DocPpkNombre
        
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
    
    With .Add(Nothing, cscPpkFecha)
      .PropertyType = cspDate
      .Name = LNGGetText(1569, vbNullString)    'Fecha
      .LeftLabel = -580
      .Left = 700
      .Key = K_FECHA
      .Value = m_Fecha
    End With
    
    With .Add(Nothing, cscPpkNrodoc)
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
      .TopFromProperty = cscPpkFecha
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
    
    With .Add(Nothing, cscPpkDescrip)
      .PropertyType = cspText
      .SubType = cspMemo
      .Name = LNGGetText(1211, vbNullString)    'Observ.
      .LeftLabel = -600
      .Size = 5000
      .Key = K_DESCRIP
      .Value = m_Descrip
      .LeftFromProperty = cscPpkFecha
      .TopFromProperty = cscPpkNrodoc
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
  
  sqlstmt = "sp_DocParteProdKitGetItems " & m_Id
  
  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, "pLoadItems", C_Module) Then Exit Function
  
  With Propiedad.Grid
  
    .Columns.Clear
    .Rows.Clear
  
    With .Columns
      With .Add(Nothing)
        .Visible = False
        .Key = KI_PPK_ID
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
        .Name = LNGGetText(1997, vbNullString)    'Nro. Serie/Lote/Alt.
        .PropertyType = cspText
        .SubType = cspTextButton
        .Width = 3000
        .Key = KI_NROSERIE
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
          
      With .Add(Nothing)
        .Visible = False
        .Key = KI_RESUMIDO
      End With
      
      With .Add(Nothing)
        .Visible = False
        .Key = KI_ALTERNATIVAS
      End With
    
      With .Add(Nothing)
        .Visible = False
        .Key = KI_IDENTIDAD
      End With
    
    End With
  
    With .Rows
  
      While Not rs.EOF
      
        With .Add(Nothing, rs(cscPpkiId).Value)
        
          With .Add(Nothing)
            .Value = gDB.ValField(rs.Fields, cscPpkiId)
            .Key = KI_PPK_ID
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.Fields, cscPrNombrecompra)
            .Id = gDB.ValField(rs.Fields, cscPrId)
            .Key = KI_PR_ID
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.Fields, cscPpkiDescrip)
            .Key = KI_DESCRIP
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.Fields, cscPpkiCantidad)
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
            .Value = vbNullString
            .Key = KI_NROSERIE
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
            .Id = gDB.ValField(rs.Fields, cscPpkiId)
            .Key = KI_GRUPO
          End With
          
          With .Add(Nothing)
            .Id = gDB.ValField(rs.Fields, cscPrKitResumido)
            .Key = KI_RESUMIDO
          End With
          
          With .Add(Nothing)
            .Id = gDB.ValField(rs.Fields, cscKitAlternativas)
            .Key = KI_ALTERNATIVAS
          End With
          
          With .Add(Nothing)
            .Id = gDB.ValField(rs.Fields, cscPrKitIdentidad)
            .Key = KI_IDENTIDAD
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
  Dim coll      As Collection
  Dim NrosSerie As String
  
  CollClear m_NrosSerie
  
  Set rs = rs.NextRecordset
  
  While Not rs.EOF
    
    ' Si cambie de grupo
    If CurGroup <> gDB.ValField(rs.Fields, cscPpkiId) Then
    
      pSetNrosSerieInRow CurGroup, NrosSerie
      NrosSerie = vbNullString
    
      CurGroup = gDB.ValField(rs.Fields, cscPpkiId)
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
      .pr_id_kit = gDB.ValField(rs.Fields, cscPrIdKit)
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
  
  '//////////////////////////////////////////////////
  ' Kit - Nueva Versión
  '//////////////////////////////////////////////////
  If Not pLoadKitItems(rs, Propiedad.Grid.Rows) Then Exit Function
  
  pLoadItems = True
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

Private Function Load(ByVal Id As Long) As Boolean
  Dim sqlstmt As String

  sqlstmt = "sp_DocParteProdKitGet " & EmpId & "," & Id & "," & gDB.UserId
  
  Dim rs As Recordset

  m_Kits.Clear

  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, C_LoadFunction, C_Module) Then Exit Function

  If Not rs.EOF Then

    m_Id = gDB.ValField(rs.Fields, cscPpkId)
    m_Numero = gDB.ValField(rs.Fields, cscPpkNumero)
    m_Nrodoc = gDB.ValField(rs.Fields, cscPpkNrodoc)
    m_Descrip = gDB.ValField(rs.Fields, cscPpkDescrip)
    m_Fecha = gDB.ValField(rs.Fields, cscPpkFecha)
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
    m_st_id1 = gDB.ValField(rs.Fields, cscStId1)
    m_st_id2 = gDB.ValField(rs.Fields, cscStId2)

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
    m_st_id1 = csNO_ID
    m_st_id2 = csNO_ID
  
    m_TaPropuesto = False
    m_TaMascara = vbNullString
    
    pGetCurrentDocId
  
    DocEditableGet m_doc_id, m_DocEditable, m_DocEditMsg, csPreStNewParteProdKit
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
  m_Host.Server.AddMenu LNGGetText(1999, vbNullString), csPreStListParteProdKit, str_1998, 0, True, False, False, False, False, Me
                          '&Parte de Producción de Kit
  cIMenuClient_Initialize = True
  
  GoTo ExitProc
ControlError:
  MngError Err, "cIMenuClient_Initialize", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Private Function cIMenuClient_ProcessMenu(ByVal Id As Long) As Variant
  m_Host.MenuListDocClick "CSABMInterface2.CABMGeneric", "CSStock2.cParteProdKit", "CSABMInterface2.CABMGenericListDoc", "CSStock2.cParteProdKitListDoc", Me, LNGGetText(2000, vbNullString), 0
                                                                                                                                                              'Parte de Producción de Kit
End Function

Private Function pSaveItems(ByVal ppkTMP_Id As Long) As Boolean
  
  ' Generales
  '
  Dim register  As cRegister
  Dim iOrden    As Long
  Dim Row       As cIABMGridRow
  Dim Cell      As cIABMGridCellValue
  
  Dim bIdentidad  As Boolean
  Dim bAlts       As Boolean
  
  ' Para numeros de serie
  '
  Dim iOrden2     As Long
  Dim Grupo       As Long
  Dim PrId        As Long
  
  Dim lRow As Long
  
  For Each Row In m_Items.Properties(c_Items).Grid.Rows
  
    lRow = lRow + 1
  
    Set register = New cRegister
    With register
    
      .fieldId = cscPpkiTMPId
      .Table = csTParteProdKitItemTMP
      .Id = csNew
    
      With .Fields
    
        For Each Cell In Row
          Select Case Cell.Key
            
            Case KI_PPK_ID
              If m_Copy Then
                .Add2 cscPpkiId, csNew, csInteger
              Else
                .Add2 cscPpkiId, Val(Cell.Value), csInteger
              End If
            Case KI_CANTIDAD
              .Add2 cscPpkiCantidad, Cell.Value, csDouble
            Case KI_DESCRIP
              .Add2 cscPpkiDescrip, Cell.Value, csText
            Case KI_PR_ID
              PrId = Cell.Id
              .Add2 cscPrId, PrId, csId
            Case KI_GRUPO
              Grupo = Cell.Id
            Case KI_PRFK_ID
              .Add2 cscPrfkId, Cell.Id, csId
          End Select
        Next
        
        iOrden = iOrden + 1
        .Add2 cscPpkiOrden, iOrden, csInteger
        .Add2 cscPpkTMPId, ppkTMP_Id, csId
        .Add2 cscDeplId, m_ObjAbm.Properties.Item(cscDeplId).HelpId, csId
        
        .HaveLastUpdate = False
        .HaveWhoModify = False
        
      End With
    
      If Not gDB.Save(register, , _
                      "pSaveItems", _
                      C_Module, _
                      c_ErrorSave) Then Exit Function
      
      ' Determino si es un Kit de los nuevos
      ' o de los viejos
      '
      bIdentidad = pCell(Row, KI_IDENTIDAD).Id
      bAlts = pCell(Row, KI_ALTERNATIVAS).Id
      
      If bIdentidad Or bAlts Then
        
        If bIdentidad Then
          
          ' Vamos con el nuevo invento
          '
          If Not pSaveItemNroSerieEx(Row, _
                                     ppkTMP_Id, _
                                     .Id, _
                                     lRow) Then Exit Function
                                   
        Else
        
          ' Vamos con el nuevo invento
          '
          If Not pSaveItemAlts(Row, _
                               ppkTMP_Id, _
                               .Id, _
                               lRow) Then Exit Function
        
        End If
        
      Else
        
        ' Si es nuevo se usa el orden
        ' Vamos por el sabor clasico
        '
        If Grupo = 0 Then Grupo = iOrden * -1
        If Not pSaveItemNroSerie(Row, _
                                 iOrden2, _
                                 PrId, _
                                 ppkTMP_Id, _
                                 .Id, _
                                 Grupo) Then Exit Function
      End If
    
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
      register.fieldId = cscPpkibTMPId
      register.Table = csTParteProdKitItemBorradoTMP
      register.Id = csNew
      
      register.Fields.Add2 cscPpkiId, Val(vDeletes(i)), csInteger
      register.Fields.Add2 cscPpkId, m_Id, csId
      register.Fields.Add2 cscPpkTMPId, ppkTMP_Id, csId
      
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
    pCell(Row, KI_PR_LLEVANROSERIE).Id = gDB.ValField(rs.Fields, cscPrLlevaNroSerie)
    pCell(Row, KI_ES_KIT).Id = bEsKit
    pCell(Row, KI_RESUMIDO).Id = gDB.ValField(rs.Fields, cscPrKitResumido)
    pCell(Row, KI_ALTERNATIVAS).Id = gDB.ValField(rs.Fields, cscKitAlternativas)
    pCell(Row, KI_IDENTIDAD).Id = gDB.ValField(rs.Fields, cscPrKitIdentidad)
    
    If bChanged Then
      With pCell(Row, KI_PRFK_ID)
        .Id = gDB.ValField(rs.Fields, cscPrfkId)
        .Value = gDB.ValField(rs.Fields, cscPrfkNombre)
      End With
    End If
    
    If bEsKit Then
    
      Dim coll    As Collection
    
      sqlstmt = "sp_StockProductoGetKitInfo " & pr_id & ",1,0,1,1,1"
      If Not gDB.OpenRs(sqlstmt, rs) Then Exit Sub
      
      Set coll = GetCollKitInfoXPrId(pr_id, m_CollKitInfo)
      
      While Not rs.EOF
        pr_id = gDB.ValField(rs.Fields, cscPrId)
        With GetKitInfoItem(coll, pr_id)
          .pr_id = pr_id
          .Nombre = gDB.ValField(rs.Fields, cscPrNombrecompra)
          .Cantidad = gDB.ValField(rs.Fields, "cantidad")
          .LlevaNroSerie = gDB.ValField(rs.Fields, cscPrLlevaNroSerie)
          .pr_id_kit = gDB.ValField(rs.Fields, cscPrIdKit)
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
  
  sqlstmt = "sp_DocParteProdKitMover " & MoveTo & "," & m_Numero & "," & doc_id
  
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
        GetDocNumber m_LastDoc, m_ObjAbm, m_TaPropuesto, cscPpkNrodoc
    
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
    
    Set c = .Item(cscPpkFecha)
    c.Value = m_Fecha
    
    Set c = .Item(csDocNumberID)
    c.Value = m_Numero
    
    Set c = .Item(cscPpkNrodoc)
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
    
    Set c = .Item(cscPpkDescrip)
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
  
  c_ErrorSave = LNGGetText(2001, vbNullString) 'Error al grabar el Parte de Producción de Kit
  
  Set m_Kits = New cKitLines
  Set m_NrosSerie = New Collection
  Set m_GeneralConfig = New cGeneralConfig
  m_GeneralConfig.Load

  ' Preferencias del Usuario
  '
  Set m_UserCfg = New cUsuarioConfig
  m_UserCfg.Load
  m_UserCfg.ValidatePPK

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

'////////////////////////////////////////////////////////////////////////////////
' Kits Grabación de la Nueva Versión
'
Private Function pSaveItemAlts(ByRef Row As CSInterfacesABM.cIABMGridRow, _
                               ByVal PpkTMPId As Long, _
                               ByVal PpkiTMPId As Long, _
                               ByVal lRow As Long) As Boolean
                               
  Dim KitLn As cKitLine
  Dim Kit   As cKit
  Dim i     As Long
  
  ' Obtengo el KitLn para esta linea
  '
  Set KitLn = pGetKitLn(Row, lRow)
  
  For i = KitLn.Items.Count + 1 To Val(pCell(Row, KI_CANTIDAD).Value)
  
    If KitLn.KitType.prfk_id = 0 Then
    
      KitLn.KitType.prfk_id = pCell(Row, KI_PRFK_ID).Id
    
      If Not pLoadKitInfo(KitLn.KitType) Then Exit Function
    End If
  
    Set Kit = KitGetKit(KitLn, i)
    
    Dim KitAlt      As cKitItem
    Dim KitAltItem  As cKitAltItem
    Dim q           As Long
    
    q = 0
    
    For Each KitAlt In Kit.Alts
      q = q + 1
      If KitAlt.Items.Count = 0 Then
        Set KitAltItem = KitAlt.Items.Add()
        
        With KitLn.KitType.Alts(q)
          KitAltItem.Cantidad = .Cantidad
          KitAltItem.pr_id = .pr_id
        End With
        
      End If
    Next
  Next
  
  ' Guardo cada kit de la linea
  '
  For Each Kit In KitLn.Items
    If Not pSaveKitAlt(Kit, PpkTMPId, PpkiTMPId) Then
      Exit Function
    End If
  Next
                                 
  pSaveItemAlts = True
End Function

Private Function pSaveItemNroSerieEx(ByRef Row As CSInterfacesABM.cIABMGridRow, _
                                     ByVal PpkTMPId As Long, _
                                     ByVal PpkiTMPId As Long, _
                                     ByVal lRow As Long) As Boolean
  
  Dim KitLn As cKitLine
  Dim Kit   As cKit
  
  ' Obtengo el KitLn para esta linea
  '
  Set KitLn = pGetKitLn(Row, lRow)
  
  ' Guardo cada kit de la linea
  '
  For Each Kit In KitLn.Items
    If Not pSaveKitEx(Kit, PpkTMPId, PpkiTMPId) Then
      Exit Function
    End If
  Next
  
  pSaveItemNroSerieEx = True
End Function

Private Function pSaveKitAlt(ByRef Kit As cKit, _
                             ByVal PpkTMPId As Long, _
                             ByVal PpkiTMPId As Long) As Boolean
  
  Dim KitAlt        As cKitItem
  Dim KitAltItem    As cKitAltItem
  Dim register      As cRegister
  
  For Each KitAlt In Kit.Alts
    
    For Each KitAltItem In KitAlt.Items
    
      Set register = New cRegister
      With register
        .fieldId = cscPpkiaTMPId
        .Table = csTParteProdKitItemATMP
        .Id = csNew
      
        With .Fields
          .Add2 cscPrId, KitAltItem.pr_id, csId
          .Add2 cscPpkiaCantidad, KitAltItem.Cantidad, csDouble
          .Add2 cscPrkId, KitAlt.prk_id, csId
          
          .Add2 cscPpkTMPId, PpkTMPId, csId
          .Add2 cscPpkiTMPId, PpkiTMPId, csId
      
          .HaveLastUpdate = False
          .HaveWhoModify = False
        End With
      End With
      
      If Not gDB.Save(register, , _
                      "pSaveKitAlt", _
                      C_Module, _
                      c_ErrorSave) Then Exit Function
    Next
  Next
  
  pSaveKitAlt = True
End Function

Private Function pSaveKitSerie(ByRef Kit As cKit, _
                               ByVal PpkTMPId As Long, _
                               ByVal PpkiTMPId As Long, _
                               ByRef PrskTMPId) As Boolean
                               
  Dim register        As cRegister
    
  Set register = New cRegister
  With register
    .fieldId = cscPrskTMPId
    .Table = csTProductoSerieKitTMP
    .Id = csNew
  
    With .Fields
      .Add2 cscPrskId, Kit.prsk_id, csInteger
      .Add2 cscPrId, Kit.pr_id, csId
      
      .Add2 cscPrnsId, Kit.prns_id, csId
      .Add2 cscPrnsCodigo, Kit.prns_codigo, csText
      
      .Add2 cscStlId, Kit.stl_id, csId
      .Add2 cscStlCodigo, Kit.stl_codigo, csText
      
      .Add2 cscPrfkId, Kit.prfk_id, csId
      
      
      .Add2 cscPpkTMPId, PpkTMPId, csId
      .Add2 cscPpkiTMPId, PpkiTMPId, csId
  
      .HaveLastUpdate = False
      .HaveWhoModify = False
    End With
  
    If Not gDB.Save(register, , _
                    "pSaveKitSerie", _
                    C_Module, _
                    c_ErrorSave) Then Exit Function
                   
    PrskTMPId = .Id
    
    If Not pSaveKitSerieItem(Kit, _
                             PpkTMPId, _
                             PpkiTMPId, _
                             PrskTMPId) Then Exit Function
  End With
  
  pSaveKitSerie = True
End Function

Private Function pSaveKitSerieItem(ByRef Kit As cKit, _
                                   ByVal PpkTMPId As Long, _
                                   ByVal PpkiTMPId As Long, _
                                   ByVal PrskTMPId As Long) As Boolean
                                   
  Dim KitSerie        As cKitSerie
  Dim KitSerieItem    As cKitSerieNumber
  Dim register        As cRegister
  Dim pr_id           As Long
  
  For Each KitSerie In Kit.Series
                                   
    ' Los items auxiliares que agrego
    ' para editar la identidad o el lote
    ' cuando el producto indica un talonario
    ' no se guardan en KitSerieItem ya que no
    ' tienen prk_id
    '
    If KitSerie.prk_id Then
                                   
      For Each KitSerieItem In KitSerie.Items
      
        Set register = New cRegister
        With register
          .fieldId = cscPrskiTMPId
          .Table = csTProductoSerieKitItemTMP
          .Id = csNew
        
          With .Fields
            
            pr_id = KitSerieItem.pr_id
            If pr_id = csNO_ID Then
              pr_id = KitSerie.pr_id
            End If
            
            .Add2 cscPrId, pr_id, csId
            .Add2 cscPrnsId, KitSerieItem.prns_id, csId
            .Add2 cscPrskiCantidad, 1, csDouble
            
            .Add2 cscPrkId, KitSerie.prk_id, csId
            
            .Add2 cscPpkTMPId, PpkTMPId, csId
            .Add2 cscPpkiTMPId, PpkiTMPId, csId
            .Add2 cscPrskTMPId, PrskTMPId, csId
        
            .HaveLastUpdate = False
            .HaveWhoModify = False
          End With
        End With
        
        If Not gDB.Save(register, , _
                        "pSaveKitSerieItem", _
                        C_Module, _
                        c_ErrorSave) Then Exit Function
      Next
      
    End If
  Next
  
  pSaveKitSerieItem = True
End Function

Private Function pSaveKitLote(ByRef Kit As cKit, _
                              ByVal PpkTMPId As Long, _
                              ByVal PpkiTMPId As Long, _
                              ByVal PrskTMPId As Long) As Boolean
                                   
  Dim KitLote         As cKitLote
  Dim KitLoteItem     As cKitLoteNumber
  Dim register        As cRegister
  Dim pr_id           As Long
  
  For Each KitLote In Kit.Lotes
                                   
    ' Los items auxiliares que agrego
    ' para editar la identidad o el lote
    ' cuando el producto indica un talonario
    ' no se guardan en KitSerieItem ya que no
    ' tienen prk_id
    '
    If KitLote.prk_id Then
                                     
      For Each KitLoteItem In KitLote.Items
      
        Set register = New cRegister
        With register
          .fieldId = cscPrskiTMPId
          .Table = csTProductoSerieKitItemTMP
          .Id = csNew
        
          With .Fields
            
            pr_id = KitLoteItem.pr_id
            If pr_id = csNO_ID Then
              pr_id = KitLote.pr_id
            End If
            
            .Add2 cscPrId, pr_id, csId
            .Add2 cscStlId, KitLoteItem.stl_id, csId
            .Add2 cscPrskiCantidad, KitLoteItem.Cantidad, csDouble
            
            .Add2 cscPrkId, KitLote.prk_id, csId
            
            .Add2 cscPpkTMPId, PpkTMPId, csId
            .Add2 cscPpkiTMPId, PpkiTMPId, csId
            .Add2 cscPrskTMPId, PrskTMPId, csId
        
            .HaveLastUpdate = False
            .HaveWhoModify = False
          End With
        End With
        
        If Not gDB.Save(register, , _
                        "pSaveKitLote", _
                        C_Module, _
                        c_ErrorSave) Then Exit Function
      Next
      
    End If
  Next
  
  pSaveKitLote = True
End Function

Private Function pSaveKitSerieAlt(ByRef Kit As cKit, _
                                  ByVal PpkTMPId As Long, _
                                  ByVal PpkiTMPId As Long, _
                                  ByVal PrskTMPId As Long) As Boolean
                                   
  Dim KitAlt         As cKitItem
  Dim KitAltItem     As cKitAltItem
  Dim register       As cRegister
  
  For Each KitAlt In Kit.Alts
                                   
    For Each KitAltItem In KitAlt.Items
    
      Set register = New cRegister
      With register
        .fieldId = cscPrskiTMPId
        .Table = csTProductoSerieKitItemTMP
        .Id = csNew
      
        With .Fields
          
          .Add2 cscPrId, KitAltItem.pr_id, csId
          .Add2 cscPrskiCantidad, IIf(KitAltItem.Cantidad, KitAltItem.Cantidad, 1), csDouble
          
          .Add2 cscPrkId, KitAlt.prk_id, csId
          
          .Add2 cscPpkTMPId, PpkTMPId, csId
          .Add2 cscPpkiTMPId, PpkiTMPId, csId
          .Add2 cscPrskTMPId, PrskTMPId, csId
      
          .HaveLastUpdate = False
          .HaveWhoModify = False
        End With
      End With
      
      If Not gDB.Save(register, , _
                      "pSaveKitAlt", _
                      C_Module, _
                      c_ErrorSave) Then Exit Function
    Next
  Next
  
  pSaveKitSerieAlt = True
End Function

Private Function pSaveKitVar(ByRef Kit As cKit, _
                             ByVal PpkTMPId As Long, _
                             ByVal PpkiTMPId As Long, _
                             ByVal PrskTMPId As Long) As Boolean
                                   
  Dim KitVar         As cKitVar
  Dim register       As cRegister
  
  For Each KitVar In Kit.Vars
    
    Set register = New cRegister
    With register
      .fieldId = cscPrskiTMPId
      .Table = csTProductoSerieKitItemTMP
      .Id = csNew
    
      With .Fields
        
        .Add2 cscPrId, KitVar.pr_id, csId
        .Add2 cscPrskiCantidad, KitVar.Cantidad, csDouble
        
        .Add2 cscPrkId, KitVar.prk_id, csId
        
        .Add2 cscPpkTMPId, PpkTMPId, csId
        .Add2 cscPpkiTMPId, PpkiTMPId, csId
        .Add2 cscPrskTMPId, PrskTMPId, csId
    
        .HaveLastUpdate = False
        .HaveWhoModify = False
      End With
    End With
    
    If Not gDB.Save(register, , _
                    "pSaveKitVar", _
                    C_Module, _
                    c_ErrorSave) Then Exit Function
  Next
  
  pSaveKitVar = True
End Function

Private Function pSaveKitEx(ByRef Kit As cKit, _
                            ByVal PpkTMPId As Long, _
                            ByVal PpkiTMPId As Long) As Boolean
                            
  Dim PrskTMPId As Long
                            
  ' Guardo los Numeros de serie
  '
  If Not pSaveKitSerie(Kit, _
                       PpkTMPId, _
                       PpkiTMPId, _
                       PrskTMPId) Then Exit Function
  
  ' Guardo los Lotes
  '
  If Not pSaveKitLote(Kit, _
                      PpkTMPId, _
                      PpkiTMPId, _
                      PrskTMPId) Then Exit Function
  
  ' Guardo las alternativas
  '
  If Not pSaveKitSerieAlt(Kit, _
                          PpkTMPId, _
                          PpkiTMPId, _
                          PrskTMPId) Then Exit Function
  
  ' Guardo las variables
  '
  If Not pSaveKitVar(Kit, _
                     PpkTMPId, _
                     PpkiTMPId, _
                     PrskTMPId) Then Exit Function
                            
  pSaveKitEx = True
End Function

'////////////////////////////////////////////////////////////////////////////////
' Kits Grabación de la Vieja Versión
'
Private Function pSaveItemNroSerie(ByRef Row As CSInterfacesABM.cIABMGridRow, _
                                   ByRef iOrden As Long, _
                                   ByVal PrId As Long, _
                                   ByVal PpkTMPId As Long, _
                                   ByVal PpkiTMPId As Long, _
                                   ByVal Grupo As Long) As Boolean
                                   
  Dim pt              As cProductoSerieType
  Dim register        As cRegister
  
  ' Si lleva numero de serie
  '
  If pCell(Row, KI_PR_LLEVANROSERIE).Id Then
  
    ' Obtengo los numeros de serie y guardo un Item por cada uno
    '
    For Each pt In m_NrosSerie.Item(GetKey(Grupo))
        
      Set register = New cRegister
      With register
        .fieldId = cscPpkisTMPId
        .Table = csTParteProdKitItemSerieTMP
        .Id = csNew
      
        With .Fields
          .Add2 cscPrId, PrId, csId
          .Add2 cscPrnsId, pt.prns_id, csId
          .Add2 cscPrnsCodigo, pt.Codigo, csText
          .Add2 cscPrnsDescrip, pt.Descrip, csText
          .Add2 cscPrnsFechavto, pt.FechaVto, csDate
          .Add2 cscPrIdItem, pt.pr_id_item, csId
          .Add2 cscPrIdKit, pt.pr_id_kit, csId
      
          .Add2 cscPpkTMPId, PpkTMPId, csId
          .Add2 cscPpkiTMPId, PpkiTMPId, csId
      
          iOrden = iOrden + 1
          .Add2 cscPpkisOrden, iOrden, csInteger
      
          .HaveLastUpdate = False
          .HaveWhoModify = False
        End With
      End With
      
      If Not gDB.Save(register, , _
                      "pSaveItemNroSerie", _
                      C_Module, _
                      c_ErrorSave) Then Exit Function
    Next
  End If
  
  pSaveItemNroSerie = True
End Function

Private Sub pGetCurrentDocId()
  Dim DocId As Long
  
  If m_ObjAbm.Properties.Item(cscDocId) Is Nothing Then Exit Sub
  
  DocId = m_ObjAbm.Properties.Item(cscDocId).HelpId
  
  gDB.GetData csTDocumento, cscDocId, DocId, cscDoctId, m_cur_doct_id
End Sub

' Borrar
'Private Sub pGNGStockAux()
'  Dim sqlstmt As String
'  Dim rs As ADODB.Recordset
'  sqlstmt = "sp_GNGStockAux"
'
'
'  If User.Id <> 1 Then Exit Sub
'
'  If Not Ask(LNGGetText(2002, vbNullString), vbNo) Then Exit Sub
'            'Desea ejecutar este proceso
'  If Not Ask(LNGGetText(2003, vbNullString), vbNo) Then Exit Sub
'            'Está realmente seguro?
'  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Sub
'
'  Dim ppk      As cParteProdKit
'  Dim iEdit    As cIEditGenericDoc
'  Dim iEdit2   As cIEditGeneric
'  Dim sec      As Long
'
'  While Not rs.EOF
'
'    Set ppk = New cParteProdKit
'    Set iEdit = ppk
'    Set iEdit2 = ppk
'
'    Set iEdit2.ObjAbm = New cABMGeneric
'    Set iEdit.Items = New cABMGeneric
'    Set iEdit.Footer = New cABMGeneric
'
'    ppk.Edit gDB.ValField(rs.Fields, "ppk_id")
'    DoEvents
'
'    iEdit2.ObjAbm.ObjForm.Caption = sec
'    DoEvents
'
'    sec = ppk.Save()
'    DoEvents
'
'    rs.MoveNext
'  Wend
'
'End Sub

'////////////////////////////////////////////////////////////////////////////////
' Kits Edición de la Nueva Versión
'
Friend Sub Edit(ByVal ppk_id As Long)
  cIEditGeneric_Edit ppk_id
End Sub

Friend Function Save() As Long
  Dim t As Single
  t = Timer
  cIABMClient_Save
  Unload m_ObjAbm.ObjForm
  Save = Timer - t
End Function

Private Function pGNGAux() As Boolean
  pGNGAux = True
End Function

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

Private Function pNroSerieCantidadChanged(ByRef Row As cIABMGridRow, _
                                          ByVal lRow As Long, _
                                          ByVal NewValue As Double, _
                                          ByVal bAlts As Boolean, _
                                          ByVal bIdentidad As Boolean) As Boolean
  Dim OldValue As Double
  OldValue = Val(pCell(Row, KI_CANTIDAD).Value)
  
  If OldValue <> NewValue And OldValue > 0 Then
    
    Dim KitLn As cKitLine
    Set KitLn = pGetKitLn(Row, lRow)
    
    If KitLn.Items.Count > NewValue Then
      If Not pDeleteNroSerie(Row, _
                             bAlts, _
                             bIdentidad, _
                             lRow, _
                             KitLn.Items.Count) Then Exit Function
    Else
      
      ' Si ya hay informacion cargada
      ' para este renglon le muestro la ventana
      ' de carga de numeros de serie, sino
      ' espero a que llegue a la columna
      ' para darle una oportunidad de elegir
      ' la formula de kit
      '
      If KitLn.Items.Count Then
        If Not pEditKits(Row, _
                         bAlts, _
                         bIdentidad, _
                         lRow, False, _
                         NewValue) Then
          Exit Function
        End If
      End If
    End If
  End If
  pNroSerieCantidadChanged = True
End Function

Private Function pDeleteNroSerie(ByRef Row As cIABMGridRow, _
                                 ByVal bAlts As Boolean, _
                                 ByVal bIdentidad As Boolean, _
                                 ByVal lRow As Long, _
                                 ByVal Cantidad As Long) As Boolean

  ' Solo se puede modificar la cantidad
  ' en un parte de producción en menos
  ' cuando el parte es nuevo.
  '
  ' Para partes ya guardados hay que hacer un
  ' parte de desarme
  '
  If m_Id <> csNO_ID Then
    MsgWarning C_MSG_EDIT_CHANGE_CANT
    Exit Function
  End If

  pDeleteNroSerie = pEditKits(Row, _
                              bIdentidad, _
                              bAlts, _
                              lRow, _
                              True, _
                              Cantidad)
End Function

Private Function pEditKits(ByRef Row As cIABMGridRow, _
                           ByVal bIdentidad As Boolean, _
                           ByVal bAlts As Boolean, _
                           ByVal lRow As Long, _
                           ByVal bDelete As Boolean, _
                           ByVal Cantidad As Long) As Boolean

  Dim KitLn     As cKitLine
  Dim prfk_id   As Long
  Dim OldCant   As Long
  
  Set KitLn = pGetKitLn(Row, lRow)
  If KitLn Is Nothing Then Exit Function
  
  OldCant = KitLn.Items.Count
  
  KitLn.KitType.Cantidad = Cantidad
  With pCell(Row, KI_PR_ID)
    KitLn.KitType.Nombre = .Value
    KitLn.KitType.pr_id = .Id
  End With
  
  prfk_id = pCell(Row, KI_PRFK_ID).Id
  If KitLn.KitType.prfk_id <> prfk_id Then
    KitLn.KitType.prfk_id = prfk_id
    If Not pLoadKitInfo(KitLn.KitType) Then Exit Function
    pApplyFormulaInKits KitLn
  End If
  
  Dim KEdit As cKitEdit
  Set KEdit = New cKitEdit
  
  If Not KEdit.Edit(KitLn, _
                    pGetDeplId(), _
                    m_Kits, _
                    Row, _
                    KI_NROSERIE, _
                    bDelete) Then
                         
    ' Si cancela elimino
    ' los nuevos kits que agrego
    ' la function pEditKits
    '
    Dim i As Long
    For i = OldCant + 1 To Cantidad
      KitLn.Items.Remove OldCant + 1
    Next
    Exit Function
  End If
  pEditKits = True
End Function

Private Function pGetKitLn(ByRef Row As cIABMGridRow, _
                           ByVal lRow As Long) As cKitLine
  Dim ppk_id As Long
  Dim Key    As String
  Dim rtn    As cKitLine
  
  ppk_id = Val(pCell(Row, KI_PPK_ID).Value)
  If ppk_id = csNO_ID Then ppk_id = lRow * -1
  Key = GetKey(ppk_id)
  
  Set rtn = m_Kits.Item(Key)
  If rtn Is Nothing Then
    Set rtn = m_Kits.Add(Key)
  End If
  
  Set pGetKitLn = rtn
End Function

Private Function pLoadKitInfo(ByRef Kit As cKit) As Boolean
  Dim sqlstmt As String
  
  With Kit
    .Series.Clear
    .Lotes.Clear
    .Alts.Clear
    .Vars.Clear
    .prns_id = csNO_ID
  End With
  
  If Not pLoadKitInfoHeader(Kit) Then Exit Function
  
  ' Si es un desarme la definicion del kit solo incluye
  ' el numero de serie que lo identifica cuando lleva
  ' identidad, o la descrepcion de sus alternativas cuando
  ' NO lleva identidad.
  '
  If m_cur_doct_id = csEDT_ParteDesarmeKit Then
  
    ' Para los desarmes si el kit
    ' tiene identidad cargamos como
    ' definicion del kit un numero de serie
    ' asociado al pr_id del kit
    '
    If Kit.bIdentidad Then
  
      Dim Item As cKitSerie
      Set Item = Kit.Series.Add(c_prk_id_desarme)
    
      Kit.pr_id_serie = Kit.pr_id
    
      With Item
        .Nombre = Kit.Nombre
        .pr_id = Kit.pr_id
        .prk_id = c_prk_id_desarme
        .Cantidad = 1
      End With
    
    ' Si no tiene identidad cargamos
    ' la definicion de sus alternativas
    ' ya que el usuario es el encargado
    ' de desarmar el kit y el sabra definir
    ' que alterntivas se utilizaron para el
    ' el armado del kit que se esta desarmando,
    ' si es que se utilizo alguna alternativa.
    '
    Else
    
      sqlstmt = "sp_stockProdutoFormulaKitGet " & Kit.prfk_id & "," & c_alts
      If Not pLoadKitInfoAux(Kit, sqlstmt, c_alts) Then Exit Function
    
    End If
    
  Else
    sqlstmt = "sp_stockProdutoFormulaKitGet " & Kit.prfk_id & "," & c_series
    If Not pLoadKitInfoAux(Kit, sqlstmt, c_series) Then Exit Function
    
    sqlstmt = "sp_stockProdutoFormulaKitGet " & Kit.prfk_id & "," & c_lotes
    If Not pLoadKitInfoAux(Kit, sqlstmt, c_lotes) Then Exit Function
    
    sqlstmt = "sp_stockProdutoFormulaKitGet " & Kit.prfk_id & "," & c_alts
    If Not pLoadKitInfoAux(Kit, sqlstmt, c_alts) Then Exit Function
    
    sqlstmt = "sp_stockProdutoFormulaKitGet " & Kit.prfk_id & "," & c_vars
    If Not pLoadKitInfoAux(Kit, sqlstmt, c_vars) Then Exit Function
  End If
  
  pLoadKitInfo = True
End Function

Private Function pLoadKitInfoHeader(ByRef Kit As cKit) As Boolean
  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  
  sqlstmt = "sp_stockProductoFormulaKitHGet " & Kit.prfk_id
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Function
  
  If Not rs.EOF Then
  
    With Kit
      .pr_id = gDB.ValField(rs.Fields, cscPrId)
      .bIdentidad = gDB.ValField(rs.Fields, "bIdentidad")
      .bIdentidadXItem = gDB.ValField(rs.Fields, "bIdentidadXItem")
      .bLote = gDB.ValField(rs.Fields, "bLote")
      .bLoteXItem = gDB.ValField(rs.Fields, "bLoteXItem")
      .ta_id_lote = gDB.ValField(rs.Fields, "ta_id_lote")
      .ta_id_serie = gDB.ValField(rs.Fields, "ta_id_serie")
      .pr_id_lote = gDB.ValField(rs.Fields, "pr_id_lote")
      .pr_id_serie = gDB.ValField(rs.Fields, "pr_id_serie")
      .bTalEditSerie = gDB.ValField(rs.Fields, "bTalEditSerie")
      .bTalEditLote = gDB.ValField(rs.Fields, "bTalEditLote")
    End With
  End If
  
  If Kit.bIdentidad Then
    
    ' Cuando son desarmes esto no se hace
    '
    If m_cur_doct_id <> csEDT_ParteDesarmeKit Then
      
      If Not Kit.bIdentidadXItem Then
      
        With Kit.Series.Add(0)
          .Nombre = Kit.Nombre
          .pr_id = Kit.pr_id
          .Cantidad = 1
          .ta_id = Kit.ta_id_serie
          .bTalEdit = Kit.bTalEditSerie
        End With
      
      End If
      
      If Kit.bLote And Not Kit.bLoteXItem Then
        
        With Kit.Lotes.Add(0)
          .Nombre = Kit.Nombre
          .pr_id = Kit.pr_id
          .Cantidad = 1
          .ta_id = Kit.ta_id_lote
          .bTalEdit = Kit.bTalEditLote
        End With
    
      End If
    End If
  End If
  
  pLoadKitInfoHeader = True
End Function

Private Function pLoadKitInfoAux(ByRef Kit As cKit, _
                                 ByVal sqlstmt As String, _
                                 ByVal itemType As Long) As Boolean
  Dim rs      As ADODB.Recordset
  Dim rsAlt   As ADODB.Recordset
  
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Function
  
  If itemType <> c_vars Then
    Set rsAlt = rs.NextRecordset
  End If
  
  While Not rs.EOF
    Select Case itemType
      Case c_series
        If Not pLoadKitInfoSerie(Kit, rs, rsAlt) Then Exit Function
      Case c_lotes
        If Not pLoadKitInfoLote(Kit, rs, rsAlt) Then Exit Function
      Case c_alts
        If Not pLoadKitInfoAlts(Kit, rs, rsAlt) Then Exit Function
      Case c_vars
        If Not pLoadKitInfoVars(Kit, rs) Then Exit Function
    End Select
    
    rs.MoveNext
  Wend
  
  pLoadKitInfoAux = True
End Function

Private Function pLoadKitInfoSerie(ByRef Kit As cKit, _
                                   ByRef rs As ADODB.Recordset, _
                                   ByRef rsAlt As ADODB.Recordset) As Boolean

  Dim Item As cKitSerie
  Set Item = Kit.Series.Add(0)
  pLoadKitItem Item, rs, rsAlt, True
  pLoadKitInfoSerie = True
  
End Function

Private Function pLoadKitInfoLote(ByRef Kit As cKit, _
                                  ByRef rs As ADODB.Recordset, _
                                  ByRef rsAlt As ADODB.Recordset) As Boolean

  Dim Item As cKitLote
  Set Item = Kit.Lotes.Add(0)
  pLoadKitItem Item, rs, rsAlt, True
  pLoadKitInfoLote = True
  
End Function

Private Function pLoadKitInfoAlts(ByRef Kit As cKit, _
                                  ByRef rs As ADODB.Recordset, _
                                  ByRef rsAlt As ADODB.Recordset) As Boolean

  Dim Item As cKitItem
  Set Item = Kit.Alts.Add(0)
  pLoadKitItem Item, rs, rsAlt, True
  pLoadKitInfoAlts = True
  
End Function

Private Function pLoadKitInfoVars(ByRef Kit As cKit, _
                                  ByRef rs As ADODB.Recordset) As Boolean

  Dim Item As cKitVar
  Set Item = Kit.Vars.Add(0)
  pLoadKitItem Item, rs, Nothing, False
  pLoadKitInfoVars = True
  
End Function

Private Sub pLoadKitItem(ByRef Item As Object, _
                         ByRef rs As ADODB.Recordset, _
                         ByRef rsAlt As ADODB.Recordset, _
                         ByVal bHaveAlts As Boolean)
  With Item
    .Nombre = gDB.ValField(rs.Fields, cscPrNombrecompra)
    .pr_id = gDB.ValField(rs.Fields, cscPrIdItem)
    .prk_id = gDB.ValField(rs.Fields, cscPrkId)
    .Cantidad = gDB.ValField(rs.Fields, cscPrkCantidad)
    If Not TypeOf Item Is cKitVar Then
      .Variable = gDB.ValField(rs.Fields, cscPrkVariable)
    End If
  End With
  
  If bHaveAlts Then
  
    If Not (rsAlt.EOF And rsAlt.BOF) Then
      rsAlt.MoveFirst
      While Not rsAlt.EOF
        
        If Item.prk_id = gDB.ValField(rsAlt.Fields, cscPrkId) Then
          pLoadKitItemAlt Item.Alts.Add(), rsAlt
        End If
        rsAlt.MoveNext
      Wend
    End If
  End If
End Sub

Private Sub pLoadKitItemAlt(ByRef Item As cKitAlt, _
                            ByRef rs As ADODB.Recordset)

  With Item
    .Nombre = gDB.ValField(rs.Fields, cscPrNombrecompra)
    .pr_id = gDB.ValField(rs.Fields, cscPrId)
  End With
End Sub

Private Function pGetDeplId() As Long
  pGetDeplId = m_ObjAbm.Properties(cscDeplId).HelpId
End Function

Private Function pLoadKitItems(ByRef rs As ADODB.Recordset, _
                               ByRef Rows As cIABMGridRows) As Boolean
  
  Dim sqlstmt As String
  Dim Key     As String
  Dim lRow    As Long
  Dim KitLn   As cKitLine
  Dim Row     As cIABMGridRow
  
  Dim ppki_id As Long
  Dim bFound  As Boolean
  
  Dim prns_id     As Long
  Dim stl_id      As Long
  Dim prk_id      As Long
  Dim last_prk_id As Long
  Dim iRowKey     As Long
  Dim iColKey     As Long
  Dim KitSerie    As cKitSerie
  Dim KitLote     As cKitLote
  Dim KitAlt      As cKitItem
  Dim KitVar      As cKitVar
  
  Dim bIsVar      As Boolean
  
  Dim rsKs    As ADODB.Recordset
  Dim rsKsI   As ADODB.Recordset
  Dim rsAlt   As ADODB.Recordset
  
  Dim strDescrip As String
  
  Set rsKs = rs.NextRecordset
  Set rsKsI = rs.NextRecordset
  Set rsAlt = rs.NextRecordset
  
  Dim coll    As Collection ' Es un cache de definiciones de
                            ' kits que ya lei desde la base de datos
                            ' para no estar leyendo varias veces
                            ' la misma definición
                               
  Set coll = New Collection
  
  For Each Row In Rows
  
    lRow = lRow + 1
    
    strDescrip = vbNullString
    
    ' Obtenemos el KitLn
    '
    Set KitLn = pGetKitLn(Row, lRow)
    
    ' Cargamos su definición
    '
    Key = "K" & pCell(Row, KI_PR_ID).Id & "-" & pCell(Row, KI_PRFK_ID).Id
    If ExistsObjectInColl(coll, Key) Then
      pCopyKitDef coll.Item(Key), KitLn.KitType ' No comparto definiciones
                                                ' de kits entre renglones
                                                ' por que pueden cambiar
    Else
      KitLn.KitType.prfk_id = pCell(Row, KI_PRFK_ID).Id
      If Not pLoadKitInfo(KitLn.KitType) Then Exit Function
    End If
    
    ' Ahora cargamos el KitLn
    '
    If Not (rsKs.EOF And rsKs.BOF) Then
      rsKs.MoveFirst
    End If
    
    ' Ahora cargamos el KitLn
    '
    If Not (rsKsI.EOF And rsKsI.BOF) Then
      rsKsI.MoveFirst
    End If
    
    ' Ahora cargamos el KitLn
    '
    If Not (rsAlt.EOF And rsAlt.BOF) Then
      rsAlt.MoveFirst
    End If
    
    bFound = False
    prk_id = csNO_ID
    iRowKey = 0
    
    ppki_id = Val(pCell(Row, KI_PPK_ID).Value)
    
    Do While Not rsKs.EOF
    
      If ppki_id = gDB.ValField(rsKs.Fields, cscPpkiId) Then
        
        iRowKey = iRowKey + 1
        iColKey = 0
        
        With KitGetKit(KitLn, iRowKey)
        
          .prns_id = gDB.ValField(rsKs.Fields, cscPrnsId)
          .prns_codigo = gDB.ValField(rsKs.Fields, cscPrnsCodigo)
          .stl_id = gDB.ValField(rsKs.Fields, cscStlId)
          .stl_codigo = gDB.ValField(rsKs.Fields, cscStlCodigo)
          .prsk_id = gDB.ValField(rsKs.Fields, cscPrskId)
        
          last_prk_id = 0
        
          Do While Not rsKsI.EOF
          
            If .prsk_id = gDB.ValField(rsKsI.Fields, cscPrskId) Then
            
              iColKey = iColKey + 1
            
              prk_id = gDB.ValField(rsKsI.Fields, cscPrkId)
              
              prns_id = gDB.ValField(rsKsI.Fields, cscPrnsId)
              stl_id = gDB.ValField(rsKsI.Fields, cscStlId)
              
              If prns_id Then
                
                If prk_id <> last_prk_id Then
                  last_prk_id = prk_id
                  Set KitSerie = .Series.Item(GetKey(prk_id))
                End If
                
                With KitSerie.Items.Add(KitGetKeyItem(iRowKey, iColKey))
                  .Nombre = gDB.ValField(rsKsI.Fields, cscPrNombrecompra)
                  .pr_id = gDB.ValField(rsKsI.Fields, cscPrId)
                  .prns_id = gDB.ValField(rsKsI.Fields, cscPrnsId)
                  .Serie = gDB.ValField(rsKsI.Fields, cscPrnsCodigo)
                  strDescrip = strDescrip & .Serie & ","
                End With
              
              ElseIf stl_id Then
              
                If prk_id <> last_prk_id Then
                  last_prk_id = prk_id
                  Set KitLote = .Lotes.Item(GetKey(prk_id))
                End If
                
                With KitLote.Items.Add(KitGetKeyItem(iRowKey, iColKey))
                  .Nombre = gDB.ValField(rsKsI.Fields, cscPrNombrecompra)
                  .pr_id = gDB.ValField(rsKsI.Fields, cscPrId)
                  .stl_id = gDB.ValField(rsKsI.Fields, cscStlId)
                  .Lote = gDB.ValField(rsKsI.Fields, cscStlCodigo)
                  .Cantidad = gDB.ValField(rsKsI.Fields, cscPrskiCantidad)
                  strDescrip = strDescrip & .Lote & ","
                End With
              
              ElseIf bIsVar Then
              
                If prk_id <> last_prk_id Then
                  last_prk_id = prk_id
                  Set KitVar = .Lotes.Item(GetKey(prk_id))
                End If
                
                With KitVar
                  .Nombre = gDB.ValField(rsKsI.Fields, cscPrNombrecompra)
                  .Cantidad = gDB.ValField(rsKsI.Fields, cscPrskiCantidad)
                  .pr_id = gDB.ValField(rsKsI.Fields, cscPrId)
                  strDescrip = strDescrip & .Nombre & "(" & _
                                     Format(.Cantidad, "0.00") & ")" & ","
                End With
              
              Else
              
                If prk_id <> last_prk_id Then
                  last_prk_id = prk_id
                  Set KitAlt = .Alts.Item(GetKey(prk_id))
                End If
                
                With KitAlt.Items.Add()
                  .Nombre = gDB.ValField(rsKsI.Fields, cscPrNombrecompra)
                  .pr_id = gDB.ValField(rsKsI.Fields, cscPrId)
                  .Cantidad = gDB.ValField(rsKsI.Fields, cscPrskiCantidad)
                  strDescrip = strDescrip & .Nombre & "(" & _
                                     Format(.Cantidad, "0.00") & ")" & ","
                End With
              
              End If
            
              bFound = True
            Else
              If bFound Then
                Exit Do
              End If
            End If
          
            rsKsI.MoveNext
          Loop
          
        End With
        
        bFound = True
      Else
        If bFound Then
          Exit Do
        End If
      End If
    
      rsKs.MoveNext
    Loop
        
    Do While Not rsAlt.EOF
    
      If ppki_id = gDB.ValField(rsAlt.Fields, cscPpkiId) Then
      
        With KitGetKit(KitLn, lRow)
        
          last_prk_id = 0
          
          prk_id = gDB.ValField(rsAlt.Fields, cscPrkId)
          
          If prk_id <> last_prk_id Then
            last_prk_id = prk_id
            Set KitAlt = .Alts.Item(GetKey(prk_id))
          End If
          
          With KitAlt.Items.Add()
            .Nombre = gDB.ValField(rsAlt.Fields, cscPrNombrecompra)
            .pr_id = gDB.ValField(rsAlt.Fields, cscPrId)
            .Cantidad = gDB.ValField(rsAlt.Fields, cscPpkiaCantidad)
            strDescrip = strDescrip & .Nombre & "(" & _
                               Format(.Cantidad, "0.00") & ")" & ","
          End With
        
        End With
        
      Else
        If bFound Then
          Exit For
        End If
      End If
    
      rsAlt.MoveNext
    Loop
    
    pCell(Row, KI_NROSERIE).Value = RemoveLastColon(strDescrip)
    
  Next
  
  pLoadKitItems = True
End Function

Private Sub pCopyKitDef(ByRef KitFrom As cKit, _
                        ByRef KitTo As cKit)

  Dim KitItem   As cKitItem
  Dim KitAlt    As cKitAlt
  Dim KitLote   As cKitLote
  Dim KitSerie  As cKitSerie
  Dim KitVar    As cKitVar

  With KitTo
    .bIdentidad = KitFrom.bIdentidad
    .bIdentidadXItem = KitFrom.bIdentidadXItem
    .bLote = KitFrom.bLote
    .bLoteXItem = KitFrom.bLoteXItem
    .bTalEditLote = KitFrom.bTalEditLote
    .bTalEditSerie = KitFrom.bTalEditSerie
    .Cantidad = KitFrom.Cantidad
    .Nombre = KitFrom.Nombre
    .pr_id = KitFrom.pr_id
    .pr_id_lote = KitFrom.pr_id_lote
    .pr_id_serie = KitFrom.pr_id_serie
    .prfk_id = KitFrom.prfk_id
    .ta_id_lote = KitFrom.ta_id_lote
    .ta_id_serie = KitFrom.ta_id_serie
    
    For Each KitItem In KitFrom.Alts
      With .Alts.Add(0)
        .Cantidad = KitItem.Cantidad
        .Nombre = KitItem.Nombre
        .pr_id = KitItem.pr_id
        .prk_id = KitItem.prk_id
        .Variable = KitItem.Variable
        For Each KitAlt In KitItem.Alts
          With .Alts.Add()
            .Nombre = KitAlt.Nombre
            .pr_id = KitAlt.pr_id
          End With
        Next
      End With
    Next
    
    For Each KitLote In KitFrom.Lotes
      With .Lotes.Add(0)
        .bTalEdit = .bTalEdit
        .Cantidad = .Cantidad
        .Nombre = .Nombre
        .pr_id = .pr_id
        .prk_id = .prk_id
        .ta_id = .ta_id
        .Variable = .Variable
        
        For Each KitAlt In .Alts
          With .Alts.Add()
            .Nombre = KitAlt.Nombre
            .pr_id = KitAlt.pr_id
          End With
        Next
      End With
    Next
    
    For Each KitSerie In KitFrom.Series
      With .Series.Add(0)
        .bTalEdit = KitSerie.bTalEdit
        .Cantidad = KitSerie.Cantidad
        .Nombre = KitSerie.Nombre
        .pr_id = KitSerie.pr_id
        .prk_id = KitSerie.prk_id
        .ta_id = KitSerie.ta_id
        .Variable = KitSerie.Variable
        
        For Each KitAlt In .Alts
          With .Alts.Add()
            .Nombre = KitAlt.Nombre
            .pr_id = KitAlt.pr_id
          End With
        Next
      End With
    Next
    
    For Each KitVar In KitFrom.Vars
      With .Vars.Add(0)
        .Cantidad = KitVar.Cantidad
        .Nombre = KitVar.Nombre
        .pr_id = KitVar.pr_id
        .prk_id = KitVar.prk_id
      End With
    Next
    
  End With

End Sub

'------------------------------------------------------------------------------------------
'
Private Sub pApplyFormulaInKits(ByRef KitLn As cKitLine)
  Dim Serie As cKitSerie
  Dim Lote  As cKitLote
  Dim Var   As cKitVar
  Dim Alt   As cKitItem
  
  Dim SerieDef As cKitSerie
  Dim LoteDef  As cKitLote
  Dim VarDef   As cKitVar
  Dim AltDef   As cKitItem
  
  Dim Kit     As cKit
  
  Dim idx     As Long
  Dim bFound  As Boolean
  
  ' Hay que analizar todos lo kits
  ' de este item y dejar solo la info
  ' que es compatible entre las distintas
  ' formulas
  '
  For Each Kit In KitLn.Items
    
    '---------------------------------------------------
    '
    ' Series
    '
    '---------------------------------------------------
    
    idx = 1
    
    ' Eliminamos los series que no existen
    ' en la formula actual
    '
    While idx <= Kit.Series.Count
      
      Set Serie = Kit.Series.Item(idx)
    
      ' Series
      '
      For Each SerieDef In KitLn.KitType.Series
        
        If Serie.pr_id = SerieDef.pr_id Then
          bFound = True
          Exit For
        End If
      Next
      
      If bFound Then
        idx = idx + 1
        Serie.prk_id = SerieDef.prk_id
      Else
        Kit.Series.Remove idx
      End If
    Wend
    
    ' Ahora agregamos cualquier nuevo serie
    ' mencionado por la formula actual
    '
    
    idx = 0
    
    For Each SerieDef In KitLn.KitType.Series
      idx = idx + 1
      If Kit.Series.Count < idx Then
        
        KitCopySerie SerieDef, _
                     Kit.Series.Add(SerieDef.prk_id)
      Else
        
        If SerieDef.pr_id <> Kit.Series.Item(idx).pr_id Then
          
          KitCopySerie SerieDef, _
                       Kit.Series.Add(SerieDef.prk_id, , idx)
        End If
      End If
    Next
    
    '---------------------------------------------------
    '
    ' Lotes
    '
    '---------------------------------------------------
    
    idx = 1
    
    ' Eliminamos los lotes que no existen
    ' en la formula actual
    '
    While idx <= Kit.Lotes.Count
      
      Set Lote = Kit.Lotes.Item(idx)
    
      ' Lotes
      '
      For Each LoteDef In KitLn.KitType.Lotes
        
        If Lote.pr_id = LoteDef.pr_id Then
          bFound = True
          Exit For
        End If
      Next
      
      If bFound Then
        idx = idx + 1
        Lote.prk_id = LoteDef.prk_id
      Else
        Kit.Lotes.Remove idx
      End If
    Wend
    
    ' Ahora agregamos cualquier nuevo lote
    ' mencionado por la formula actual
    '
    
    idx = 0
    
    For Each LoteDef In KitLn.KitType.Lotes
      idx = idx + 1
      If Kit.Lotes.Count < idx Then
        
        KitCopyLote LoteDef, _
                    Kit.Lotes.Add(LoteDef.prk_id)
      Else
        
        If LoteDef.pr_id <> Kit.Lotes.Item(idx).pr_id Then
          
          KitCopyLote LoteDef, _
                      Kit.Lotes.Add(LoteDef.prk_id, , idx)
        End If
      End If
    Next
    
    '---------------------------------------------------
    '
    ' Alternativas
    '
    '---------------------------------------------------
    
    idx = 1
    
    ' Eliminamos los alternativass que no existen
    ' en la formula actual
    '
    While idx <= Kit.Alts.Count
      
      Set Alt = Kit.Alts.Item(idx)
    
      ' Alternativas
      '
      For Each AltDef In KitLn.KitType.Alts
        
        If Alt.pr_id = AltDef.pr_id Then
          bFound = True
          Exit For
        End If
      Next
      
      If bFound Then
        idx = idx + 1
        Alt.prk_id = AltDef.prk_id
      Else
        Kit.Alts.Remove idx
      End If
    Wend
    
    ' Ahora agregamos cualquier nueva alternativa
    ' mencionada por la formula actual
    '
    
    idx = 0
    
    For Each AltDef In KitLn.KitType.Alts
      idx = idx + 1
      If Kit.Alts.Count < idx Then
        
        KitCopyAlt AltDef, _
                   Kit.Alts.Add(AltDef.prk_id)
      Else
        
        If AltDef.pr_id <> Kit.Alts.Item(idx).pr_id Then
          
          KitCopyAlt AltDef, _
                     Kit.Alts.Add(AltDef.prk_id, , idx)
        End If
      End If
    Next
    
    '---------------------------------------------------
    '
    ' Variables
    '
    '---------------------------------------------------
    
    idx = 1
    
    ' Eliminamos los variables que no existen
    ' en la formula actual
    '
    While idx <= Kit.Vars.Count
      
      Set Var = Kit.Vars.Item(idx)
    
      ' Variables
      '
      For Each VarDef In KitLn.KitType.Vars
        
        If Var.pr_id = VarDef.pr_id Then
          bFound = True
          Exit For
        End If
      Next
      
      If bFound Then
        idx = idx + 1
        Var.prk_id = VarDef.prk_id
      Else
        Kit.Vars.Remove idx
      End If
    Wend
    
    ' Ahora agregamos cualquier nueva variable
    ' mencionada por la formula actual
    '
    
    idx = 0
    
    For Each VarDef In KitLn.KitType.Vars
      idx = idx + 1
      If Kit.Vars.Count < idx Then
        
        KitCopyVar VarDef, _
                   Kit.Vars.Add(VarDef.prk_id)
      Else
        
        If VarDef.pr_id <> Kit.Vars.Item(idx).pr_id Then
          
          KitCopyVar VarDef, _
                     Kit.Vars.Add(VarDef.prk_id, , idx)
        End If
      End If
    Next
  
  Next
End Sub

Private Function pGetItems() As cIABMProperty
  Set pGetItems = m_Items.Properties.Item(c_Items)
End Function

