VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cLiquidacion"
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
' cLiquidacion
' 05-10-2008

  ' TODO: 1- cEditDocEx: debe soportar este tipo de documento

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cLiquidacion"

Private Const c_Items = "Items"
Private Const c_Exceptions = "Exceptions"
Private Const c_ConceptoAdm = "ConceptoAdm"

Private Const c_cmd_load = "cmdLoad"
Private Const c_cmd_exec = "cmdExec"

Private Const K_NUMERO                         As Integer = 1
Private Const K_NRODOC                         As Integer = 2
Private Const K_DESCRIP                        As Integer = 3
Private Const K_FECHA                          As Integer = 4

Private Const K_FECHA_DESDE                    As Integer = 51
Private Const K_FECHA_HASTA                    As Integer = 52
Private Const K_PERIODO                        As Integer = 53

Private Const K_TOTAL                          As Integer = 9
Private Const K_DOC_ID                         As Integer = 11
Private Const K_DOCT_ID                        As Integer = 12
Private Const K_ITEMS                          As Integer = 15
Private Const K_EXCEPTIONS                     As Integer = 16
Private Const K_CONCEPTOS_ADM                  As Integer = 116
Private Const K_EST_ID                         As Integer = 18
Private Const K_CCOS_ID                        As Integer = 19
Private Const K_SUC_ID                         As Integer = 20
Private Const K_LGJ_ID                         As Integer = 27
Private Const K_COTIZACION                     As Integer = 28
Private Const K_LIQP_ID                        As Integer = 29
Private Const K_EM_ID                          As Integer = 30
Private Const K_CMD_LOAD                       As Integer = 31
Private Const K_CMD_EXEC                       As Integer = 32

Private Const KI_LIQI_ID                        As Integer = 1
Private Const KI_EM_ID                          As Integer = 2
Private Const KI_ORDEN                          As Integer = 3
Private Const KI_DESCRIP                        As Integer = 4
Private Const KI_IMPORTE                        As Integer = 5
Private Const KI_NRODOC                         As Integer = 6
Private Const KI_SELECT                         As Integer = 7

Private Const KIE_LIQE_ID                       As Integer = 1
Private Const KIE_EM_ID                         As Integer = 2
Private Const KIE_LIQFI_ID                      As Integer = 3
Private Const KIE_DESCRIP                       As Integer = 4
Private Const KIE_CCOS_ID                       As Integer = 5

Private Const KICA_LIQCA_ID                      As Integer = 1
Private Const KICA_EM_ID                         As Integer = 2
Private Const KICA_LIQFI_ID                      As Integer = 3
Private Const KICA_IMPORTE                       As Integer = 4
Private Const KICA_DESCRIP                       As Integer = 5
Private Const KICA_CCOS_ID                       As Integer = 6


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
Private m_fecha                        As Date

Private m_fechaDesde                   As Date
Private m_fechaHasta                   As Date
Private m_periodo                      As String

Private m_Total                        As Double
Private m_lgj_id                       As Long
Private m_Legajo                       As String

Private m_Cotizacion                   As Double
Private m_ccos_id                      As Long
Private m_CentroCosto                  As String
Private m_suc_id                       As Long
Private m_Sucursal                     As String
Private m_doc_id                       As Long
Private m_Documento                    As String
Private m_Doct_id                      As Long
Private m_mon_id                       As Long

Private m_liqp_id                      As Long
Private m_Plantilla                    As String

Private m_em_id                        As Long
Private m_Empleado                     As String

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
Private m_LastDocName       As String

Private m_IsNew             As Boolean

Private m_BranchId          As Long
Private m_TreeId            As Long

Private m_Host              As CSMenu.cIMenuHost

Private m_MonDefault        As Long

Private m_Copy              As Boolean

Private m_GeneralConfig     As cGeneralConfig

Private m_DocEditable       As Boolean
Private m_DocEditMsg        As String

Private m_TaPropuesto       As Boolean
Private m_TaMascara         As String

Private m_ItemsDeleted        As String
Private m_ExceptionsDeleted   As String
Private m_ConceptosAdmDeleted As String

' Preferencias del Usuario
'
Private m_UserCfg           As cUsuarioConfig

' propiedades publicas
' propiedades privadas
' funciones publicas
' Implementacion de cIABMClient
Private Function cIABMClient_Copy() As Boolean

  If Not DocSecurityCanAccessEx(csPrepNewLiquidacion, _
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
  GetDocNumber m_LastDoc, m_ObjAbm, m_TaPropuesto, cscLiqNrodoc
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
  GetDocNumber m_LastDoc, m_ObjAbm, m_TaPropuesto, cscLiqNrodoc
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

  Doc.ClientTable = csTLiquidacion
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
        Case K_EXCEPTIONS, K_ITEMS, K_CONCEPTOS_ADM
          pShowTotales
      End Select
      
    Case MSG_DOC_EDIT_STATE
      ShowEditState m_DocEditMsg, LNGGetText(4607, vbNullString)  'Liquidación
      
    Case MSG_DOC_DELETE
      If cIEditGeneric_Delete(m_Id) Then
        cIABMClient_MessageEx = True
        pMove MSG_DOC_NEXT
      End If
    
    Case MSG_DOC_ANULAR
      DocAnular m_Id, m_est_id, m_Estado, csPrepAnularLiquidacion, csPrepDesAnularLiquidacion, m_ObjAbm, m_DocEditable, m_DocEditMsg, "sp_DocLiquidacionAnular", "sp_DocLiquidacionEditableGet"
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
      DocumentSearch csEDT_Liquidacion, Me, Not CBool(Info)
  
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
          
          If DocCanSave(m_ObjAbm, cscLiqFecha) Then
            
            Dim EditDoc As cEditDocEx
            Set EditDoc = New cEditDocEx
            
            Set EditDoc.ObjectClient = Me
            EditDoc.Edit m_Id, _
                         m_Doct_id, _
                         csTLiquidacion, _
                         cscLiqId, _
                         csTLiquidacionItem, _
                         cscLiqiId, _
                         csPrepNewLiquidacion, _
                         csPrepEditLiquidacion, _
                         csNO_ID, csNO_ID, _
                         True
          End If
          
        End If
      
      Else
        MsgInfo LNGGetText(1556, vbNullString)
                'Esta opción solo sirve para modificar documentos guardados y aplicados
      End If
  
    Case MSG_DOC_HISTORY
    
      If m_Id <> csNO_ID Then
    
        ShowHistory csLiquidacion, m_Id, m_Documento & " " & m_Nrodoc
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
        GetDocNumber m_LastDoc, m_ObjAbm, m_TaPropuesto, cscLiqNrodoc
        
        pShowCotizacion
        
      End If
      
      ' Defino el estado de edicion del comprobante
      '
      pSetEnabled
  
    Case K_FECHA
      
      ' Cotizacion
      m_lastMonIdCotizacion = csNO_ID
      pShowCotizacion
  
    Case K_CMD_LOAD
      pAddEmpleados
      
    Case K_CMD_EXEC
    
      Dim AbmObj As cABMGeneric
      Dim Items As cABMGeneric
      
      Set AbmObj = m_ObjAbm
      Set Items = m_ObjAbm
    
      If AbmObj.bWasChanged Or Items.bWasChanged Then
      
        If Ask(LNGGetText(4625, vbNullString), vbNo) Then
                  'Exiten cambios que aun no se han guardado.
                  '
                  'El proceso de liquidación solo tomará los cambios guardados.
                  '
                  '¿Desea guardar los cambios antes de procesar la liquidacion?.
                  
          If Not AbmObj.Save() Then Exit Function
                  
        End If
       
      End If
    
      pProcess
      
  End Select
End Function

Private Sub pAddEmpleados()
  Dim rs          As ADODB.Recordset
  Dim sqlstmt     As String
  Dim Row         As cIABMGridRow
  Dim bFound      As Boolean
    
  sqlstmt = "sp_LiquidacionAddEmpleados " & _
                      gDB.sqlString(pGetEmpleado().HelpValueProcess)
                      
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Sub

  With pGetItems
      
    While Not rs.EOF
            
      bFound = False
            
      For Each Row In .Rows
        If pCell(Row, KI_EM_ID).ID = gDB.ValField(rs.fields, cscEmId) Then
          bFound = True
          Exit For
        End If
      Next
            
      If Not bFound Then
            
        With .Rows
          With .Add(Nothing)
            
            With .Add(Nothing)
              .Value = csNO_ID
              .Key = KI_LIQI_ID
            End With
            
            With .Add(Nothing)
              .Value = gDB.ValField(rs.fields, cscEmNombre)
              .ID = gDB.ValField(rs.fields, cscEmId)
              .Key = KI_EM_ID
            End With
            
            With .Add(Nothing)
              .Value = 0
              .Key = KI_IMPORTE
            End With
            
            With .Add(Nothing)
              .Value = vbNullString
              .Key = KI_NRODOC
            End With
            
            With .Add(Nothing)
              .ID = 0
              .Key = KI_SELECT
            End With
            
            With .Add(Nothing)
              .Value = vbNullString
              .Key = KI_DESCRIP
            End With
            
          End With
        
        End With
      
      End If
      
      rs.MoveNext
    Wend
    
  End With
  
  Dim AbmGen As cABMGeneric
  Set AbmGen = m_Items
  AbmGen.ShowValue pGetItemsProperty(), True
  
End Sub

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
  If Not DocCanSave(m_ObjAbm, cscLiqFecha) Then
    cIABMClient_Save = False
    Exit Function
  End If
  
  If pGetExceptions().Rows.Count = 0 And _
     pGetItems().Rows.Count = 0 Then
     
    MsgWarning LNGGetText(3903, vbNullString) 'El documento debe contener al menos un item
    cIABMClient_Save = False
    Exit Function
  End If
  
  Dim Mouse As cMouseWait
  Set Mouse = New cMouseWait
  
  DoEvents: DoEvents: DoEvents: DoEvents
  
  Set register = New cRegister
  register.fieldId = cscLiqTMPId
  register.Table = csTLiquidacionTMP
  
  register.ID = csNew
    
  If m_Copy Then
    register.fields.Add2 cscLiqId, csNew, csLong
  Else
    register.fields.Add2 cscLiqId, m_Id, csLong
  End If
  
  If register.ID = csNew Then
    m_est_id = CSGeneralEx2.csEEstado.csEEst_Pendiente
  End If
  
  Dim IProperty As cIABMProperty
  For Each IProperty In m_ObjAbm.Properties
    With IProperty
      Select Case .Key
        Case K_NUMERO
          register.fields.Add2 cscLiqNumero, .Value, csLong
        Case K_NRODOC
          register.fields.Add2 cscLiqNrodoc, .Value, csText
        Case K_DESCRIP
          register.fields.Add2 cscLiqDescrip, .Value, csText
        Case K_FECHA
          register.fields.Add2 cscLiqFecha, .Value, csDate
        
        Case K_FECHA_DESDE
          register.fields.Add2 cscLiqFechaDesde, .Value, csDate
        Case K_FECHA_HASTA
          register.fields.Add2 cscLiqFechaHasta, .Value, csDate
        Case K_PERIODO
          register.fields.Add2 cscLiqPeriodo, .Value, csText
        
        Case K_CCOS_ID
          register.fields.Add2 cscCcosId, .HelpId, csId
        Case K_SUC_ID
          register.fields.Add2 cscSucId, .HelpId, csId
        Case K_DOC_ID
          register.fields.Add2 cscDocId, .HelpId, csId
        Case K_LIQP_ID
          register.fields.Add2 cscLiqpId, .HelpId, csId
        Case K_COTIZACION
          Cotizacion = .Value
          register.fields.Add2 cscLiqCotizacion, .Value, csDouble
        Case K_LGJ_ID
          register.fields.Add2 cscLgjId, .HelpId, csId
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
  register.fields.Add2 cscLiqTotal, TotalOrigen * Cotizacion, csCurrency
  register.fields.Add2 cscLiqGrabarasiento, 1, csBoolean
  register.fields.Add2 cscEstId, m_est_id, csId
  
  If bMonedaLegal Then
    register.fields.Add2 cscLiqTotalorigen, 0, csCurrency
  Else
    register.fields.Add2 cscLiqTotalorigen, TotalOrigen, csCurrency
  End If
  
  register.fields.HaveLastUpdate = True
  register.fields.HaveWhoModify = True
  
  If Not register.BeginTrans(gDB) Then Exit Function
  
  If Not gDB.Save(register, , "cIABMClient_Save", C_Module, c_ErrorSave) Then Exit Function
  
  If Not pSaveItems(register.ID, Cotizacion, bMonedaLegal) Then Exit Function
  If Not pSaveExceptions(register.ID) Then Exit Function
  If Not pSaveConceptosAdm(register.ID) Then Exit Function
  
  If Not register.CommitTrans() Then Exit Function
  
  Dim sqlstmt As String
  Dim rs      As Recordset
  sqlstmt = "sp_DocLiquidacionSave " & register.ID
  
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
  
  m_ObjTree.sqlstmt = "sp_lsdoc_Liquidacion"
  
  If m_IsNew Then
    m_ObjTree.AddLine m_Id
  Else
    m_ObjTree.RefreshLine m_Id
  End If
ControlError:
End Function

Private Property Get cIABMClient_Title() As String
  cIABMClient_Title = LNGGetText(4608, vbNullString)  'Liquidación de Haberes
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
        
        
        Case K_FECHA_DESDE
          If ValEmpty(.Value, csDate) Then
            MsgInfo LNGGetText(2393, vbNullString)  'Debe indicar una fecha desde
            Exit Function
          End If
        Case K_FECHA_HASTA
          If ValEmpty(.Value, csDate) Then
            MsgInfo LNGGetText(2394, vbNullString)  'Debe indicar una fecha hasta
            Exit Function
          End If
        Case K_PERIODO
          If ValEmpty(.Value, csText) Then
            MsgInfo LNGGetText(4630, vbNullString)  'Debe indicar un periodo
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
        Case K_LIQP_ID
          If ValEmpty(.HelpId, csId) Then
            MsgInfo LNGGetText(4623, vbNullString)  'Debe indicar una plantilla de liquidación
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
    Case K_EXCEPTIONS
      cIABMClientGrid_IsEmptyRow = pIsEmptyRowExceptions(Row, RowIndex)
    Case K_CONCEPTOS_ADM
      cIABMClientGrid_IsEmptyRow = pIsEmptyRowConceptosAdm(Row, RowIndex)
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
  
  sqlstmt = "select doct_id, doc_id from Liquidacion where liq_id = " & ID
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
  cIEditGeneric_ShowList = SecurityCanAccess(csPrepListLiquidacion)
End Function

Private Property Set cIEditGeneric_ObjAbm(rhs As CSInterfacesABM.cIABMGeneric)
  Set m_ObjAbm = rhs
  m_ObjAbm.IsDocument = True

#If Not PREPROC_SFS Then
  Dim AbmGen      As cABMGenericDocEx
  
  Set AbmGen = m_ObjAbm
  With AbmGen
    .FactoryObject = "CSABMInterface2.cFactory"
    .ObjForm = "CSABMInterface2.fLiquidacion"
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
                          csTLiquidacion, _
                          cscLiqId, _
                          doc_id) Then
      Exit Function
    End If
  End If
  
  If Not DocSecurityCanAccess( _
                  csPrepDeleteLiquidacion, _
                  doc_id, _
                  csEDocTPreDelete) Then
    Exit Function
  End If

  Dim sqlstmt As String
  
  sqlstmt = "sp_DocLiquidacionDelete " & ID & "," & EmpId & "," & User.ID
  
  cIEditGeneric_Delete = gDB.Execute(sqlstmt, "cIEditGeneric_Delete", C_Module)
End Function

Private Function cIEditGeneric_Search(ID As Long, Cancela As Boolean) As Boolean

End Function

Private Function cIEditGeneric_Edit(ID As Long, Optional ByVal InModalWindow As Boolean) As Boolean
  On Error GoTo ControlError
  
  If Not DocSecurityCanAccess(csPrepListLiquidacion, GetdocIdFromObjAbm(m_ObjAbm), csEDocTPreList) Then Exit Function
  
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
  
  Select Case Key
    Case K_ITEMS
      pShowTotales
      cIABMClientGrid_ColumnAfterUpdate = True
    Case K_EXCEPTIONS
      cIABMClientGrid_ColumnAfterUpdate = True
    Case K_CONCEPTOS_ADM
      pShowTotales
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
  cIABMClientGrid_ColumnAfterEdit = True
End Function

Private Function cIABMClientGrid_ColumnBeforeEdit(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long, ByVal iKeyAscii As Integer) As Boolean
  Select Case Key
    Case K_ITEMS
      cIABMClientGrid_ColumnBeforeEdit = lCol <> 4
    Case Else
      cIABMClientGrid_ColumnBeforeEdit = True
  End Select
End Function

Private Function cIABMClientGrid_ColumnButtonClick(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long, ByVal iKeyAscii As Integer) As Boolean

End Function

Private Sub cIABMClientGrid_ColumnCancelEdit(ByVal Key As Integer)

End Sub

Private Sub cIABMClientGrid_ColumnClick(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long)

End Sub

Private Sub cIABMClientGrid_DblClick(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long)
  Select Case Key
    Case K_ITEMS
      If pGetItems().Rows(lRow).Item(lCol).Key = KI_IMPORTE Or lCol = 1 Then
        pShowRecibo Val(pCell(pGetItems().Rows(lRow), KI_LIQI_ID).Value)
      End If
  End Select
End Sub

Private Function cIABMClientGrid_DeleteRow(ByVal Key As Integer, Row As CSInterfacesABM.cIABMGridRow, ByVal lRow As Long) As Boolean
  Dim ID As Long
  
  Select Case Key
    Case K_EXCEPTIONS
      ID = Val(pCell(Row, KIE_LIQE_ID).Value)
      If ID <> csNO_ID Then m_ExceptionsDeleted = m_ExceptionsDeleted & ID & ","
    Case K_ITEMS
      ID = Val(pCell(Row, KI_LIQI_ID).Value)
      If ID <> csNO_ID Then m_ItemsDeleted = m_ItemsDeleted & ID & ","
    Case K_CONCEPTOS_ADM
      ID = Val(pCell(Row, KICA_LIQCA_ID).Value)
      If ID <> csNO_ID Then m_ConceptosAdmDeleted = m_ConceptosAdmDeleted & ID & ","
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
    Case K_ITEMS
      cIABMClientGrid_ValidateRow = pValidateRow(Row, RowIndex)
    Case K_EXCEPTIONS
      cIABMClientGrid_ValidateRow = pValidateRowExceptions(Row, RowIndex)
    Case K_CONCEPTOS_ADM
      cIABMClientGrid_ValidateRow = pValidateRowConceptosAdm(Row, RowIndex)
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
      Case KI_EM_ID
        If Not ValEmpty(Cell.Value, csText) Then
          bRowIsEmpty = False
          Exit For
        End If
      Case KI_DESCRIP
        If Not ValEmpty(Cell.Value, csText) Then
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
      Case KI_EM_ID
        If ValEmpty(Cell.ID, csId) Then
          MsgInfo LNGGetText(4561, vbNullString, strRow) 'Debe indicar un empleado
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
#If PREPROC_SFS Then
  Dim AbmGen      As cABMGeneric
#Else
  Dim AbmGen      As cABMGenericDocEx
#End If
  Dim Cotizacion  As Double
  
  ' Preferencias del usuario
  '
  Dim bValidateDocDefault As Boolean
  Dim oProp As cABMProperty
  
  Set AbmGen = m_ObjAbm
  AbmGen.UseHelpValueProcess = True
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
        .HelpId = m_UserCfg.DocLIQId
        .Value = m_UserCfg.DocLIQNombre
        
        bValidateDocDefault = .HelpId <> csNO_ID
      End If
      
      .HelpFilter = "'doct_id = " & csEDT_Liquidacion & "'"
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
    
    With .Add(Nothing, cscLiqFecha)
      .PropertyType = cspDate
      .Name = LNGGetText(1569, vbNullString) 'Fecha
      .LeftLabel = -880
      .Left = 1100
      .Key = K_FECHA
      .Value = m_fecha
    End With
        
    With .Add(Nothing, cscLiqNrodoc)
      .PropertyType = cspText
      .Name = LNGGetText(1065, vbNullString) 'Número
      .TopToPrevious = 400
      .Size = 50
      .Key = K_NRODOC
      .Value = m_Nrodoc
      .TextMask = m_TaMascara
      .TextAlign = vbRightJustify
    End With
            
    With .Add(Nothing, cscLiqCotizacion)
      .PropertyType = cspNumeric
      .SubType = cspMoney
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
            
    With .Add(Nothing, cscLiqFechaDesde)
      .PropertyType = cspDate
      .Name = LNGGetText(1203, vbNullString) 'Fecha Desde
      .LeftLabel = -1200
      .Key = K_FECHA_DESDE
      .Value = m_fechaDesde
      .TopFromProperty = cscLiqFecha
      .Left = 4700
    End With
    With .Add(Nothing, cscLiqFechaHasta)
      .PropertyType = cspDate
      .Name = LNGGetText(1204, vbNullString) 'Fecha Hasta
      .Key = K_FECHA_HASTA
      .Value = m_fechaHasta
      .TopToPrevious = 400
    End With
    With .Add(Nothing, cscLiqPeriodo)
      .PropertyType = cspText
      .Name = LNGGetText(4631, vbNullString) 'Periodo
      .Key = K_PERIODO
      .Value = m_periodo
      .TopToPrevious = 400
    End With
        
    With .Add(Nothing, cscLiqpId)
      .PropertyType = cspHelp
      .Table = csLiquidacionPlantilla
      .Name = LNGGetText(4621, vbNullString) 'Plantilla

      .TopFromProperty = cscLiqFecha
      .Left = 8200
      .LeftLabel = -800
      .Width = 3500

      .Key = K_LIQP_ID
      .HelpId = m_liqp_id
      .Value = m_Plantilla
    End With
    
    Set c = .Add(Nothing, cscEmId)
    With c
      .PropertyType = cspHelp
      .Table = csEmpleado
      .Name = LNGGetText(4555, vbNullString) 'Empleado
      .TopToPrevious = 400
      
      .LeftLabel = -800
      .Width = 3500
      
      .Key = K_EM_ID
      .HelpId = m_em_id
      .Value = m_Empleado
    
      Set oProp = c
      oProp.HelpType = csTree
      oProp.IsEditProperty = False
      Set oProp = Nothing
    
    End With
            
    With .Add(Nothing, c_cmd_load)
      .PropertyType = cspButton
      .Name = LNGGetText(4622, vbNullString) 'Cargar
      .TopToPrevious = 400
      .LeftLabel = -1
      .Key = K_CMD_LOAD
    End With
            
    With .Add(Nothing, c_cmd_exec)
      .PropertyType = cspButton
      .Name = LNGGetText(4624, vbNullString) 'Procesar Liquidación
      .TopToPrevious = 400
      .LeftLabel = -1
      .Key = K_CMD_EXEC
    End With
            
    With .Add(Nothing, cscLiqDescrip)
      .PropertyType = cspText
      .SubType = cspMemo
      .Name = LNGGetText(1211, vbNullString) 'Observ.
      .LeftLabel = -880
      .Size = 5000
      .Key = K_DESCRIP
      .Value = m_Descrip
      .LeftFromProperty = cscLiqFecha
      .TopFromProperty = cscLiqNrodoc
      .Width = 5870
      .Height = 520
      .TopToPrevious = 800
    End With
  
    With .Add(Nothing, cscLgjId)
      .PropertyType = cspHelp
      .Table = csLegajo
      .Name = LNGGetText(1575, vbNullString) 'Legajo
      .Key = K_LGJ_ID
      .HelpId = m_lgj_id
      .Value = m_Legajo
      .TabIndex = 1
      .Left = 2000
      .LeftLabel = -1500
    End With
    
    With .Add(Nothing, cscCcosId)
      .PropertyType = cspHelp
      .Table = csCentroCosto
      .Name = LNGGetText(1057, vbNullString) 'Centro de Costo
      .Key = K_CCOS_ID
      .HelpId = m_ccos_id
      .Value = m_CentroCosto
      .TabIndex = 1
    End With
    
    With .Add(Nothing, cscSucId)
      .PropertyType = cspHelp
      .Table = csSucursal
      .Name = LNGGetText(1281, vbNullString) 'Sucursal
      .Key = K_SUC_ID
      .HelpId = m_suc_id
      .Value = m_Sucursal
      .TabIndex = 1
    End With
  
  End With
  
  If Not m_ObjAbm.Show(Me) Then Exit Function
  
  Const c_TabItems = 0
  Const cTabExceptions = 1
  Const cTabConceptosAdm = 2
  
  With m_Items.Tabs
    
    .Clear
    
    With .Add(Nothing)
      .Index = c_TabItems
      .Name = LNGGetText(4553, vbNullString) 'Empleados
    End With
    
    With .Add(Nothing)
      .Index = cTabExceptions
      .Name = LNGGetText(4609, vbNullString) 'Excepciones
    End With
      
    With .Add(Nothing)
      .Index = cTabConceptosAdm
      .Name = LNGGetText(4841, vbNullString) 'Conceptos Administrativos
    End With
      
  End With
  
  Set AbmGen = m_Items
  AbmGen.ResetLayoutMembers
  
  With m_Items.Properties
  
    .Clear
    
    '/////////////////////////////////////////////////////////////////
    ' Items
    Set c = .Add(Nothing, c_Items)
    With c
      .PropertyType = cspGrid
      .LeftLabel = -1
      If Not pLoadItems(c, Cotizacion) Then Exit Function
      .Name = c_Items
      .Key = K_ITEMS
      .TabIndex = 0
      .GridAdd = True
      .GridEdit = True
      .GridRemove = True
    End With
    m_ItemsDeleted = vbNullString
    
    '/////////////////////////////////////////////////////////////////
    ' Excepciones
    Set c = .Add(Nothing, c_Exceptions)
    With c
      .PropertyType = cspGrid
      .LeftLabel = -1
      If Not pLoadExceptions(c) Then Exit Function
      .Name = c_Exceptions
      .Key = K_EXCEPTIONS
      .TabIndex = cTabExceptions
      .GridAdd = True
      .GridEdit = True
      .GridRemove = True
    End With
    
    m_ExceptionsDeleted = vbNullString
  
    '/////////////////////////////////////////////////////////////////
    ' Conceptos Administrativos
    Set c = .Add(Nothing, c_ConceptoAdm)
    With c
      .PropertyType = cspGrid
      .LeftLabel = -1
      If Not pLoadConceptosAdm(c) Then Exit Function
      .Name = c_ConceptoAdm
      .Key = K_CONCEPTOS_ADM
      .TabIndex = cTabConceptosAdm
      .GridAdd = True
      .GridEdit = True
      .GridRemove = True
    End With
    
    m_ConceptosAdmDeleted = vbNullString
  
  End With
  
    
  If Not m_Items.Show(Me) Then Exit Function
  
  Set AbmGen = m_Footer
  AbmGen.ResetLayoutMembers
  
  With m_Footer.Properties
  
    .Clear
  
    Set c = .Add(Nothing, cscLiqTotal)
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
  
  Set iProp = m_ObjAbm.Properties.Item(cscLiqCotizacion)
  iProp.Visible = MonId <> GetMonedaDefault
  
  If m_lastMonIdCotizacion <> MonId Or iProp.Value = 0 Then
    dDate = m_ObjAbm.Properties.Item(cscLiqFecha).Value
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
  
  pGetMonedaDefault = gDB.ValField(rs.fields, cscMonId)
End Function

Private Function pLoadItems(ByRef Propiedad As cIABMProperty, ByVal Cotizacion As Double) As Boolean
  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  
  sqlstmt = "sp_DocLiquidacionGetItems " & m_Id
  
  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, "pLoadItems", C_Module) Then Exit Function
  
  Dim oCol As cABMGridColumn
  Dim iCol As cIABMGridColumn
  
  With Propiedad.Grid
    
    .Columns.Clear
    .Rows.Clear
    
    With .Columns
    
      With .Add(Nothing)
        .Visible = False
        .Key = KI_LIQI_ID
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(4555, vbNullString)   'Empleado
        .PropertyType = cspHelp
        .Table = csEmpleado
        .Width = 1800
        .Key = KI_EM_ID
      End With
            
      With .Add(Nothing)
        .Name = LNGGetText(1228, vbNullString) 'Importe
        .PropertyType = cspNumeric
        .SubType = cspDouble
        .Width = 1000
        .Key = KI_IMPORTE
        .Format = m_GeneralConfig.FormatDecImporte
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(3819, vbNullString) 'Recibo
        .PropertyType = cspText
        .Width = 1000
        .Key = KI_NRODOC
      End With
      
      Set iCol = .Add(Nothing)
      Set oCol = iCol
      With iCol
        .Name = ""
        .PropertyType = cspCheck
        .Width = 4000
        .Key = KI_SELECT
      End With
      oCol.IsEditColumn = False
      
      With .Add(Nothing)
        .Name = C_strDescrip
        .PropertyType = cspText
        .SubType = cspTextButtonEx
        .Width = 4000
        .Key = KI_DESCRIP
      End With
                        
    End With
  
    With .Rows
      While Not rs.EOF
      
        With .Add(Nothing, rs(cscLiqiId).Value)
        
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscLiqiId)
            .Key = KI_LIQI_ID
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscEmNombre)
            .ID = gDB.ValField(rs.fields, cscEmId)
            .Key = KI_EM_ID
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscLiqiImporte)
            .Key = KI_IMPORTE
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscLiqiNroDoc)
            .Key = KI_NRODOC
          End With
          
          With .Add(Nothing)
            .ID = 0
            .Key = KI_SELECT
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscLiqiDescrip)
            .Key = KI_DESCRIP
          End With
                                        
        End With
        
        rs.MoveNext
      Wend
    End With
  End With
  
  pLoadItems = True
End Function

Private Function Load(ByVal ID As Long) As Boolean
  Dim Cotizacion  As Double
  Dim sqlstmt     As String

  sqlstmt = "sp_DocLiquidacionGet " & EmpId & "," & ID & "," & gDB.UserId
  
  Dim rs As Recordset

  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, C_LoadFunction, C_Module) Then Exit Function

  If Not rs.EOF Then

    m_IsNew = False

    m_Cotizacion = gDB.ValField(rs.fields, cscLiqCotizacion)
    Cotizacion = IIf(m_Cotizacion <> 0, m_Cotizacion, 1)

    m_Id = gDB.ValField(rs.fields, cscLiqId)
    m_Numero = gDB.ValField(rs.fields, cscLiqNumero)
    m_Nrodoc = gDB.ValField(rs.fields, cscLiqNrodoc)
    m_Descrip = gDB.ValField(rs.fields, cscLiqDescrip)
    m_fecha = gDB.ValField(rs.fields, cscLiqFecha)
    
    m_fechaDesde = gDB.ValField(rs.fields, cscLiqFechaDesde)
    m_fechaHasta = gDB.ValField(rs.fields, cscLiqFechaHasta)
    m_periodo = gDB.ValField(rs.fields, cscLiqPeriodo)
    
    m_Total = gDB.ValField(rs.fields, cscLiqTotal) / Cotizacion
    m_ccos_id = gDB.ValField(rs.fields, cscCcosId)
    m_CentroCosto = gDB.ValField(rs.fields, cscCcosNombre)
    m_suc_id = gDB.ValField(rs.fields, cscSucId)
    m_Sucursal = gDB.ValField(rs.fields, cscSucNombre)
    m_doc_id = gDB.ValField(rs.fields, cscDocId)
    m_Documento = gDB.ValField(rs.fields, cscDocNombre)
    m_Doct_id = gDB.ValField(rs.fields, cscDoctId)
    m_lgj_id = gDB.ValField(rs.fields, cscLgjId)
    m_Legajo = gDB.ValField(rs.fields, cscLgjCodigo)
    m_Creado = gDB.ValField(rs.fields, cscCreado)
    m_Modificado = gDB.ValField(rs.fields, cscModificado)
    m_Modifico = gDB.ValField(rs.fields, cscModifico)
    m_est_id = gDB.ValField(rs.fields, cscEstId)
    m_Estado = gDB.ValField(rs.fields, cscEstNombre)
    m_Firmado = gDB.ValField(rs.fields, cscLiqFirmado)
    m_mon_id = gDB.ValField(rs.fields, cscMonId)
    m_DocEditable = gDB.ValField(rs.fields, cscDocEditable)
    m_DocEditMsg = gDB.ValField(rs.fields, cscDoceditMsg)
    m_liqp_id = gDB.ValField(rs.fields, cscLiqpId)
    m_Plantilla = gDB.ValField(rs.fields, cscLiqpNombre)
    
    ' Para ver documentos auxiliares
    '
    m_as_id = gDB.ValField(rs.fields, cscAsId)
    
    m_TaPropuesto = gDB.ValField(rs.fields, cscTa_Propuesto)
    m_TaMascara = gDB.ValField(rs.fields, cscTa_Mascara)

    m_LastDoc = m_doc_id
    m_LastDocName = m_Documento
    
    m_lastMonIdCotizacion = m_mon_id
    
  Else
    m_Id = csNO_ID
    m_Numero = 0
    m_Nrodoc = vbNullString
    m_Descrip = vbNullString
    m_fecha = VDGetDateById(csToday)
    
    m_fechaDesde = VDGetDateById(csMonthLast_FirstDay)
    m_fechaHasta = VDGetDateById(csMonthLast_LastDay)
    m_periodo = Format(m_fechaDesde, "mmm yyyy")
    
    m_Total = 0
    m_ccos_id = csNO_ID
    m_CentroCosto = vbNullString
    m_doc_id = csNO_ID
    m_Documento = vbNullString
    m_Doct_id = csNO_ID
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
    m_liqp_id = csNO_ID
    m_Plantilla = vbNullString
  
    m_doc_id = m_LastDoc
    m_Documento = m_LastDocName
  
    ' Para ver documentos auxiliares
    '
    m_as_id = csNO_ID
    
    m_TaPropuesto = False
    m_TaMascara = vbNullString
  
    m_lastMonIdCotizacion = csNO_ID
  
    ' Cotizacion
    If m_doc_id <> csNO_ID Then
      m_Cotizacion = DocGetCotizacion(m_doc_id, m_fecha)
    End If
    
    DocEditableGet m_doc_id, m_DocEditable, m_DocEditMsg, csPrepNewLiquidacion
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
  Dim str_4582  As String
  
  str_4582 = LNGGetText(4582, vbNullString)  '&Personal
  
  Set m_Host = Host
  m_Host.Server.AddMenu str_4582, csMenuPersonalMain, vbNullString, 1, False, False, False, True, False, Nothing
  m_Host.Server.AddMenu LNGGetText(4610, vbNullString), csPrepListLiquidacion, str_4582, 0, True, False, False, False, False, Me
                        '&Liquidación de Haberes
  cIMenuClient_Initialize = True
  
  GoTo ExitProc
ControlError:
  MngError Err, "cIMenuClient_Initialize", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Private Function cIMenuClient_ProcessMenu(ByVal ID As Long) As Variant
#If PREPROC_SFS Then                                                                                                                                                         'Liquidación de Haberes
  m_Host.MenuListDocClick "CSABMInterface2.cABMGeneric", "CSPersonal.cLiquidacion", "CSABMInterface2.CABMGenericListDoc", "CSPersonal.cLiquidacionListDoc", Me, LNGGetText(4608, vbNullString), 0
#Else
  m_Host.MenuListDocClick "CSABMInterface2.cABMGenericDocEx", "CSPersonal.cLiquidacion", "CSABMInterface2.CABMGenericListDoc", "CSPersonal.cLiquidacionListDoc", Me, LNGGetText(4608, vbNullString), 0
#End If
End Function

Private Function pSaveItems(ByVal ID As Long, ByVal Cotizacion As Double, ByVal bMonedaLegal As Boolean) As Boolean
  Dim register  As cRegister
  Dim Origen    As Double
  Dim iOrden    As Long
  
  Dim Row  As cIABMGridRow
  Dim Cell As cIABMGridCellValue
  
  For Each Row In m_Items.Properties(c_Items).Grid.Rows
  
    Set register = New cRegister
    register.fieldId = cscLiqiTMPId
    register.Table = csTLiquidacionItemTMP
    register.ID = csNew
    
    For Each Cell In Row
      Select Case Cell.Key
        
        Case KI_LIQI_ID
          If m_Copy Then
            register.fields.Add2 cscLiqiId, csNew, csInteger
          Else
            register.fields.Add2 cscLiqiId, Val(Cell.Value), csInteger
          End If
        Case KI_DESCRIP
          register.fields.Add2 cscLiqiDescrip, Cell.Value, csText
        Case KI_NRODOC
          register.fields.Add2 cscLiqiNroDoc, Cell.Value, csText
        Case KI_EM_ID
          register.fields.Add2 cscEmId, Cell.ID, csId
      End Select
    Next
    
    register.fields.Add2 cscLiqiImporte, Origen * Cotizacion, csCurrency
    If bMonedaLegal Then
      register.fields.Add2 cscLiqiImporteOrigen, 0, csCurrency
    Else
      register.fields.Add2 cscLiqiImporteOrigen, Origen, csCurrency
    End If
    
    iOrden = iOrden + 1
    register.fields.Add2 cscLiqiOrden, iOrden, csInteger
    register.fields.Add2 cscLiqTMPId, ID, csId
    
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
      register.fieldId = cscLiqibTMPId
      register.Table = csTLiquidacionItemBorradoTMP
      register.ID = csNew
      
      register.fields.Add2 cscLiqiId, Val(vDeletes(i)), csInteger
      register.fields.Add2 cscLiqId, m_Id, csId
      register.fields.Add2 cscLiqTMPId, ID, csId
      
      register.fields.HaveLastUpdate = False
      register.fields.HaveWhoModify = False
      
      If Not gDB.Save(register, , "pSaveItems", C_Module, c_ErrorSave) Then Exit Function
    Next
    
  End If
  
  pSaveItems = True
End Function

' Reglas del Objeto de Negocios
Private Sub pShowTotales()
  Dim Total     As Double
  Dim Row       As CSInterfacesABM.cIABMGridRow
      
  For Each Row In pGetItems.Rows
    Total = Total + Val(pCell(Row, KI_IMPORTE).Value)
  Next
  
  For Each Row In pGetConceptosAdm.Rows
    Total = Total + Val(pCell(Row, KICA_IMPORTE).Value)
  Next
  
  m_Footer.Properties(cscLiqTotal).Value = Total
  
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

Private Function pFirmar() As Boolean
  Dim Doc     As cDocumento
  Dim us_id   As Long
  
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
  
  If Not Doc.Firmar(m_doc_id, us_id) Then Exit Function
  
  Dim sqlstmt As String
  Dim rs      As Recordset
  
  sqlstmt = "sp_DocLiquidacionFirmar " & m_Id & "," & us_id
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Function
  
  m_est_id = gDB.ValField(rs.fields, cscEstId)
  m_Estado = gDB.ValField(rs.fields, cscEstNombre)
  
  Dim iProp As cIABMProperty
  Set iProp = m_ObjAbm.Properties(csDocEstateID)
  
  With iProp
    .HelpId = m_est_id
    .Value = m_Estado
  End With
  
  gDB.GetData csTLiquidacion, cscLiqId, m_Id, cscLiqFirmado, m_Firmado
  
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
  
  sqlstmt = "sp_DocLiquidacionMover " & MoveTo & "," & m_Numero & "," & doc_id
  
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
        GetDocNumber m_LastDoc, m_ObjAbm, m_TaPropuesto, cscLiqNrodoc
    
    End Select
    
  Else
    If Not Load(gDB.ValField(rs.fields, 0)) Then Exit Function
    
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
    
    Set c = .Item(cscLiqFecha)
    c.Value = m_fecha
        
    Set c = .Item(cscLiqFechaDesde)
    c.Value = m_fechaDesde
    Set c = .Item(cscLiqFechaHasta)
    c.Value = m_fechaHasta
    Set c = .Item(cscLiqPeriodo)
    c.Value = m_periodo
        
    Set c = .Item(csDocNumberID)
    c.Value = m_Numero
    
    Set c = .Item(csDocEstateID)
    c.Value = m_Estado
    
    Set c = .Item(cscLiqNrodoc)
    c.Value = m_Nrodoc
    c.TextMask = m_TaMascara
    c.TextAlign = vbRightJustify
        
    Set c = .Item(cscLiqCotizacion)
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
    
    Set c = .Item(cscLiqDescrip)
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
  
  Set c = m_Items.Properties.Item(c_Items)
  If Not pLoadItems(c, Cotizacion) Then Exit Sub
  
  m_ItemsDeleted = vbNullString
  
  Set c = m_Items.Properties.Item(c_Exceptions)
  If Not pLoadExceptions(c) Then Exit Sub
  
  m_ExceptionsDeleted = vbNullString
    
  Set c = m_Items.Properties.Item(c_ConceptoAdm)
  If Not pLoadConceptosAdm(c) Then Exit Sub
  
  m_ConceptosAdmDeleted = vbNullString
    
  Set AbmGen = m_Items
  AbmGen.ShowValues m_Items.Properties
  
  Set c = m_Footer.Properties.Item(cscLiqTotal)
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
  m_UserCfg.ValidateLIQ

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
Private Function pSaveExceptions(ByVal ID As Long) As Boolean
  Dim register  As cRegister
  Dim IProperty As cIABMProperty
  Dim iOrden    As Long
  
  Dim Row  As cIABMGridRow
  Dim Cell As cIABMGridCellValue

  For Each Row In pGetExceptions().Rows

    Set register = New cRegister
    register.fieldId = cscLiqeTMPId
    register.Table = csTLiquidacionExcepcionTMP
    register.ID = csNew

    For Each Cell In Row
      Select Case Cell.Key

        Case KIE_LIQE_ID
          If m_Copy Then
            register.fields.Add2 cscLiqeId, csNew, csInteger
          Else
            register.fields.Add2 cscLiqeId, Val(Cell.Value), csInteger
          End If
        Case KIE_DESCRIP
          register.fields.Add2 cscLiqeDescrip, Cell.Value, csText

        Case KIE_EM_ID
          register.fields.Add2 cscEmId, Cell.ID, csId
        Case KIE_LIQFI_ID
          register.fields.Add2 cscLiqfiId, Cell.ID, csId
        Case KIE_CCOS_ID
          register.fields.Add2 cscCcosId, Cell.ID, csId
        
      End Select
    Next

    iOrden = iOrden + 1
    register.fields.Add2 cscLiqeOrden, iOrden, csInteger
    register.fields.Add2 cscLiqTMPId, ID, csId

    register.fields.HaveLastUpdate = False
    register.fields.HaveWhoModify = False

    If Not gDB.Save(register, , "pSaveExceptions", C_Module, c_ErrorSave) Then Exit Function
  Next

  Dim sqlstmt As String

  If m_ExceptionsDeleted <> vbNullString And m_Id <> csNO_ID And Not m_Copy Then

    Dim vDeletes As Variant
    Dim i As Long

    m_ExceptionsDeleted = RemoveLastColon(m_ExceptionsDeleted)
    vDeletes = Split(m_ExceptionsDeleted, ",")

    For i = 0 To UBound(vDeletes)

      Set register = New cRegister
      register.fieldId = cscLiqebTMPId
      register.Table = csTLiquidacionExcepcionBorradoTMP
      register.ID = csNew

      register.fields.Add2 cscLiqeId, Val(vDeletes(i)), csInteger
      register.fields.Add2 cscLiqId, m_Id, csId
      register.fields.Add2 cscLiqTMPId, ID, csId

      register.fields.HaveLastUpdate = False
      register.fields.HaveWhoModify = False

      If Not gDB.Save(register, , "pSaveExceptions", C_Module, c_ErrorSave) Then Exit Function
    Next

  End If

  pSaveExceptions = True
End Function

Private Function pSaveConceptosAdm(ByVal ID As Long) As Boolean
  Dim register  As cRegister
  Dim IProperty As cIABMProperty
  Dim iOrden    As Long
  
  Dim Row  As cIABMGridRow
  Dim Cell As cIABMGridCellValue

  For Each Row In pGetConceptosAdm().Rows

    Set register = New cRegister
    register.fieldId = cscLiqcaTMPId
    register.Table = csTLiquidacionConceptoAdmTMP
    register.ID = csNew

    For Each Cell In Row
      Select Case Cell.Key

        Case KICA_LIQCA_ID
          If m_Copy Then
            register.fields.Add2 cscLiqcaId, csNew, csInteger
          Else
            register.fields.Add2 cscLiqcaId, Val(Cell.Value), csInteger
          End If
        
        Case KICA_IMPORTE
          register.fields.Add2 cscLiqcaImporte, Cell.Value, csDouble
        Case KICA_DESCRIP
          register.fields.Add2 cscLiqcaDescrip, Cell.Value, csText

        Case KICA_EM_ID
          register.fields.Add2 cscEmId, Cell.ID, csId
        Case KICA_LIQFI_ID
          register.fields.Add2 cscLiqfiId, Cell.ID, csId
        Case KICA_CCOS_ID
          register.fields.Add2 cscCcosId, Cell.ID, csId
        
      End Select
    Next

    iOrden = iOrden + 1
    register.fields.Add2 cscLiqcaOrden, iOrden, csInteger
    register.fields.Add2 cscLiqTMPId, ID, csId

    register.fields.HaveLastUpdate = False
    register.fields.HaveWhoModify = False

    If Not gDB.Save(register, , "pSaveConceptosAdm", C_Module, c_ErrorSave) Then Exit Function
  Next

  Dim sqlstmt As String

  If m_ConceptosAdmDeleted <> vbNullString And m_Id <> csNO_ID And Not m_Copy Then

    Dim vDeletes As Variant
    Dim i As Long

    m_ConceptosAdmDeleted = RemoveLastColon(m_ConceptosAdmDeleted)
    vDeletes = Split(m_ConceptosAdmDeleted, ",")

    For i = 0 To UBound(vDeletes)

      Set register = New cRegister
      register.fieldId = cscLiqcabTMPId
      register.Table = csTLiquidacionConceptoAdmBorradoTMP
      register.ID = csNew

      register.fields.Add2 cscLiqcaId, Val(vDeletes(i)), csInteger
      register.fields.Add2 cscLiqId, m_Id, csId
      register.fields.Add2 cscLiqTMPId, ID, csId

      register.fields.HaveLastUpdate = False
      register.fields.HaveWhoModify = False

      If Not gDB.Save(register, , "pSaveConceptosAdm", C_Module, c_ErrorSave) Then Exit Function
    Next

  End If

  pSaveConceptosAdm = True
End Function

Private Function pGetConceptosAdm() As cIABMGrid
  Set pGetConceptosAdm = m_Items.Properties.Item(c_ConceptoAdm).Grid
End Function

Private Function pGetExceptions() As cIABMGrid
  Set pGetExceptions = m_Items.Properties.Item(c_Exceptions).Grid
End Function

Private Function pGetItems() As cIABMGrid
  Set pGetItems = m_Items.Properties.Item(c_Items).Grid
End Function

Private Function pGetItemsProperty() As cIABMProperty
  Set pGetItemsProperty = m_Items.Properties.Item(c_Items)
End Function

Private Function pLoadConceptosAdm(ByRef Propiedad As cIABMProperty) As Boolean
  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  
  sqlstmt = "sp_DocLiquidacionGetConceptosAdm " & m_Id
  
  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, "pLoadConceptosAdm", C_Module) Then Exit Function
  
  With Propiedad.Grid
    
    .Columns.Clear
    .Rows.Clear
    
    With .Columns
    
      With .Add(Nothing)
        .Visible = False
        .Key = KICA_LIQCA_ID
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(4555, vbNullString) 'Empleado
        .PropertyType = cspHelp
        .Table = csEmpleado
        .Width = 2200
        .Key = KICA_EM_ID
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(4611, vbNullString) 'Código
        .PropertyType = cspHelp
        .Table = csLiquidacionFormulaItem
        .Width = 1800
        .Key = KICA_LIQFI_ID
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(1228, vbNullString) 'Importe
        .PropertyType = cspNumeric
        .SubType = cspDouble
        .Width = 2500
        .Key = KICA_IMPORTE
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(1057, vbNullString) 'Centro de Costo
        .PropertyType = cspHelp
        .Table = csCentroCosto
        .Width = 1800
        .Key = KICA_CCOS_ID
      End With
            
      With .Add(Nothing)
        .Name = C_strDescrip
        .PropertyType = cspText
        .SubType = cspTextButtonEx
        .Width = 1600
        .Key = KICA_DESCRIP
      End With
    
    End With
    
    With .Rows
    
      While Not rs.EOF
        
        With .Add(Nothing, rs(cscLiqcaId).Value)
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscLiqcaId)
            .Key = KICA_LIQCA_ID
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscEmNombre)
            .ID = gDB.ValField(rs.fields, cscEmId)
            .Key = KICA_EM_ID
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscLiqfiCodigo)
            .ID = gDB.ValField(rs.fields, cscLiqfiId)
            .Key = KICA_LIQFI_ID
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscLiqcaImporte)
            .Key = KICA_IMPORTE
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscCcosNombre)
            .ID = gDB.ValField(rs.fields, cscCcosId)
            .Key = KICA_CCOS_ID
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscLiqcaDescrip)
            .Key = KICA_DESCRIP
          End With
        
        End With
        
        rs.MoveNext
      Wend
    End With
  End With
  
  pLoadConceptosAdm = True
End Function

Private Function pLoadExceptions(ByRef Propiedad As cIABMProperty) As Boolean
  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  
  sqlstmt = "sp_DocLiquidacionGetExcepciones " & m_Id
  
  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, "pLoadExceptions", C_Module) Then Exit Function
  
  With Propiedad.Grid
    
    .Columns.Clear
    .Rows.Clear
    
    With .Columns
    
      With .Add(Nothing)
        .Visible = False
        .Key = KIE_LIQE_ID
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(4555, vbNullString) 'Empleado
        .PropertyType = cspHelp
        .Table = csEmpleado
        .Width = 2200
        .Key = KIE_EM_ID
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(4611, vbNullString) 'Código
        .PropertyType = cspHelp
        .Table = csLiquidacionFormulaItem
        .Width = 1800
        .Key = KIE_LIQFI_ID
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(1057, vbNullString)    'Centro de Costo
        .PropertyType = cspHelp
        .Table = csCentroCosto
        .Width = 1800
        .Key = KIE_CCOS_ID
      End With
      
      With .Add(Nothing)
        .Name = C_strDescrip
        .PropertyType = cspText
        .SubType = cspTextButtonEx
        .Width = 1600
        .Key = KIE_DESCRIP
      End With
    
    End With
    
    With .Rows
    
      While Not rs.EOF
        
        With .Add(Nothing, rs(cscLiqeId).Value)
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscLiqeId)
            .Key = KIE_LIQE_ID
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscEmNombre)
            .ID = gDB.ValField(rs.fields, cscEmId)
            .Key = KIE_EM_ID
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscLiqfiCodigo)
            .ID = gDB.ValField(rs.fields, cscLiqfiId)
            .Key = KIE_LIQFI_ID
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscCcosNombre)
            .ID = gDB.ValField(rs.fields, cscCcosId)
            .Key = KIE_CCOS_ID
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscLiqeDescrip)
            .Key = KIE_DESCRIP
          End With
        
        End With
        
        rs.MoveNext
      Wend
    End With
  End With
  
  pLoadExceptions = True
End Function

Private Function pValidateRowConceptosAdm(ByRef Row As CSInterfacesABM.cIABMGridRow, _
                                        ByVal RowIndex As Long) As Boolean
                                     
  Dim Cell                  As cIABMGridCellValue
  Dim strRow                As String
  Dim bOrigen               As Boolean
  Dim MonId                 As Long
  
  strRow = " (Fila " & RowIndex & ")"
  
  For Each Cell In Row
    Select Case Cell.Key
      
      Case KICA_EM_ID
        If ValEmpty(Cell.ID, csId) Then
          MsgInfo LNGGetText(4613, vbNullString, strRow)   'Debe indicar un empleado (1)
          Exit Function
        End If
      
      Case KICA_LIQFI_ID
        If ValEmpty(Cell.ID, csId) Then
          MsgInfo LNGGetText(4612, vbNullString, strRow)   'Debe indicar un código (1)
          Exit Function
        End If
        
    End Select
  Next
    
  pValidateRowConceptosAdm = True
End Function

Private Function pValidateRowExceptions(ByRef Row As CSInterfacesABM.cIABMGridRow, _
                                        ByVal RowIndex As Long) As Boolean
                                     
  Dim Cell                  As cIABMGridCellValue
  Dim strRow                As String
  Dim bOrigen               As Boolean
  Dim MonId                 As Long
  
  strRow = " (Fila " & RowIndex & ")"
  
  For Each Cell In Row
    Select Case Cell.Key
      
      Case KIE_EM_ID
        If ValEmpty(Cell.ID, csId) Then
          MsgInfo LNGGetText(4613, vbNullString, strRow)   'Debe indicar un empleado (1)
          Exit Function
        End If
      
      Case KIE_LIQFI_ID
        If ValEmpty(Cell.ID, csId) Then
          MsgInfo LNGGetText(4612, vbNullString, strRow)   'Debe indicar un código (1)
          Exit Function
        End If
        
    End Select
  Next
    
  pValidateRowExceptions = True
End Function

Private Function pIsEmptyRowConceptosAdm(ByRef Row As CSInterfacesABM.cIABMGridRow, _
                                         ByVal RowIndex As Long) As Boolean
                                    
  Dim Cell                  As cIABMGridCellValue
  Dim strRow                As String
  Dim bRowIsEmpty           As Boolean
  
  strRow = " (Fila " & RowIndex & ")"
  
  bRowIsEmpty = True
  
  For Each Cell In Row
  
    Select Case Cell.Key
      
      Case KICA_EM_ID, KICA_LIQFI_ID
        If Not ValEmpty(Cell.Value, csText) Then
          bRowIsEmpty = False
          Exit For
        End If
    
    End Select
  Next
  
  pIsEmptyRowConceptosAdm = bRowIsEmpty
End Function

Private Function pIsEmptyRowExceptions(ByRef Row As CSInterfacesABM.cIABMGridRow, _
                                       ByVal RowIndex As Long) As Boolean
                                    
  Dim Cell                  As cIABMGridCellValue
  Dim strRow                As String
  Dim bRowIsEmpty           As Boolean
  
  strRow = " (Fila " & RowIndex & ")"
  
  bRowIsEmpty = True
  
  For Each Cell In Row
  
    Select Case Cell.Key
      
      Case KIE_EM_ID, KIE_LIQFI_ID
        If Not ValEmpty(Cell.Value, csText) Then
          bRowIsEmpty = False
          Exit For
        End If
    
    End Select
  Next
  
  pIsEmptyRowExceptions = bRowIsEmpty
End Function

Private Function pGetCotizacion() As cIABMProperty
  Set pGetCotizacion = m_ObjAbm.Properties.Item(cscLiqCotizacion)
End Function

Private Function pGetEmpleado() As cIABMProperty
  Set pGetEmpleado = m_ObjAbm.Properties.Item(cscEmId)
End Function

Private Sub pProcess()
  Dim LiqAux As cLiquidacionAux
  Set LiqAux = New cLiquidacionAux
  
  If LiqAux.Edit(m_Id, pGetSelecteds()) Then
    Load m_Id
    pRefreshProperties
  End If
End Sub

Private Sub pShowRecibo(ByVal liqi_id As Long)
  Dim AbmGen As cABMGeneric
  Set AbmGen = m_ObjAbm
  
  AbmGen.PrintDocEx liqi_id * -1
End Sub

Private Function pGetSelecteds() As Long()
  Dim rtn() As Long
  Dim i As Long
  Dim Row As cIABMGridRow
  Dim Rows As cIABMGridRows
  
  ReDim rtn(0)
  
  Set Rows = pGetItems().Rows
  
  For i = 1 To Rows.Count
    Set Row = Rows.Item(i)
    If pCell(Row, KI_SELECT).ID Then
      ReDim Preserve rtn(UBound(rtn) + 1)
      rtn(UBound(rtn)) = Val(pCell(Row, KI_LIQI_ID).Value)
    End If
  Next
  
  pGetSelecteds = rtn
End Function
