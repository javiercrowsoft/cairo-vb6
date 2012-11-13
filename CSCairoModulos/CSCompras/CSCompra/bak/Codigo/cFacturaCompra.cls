VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cFacturaCompra"
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
' cFacturaCompra
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
Private Const C_Module = "cFacturaCompra"
Private Const c_ErrorSave = "Error al grabar la factura de compra"
Private Const c_Items = "ITEMS"
Private Const c_Otros = "OTROS"
Private Const c_Percepciones = "PERCEPCIONES"
Private Const c_Legajos = "LEGAJOS"

Private Const K_NUMERO                         As Integer = 1
Private Const K_NRODOC                         As Integer = 2
Private Const K_DESCRIP                        As Integer = 3
Private Const K_FECHA                          As Integer = 4
Private Const K_FECHAENTREGA                   As Integer = 5
Private Const K_FECHAIVA                       As Integer = 501
Private Const K_FECHAVTO                       As Integer = 500
Private Const K_NETO                           As Integer = 6
Private Const K_IVARI                          As Integer = 7
Private Const K_IVARNI                         As Integer = 8
Private Const K_TOTAL                          As Integer = 9
Private Const K_PROV_ID                        As Integer = 10
Private Const K_DOC_ID                         As Integer = 11
Private Const K_LP_ID                          As Integer = 13
Private Const K_LD_ID                          As Integer = 14
Private Const K_ITEMS                          As Integer = 15
Private Const K_CPG_ID                         As Integer = 16
Private Const K_EST_ID                         As Integer = 17
Private Const K_CCOS_ID                        As Integer = 18
Private Const K_SUC_ID                         As Integer = 19
Private Const K_DESCUENTO1                     As Integer = 20
Private Const K_DESCUENTO2                     As Integer = 21
Private Const K_IMPORTEDESC1                   As Integer = 22
Private Const K_IMPORTEDESC2                   As Integer = 23
Private Const K_SUBTOTAL                       As Integer = 24
Private Const K_COTIZACION                     As Integer = 25
Private Const K_LGJ_ID                         As Integer = 27
Private Const K_CAI                            As Integer = 28

Private Const K_PRO_ID_ORIGEN                  As Integer = 29
Private Const K_PRO_ID_DESTINO                 As Integer = 30

Private Const K_OTROS                          As Integer = 31
Private Const K_TOTALOTROS                     As Integer = 32
Private Const K_PERCEPCIONES                   As Integer = 33
Private Const K_TOTAPERCEPCIONES               As Integer = 34
Private Const K_LEGAJOS                        As Integer = 35

Private Const K_DEPL_ID                        As Integer = 36

Private Const K_TIPOCOMPRABANTE                As Integer = 37

' TO
Private Const KI_TO_ID                          As Integer = 400

Private Const KI_FC_ID                          As Integer = 1
Private Const KI_FCI_ID                         As Integer = 2
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
Private Const KI_DESCUENTO                      As Integer = 18
Private Const KI_UNIDAD                         As Integer = 19
Private Const KI_PRECIO_LP                      As Integer = 20
Private Const KI_PRECIO_USR                     As Integer = 21
Private Const KI_CCOS_ID                        As Integer = 22
Private Const KI_CUE_ID                         As Integer = 23
Private Const KI_CUE_ID_IVARI                   As Integer = 24
Private Const KI_CUE_ID_IVARNI                  As Integer = 25

Private Const KI_PR_LLEVANROSERIE               As Integer = 30
Private Const KI_NROSERIE                       As Integer = 31
Private Const KI_GRUPO                          As Integer = 32

Private Const KI_DEBE                           As Integer = 26
Private Const KI_HABER                          As Integer = 27
Private Const KI_FCOT_ID                        As Integer = 28

Private Const KIL_LGJ_ID                        As Integer = 1
Private Const KIL_FCLGJ_ID                      As Integer = 2
Private Const KIL_IMPORTE                       As Integer = 3
Private Const KIL_DESCRIP                       As Integer = 4

' Lote
'
Private Const KI_STL_ID                         As Integer = 26
Private Const KI_STL_CODIGO                     As Integer = 29
Private Const KI_PR_LLEVALOTE                   As Integer = 27

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
Private m_Fechaentrega                 As Date
Private m_FechaVto                     As Date
Private m_FechaIva                     As Date
Private m_Neto                         As Double
Private m_Ivari                        As Double
Private m_Ivarni                       As Double
Private m_Total                        As Double
Private m_TotalOtros                   As Double
Private m_TotalPercepciones            As Double
Private m_SubTotal                     As Double
Private m_Descuento1                   As Double
Private m_Descuento2                   As Double
Private m_ImporteDesc1                 As Double
Private m_ImporteDesc2                 As Double
Private m_cpg_id                       As Long
Private m_CondicionPago                As String
Private m_lgj_id                       As Long
Private m_Legajo                       As String
Private m_Cai                          As String

Private m_pro_id_origen                As Long
Private m_ProOrigen                    As String
Private m_pro_id_destino               As Long
Private m_ProDestino                   As String

Private m_depl_id                      As Long
Private m_Deposito                     As String

Private m_tipoComprobante              As csETipoComprobante
Private m_Cotizacion                   As Double
Private m_ccos_id                      As Long
Private m_CentroCosto                  As String
Private m_suc_id                       As Long
Private m_Sucursal                     As String
Private m_Prov_id                      As Long
Private m_proveedor                    As String
Private m_doc_id                       As Long
Private m_Documento                    As String
Private m_Doct_id                      As Long
Private m_Lp_id                        As Long
Private m_ListaPrecio                  As String
Private m_Ld_id                        As Long
Private m_ListaDescuento               As String
Private m_mon_id                       As Long
Private m_lastMonIdCotizacion          As Long
Private m_Creado                       As Date
Private m_Modificado                   As Date
Private m_Modifico                     As Long
Private m_Firmado                      As Boolean

Private m_lastFecha                    As Date

' Para ver documentos auxiliares
'
Private m_as_id                        As Long
Private m_st_id                        As Long

Private m_Editing           As Boolean

Private m_Footer            As cIABMGeneric
Private m_Items             As cIABMGeneric
Private m_ObjAbm            As cIABMGeneric
Private m_ObjTree           As Object

Private m_LastDoc           As Long
Private m_LastDoctId        As Long ' nrs devolucion
Private m_LastProv          As Long
Private m_LastDocName       As String
Private m_LastProvName      As String

Private m_LastCpgId         As Long

Private m_bShowStockData    As Boolean

Private m_bIva              As Boolean
Private m_bIvaRni           As Boolean

Private m_IsNew             As Boolean

Private m_BranchId          As Long
Private m_TreeId            As Long

Private m_Host              As CSMenu.cIMenuHost

Private m_ItemsDeleted        As String
Private m_OtrosDeleted        As String
Private m_PercepcionesDeleted As String
Private m_LegajosDeleted      As String

Private m_Copy              As Boolean

Private m_GeneralConfig     As cGeneralConfig

Private m_DocEditable       As Boolean
Private m_DocEditMsg        As String

Private m_TaPropuesto       As Boolean
Private m_TaMascara         As String

Private m_ObjApply          As cFacturaCompraAplic

Private m_OcIds()           As Long
Private m_RcIds()           As Long

Private m_NrosSerie         As Collection

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

Public Function TerminateWizard(ByVal Id As Long)
  On Error Resume Next
  If Id <> csNO_ID Then
    cIEditGeneric_Edit Id
  End If
End Function

Public Sub ShowFacturaRemito(ByVal ProvId As Long, ByRef vRcIds() As Long)
  On Error GoTo ControlError

  m_Prov_id = ProvId
  gDB.GetData csTProveedor, cscProvId, ProvId, cscProvNombre, m_proveedor
  
  Dim i As Long
  ReDim m_RcIds(UBound(vRcIds) + 1)
  For i = 1 To UBound(vRcIds) + 1
    m_RcIds(i) = vRcIds(i - 1)
  Next
  
  If Not pInitMembers Then
    Exit Sub
  End If

  pShowStartWizardRemito

  GoTo ExitProc
ControlError:
  MngError Err, "ShowFacturaRemito", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Function pInitMembers() As Boolean
  Set cIEditGeneric_ObjAbm = New cABMGeneric
  Set cIEditGenericDoc_Footer = New cABMGeneric
  Set cIEditGenericDoc_Items = New cABMGeneric
  
  If Not DocSecurityCanAccess(csPreCpraNewFactura, _
                              csNO_ID, _
                              csEDocTPreNew) Then
    Exit Function
  End If
  pInitMembers = True
End Function

Public Sub ShowFacturaOrden(ByVal ProvId As Long, ByRef vOcIds() As Long)
  On Error GoTo ControlError

  m_Prov_id = ProvId
  gDB.GetData csTProveedor, cscProvId, ProvId, cscProvNombre, m_proveedor
  
  Dim i As Long
  ReDim m_OcIds(UBound(vOcIds) + 1)
  For i = 1 To UBound(vOcIds) + 1
    m_OcIds(i) = vOcIds(i - 1)
  Next
  
  If Not pInitMembers Then
    Exit Sub
  End If

  pShowStartWizard

  GoTo ExitProc
ControlError:
  MngError Err, "ShowFacturaOrden", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub
' Implementacion de cIABMClient
Private Function cIABMClient_Copy() As Boolean
  
  If Not DocSecurityCanAccessEx(csPreCpraNewFactura, _
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
  GetDocNumberForProveedor m_LastProv, m_LastDoc, m_ObjAbm, m_TaPropuesto
  pSetEnabled
End Function

Private Function cIABMClient_EditNew() As Boolean
  
  cIABMClient_Terminate
  m_IsNew = True

  cIEditGeneric_Edit csNO_ID
  m_LastProv = csNO_ID
  
  If Not m_DocEditable Then MsgWarning m_DocEditMsg
  
  ' Obtengo los datos por defecto del proveedor
  '
  pSetDatosProveedor
  
  ' Obtengo el numero para este comprobante
  '
  GetDocNumberForProveedor m_LastProv, m_LastDoc, m_ObjAbm, m_TaPropuesto
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

  Doc.ClientTable = csTFacturaCompra
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
      pShowTotales
    
    Case MSG_DOC_APPLY
      pShowApply
    
    Case MSG_DOC_EDIT_STATE
      ShowEditState m_DocEditMsg, "Factura de Compra"
      
    Case MSG_DOC_DELETE
      If cIEditGeneric_Delete(m_Id) Then
        cIABMClient_MessageEx = True
        pMove MSG_DOC_NEXT
      End If
    
    Case MSG_DOC_ANULAR
      DocAnular m_Id, m_est_id, m_Estado, csPreCpraAnularFactura, csPreCpraDesAnularFactura, m_ObjAbm, m_DocEditable, m_DocEditMsg, "sp_DocFacturaCompraAnular", "sp_DocFacturaCompraEditableGet"
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
      DocumentSearch csEDT_FacturaCompra, Me, Not CBool(Info)
  
    Case MSG_DOC_DOC_AUX
      
      If m_Id Then
      
        If m_bShowStockData Then
          Dim AbmObj As cABMGeneric
          Set AbmObj = m_ObjAbm
        
          AbmObj.ShowPopMenu "&Ver Asiento~1|Ver Transferencia de Stock~2"
        Else
          ShowDocAux m_as_id, _
                     "CSContabilidad2.cAsiento", _
                     "CSABMInterface2.cABMGeneric"
        End If
      Else
        MsgInfo "Debe editar un comprobante guardado para poder ver los documentos auxiliares"
      End If
      
    Case MSG_DOC_DOC_EDIT
      
      If m_Id Then
      
        If m_DocEditable Then
        
          MsgInfo "Este documento puede editarse normalmente"
        Else
          
          If DocCanSave(m_ObjAbm, cscFcFecha) Then
            
            Dim EditDoc As cEditDocEx
            Set EditDoc = New cEditDocEx
            
            With EditDoc
              Set .ObjectClient = Me
              .bMonedaLegal = GetMonedaDefault = GetMonIdFromDoc(pGetDocId().HelpId)
              .Cotizacion = Val(pGetCotizacion.Value)
              .Edit m_Id, _
                    m_Doct_id, _
                    csTFacturaCompra, _
                    cscFcId, _
                    csTFacturaCompraItem, _
                    cscFciId, _
                    csPreCpraNewFactura, _
                    csPreCpraEditFactura, _
                    csNO_ID, m_Prov_id, _
                    True
            End With
          End If
          
        End If
      
      Else
        MsgInfo "Esta opción solo sirve para modificar documentos guardados y aplicados"
      End If
      
    Case MSG_MENU_AUX
      
      Select Case Val(Info)
        Case 1 ' Asiento
          ShowDocAux m_as_id, _
                     "CSContabilidad2.cAsiento", _
                     "CSABMInterface2.cABMGeneric"

          
        Case 2 ' Transferencia de stock
          ShowDocAux m_st_id, _
                     "CSStock2.cStock", _
                     "CSABMInterface2.cABMGeneric"

      End Select
  
    Case MSG_DOC_HISTORY
    
      If m_Id <> csNO_ID Then
    
        ShowHistory csFacturaCompra, m_Id, m_Documento & " " & m_Nrodoc
      Else
        
        MsgInfo LNGGetText(1552, vbNullString) ' "El documento aun no ha sido guardado"
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
        
        ' Obtengo el tipo de documento
        If Not gDB.GetData(csTDocumento, cscDocId, m_LastDoc, cscDoctId, m_LastDoctId) Then Exit Function ' nrs devolucion
        
        ' Si cambie de documento y estaba en un comprobante ya guardado
        ' tengo que mostrar el formulario sin datos, para evitar
        ' que presione guardar y le cambie el doc_id al comprobante por error
        '
        If m_Id <> csNO_ID And m_doc_id <> m_LastDoc Then cIEditGeneric_Edit csDocChanged
        
        ' Obtengo el numero para este comprobante
        '
        GetDocNumberForProveedor m_LastProv, m_LastDoc, m_ObjAbm, m_TaPropuesto
        
        ' Si corresponde muestro la cotizacion de la moneda del documento
        '
        pShowCotizacion
        
        ' Si corresponde muestro el deposito
        '
        pSetShowStockData
      End If
      ' Defino el estado de edicion del comprobante
      '
      pSetEnabled
      
    Case K_PROV_ID
      
      ' Obtengo los datos del proveedor
      '
      If pSetDatosProveedor Then GetDocNumberForProveedor m_LastProv, m_LastDoc, m_ObjAbm, m_TaPropuesto
      
    Case K_DESCUENTO1, K_DESCUENTO2
      pShowTotales
  
    Case K_FECHA
      
      ' Cotizacion
      If m_lastFecha <> pGetFecha() Then
        m_lastFecha = pGetFecha()
        m_lastMonIdCotizacion = csNO_ID
        pShowCotizacion
      
        With m_ObjAbm.Properties
          .Item(cscFcFechaIva).Value = .Item(cscFcFecha).Value
          m_ObjAbm.ShowValue .Item(cscFcFechaIva)
        End With
    
      End If
    
    Case K_CPG_ID
    
      pShowFechaVto
  End Select
End Function

Private Function cIABMClient_Save() As Boolean
  Dim register     As cRegister
  Dim Cotizacion   As Double
  Dim TotalOrigen  As Double
  Dim bMonedaLegal As Boolean
  Dim Neto         As Double
  Dim TotalOtros   As Double
  Dim TotalPercep  As Double
  Dim IvaRi        As Double
  Dim IvaRni       As Double
  Dim DocId        As Long
  
  ' Save and State
  '
  If Not DocCanEdit(m_DocEditable, m_DocEditMsg) Then
    cIABMClient_Save = True
    Exit Function
  End If
  If Not DocCanSave(m_ObjAbm, cscFcFecha) Then
    cIABMClient_Save = False
    Exit Function
  End If
  
  Dim Mouse As cMouseWait
  Set Mouse = New cMouseWait
  
  DoEvents: DoEvents: DoEvents: DoEvents
  
  Set register = New cRegister
  register.fieldId = cscFcTMPId
  register.Table = csTFacturaCompraTMP
  
  register.Id = csNew
    
  If m_Copy Then
    register.fields.Add2 cscFcId, csNew, csLong
  Else
    register.fields.Add2 cscFcId, m_Id, csLong
  End If
  
  If register.Id = csNew Then
    m_est_id = CSGeneralEx2.csEEstado.csEEst_Pendiente
  End If
  
  Dim IProperty As cIABMProperty
  For Each IProperty In m_ObjAbm.Properties
    With IProperty
      Select Case .Key
        Case K_NUMERO
          register.fields.Add2 cscFcNumero, .Value, csLong
        Case K_NRODOC
          register.fields.Add2 cscFcNrodoc, .Value, csText
        Case K_DESCRIP
          register.fields.Add2 cscFcDescrip, .Value, csText
        Case K_FECHA
          register.fields.Add2 cscFcFecha, .Value, csDate
        Case K_FECHAENTREGA
          register.fields.Add2 cscFcFechaentrega, .Value, csDate
        Case K_FECHAIVA
          register.fields.Add2 cscFcFechaIva, .Value, csDate
        Case K_FECHAVTO
          register.fields.Add2 cscFcFechaVto, .Value, csDate
        Case K_PROV_ID
          register.fields.Add2 cscProvId, .HelpId, csId
        Case K_CCOS_ID
          register.fields.Add2 cscCcosId, .HelpId, csId
        Case K_SUC_ID
          register.fields.Add2 cscSucId, .HelpId, csId
        Case K_DESCUENTO1
          register.fields.Add2 cscFcDescuento1, .Value, csCurrency
        Case K_DESCUENTO2
          register.fields.Add2 cscFcDescuento2, .Value, csCurrency
        Case K_DOC_ID
          DocId = .HelpId
          register.fields.Add2 cscDocId, DocId, csId
        Case K_LP_ID
          register.fields.Add2 cscLpId, .HelpId, csId
        Case K_LD_ID
          register.fields.Add2 cscLdId, .HelpId, csId
        Case K_CPG_ID
          register.fields.Add2 cscCpgId, .HelpId, csId
        Case K_COTIZACION
          Cotizacion = .Value
          register.fields.Add2 cscFcCotizacion, .Value, csDouble
        Case K_PROV_ID
          register.fields.Add2 cscProvId, .HelpId, csId
        Case K_LGJ_ID
          register.fields.Add2 cscLgjId, .HelpId, csId
        Case K_CAI
          register.fields.Add2 cscFcCai, .Value, csText
        Case K_PRO_ID_ORIGEN
          register.fields.Add2 cscProIdOrigen, .HelpId, csId
        Case K_PRO_ID_DESTINO
          register.fields.Add2 cscProIdDestino, .HelpId, csId
        Case K_DEPL_ID
          register.fields.Add2 cscDeplId, .HelpId, csId
        Case K_TIPOCOMPRABANTE
          register.fields.Add2 cscFcTipoComprobante, .ListItemData, csInteger
      End Select
    End With
  Next
  
  ' Manejo de la moneda y la cotizacion
  '
  bMonedaLegal = GetMonedaDefault = GetMonIdFromDoc(DocId)
  If bMonedaLegal Then
    Cotizacion = 1
  Else
    If Cotizacion = 0 Then Cotizacion = 1
  End If
  
  For Each IProperty In m_Footer.Properties
    With IProperty
      Select Case .Key
        Case K_NETO
          Neto = Val(.Value)
          register.fields.Add2 cscFcNeto, Neto * Cotizacion, csCurrency
        Case K_IVARI
          IvaRi = Val(.Value)
          register.fields.Add2 cscFcIvari, IvaRi * Cotizacion, csCurrency
        Case K_IVARNI
          IvaRni = Val(.Value)
          register.fields.Add2 cscFcIvarni, IvaRni * Cotizacion, csCurrency
        Case K_SUBTOTAL
          register.fields.Add2 cscFcSubtotal, Val(.Value) * Cotizacion, csCurrency
        Case K_IMPORTEDESC1
          register.fields.Add2 cscFcImportedesc1, Val(.Value) * Cotizacion, csCurrency
        Case K_IMPORTEDESC2
          register.fields.Add2 cscFcImportedesc2, Val(.Value) * Cotizacion, csCurrency
        Case K_TOTALOTROS
          TotalOtros = Val(.Value)
          register.fields.Add2 cscFcTotalOtros, TotalOtros * Cotizacion, csCurrency
        Case K_TOTAPERCEPCIONES
          TotalPercep = Val(.Value)
          register.fields.Add2 cscFcTotalPercepciones, TotalPercep * Cotizacion, csCurrency
      End Select
    End With
  Next
  
  TotalOrigen = Neto + TotalOtros + TotalPercep
  If m_bIva Then
    TotalOrigen = TotalOrigen + IvaRi
  End If
  If m_bIvaRni Then
    TotalOrigen = TotalOrigen + IvaRni
  End If
  
  With register
    With .fields
      .Add2 cscFcTotal, TotalOrigen * Cotizacion, csCurrency
      .Add2 cscFcGrabarAsiento, 1, csBoolean
      .Add2 cscEstId, m_est_id, csId
    
      If bMonedaLegal Then
        .Add2 cscFcTotalOrigen, 0, csCurrency
      Else
        .Add2 cscFcTotalOrigen, TotalOrigen, csCurrency
      End If
    
      .HaveLastUpdate = True
      .HaveWhoModify = True
    End With
  
    If Not .BeginTrans(gDB) Then Exit Function
    
    If Not gDB.Save(register, , "cIABMClient_Save", C_Module, c_ErrorSave) Then Exit Function
    
    If Not pSaveItems(.Id, Cotizacion, bMonedaLegal) Then Exit Function
    If Not pSaveOtros(.Id, Cotizacion, bMonedaLegal) Then Exit Function
    If Not SavePercepciones(GetItems(m_Items, c_Percepciones), _
                            .Id, Cotizacion, bMonedaLegal, _
                            m_Copy, m_PercepcionesDeleted, _
                            m_Id, C_Module) Then Exit Function
    If Not pSaveLegajos(.Id, Cotizacion, bMonedaLegal) Then Exit Function
    
    If Not .CommitTrans() Then Exit Function
  
  End With

  Dim sqlstmt As String
  Dim rs      As Recordset
  sqlstmt = "sp_DocFacturaCompraSave " & register.Id
  
  If Not gDB.OpenRs(sqlstmt, rs, , , , "cIABMClient_Save", C_Module, c_ErrorSave) Then
    ' Si el error es por clave duplicada
    If CSKernelClient2.LastErrorNumber = -2147217900 Then
      If InStr(1, CSKernelClient2.LastErrorDescription, "IX_FacturaCompra") Then
        pShowFacturaDuplicada
      End If
    End If
    Exit Function
  End If
  
  If rs.EOF Then Exit Function
  
  Dim Id As Long
  If Not GetDocIDFromRecordset(rs, Id) Then Exit Function
  
  m_Copy = False
  
  cIABMClient_Save = Load(Id)
End Function

Private Sub pShowFacturaDuplicada()
  Dim NroDoc    As String
  Dim sqlstmt   As String
  Dim rs        As ADODB.Recordset
  Dim msg       As String
  Dim ProvId    As Long
  
  NroDoc = m_ObjAbm.Properties.Item(cscFcNrodoc).Value
  ProvId = m_ObjAbm.Properties.Item(cscProvId).HelpId
  sqlstmt = "sp_DocFacturaCompraGetForNroDoc " & gDB.sqlString(NroDoc) & "," & ProvId
  
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Sub
  
  If Not rs.EOF Then
    With rs.fields
      msg = "La factura " & .Item(cscFcNrodoc).Value & " pertenece al proveedor " & .Item(cscProvNombre).Value & " en el documento " & .Item(cscDocNombre).Value & " generada el " & .Item(cscFcFecha).Value
      MsgWarning msg
    End With
  End If
End Sub

Private Function cIABMClient_Terminate() As Boolean
  m_Editing = False
  
  cIABMClient_Terminate = True
  ' Este objeto puede no cumplir con la interfaz esperada, asi que si hay un error no
  ' le doy bola
  On Error GoTo ControlError
  If m_Id = csNO_ID Then Exit Function
  If m_ObjTree Is Nothing Then Exit Function
  
  m_ObjTree.sqlstmt = "sp_lsdoc_FacturaCompra"
  
  If m_IsNew Then
    m_ObjTree.AddLine m_Id
  Else
    m_ObjTree.RefreshLine m_Id
  End If
ControlError:
End Function

Private Property Get cIABMClient_Title() As String
  cIABMClient_Title = "Facturas de Compra"
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
        Case K_FECHAENTREGA
          If ValEmpty(.Value, csDate) Then
            MsgInfo "Debe indicar una fecha de entrega"
            Exit Function
          End If
        Case K_FECHAVTO
          If ValEmpty(.Value, csDate) And .Visible Then
            MsgInfo "Debe indicar una fecha de vencimiento"
            Exit Function
          End If
        Case K_PROV_ID
          If ValEmpty(.HelpId, csId) Then
            MsgInfo "Debe indicar un Proveedor"
            Exit Function
          End If
        Case K_DOC_ID
          If ValEmpty(.HelpId, csId) Then
            MsgInfo "Debe indicar un documento"
            Exit Function
          End If
        Case K_CPG_ID
          If ValEmpty(.HelpId, csId) Then
            MsgInfo "Debe indicar una condición de pago"
            Exit Function
          End If
        Case K_SUC_ID
          If ValEmpty(.HelpId, csId) Then
            MsgInfo "Debe indicar una sucursal"
            Exit Function
          End If
        Case K_COTIZACION
          If ValEmpty(.Value, csDouble) And .Visible Then
            MsgInfo "Debe indicar una cotización"
            Exit Function
          End If
        Case K_DEPL_ID
          If ValEmpty(.HelpId, csId) And m_bShowStockData Then
            MsgInfo "Debe indicar un deposito"
            Exit Function
          End If
      End Select
    End With
  Next
  
  If Not pValidateCuentaMoneda() Then Exit Function

  cIABMClient_Validate = True
End Function

Private Function pValidateCuit(ByVal ProvId As Long) As Boolean
  On Error GoTo ControlError

  Dim sqlstmt  As String
  Dim rs       As Recordset
  Dim Cuit     As String
  
  If ProvId <> csNO_ID Then
  
    sqlstmt = "select prov_catfiscal, prov_cuit from proveedor where prov_id=" & ProvId
  
    If Not gDB.OpenRs(sqlstmt, rs) Then Exit Function
    
    If Not rs.EOF Then
      Cuit = gDB.ValField(rs.fields, cscProvCuit)
      
      Select Case gDB.ValField(rs.fields, cscProvCatFiscal)
        Case csCatFConsumidorFinal, csCatFExento, csCatFExtranjero, csCatFNoCategorizado
        Case Else 'csCatFExtranjeroIva,csCatFMonoTributo, csCatFInscripto,
                  'csCatFNoInscripto, csCatFNoResponsableExento, csCatFInscriptoM
          If Trim(Cuit) = vbNullString Then
            MsgWarning "Para poder crear la factura debe dar de alta el CUIT del Proveedor"
            Exit Function
          End If
      End Select
    Else
      MsgWarning "No se pudo obtener el Cuit del Proveedor"
    End If
  End If
       
  pValidateCuit = True
  
  GoTo ExitProc
ControlError:
  MngError Err, "pValidateCuit", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function


Private Function pValidateCuentaMoneda() As Boolean
  Dim MonIdProveedor      As Long
  Dim MonIdDocumento    As Long
  
  If Not pGetCueIdProveedor(MonIdProveedor, 0) Then Exit Function
  If Not gDB.GetData(csTDocumento, cscDocId, m_LastDoc, cscMonId, MonIdDocumento) Then Exit Function
  
  If MonIdProveedor <> MonIdDocumento Then
    MsgInfo "La cuenta asociada al Proveedor y la cuenta del documento tienen diferentes monedas"
    Exit Function
  End If
  pValidateCuentaMoneda = True
End Function

Private Function cIABMClientGrid_IsEmptyRow(ByVal Key As Integer, Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  On Error GoTo ControlError

  Select Case Key
    Case K_ITEMS
      cIABMClientGrid_IsEmptyRow = pIsEmptyRowItems(Row, RowIndex)
    Case K_OTROS
      cIABMClientGrid_IsEmptyRow = pIsEmptyRowOtros(Row, RowIndex)
    Case K_PERCEPCIONES
      cIABMClientGrid_IsEmptyRow = IsEmptyRowPercepciones(Row, RowIndex)
    Case K_LEGAJOS
      cIABMClientGrid_IsEmptyRow = pIsEmptyRowLegajos(Row, RowIndex)
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
  
  sqlstmt = "select doct_id, doc_id from FacturaCompra where fc_id = " & Id
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
  cIEditGeneric_ShowList = SecurityCanAccess(csPreCpraListFactura)
End Function

Private Property Set cIEditGeneric_ObjAbm(rhs As CSInterfacesABM.cIABMGeneric)
  Set m_ObjAbm = rhs
  m_ObjAbm.IsDocument = True

#If Not PREPROC_SFS Then
  Dim AbmGen      As cABMGenericDocEx
  
  Set AbmGen = m_ObjAbm
  With AbmGen
    .FactoryObject = "CSABMInterface2.cFactory"
    .ObjForm = "CSABMInterface2.fFacturaCompra"
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
                          csTFacturaCompra, _
                          cscFcId, _
                          doc_id) Then
      Exit Function
    End If
  End If
  
  If Not DocSecurityCanAccess( _
                  csPreCpraDeleteFactura, _
                  doc_id, _
                  csEDocTPreDelete) Then
    Exit Function
  End If

  Dim sqlstmt As String
  
  sqlstmt = "sp_DocFacturaCompraDelete " & Id
  
  cIEditGeneric_Delete = gDB.Execute(sqlstmt, "cIEditGeneric_Delete", C_Module)
End Function

Private Function cIEditGeneric_Search(Id As Long, Cancela As Boolean) As Boolean

End Function

Private Function cIEditGeneric_Edit(Id As Long, Optional ByVal InModalWindow As Boolean) As Boolean
  On Error GoTo ControlError
  
  If Not DocSecurityCanAccess(csPreCpraListFactura, GetdocIdFromObjAbm(m_ObjAbm), csEDocTPreList) Then Exit Function
    
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

  Dim AbmGen As cABMGeneric
  Set AbmGen = m_ObjAbm
  AbmGen.NewKeyPropFocus = vbNullString

  ' Solo muestro asistentes si el nuevo no se esta dando por
  ' un cambio de documento
  '
  If Id <> csDocChanged And m_IsNew And pDocDesdeOrden() Then
      
    pShowStartWizard
  
  ElseIf Id <> csDocChanged And m_IsNew And pDocDesdeRemito() Then
  
    pShowStartWizardRemito
  
  Else
    
    AbmGen.NewKeyPropFocus = cscProvId
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
    
      If m_Items.Properties.Item(c_Items).Grid.Columns.Item(lCol).Key = KI_IVARI Then
        pShowImporteAndIvaManual GetItems(m_Items, c_Items).Grid.Rows(lRow)
      Else
        pShowImporteAndIva GetItems(m_Items, c_Items).Grid.Rows(lRow)
      End If
      pShowTotales
      cIABMClientGrid_ColumnAfterUpdate = True
    Case K_OTROS
      pShowTotales
      cIABMClientGrid_ColumnAfterUpdate = True
    Case K_PERCEPCIONES
      pShowTotales
      cIABMClientGrid_ColumnAfterUpdate = True
    Case K_LEGAJOS
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
      cIABMClientGrid_ColumnAfterEdit = pColumnAfterEditItems( _
                                            GetItems(m_Items, c_Items), _
                                            lRow, _
                                            lCol, _
                                            NewValue, _
                                            NewValueID)
    Case K_OTROS
      cIABMClientGrid_ColumnAfterEdit = pColumnAfterEditOtros( _
                                            m_Items.Properties.Item(c_Otros), _
                                            lRow, _
                                            lCol, _
                                            NewValue, _
                                            NewValueID)
    Case K_PERCEPCIONES
      cIABMClientGrid_ColumnAfterEdit = ColumnAfterEditPercepciones( _
                                            m_Items.Properties.Item(c_Percepciones), _
                                            lRow, _
                                            lCol, _
                                            NewValue, _
                                            NewValueID)
    Case K_LEGAJOS
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
    Case K_ITEMS
      cIABMClientGrid_ColumnBeforeEdit = pColumnBeforeEditItems( _
                                                GetItems(m_Items, c_Items), _
                                                lRow, _
                                                lCol, _
                                                iKeyAscii)
    Case K_OTROS
      cIABMClientGrid_ColumnBeforeEdit = pColumnBeforeEditOtros( _
                                                m_Items.Properties.Item(c_Otros), _
                                                lRow, _
                                                lCol, _
                                                iKeyAscii)
    Case K_PERCEPCIONES
      cIABMClientGrid_ColumnBeforeEdit = True
    Case K_LEGAJOS
      cIABMClientGrid_ColumnBeforeEdit = True
  End Select
  
  GoTo ExitProc
ControlError:
  MngError Err, "cIABMClientGrid_ColumnBeforeEdit", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Private Function pColumnBeforeEditItems(ByRef IProperty As cIABMProperty, _
                                        ByVal lRow As Long, _
                                        ByVal lCol As Long, _
                                        ByVal iKeyAscii As Integer) As Boolean
  
  Dim Row As cIABMGridRow
  
  Select Case IProperty.Grid.Columns(lCol).Key
    Case KI_NROSERIE
      Set Row = IProperty.Grid.Rows(lRow)
      If Not Row Is Nothing Then
        pColumnBeforeEditItems = pCell(Row, KI_PR_LLEVANROSERIE).Id
      End If
    
    ' Lote
    '
    Case KI_STL_CODIGO
      Set Row = IProperty.Grid.Rows(lRow)
      If Not Row Is Nothing Then
        pColumnBeforeEditItems = pCell(Row, KI_PR_LLEVALOTE).Id
      End If
    
    Case Else
      pColumnBeforeEditItems = True
  End Select
End Function

Private Function pColumnBeforeEditOtros(ByRef IProperty As cIABMProperty, _
                                        ByVal lRow As Long, _
                                        ByVal lCol As Long, _
                                        ByVal iKeyAscii As Integer) As Boolean
  pColumnBeforeEditOtros = True
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

Private Function pColumnAfterEditOtros(ByRef IProperty As cIABMProperty, _
                                       ByVal lRow As Long, _
                                       ByVal lCol As Long, _
                                       ByVal NewValue As Variant, _
                                       ByVal NewValueID As Long) As Boolean
  Dim Row     As cIABMGridRow
  
  With IProperty.Grid.Columns(lCol)
    Select Case .Key
      Case KI_DEBE, KI_HABER
        Set Row = IProperty.Grid.Rows(lRow)
        If .Key = KI_DEBE Then
          With pCell(Row, KI_DEBE)
            If Val(NewValue) < 0 Then
              .Value = 0
            ElseIf Val(NewValue) > 0 Then
              pCell(Row, KI_HABER).Value = 0
            End If
          End With
        ElseIf .Key = KI_HABER Then
          With pCell(Row, KI_HABER)
            If Val(NewValue) < 0 Then
              .Value = 0
            ElseIf Val(NewValue) > 0 Then
              pCell(Row, KI_DEBE).Value = 0
            End If
          End With
        End If
    End Select
  End With
  
  pColumnAfterEditOtros = True
End Function

Private Function pColumnAfterEditItems(ByRef IProperty As cIABMProperty, _
                                       ByVal lRow As Long, _
                                       ByVal lCol As Long, _
                                       ByVal NewValue As Variant, _
                                       ByVal NewValueID As Long) As Boolean
  Dim Row     As cIABMGridRow
  
  Select Case IProperty.Grid.Columns(lCol).Key
    Case KI_PR_ID
      Set Row = IProperty.Grid.Rows(lRow)
      pSetDataProducto Row, NewValueID
      pSetPrecios Row, NewValueID
      pSetDescuentos Row, NewValueID, pGetPrecioFromRow(Row)
      pSetTasasImpositivas Row, NewValueID, NewValue
      
    Case KI_PRECIO_USR
      Set Row = IProperty.Grid.Rows(lRow)
      pSetDescuentos Row, pCell(Row, KI_PR_ID).Id, NewValue
      
    Case KI_CANTIDAD
      
      Set Row = IProperty.Grid.Rows(lRow)
      
      If pCell(Row, KI_PR_LLEVANROSERIE).Id Then
      
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
                                       pGetPrId(PrId), _
                                       pGetDeplId(), _
                                       pGetIsInput(), _
                                       pGetProvId()) Then Exit Function
      End If
  End Select
  
  pColumnAfterEditItems = True
End Function

Private Function cIABMClientGrid_ColumnButtonClick(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long, ByVal iKeyAscii As Integer) As Boolean
  Dim Row As cIABMGridRow
  
  Select Case Key
    Case K_ITEMS
      With GetItems(m_Items, c_Items).Grid
        Select Case .Columns(lCol).Key
          Case KI_NROSERIE
            Set Row = .Rows(lRow)
            If pCell(Row, KI_PR_LLEVANROSERIE).Id Then
            
              Dim PrId As Long
              
              PrId = pCell(Row, KI_PR_ID).Id
            
              ' nrs devolucion
              cIABMClientGrid_ColumnButtonClick = EditNroSerie(pCell(Row, KI_GRUPO).Id, _
                                                               Val(pCell(Row, KI_CANTIDAD).Value), _
                                                               Row, _
                                                               m_NrosSerie, _
                                                               KI_GRUPO, _
                                                               KI_NROSERIE, _
                                                               lRow, _
                                                               pGetPrId(PrId), _
                                                               pGetDeplId, _
                                                               pGetIsInput(), _
                                                               False, Nothing, _
                                                               pGetProvId, csNO_ID)
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
  
  Select Case Key
    Case K_ITEMS
      Id = Val(pCell(Row, KI_FCI_ID).Value)
      If Id <> csNO_ID Then m_ItemsDeleted = m_ItemsDeleted & Id & ","
    Case K_OTROS
      Id = Val(pCell(Row, KI_FCOT_ID).Value)
      If Id <> csNO_ID Then m_OtrosDeleted = m_OtrosDeleted & Id & ","
    Case K_PERCEPCIONES
      Id = Val(pCell(Row, KIP_FCPERC_ID).Value)
      If Id <> csNO_ID Then m_PercepcionesDeleted = m_PercepcionesDeleted & Id & ","
    Case K_LEGAJOS
      Id = Val(pCell(Row, KIL_FCLGJ_ID).Value)
      If Id <> csNO_ID Then m_LegajosDeleted = m_LegajosDeleted & Id & ","
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
      cIABMClientGrid_ValidateRow = pValidateRowItems(Row, RowIndex)
    Case K_OTROS
      cIABMClientGrid_ValidateRow = pValidateRowOtros(Row, RowIndex)
    Case K_PERCEPCIONES
      cIABMClientGrid_ValidateRow = ValidateRowPercepciones(Row, RowIndex)
    Case K_LEGAJOS
      cIABMClientGrid_ValidateRow = pValidateRowLegajos(Row, RowIndex)
  End Select
  
  GoTo ExitProc
ControlError:
  MngError Err, "cIABMClientGrid_ValidateRow", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Private Function pIsEmptyRowLegajos(ByRef Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  Dim Cell                  As cIABMGridCellValue
  Dim strRow                As String
  Dim bRowIsEmpty           As Boolean
  
  strRow = " (Fila " & RowIndex & ")"
  
  bRowIsEmpty = True
  
  For Each Cell In Row
    Select Case Cell.Key
      Case KIL_IMPORTE
        If Not ValEmpty(Cell.Value, csCurrency) Then
          bRowIsEmpty = False
          Exit For
        End If
      Case KIL_LGJ_ID
        If Not ValEmpty(Cell.Id, csId) Then
          bRowIsEmpty = False
          Exit For
        End If
      Case KIL_DESCRIP
        If Not ValEmpty(Cell.Value, csText) Then
          bRowIsEmpty = False
          Exit For
        End If
    End Select
  Next
  
  pIsEmptyRowLegajos = bRowIsEmpty
End Function

Private Function pIsEmptyRowOtros(ByRef Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  Dim Cell                  As cIABMGridCellValue
  Dim strRow                As String
  Dim bRowIsEmpty           As Boolean
  
  strRow = " (Fila " & RowIndex & ")"
  
  bRowIsEmpty = True
  
  For Each Cell In Row
    Select Case Cell.Key
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
      Case KI_CUE_ID
        If Not ValEmpty(Cell.Id, csId) Then
          bRowIsEmpty = False
          Exit For
        End If
    End Select
  Next
  
  pIsEmptyRowOtros = bRowIsEmpty
End Function

Private Function pIsEmptyRowItems(ByRef Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
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
  
  pIsEmptyRowItems = bRowIsEmpty
End Function

Private Function pValidateRowLegajos(ByRef Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  Dim Cell                  As cIABMGridCellValue
  Dim strRow                As String
  strRow = " (Fila " & RowIndex & ")"
  
  For Each Cell In Row
    Select Case Cell.Key
      Case KIL_LGJ_ID
        If ValEmpty(Cell.Id, csId) Then
          MsgInfo "Debe indicar un legajo" & strRow
          Exit Function
        End If
      Case KIL_IMPORTE
        If ValEmpty(Cell.Value, csCurrency) Then
          MsgInfo "Debe indicar un importe" & strRow
          Exit Function
        End If
    End Select
  Next
  
  pValidateRowLegajos = True
End Function

Private Function pValidateRowOtros(ByRef Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  Dim Cell                  As cIABMGridCellValue
  Dim strRow                As String
  Dim bDebeHaber            As Boolean
  strRow = " (Fila " & RowIndex & ")"
  
  For Each Cell In Row
    Select Case Cell.Key
      Case KI_CUE_ID
        If ValEmpty(Cell.Id, csId) Then
          MsgInfo "Debe indicar una cuenta" & strRow
          Exit Function
        End If
      Case KI_DEBE
        If Not ValEmpty(Cell.Value, csCurrency) Then
          bDebeHaber = True
        End If
      Case KI_HABER
        If ValEmpty(Cell.Id, csId) Then
          bDebeHaber = True
        End If
    End Select
  Next
  
  If Not bDebeHaber Then
    MsgInfo "Debe indicar un importe en el debe o en el haber" & strRow
    Exit Function
  End If
  
  pValidateRowOtros = True
End Function

Private Function pValidateRowItems(ByRef Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  Dim Cell                  As cIABMGridCellValue
  Dim strRow                As String
  Dim bLlevaNroSerie        As Boolean
  Dim Cantidad              As Double
  
  strRow = " (Fila " & RowIndex & ")"
  
  For Each Cell In Row
    Select Case Cell.Key
      
      Case KI_CANTIDAD
        Cantidad = Val(Cell.Value)
        If ValEmpty(Cell.Value, csCurrency) Then
          MsgInfo "Debe indicar una cantidad" & strRow
          Exit Function
        End If
      
      Case KI_PRECIO
        If ValEmpty(Cell.Value, csCurrency) Then
          MsgInfo "Debe indicar un precio" & strRow
          Exit Function
        End If
      
      Case KI_PR_ID
        If ValEmpty(Cell.Id, csId) Then
          MsgInfo "Debe indicar un producto de Compra" & strRow
          Exit Function
        End If
      
      Case KI_NROSERIE
        bLlevaNroSerie = pCell(Row, KI_PR_LLEVANROSERIE).Id
        If ValEmpty(Cell.Value, csText) And bLlevaNroSerie Then
          MsgInfo "Debe indicar un numero de serie" & strRow
          Exit Function
        End If
      
      ' Lote
      '
      Case KI_STL_CODIGO
        If ValEmpty(Cell.Value, csText) And pCell(Row, KI_PR_LLEVALOTE).Id Then
          MsgInfo "Debe indicar un lote" & strRow
          Exit Function
        End If
      
      ' TO
      Case KI_TO_ID
        If ValEmpty(Cell.Id, csId) Then
          MsgInfo "Debe indicar un tipo de operación" & strRow
          Exit Function
        End If
    End Select
  Next
  
  ' Si lleva numero de serie valido que
  ' la cantidad indicada sea la misma
  ' que en la coleccion de numeros de serie
  '
  If bLlevaNroSerie Then
  
    Dim PrId As Long
    
    PrId = pCell(Row, KI_PR_ID).Id
  
    If Not NroSerieValidateCount(Row, _
                                 KI_GRUPO, _
                                 RowIndex, _
                                 m_NrosSerie, _
                                 Cantidad, _
                                 strRow, _
                                 KI_PR_ID, _
                                 KI_CANTIDAD, _
                                 KI_NROSERIE, _
                                 pGetPrId(PrId), _
                                 pGetDeplId(), _
                                 pGetIsInput()) Then
      Exit Function
    End If
  End If
  
  pValidateRowItems = True
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
  
  Set AbmGen = m_ObjAbm
  AbmGen.ResetLayoutMembers
  m_ObjAbm.Properties.Clear
  
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
    
    With .Add(Nothing, cscDocId)
      .PropertyType = cspHelp
      .Table = CSDocumento2.CSDocumento
      .Name = "Documento"
      .Key = K_DOC_ID
      
      If m_doc_id <> csNO_ID Then
        .HelpId = m_doc_id
        .Value = m_Documento
      Else
        ' Preferencias del usuario
        '
        .HelpId = m_UserCfg.DocFcId
        .Value = m_UserCfg.DocFcNombre
        
        bValidateDocDefault = .HelpId <> csNO_ID
      End If
      
      .HelpFilter = pGetDocFilter
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
    
    With .Add(Nothing, cscFcFecha)
      .PropertyType = cspDate
      .Name = "Fecha"
      .LeftLabel = -580
      .Left = 700
      .Key = K_FECHA
      .Value = m_Fecha
    End With
    
    With .Add(Nothing, cscFcFechaIva)
      .PropertyType = cspDate
      .Name = "F. IVA"
      .Key = K_FECHAIVA
      .Value = m_FechaIva
    End With
    
    With .Add(Nothing, cscProvId)
      .PropertyType = cspHelp
      .Table = csProveedor
      .TopFromProperty = cscFcFecha
      .Left = 2900
      .LeftLabel = -800
      .Name = "Proveedor"
      .Key = K_PROV_ID
      .HelpId = m_Prov_id
      .Value = m_proveedor
      AbmGen.NewKeyPropFocus = cscProvId
    End With
    
    With .Add(Nothing, cscFcNrodoc)
      .PropertyType = cspText
      .Name = "Número"
      .Size = 50
      .Key = K_NRODOC
      .Value = m_Nrodoc
      .TextMask = m_TaMascara
      .TextAlign = vbRightJustify
    End With
    
    With .Add(Nothing, cscCpgId)
      .PropertyType = cspHelp
      .Table = csCondicionPago
      .Name = "C. pago"
      .TopFromProperty = cscFcFecha
      .Left = 5900
      .LeftLabel = -620
      .Key = K_CPG_ID
      .HelpId = m_cpg_id
      .Value = m_CondicionPago
    End With
    
    With .Add(Nothing, cscFcFechaVto)
      .PropertyType = cspDate
      .Name = "Vto."
      .LeftLabel = -350
      .Key = K_FECHAVTO
      .Value = m_FechaVto
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
    
    With .Add(Nothing, cscProIdOrigen)
      .PropertyType = cspHelp
      .Table = csProvincia
      .Name = "Origen"
      .Key = K_PRO_ID_ORIGEN
      .HelpId = m_pro_id_origen
      .Value = m_ProOrigen
      .TabIndex = 1
    End With
    
    With .Add(Nothing, cscProIdDestino)
      .PropertyType = cspHelp
      .Table = csProvincia
      .Name = "Destino"
      .Key = K_PRO_ID_DESTINO
      .HelpId = m_pro_id_destino
      .Value = m_ProDestino
      .TabIndex = 1
    End With
    
    With .Add(Nothing, cscFcCai)
      .PropertyType = cspText
      .Name = "Cai"
      .Key = K_CAI
      .Value = m_Cai
      .TabIndex = 1
    End With
    
    With .Add(Nothing, cscFcFechaentrega)
      .PropertyType = cspDate
      .Name = "Entrega"
      .LeftLabel = -1080
      .Key = K_FECHAENTREGA
      .Value = m_Fechaentrega
      .TabIndex = 1
    End With
    
    With .Add(Nothing, cscDeplIdOrigen)
      .PropertyType = cspHelp
      .Table = csDepositoLogico
      .Name = "Deposito"
      .LeftLabel = -1080
      .Key = K_DEPL_ID
      
      If m_depl_id <> csNO_ID Or Not m_bShowStockData Then
        .HelpId = m_depl_id
        .Value = m_Deposito
      Else
        ' Preferencias del usuario
        '
        .HelpId = m_UserCfg.DeplId
        .Value = m_UserCfg.DeplNombre
      End If
      
      .Enabled = m_bShowStockData
      .TabIndex = 1
    End With
    
    With .Add(Nothing, cscFcTipoComprobante)
      .PropertyType = cspList
      .Name = "Tipo Comprobante"
      .LeftLabel = -1080
      .Key = K_TIPOCOMPRABANTE
      .ListWhoSetItem = csListItemData
      With .List
        With .Add(Nothing)
          .Id = csETC_Original
          .Value = "Original"
        End With
        
        With .Add(Nothing)
          .Id = csETC_Fax
          .Value = "Fax"
        End With
        
        With .Add(Nothing)
          .Id = csETC_FotoCopia
          .Value = "Fotocopia"
        End With
        
        With .Add(Nothing)
          .Id = csETC_Duplicado
          .Value = "Duplicado"
        End With
              
      End With
      .ListItemData = m_tipoComprobante
      .TabIndex = 1
    End With

    With .Add(Nothing, cscFcCotizacion)
      .PropertyType = cspNumeric
      .SubType = cspMoney
      .LeftLabel = -600
      .Name = "Cotiz."
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
    
    With .Add(Nothing, cscFcDescuento1)
      .PropertyType = cspNumeric
      .SubType = cspPercent
      .LeftLabel = -600
      .Name = "Desc. 1"
      .Key = K_DESCUENTO1
      .Value = m_Descuento1
      .Width = 1000
    End With
    
    With .Add(Nothing, cscFcDescuento2)
      .PropertyType = cspNumeric
      .SubType = cspPercent
      .TopFromProperty = cscFcDescuento1
      .Left = 7150
      .LeftLabel = -150
      .Name = "2"
      .Key = K_DESCUENTO2
      .Value = m_Descuento2
      .Width = 1000
    End With
    
    With .Add(Nothing, cscLpId)
    .PropertyType = cspHelp
    .Table = csListaPrecio
    .Name = "Lista de Precios"
    .HelpFilter = GetListaPrecioGetXProveedor(m_doc_id, m_Prov_id)
    .TopFromProperty = cscFcFecha
    .Left = 9400
    .Key = K_LP_ID
    .HelpId = m_Lp_id
    .Value = m_ListaPrecio
    End With
    
    With .Add(Nothing, cscLdId)
      .PropertyType = cspHelp
      .Table = csListaDescuento
      .Name = "Lista de Descuentos"
      .HelpFilter = GetListaDescGetXProveedor(m_doc_id, m_Prov_id)
      .Key = K_LD_ID
      .HelpId = m_Ld_id
      .Value = m_ListaDescuento
    End With
    
    With .Add(Nothing, cscCcosId)
      .PropertyType = cspHelp
      .Table = csCentroCosto
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
    
    With .Add(Nothing, cscFcDescrip)
      .PropertyType = cspText
      .SubType = cspMemo
      .Name = "Observ."
      .LeftLabel = -600
      .Size = 5000
      .Key = K_DESCRIP
      .Value = m_Descrip
      .LeftFromProperty = cscFcFecha
      .TopFromProperty = cscFcNrodoc
      .Width = 4480
      .Height = 800
      .TopToPrevious = 440
    End With
    
  End With
  
  If Not m_ObjAbm.Show(Me) Then Exit Function
      
  pSetShowStockData
  
  With m_Items.Tabs
    .Clear
  
    With .Add(Nothing)
      .Index = 0
      .Name = "Items"
    End With
    
    With .Add(Nothing)
      .Index = 1
      .Name = "Otros"
    End With
    
    With .Add(Nothing)
      .Index = 2
      .Name = "Percepciones"
    End With
    
    With .Add(Nothing)
      .Index = 3
      .Name = "Legajos"
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
      If Not pLoadItems(c, Cotizacion) Then Exit Function
      .Name = c_Items
      .Key = K_ITEMS
      .TabIndex = 0
      .GridAdd = True
      .GridEdit = True
      .GridRemove = True
    End With
    
    m_ItemsDeleted = vbNullString
    
    Set c = .Add(Nothing, c_Otros)
    With c
      .PropertyType = cspGrid
      .LeftLabel = -1
      If Not pLoadOtros(c, Cotizacion) Then Exit Function
      .Name = c_Otros
      .Key = K_OTROS
      .TabIndex = 1
      .GridAdd = True
      .GridEdit = True
      .GridRemove = True
    End With
    
    m_OtrosDeleted = vbNullString
    
    Set c = .Add(Nothing, c_Percepciones)
    With c
      .PropertyType = cspGrid
      .LeftLabel = -1
      If Not pLoadPercepciones(c, Cotizacion) Then Exit Function
      .Name = c_Percepciones
      .Key = K_PERCEPCIONES
      .TabIndex = 2
      .GridAdd = True
      .GridEdit = True
      .GridRemove = True
    End With
    
    m_PercepcionesDeleted = vbNullString
    
    Set c = .Add(Nothing, c_Legajos)
    With c
      .PropertyType = cspGrid
      .LeftLabel = -1
      If Not pLoadLegajos(c, Cotizacion) Then Exit Function
      .Name = c_Legajos
      .Key = K_LEGAJOS
      .TabIndex = 3
      .GridAdd = True
      .GridEdit = True
      .GridRemove = True
    End With
    
    m_LegajosDeleted = vbNullString
    
  End With
  
  If Not m_Items.Show(Me) Then Exit Function
  
  Set AbmGen = m_Footer
  AbmGen.ResetLayoutMembers
  
  With m_Footer.Properties
    
    .Clear
  
    With .Add(Nothing, cscFcSubtotal)
      .PropertyType = cspNumeric
      .SubType = cspMoney
      .Name = "Sub Total"
      .Key = K_SUBTOTAL
      .Value = m_SubTotal
      .Format = m_GeneralConfig.FormatDecImporte
      .Enabled = False
    End With
    
    With .Add(Nothing, cscFcImportedesc1)
      .PropertyType = cspNumeric
      .SubType = cspMoney
      .Name = "Desc. 1"
      .Key = K_IMPORTEDESC1
      .Value = m_ImporteDesc1
      .Format = m_GeneralConfig.FormatDecImporte
      .Enabled = False
    End With
    
    With .Add(Nothing, cscFcImportedesc2)
      .PropertyType = cspNumeric
      .SubType = cspMoney
      .Name = "Desc. 2"
      .Key = K_IMPORTEDESC2
      .Value = m_ImporteDesc2
      .Format = m_GeneralConfig.FormatDecImporte
      .Enabled = False
    End With
    
    With .Add(Nothing, cscFcNeto)
      .PropertyType = cspNumeric
      .SubType = cspMoney
      .Name = "Neto"
      .Key = K_NETO
      .Value = m_Neto
      .Format = m_GeneralConfig.FormatDecImporte
      .Enabled = False
    End With
    
    With .Add(Nothing, cscFcIvari)
      .PropertyType = cspNumeric
      .Name = "IVA RI"
      .SubType = cspMoney
      .Key = K_IVARI
      .Value = m_Ivari
      .Format = m_GeneralConfig.FormatDecImporte
      .Enabled = False
    End With
    
    With .Add(Nothing, cscFcIvarni)
      .PropertyType = cspNumeric
      .Name = "IVA RNI"
      .SubType = cspMoney
      .Key = K_IVARNI
      .Value = m_Ivarni
      .Format = m_GeneralConfig.FormatDecImporte
      .Enabled = False
    End With
    
    With .Add(Nothing, cscFcTotalOtros)
      .PropertyType = cspNumeric
      .Format = m_GeneralConfig.FormatDecImporte
      .Name = "Otros"
      .SubType = cspMoney
      .Key = K_TOTALOTROS
      .Value = m_TotalOtros
      .Enabled = False
    End With
    
    With .Add(Nothing, cscFcTotalPercepciones)
      .PropertyType = cspNumeric
      .Format = m_GeneralConfig.FormatDecImporte
      .Name = "Percepciones"
      .SubType = cspMoney
      .Key = K_TOTAPERCEPCIONES
      .Value = m_TotalPercepciones
      .Enabled = False
    End With
    
    With .Add(Nothing, cscFcTotal)
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
  
  ' Preferencias del Usuario
  '
  If bValidateDocDefault Then
    cIABMClient_PropertyChange K_DOC_ID
  End If

  pShowCotizacion

  LoadCollection = True
End Function

Private Function pGetDocId() As cIABMProperty
  Set pGetDocId = m_ObjAbm.Properties.Item(cscDocId)
End Function

' Cotizacion
Private Function pGetCotizacion() As cIABMProperty
  Set pGetCotizacion = m_ObjAbm.Properties.Item(cscFcCotizacion)
End Function

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
  
  Set iProp = pGetCotizacion()
  iProp.Visible = MonId <> GetMonedaDefault
  
  If m_lastMonIdCotizacion <> MonId Or iProp.Value = 0 Then
    dDate = pGetFecha()
    If Not IsDate(dDate) Then dDate = Date
    iProp.Value = GetCotizacion(MonId, dDate)
    m_lastFecha = dDate
    m_lastMonIdCotizacion = MonId
  End If
  
  m_ObjAbm.ShowValue iProp
End Sub

Private Sub pShowFechaVto()
  Dim iProp     As cIABMProperty
  Dim bEsLibre  As Boolean
  
  If pGetCondicionPago().HelpId <> m_LastCpgId Then
    m_LastCpgId = pGetCondicionPago().HelpId
    If Not gDB.GetData(csTCondicionPago, _
                       cscCpgId, _
                       m_LastCpgId, _
                       cscCpgEsLibre, _
                       bEsLibre) Then Exit Sub
    
    Set iProp = m_ObjAbm.Properties.Item(cscFcFechaVto)
    iProp.Visible = bEsLibre
    m_ObjAbm.ShowValue iProp
  End If
End Sub

Private Function pGetCondicionPago() As cIABMProperty
  Set pGetCondicionPago = m_ObjAbm.Properties.Item(cscCpgId)
End Function

Private Function pLoadItems(ByRef Propiedad As cIABMProperty, ByVal Cotizacion As Double) As Boolean
  Dim sqlstmt As String
  
  Dim rs As ADODB.Recordset
  
  sqlstmt = "sp_DocFacturaCompraGetItems " & m_Id
  
  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, "pLoadItems", C_Module) Then Exit Function
  
  Dim o As cIABMGridColumn
  
  With Propiedad.Grid
    
    .Columns.Clear
    .Rows.Clear

    With .Columns
      With .Add(Nothing)
        .Visible = False
        .Key = KI_FCI_ID
      End With
      
      With .Add(Nothing)
        .Name = "Producto"
        .PropertyType = cspHelp
        .Table = csProductoCompra
        .Width = 1800
        .Key = KI_PR_ID
      End With
      
      With .Add(Nothing)
        .Visible = False
        .Key = KI_CUE_ID
      End With
      
      With .Add(Nothing)
        .Visible = False
        .Key = KI_CUE_ID_IVARI
      End With
      
      With .Add(Nothing)
        .Visible = False
        .Key = KI_CUE_ID_IVARNI
      End With
      
      With .Add(Nothing)
        .Name = "Descripción"
        .PropertyType = cspText
        .SubType = cspTextButtonEx
        .Width = 1200
        .Key = KI_DESCRIP
      End With
      
      With .Add(Nothing)
        .Name = "Cantidad"
        .Format = m_GeneralConfig.FormatDecCantidad
        .PropertyType = cspNumeric
        .SubType = cspDouble
        .Width = 1000
        .Key = KI_CANTIDAD
      End With
      
      With .Add(Nothing)
        .Name = "Nro. Serie"
        .PropertyType = cspText
        .SubType = cspTextButton
        .Width = 3000
        .Key = KI_NROSERIE
      End With
      
      ' Lote
      '
      With .Add(Nothing)
        .Name = "Lote"
        .PropertyType = cspText
        .Width = 2000
        .Key = KI_STL_CODIGO
      End With
      
      With .Add(Nothing)
        .Visible = False
        .Key = KI_STL_ID
      End With
      
      With .Add(Nothing)
        .Name = "Descuento"
        .PropertyType = cspNumeric
        .Format = m_GeneralConfig.FormatDecImporte
        .SubType = cspMoney
        .Width = 1000
        .Key = KI_DESCUENTO
        .Enabled = False
      End With
      
      With .Add(Nothing)
        .Name = "Unidad"
        .PropertyType = cspText
        .Width = 1000
        .Key = KI_UNIDAD
        .Enabled = False
      End With
      
      With .Add(Nothing)
        .Name = "Precio (LP)"
        .PropertyType = cspNumeric
        .SubType = cspMoney
        .Format = m_GeneralConfig.FormatDecImporte
        .Width = 1200
        .Key = KI_PRECIO_LP
        .Enabled = False
      End With
    
      With .Add(Nothing)
        .Name = "Precio"
        .PropertyType = cspNumeric
        .SubType = cspMoney
        .Width = 1200
        .Format = m_GeneralConfig.FormatDecImporte
        .Key = KI_PRECIO_USR
      End With
      
      With .Add(Nothing)
        .Name = "Precio c/desc."
        .PropertyType = cspNumeric
        .SubType = cspMoney
        .Width = 1200
        .Format = m_GeneralConfig.FormatDecImporte
        .Key = KI_PRECIO
        .Enabled = False
      End With
      
      With .Add(Nothing)
        .Name = "Neto"
        .PropertyType = cspNumeric
        .SubType = cspMoney
        .Format = m_GeneralConfig.FormatDecImporte
        .Width = 1200
        .Key = KI_NETO
        .Enabled = False
      End With
      
      With .Add(Nothing)
        .Name = "IVA RI"
        .PropertyType = cspNumeric
        .SubType = cspMoney
        .Format = m_GeneralConfig.FormatDecImporte
        .Width = 1200
        .Key = KI_IVARI
      End With
      
      With .Add(Nothing)
        .Name = "IVA RNI"
        .PropertyType = cspNumeric
        .Format = m_GeneralConfig.FormatDecImporte
        .SubType = cspMoney
        .Width = 1200
        .Key = KI_IVARNI
        .Enabled = False
      End With
      
      With .Add(Nothing)
        .Name = "Importe"
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
        .Name = "Centro de Costo"
        .PropertyType = cspHelp
        .Table = csCentroCosto
        .Width = 1800
        .Key = KI_CCOS_ID
      End With
    
      ' Lote
      '
      With .Add(Nothing)
        .Visible = False
        .Key = KI_PR_LLEVALOTE
      End With
      
      ' TO
      With .Add(Nothing)
        .Name = "Tipo Operación"
        .PropertyType = cspHelp
        .Table = csTipoOperacion
        .Width = 1800
        Set .DefaultValue = New cABMGridRowValue
        .DefaultValue.Id = C_TO_ComercialId
        .DefaultValue.Value = C_TO_Comercial
        .Key = KI_TO_ID
      End With
    
      With .Add(Nothing)
        .Visible = False
        .Key = KI_PR_LLEVANROSERIE
      End With
      
      With .Add(Nothing)
        .Visible = False
        .Key = KI_GRUPO
      End With
    End With
  
    With .Rows
  
      While Not rs.EOF
      
        With .Add(Nothing, rs(cscFciId).Value)
        
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscFciId)
            .Key = KI_FCI_ID
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscPrNombrecompra)
            .Id = gDB.ValField(rs.fields, cscPrId)
            .Key = KI_PR_ID
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscCueId)
            .Key = KI_CUE_ID
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscCueIdIvaRI)
            .Key = KI_CUE_ID_IVARI
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscCueIdIvaRNI)
            .Key = KI_CUE_ID_IVARNI
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscFciDescrip)
            .Key = KI_DESCRIP
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscFciCantidad)
            .Key = KI_CANTIDAD
          End With
          
          With .Add(Nothing)
            .Value = vbNullString
            .Key = KI_NROSERIE
          End With
          
          ' Lote
          '
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscStlCodigo)
            .Key = KI_STL_CODIGO
          End With
          
          With .Add(Nothing)
            .Id = gDB.ValField(rs.fields, cscStlId)
            .Key = KI_STL_ID
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscFciDescuento)
            .Key = KI_DESCUENTO
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscUnNombre)
            .Key = KI_UNIDAD
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscFciPrecioLista) / Cotizacion
            .Key = KI_PRECIO_LP
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscFciPrecioUsr) / Cotizacion
            .Key = KI_PRECIO_USR
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscFciPrecio) / Cotizacion
            .Key = KI_PRECIO
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscFciNeto) / Cotizacion
            .Key = KI_NETO
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscFciIvari) / Cotizacion
            .Key = KI_IVARI
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscFciIvarni) / Cotizacion
            .Key = KI_IVARNI
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscFciImporte) / Cotizacion
            .Key = KI_IMPORTE
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, "iva_ri_porcentaje")
            .Key = KI_IVARIPercent
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, "iva_rni_porcentaje")
            .Key = KI_IVARNIPercent
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscCcosNombre)
            .Id = gDB.ValField(rs.fields, cscCcosId)
            .Key = KI_CCOS_ID
          End With
          
          ' Lote
          '
          With .Add(Nothing)
            .Id = gDB.ValField(rs.fields, cscPrLlevaNroLote)
            .Key = KI_PR_LLEVALOTE
          End With
          
          ' TO
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscToNombre)
            .Id = gDB.ValField(rs.fields, cscToId)
            .Key = KI_TO_ID
          End With
          
          With .Add(Nothing)
            If m_bShowStockData Then
              .Id = gDB.ValField(rs.fields, cscPrLlevaNroSerie)
            Else
              .Id = False
            End If
            .Key = KI_PR_LLEVANROSERIE
          End With
          
          With .Add(Nothing)
            .Id = gDB.ValField(rs.fields, cscFciId)
            .Key = KI_GRUPO
          End With
        End With
        
        rs.MoveNext
      Wend
    End With
  End With

  Dim NroSerie  As cProductoSerieType
  Dim CurGroup  As Long
  Dim coll      As Collection
  Dim NrosSerie As String
  
  CollClear m_NrosSerie
  
  Set rs = rs.NextRecordset
  
  While Not rs.EOF
    
    ' Si cambie de grupo
    If CurGroup <> gDB.ValField(rs.fields, cscFciId) Then
    
      pSetNrosSerieInRow CurGroup, NrosSerie
      NrosSerie = vbNullString
    
      CurGroup = gDB.ValField(rs.fields, cscFciId)
      Set coll = New Collection
      m_NrosSerie.Add coll, GetKey(CurGroup)
    End If
    
    ' Guardo el numero de serie
    Set NroSerie = New cProductoSerieType
    With NroSerie
      .codigo = gDB.ValField(rs.fields, cscPrnsCodigo)
      .Descrip = gDB.ValField(rs.fields, cscPrnsDescrip)
      .FechaVto = gDB.ValField(rs.fields, cscPrnsFechavto)
      .prns_id = gDB.ValField(rs.fields, cscPrnsId)
      
      NrosSerie = NrosSerie & .codigo & ","
    End With
    
    ' Lo agrego a la bolsa
    coll.Add NroSerie, GetKey(NroSerie.prns_id)
    
    rs.MoveNext
  Wend
  
  pSetNrosSerieInRow CurGroup, NrosSerie
  
  pLoadItems = True
End Function

Private Function pLoadPercepciones(ByRef Propiedad As cIABMProperty, ByVal Cotizacion As Double) As Boolean
  Dim sqlstmt As String
  
  Dim rs As ADODB.Recordset
  
  sqlstmt = "sp_DocFacturaCompraGetPercepciones " & m_Id
  
  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, "pLoadPercepciones", C_Module) Then Exit Function
  
  Dim o As cIABMGridColumn
  
  With Propiedad.Grid
    .Columns.Clear
    .Rows.Clear
  End With
  
  LoadPercepciones Propiedad.Grid, m_GeneralConfig
  
  Dim f  As cIABMGridRow
  Dim fv As cIABMGridCellValue
  
  While Not rs.EOF
  
    Set f = Propiedad.Grid.Rows.Add(Nothing, rs(cscFcPercId).Value)
    
    Set fv = f.Add(Nothing)
    fv.Value = gDB.ValField(rs.fields, cscFcPercId)
    fv.Key = KIP_FCPERC_ID
    
    Set fv = f.Add(Nothing)
    fv.Value = gDB.ValField(rs.fields, cscPercNombre)
    fv.Id = gDB.ValField(rs.fields, cscPercId)
    fv.Key = KIP_PERC_ID

    Set fv = f.Add(Nothing)
    fv.Value = gDB.ValField(rs.fields, cscFcPercBase) / Cotizacion
    fv.Key = KIP_BASE

    Set fv = f.Add(Nothing)
    fv.Value = gDB.ValField(rs.fields, cscFcPercPorcentaje)
    fv.Key = KIP_PORCENTAJE
    
    Set fv = f.Add(Nothing)
    fv.Value = gDB.ValField(rs.fields, cscFcPercImporte) / Cotizacion
    fv.Key = KIP_IMPORTE
    
    Set fv = f.Add(Nothing)
    fv.Value = gDB.ValField(rs.fields, cscFcPercDescrip)
    fv.Key = KIP_DESCRIP
    
    Set fv = f.Add(Nothing)
    fv.Value = gDB.ValField(rs.fields, cscCcosNombre)
    fv.Id = gDB.ValField(rs.fields, cscCcosId)
    fv.Key = KI_CCOS_ID
    
    rs.MoveNext
  Wend
  
  pLoadPercepciones = True
End Function

Private Function pLoadLegajos(ByRef Propiedad As cIABMProperty, ByVal Cotizacion As Double) As Boolean
  Dim sqlstmt As String
  
  Dim rs As ADODB.Recordset
  
  sqlstmt = "sp_DocFacturaCompraGetLegajos " & m_Id
  
  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, "pLoadLegajos", C_Module) Then Exit Function
  
  Dim o As cIABMGridColumn
  
  With Propiedad.Grid.Columns
    
    .Clear
    Propiedad.Grid.Rows.Clear
    
    Set o = .Add(Nothing)
    o.Visible = False
    o.Key = KIL_FCLGJ_ID
    
    Set o = .Add(Nothing)
    o.Name = "Legajo"
    o.PropertyType = cspHelp
    o.Table = csLegajo
    o.Width = 1800
    o.Key = KIL_LGJ_ID
    
    Set o = .Add(Nothing)
    o.Name = "Importe"
    o.PropertyType = cspNumeric
    o.SubType = cspMoney
    o.Format = m_GeneralConfig.FormatDecImporte
    o.Width = 1200
    o.Key = KIL_IMPORTE
    
    Set o = .Add(Nothing)
    o.Name = "Observaciones"
    o.PropertyType = cspText
    o.Width = 1800
    o.Key = KIL_DESCRIP
  End With
  
  Dim f  As cIABMGridRow
  Dim fv As cIABMGridCellValue
  
  While Not rs.EOF
  
    Set f = Propiedad.Grid.Rows.Add(Nothing, rs(cscFcLgjId).Value)
    
    Set fv = f.Add(Nothing)
    fv.Value = gDB.ValField(rs.fields, cscFcLgjId)
    fv.Key = KIL_FCLGJ_ID
    
    Set fv = f.Add(Nothing)
    fv.Value = gDB.ValField(rs.fields, cscLgjCodigo)
    fv.Id = gDB.ValField(rs.fields, cscLgjId)
    fv.Key = KIL_LGJ_ID

    Set fv = f.Add(Nothing)
    fv.Value = gDB.ValField(rs.fields, cscFcLgjImporte) / Cotizacion
    fv.Key = KIL_IMPORTE
    
    Set fv = f.Add(Nothing)
    fv.Value = gDB.ValField(rs.fields, cscFcLgjDescrip)
    fv.Key = KIL_DESCRIP
    
    rs.MoveNext
  Wend
  
  pLoadLegajos = True
End Function

Private Function pLoadOtros(ByRef Propiedad As cIABMProperty, ByVal Cotizacion As Double) As Boolean
  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  
  sqlstmt = "sp_DocFacturaCompraGetOtros " & m_Id
  
  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, "pLoadOtros", C_Module) Then Exit Function
  
  With Propiedad.Grid
    .Columns.Clear
    .Rows.Clear
    
    With .Columns
      With .Add(Nothing)
        .Visible = False
        .Key = KI_FCOT_ID
      End With
      
      With .Add(Nothing)
        .Name = "Cuenta"
        .PropertyType = cspHelp
        .Table = csCuenta
        .Width = 1800
        .Key = KI_CUE_ID
        .HelpFilter = GetHelpFilterCuenta()
      End With
      
      With .Add(Nothing)
        .Name = "Debe"
        .PropertyType = cspNumeric
        .SubType = cspMoney
        .Format = m_GeneralConfig.FormatDecImporte
        .Width = 1200
        .Key = KI_DEBE
      End With
      
      With .Add(Nothing)
        .Name = "Haber"
        .PropertyType = cspNumeric
        .Format = m_GeneralConfig.FormatDecImporte
        .SubType = cspMoney
        .Width = 1200
        .Key = KI_HABER
      End With
      
      With .Add(Nothing)
        .Name = "Observaciones"
        .PropertyType = cspText
        .Width = 1800
        .Key = KI_DESCRIP
      End With
      
      With .Add(Nothing)
        .Name = "Centro de Costo"
        .PropertyType = cspHelp
        .Table = csCentroCosto
        .Width = 1800
        .Key = KI_CCOS_ID
      End With
    End With
    
    With .Rows
  
      While Not rs.EOF
      
        With .Add(Nothing, rs(cscFcotId).Value)
        
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscFcotId)
            .Key = KI_FCOT_ID
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscCueNombre)
            .Id = gDB.ValField(rs.fields, cscCueId)
            .Key = KI_CUE_ID
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscFcotDebe) / Cotizacion
            .Key = KI_DEBE
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscFcotHaber) / Cotizacion
            .Key = KI_HABER
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscFcotDescrip)
            .Key = KI_DESCRIP
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
  
  pLoadOtros = True
End Function

Private Sub pSetNrosSerieInRow(ByVal CurrGroup As Long, ByVal NroSerie As String)
  Dim Row As cIABMGridRow
  
  If CurrGroup = 0 Then Exit Sub
  
  For Each Row In GetItems(m_Items, c_Items).Grid.Rows
    If pCell(Row, KI_GRUPO).Id = CurrGroup Then
      pCell(Row, KI_NROSERIE).Value = RemoveLastColon(NroSerie)
      Exit Sub
    End If
  Next
End Sub

Private Function Load(ByVal Id As Long) As Boolean
  Dim Cotizacion  As Double
  Dim sqlstmt     As String

  sqlstmt = "sp_DocFacturaCompraGet " & EmpId & "," & Id & "," & gDB.UserId
  
  Dim rs As Recordset

  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, C_LoadFunction, c_Module) Then Exit Function

  If Not rs.EOF Then

    m_Cotizacion = gDB.ValField(rs.fields, cscFcCotizacion)
    Cotizacion = IIf(m_Cotizacion <> 0, m_Cotizacion, 1)

    m_Id = gDB.ValField(rs.fields, cscFcId)
    m_Numero = gDB.ValField(rs.fields, cscFcNumero)
    m_Nrodoc = gDB.ValField(rs.fields, cscFcNrodoc)
    m_Descrip = gDB.ValField(rs.fields, cscFcDescrip)
    m_Fecha = gDB.ValField(rs.fields, cscFcFecha)
    m_Fechaentrega = gDB.ValField(rs.fields, cscFcFechaentrega)
    m_FechaVto = gDB.ValField(rs.fields, cscFcFechaVto)
    m_FechaIva = gDB.ValField(rs.fields, cscFcFechaIva)
    m_Neto = gDB.ValField(rs.fields, cscFcNeto) / Cotizacion
    m_Ivari = gDB.ValField(rs.fields, cscFcIvari) / Cotizacion
    m_Ivarni = gDB.ValField(rs.fields, cscFcIvarni) / Cotizacion
    m_Total = gDB.ValField(rs.fields, cscFcTotal) / Cotizacion
    m_TotalOtros = gDB.ValField(rs.fields, cscFcTotalOtros) / Cotizacion
    m_TotalPercepciones = gDB.ValField(rs.fields, cscFcTotalPercepciones) / Cotizacion
    m_SubTotal = gDB.ValField(rs.fields, cscFcSubtotal) / Cotizacion
    m_Descuento1 = gDB.ValField(rs.fields, cscFcDescuento1)
    m_Descuento2 = gDB.ValField(rs.fields, cscFcDescuento2)
    m_ImporteDesc1 = gDB.ValField(rs.fields, cscFcImportedesc1) / Cotizacion
    m_ImporteDesc2 = gDB.ValField(rs.fields, cscFcImportedesc2) / Cotizacion
    m_Prov_id = gDB.ValField(rs.fields, cscProvId)
    m_proveedor = gDB.ValField(rs.fields, cscProvNombre)
    m_ccos_id = gDB.ValField(rs.fields, cscCcosId)
    m_CentroCosto = gDB.ValField(rs.fields, cscCcosNombre)
    m_suc_id = gDB.ValField(rs.fields, cscSucId)
    m_Sucursal = gDB.ValField(rs.fields, cscSucNombre)
    m_doc_id = gDB.ValField(rs.fields, cscDocId)
    m_Documento = gDB.ValField(rs.fields, cscDocNombre)
    m_Doct_id = gDB.ValField(rs.fields, cscDoctId)
    m_Lp_id = gDB.ValField(rs.fields, cscLpId)
    m_ListaPrecio = gDB.ValField(rs.fields, cscLpNombre)
    m_cpg_id = gDB.ValField(rs.fields, cscCpgId)
    m_CondicionPago = gDB.ValField(rs.fields, cscCpgNombre)
    m_Ld_id = gDB.ValField(rs.fields, cscLdId)
    m_ListaDescuento = gDB.ValField(rs.fields, cscLdNombre)
    m_lgj_id = gDB.ValField(rs.fields, cscLgjId)
    m_Legajo = gDB.ValField(rs.fields, cscLgjCodigo)
    m_Cai = gDB.ValField(rs.fields, cscFcCai)
    m_pro_id_origen = gDB.ValField(rs.fields, cscProIdOrigen)
    m_ProOrigen = gDB.ValField(rs.fields, "ProOrigen")
    m_pro_id_destino = gDB.ValField(rs.fields, cscProIdDestino)
    m_ProDestino = gDB.ValField(rs.fields, "ProDestino")
    m_Creado = gDB.ValField(rs.fields, cscCreado)
    m_Modificado = gDB.ValField(rs.fields, cscModificado)
    m_Modifico = gDB.ValField(rs.fields, cscModifico)
    m_est_id = gDB.ValField(rs.fields, cscEstId)
    m_Estado = gDB.ValField(rs.fields, cscEstNombre)
    m_Firmado = gDB.ValField(rs.fields, cscFcFirmado)
    m_mon_id = gDB.ValField(rs.fields, cscMonId)
    
    m_DocEditable = gDB.ValField(rs.fields, cscDocEditable)
    m_DocEditMsg = gDB.ValField(rs.fields, cscDoceditMsg)
    
    m_depl_id = gDB.ValField(rs.fields, cscDeplId)
    m_Deposito = gDB.ValField(rs.fields, cscDeplNombre)
    
    m_tipoComprobante = gDB.ValField(rs.fields, cscFcTipoComprobante)
    
    m_bIva = gDB.ValField(rs.fields, cscbIvaRi)
    m_bIvaRni = gDB.ValField(rs.fields, cscbIvaRni)

    ' Para ver documentos auxiliares
    '
    m_as_id = gDB.ValField(rs.fields, cscAsId)
    m_st_id = gDB.ValField(rs.fields, cscStId)
    
    m_TaMascara = gDB.ValField(rs.fields, cscTa_Mascara)
    m_TaPropuesto = gDB.ValField(rs.fields, cscTa_Propuesto)
    
    m_LastDoc = m_doc_id
    m_LastDoctId = m_Doct_id ' nrs devolucion
    m_LastProv = m_Prov_id
    m_LastDocName = m_Documento
    m_LastProvName = m_proveedor
    
    m_lastMonIdCotizacion = m_mon_id
    m_lastFecha = m_Fecha
    
  Else
    m_Id = csNO_ID
    m_Numero = 0
    m_Nrodoc = vbNullString
    m_Descrip = vbNullString
    m_Fecha = VDGetDateById(csToday)
    m_Fechaentrega = VDGetDateById(csTomorrow)
    m_FechaVto = csNoDate
    m_FechaIva = m_Fecha
    m_Neto = 0
    m_Ivari = 0
    m_Ivarni = 0
    m_Total = 0
    m_TotalOtros = 0
    m_TotalPercepciones = 0
    m_SubTotal = 0
    m_Descuento1 = 0
    m_Descuento2 = 0
    m_ImporteDesc1 = 0
    m_ImporteDesc2 = 0
    m_Prov_id = csNO_ID
    m_proveedor = vbNullString
    m_ccos_id = csNO_ID
    m_CentroCosto = vbNullString
    m_doc_id = csNO_ID
    m_Documento = vbNullString
    m_Doct_id = csNO_ID
    m_Lp_id = csNO_ID
    m_Ld_id = csNO_ID
    m_cpg_id = csNO_ID
    m_lgj_id = csNO_ID
    m_Legajo = vbNullString
    m_Cai = vbNullString
    m_pro_id_origen = csNO_ID
    m_ProOrigen = vbNullString
    m_pro_id_destino = csNO_ID
    m_ProDestino = vbNullString
    m_CondicionPago = vbNullString
    m_ListaPrecio = vbNullString
    m_ListaDescuento = vbNullString
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
  
    m_depl_id = csNO_ID
    m_Deposito = vbNullString
    
    m_tipoComprobante = csETC_Original
    
    m_doc_id = m_LastDoc
    m_Doct_id = m_LastDoctId ' nrs devolucion
    m_Prov_id = m_LastProv
    m_proveedor = m_LastProvName
    m_Documento = m_LastDocName
  
    ' Para ver documentos auxiliares
    '
    m_as_id = csNO_ID
    m_st_id = csNO_ID
    
    m_TaMascara = vbNullString
    m_TaPropuesto = False
    
    m_bIvaRni = False
    m_bIva = False
    
    m_lastMonIdCotizacion = csNO_ID
    m_lastFecha = csNoDate
    
    ' Cotizacion
    If m_doc_id <> csNO_ID Then
      m_Cotizacion = DocGetCotizacion(m_doc_id, m_Fecha)
    End If
    
    DocEditableGet m_doc_id, m_DocEditable, m_DocEditMsg, csPreCpraNewFactura
  
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

  Set m_Host = Host
  m_Host.Server.AddMenu "Com&pras", csMenuEnum.csMenuCompras, vbNullString, 1, False, False, False, True, False, Nothing
  m_Host.Server.AddMenu "&Facturas de Compra", csPreCpraListFactura, "Com&pras", 0, True, False, False, False, False, Me
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
  m_Host.MenuListDocClick "CSABMInterface2.cABMGeneric", "CSCompra2.cFacturaCompra", "CSABMInterface2.CABMGenericListDoc", "CSCompra2.cFacturaCpraListDoc", Me, "Facturas de Compra", 0
#Else
  m_Host.MenuListDocClick "CSABMInterface2.cABMGenericDocEx", "CSCompra2.cFacturaCompra", "CSABMInterface2.CABMGenericListDoc", "CSCompra2.cFacturaCpraListDoc", Me, "Facturas de Compra", 0
#End If
End Function

Private Function pSaveItems(ByVal Id As Long, ByVal Cotizacion As Double, ByVal bMonedaLegal As Boolean) As Boolean
  
  ' Generales
  '
  Dim register  As cRegister
  Dim IProperty As cIABMProperty
  Dim iOrden    As Long
  Dim Origen    As Double
  Dim Neto      As Double
  Dim IvaRi     As Double
  Dim IvaRni    As Double
  
  ' Para numeros de serie
  '
  Dim iOrden2     As Long
  Dim Grupo       As Long
  Dim PrId        As Long
  
  Dim Row  As cIABMGridRow
  Dim Cell As cIABMGridCellValue
    
  For Each Row In GetItems(m_Items, c_Items).Grid.Rows
  
    Set register = New cRegister
    register.fieldId = cscFciTMPId
    register.Table = csTFacturaCompraItemTMP
    register.Id = csNew
    
    For Each Cell In Row
      Select Case Cell.Key
        
        Case KI_FCI_ID
          If m_Copy Then
            register.fields.Add2 cscFciId, csNew, csInteger
          Else
            register.fields.Add2 cscFciId, Val(Cell.Value), csInteger
          End If
        Case KI_CANTIDAD
          register.fields.Add2 cscFciCantidad, Cell.Value, csDouble
        Case KI_DESCRIP
          register.fields.Add2 cscFciDescrip, Cell.Value, csText
        Case KI_PRECIO
          register.fields.Add2 cscFciPrecio, Val(Cell.Value) * Cotizacion, csCurrency
        Case KI_PRECIO_LP
          register.fields.Add2 cscFciPrecioLista, Val(Cell.Value) * Cotizacion, csCurrency
        Case KI_PRECIO_USR
          register.fields.Add2 cscFciPrecioUsr, Val(Cell.Value) * Cotizacion, csCurrency
        Case KI_NETO
          Neto = Val(Cell.Value)
          register.fields.Add2 cscFciNeto, Neto * Cotizacion, csCurrency
        Case KI_IVARI
          ' Por seguridad
          If m_bIva Then
            IvaRi = Val(Cell.Value)
            register.fields.Add2 cscFciIvari, IvaRi * Cotizacion, csCurrency
          End If
        Case KI_IVARNI
          ' Por seguridad
          If m_bIvaRni Then
            IvaRni = Val(Cell.Value)
            register.fields.Add2 cscFciIvarni, IvaRni * Cotizacion, csCurrency
          End If
        Case KI_IVARIPercent
          register.fields.Add2 cscFciIvariporc, Cell.Value, csDouble
        Case KI_IVARNIPercent
          register.fields.Add2 cscFciIvarniporc, Cell.Value, csDouble
        Case KI_PR_ID
          PrId = Cell.Id
          register.fields.Add2 cscPrId, PrId, csId
        Case KI_CCOS_ID
          register.fields.Add2 cscCcosId, Cell.Id, csId
        ' TO
        Case KI_TO_ID
          register.fields.Add2 cscToId, Cell.Id, csId
        Case KI_CUE_ID
          register.fields.Add2 cscCueId, Val(Cell.Value), csId
        Case KI_CUE_ID_IVARI
          register.fields.Add2 cscCueIdIvaRI, Val(Cell.Value), csId
        Case KI_CUE_ID_IVARNI
          register.fields.Add2 cscCueIdIvaRNI, Val(Cell.Value), csId
        Case KI_GRUPO
          Grupo = Cell.Id
      
        ' Lote
        '
        Case KI_STL_CODIGO
          register.fields.Add2 cscStlCodigo, Cell.Value, csText
        Case KI_STL_ID
          register.fields.Add2 cscStlId, Cell.Id, csId
      End Select
    Next
    
    ' Por seguridad
    Origen = Neto
    If m_bIva Then
      Origen = Origen + IvaRi
    End If
    If m_bIvaRni Then
      Origen = Origen + IvaRni
    End If
    
    register.fields.Add2 cscFciImporte, Origen * Cotizacion, csCurrency
    If bMonedaLegal Then
      register.fields.Add2 cscFciImporteOrigen, 0, csCurrency
    Else
      register.fields.Add2 cscFciImporteOrigen, Origen, csCurrency
    End If
    
    iOrden = iOrden + 1
    register.fields.Add2 cscFciOrden, iOrden, csInteger
    register.fields.Add2 cscFcTMPId, Id, csId
    
    register.fields.HaveLastUpdate = False
    register.fields.HaveWhoModify = False
    
    If Not gDB.Save(register, , "pSaveItems", C_Module, c_ErrorSave) Then Exit Function
  
    ' Si es nuevo se usa el orden
    If Grupo = 0 Then Grupo = iOrden * -1
    If Not pSaveItemNroSerie(Row, iOrden2, PrId, Id, register.Id, Grupo) Then Exit Function
  Next
  
  Dim sqlstmt As String
  
  If m_ItemsDeleted <> vbNullString And m_Id <> csNO_ID And Not m_Copy Then
  
    Dim vDeletes As Variant
    Dim i As Long
    
    m_ItemsDeleted = RemoveLastColon(m_ItemsDeleted)
    vDeletes = Split(m_ItemsDeleted, ",")
    
    For i = 0 To UBound(vDeletes)
    
      Set register = New cRegister
      register.fieldId = cscFcibTMPId
      register.Table = csTFacturaCompraItemBorradoTMP
      register.Id = csNew
      
      register.fields.Add2 cscFciId, Val(vDeletes(i)), csInteger
      register.fields.Add2 cscFcId, m_Id, csId
      register.fields.Add2 cscFcTMPId, Id, csId
      
      register.fields.HaveLastUpdate = False
      register.fields.HaveWhoModify = False
      
      If Not gDB.Save(register, , "pSaveItems", C_Module, c_ErrorSave) Then Exit Function
    Next
    
  End If
  
  pSaveItems = True
End Function

Private Function pSaveOtros(ByVal Id As Long, ByVal Cotizacion As Double, ByVal bMonedaLegal As Boolean) As Boolean
  Dim register  As cRegister
  Dim IProperty As cIABMProperty
  Dim iOrden    As Long
  Dim Origen    As Double
  
  With m_Items.Properties.Item(c_Otros)
    Dim Row  As cIABMGridRow
    Dim Cell As cIABMGridCellValue
    
    For Each Row In .Grid.Rows
    
      Set register = New cRegister
      register.fieldId = cscFcotTMPId
      register.Table = csTFacturaCompraOtroTMP
      register.Id = csNew
      
      For Each Cell In Row
        Select Case Cell.Key
          
          Case KI_FCOT_ID
            If m_Copy Then
              register.fields.Add2 cscFcotId, csNew, csInteger
            Else
              register.fields.Add2 cscFcotId, Val(Cell.Value), csInteger
            End If
          Case KI_CUE_ID
            register.fields.Add2 cscCueId, Cell.Id, csId
          Case KI_DEBE
            If Val(Cell.Value) > 0 Then Origen = Val(Cell.Value)
            register.fields.Add2 cscFcotDebe, Val(Cell.Value) * Cotizacion, csCurrency
          Case KI_HABER
            If Val(Cell.Value) > 0 Then Origen = Val(Cell.Value)
            register.fields.Add2 cscFcotHaber, Val(Cell.Value) * Cotizacion, csCurrency
          Case KI_CCOS_ID
            register.fields.Add2 cscCcosId, Cell.Id, csId
          Case KI_DESCRIP
            register.fields.Add2 cscFcotDescrip, Cell.Value, csText
        End Select
      Next
      
      If bMonedaLegal Then
        register.fields.Add2 cscFcotOrigen, 0, csCurrency
      Else
        register.fields.Add2 cscFcotOrigen, Origen, csCurrency
      End If
      
      iOrden = iOrden + 1
      register.fields.Add2 cscFcotOrden, iOrden, csInteger
      register.fields.Add2 cscFcTMPId, Id, csId
      
      register.fields.HaveLastUpdate = False
      register.fields.HaveWhoModify = False
      
      If Not gDB.Save(register, , "pSaveotros", C_Module, c_ErrorSave) Then Exit Function
    Next
  End With
  
  Dim sqlstmt As String
  
  If m_OtrosDeleted <> vbNullString And m_Id <> csNO_ID And Not m_Copy Then
  
    Dim vDeletes As Variant
    Dim i As Long
    
    m_OtrosDeleted = RemoveLastColon(m_OtrosDeleted)
    vDeletes = Split(m_OtrosDeleted, ",")
    
    For i = 0 To UBound(vDeletes)
    
      Set register = New cRegister
      register.fieldId = cscFcotbTMPId
      register.Table = csTFacturaCompraOtroBorradoTMP
      register.Id = csNew
      
      register.fields.Add2 cscFcotId, Val(vDeletes(i)), csInteger
      register.fields.Add2 cscFcId, m_Id, csId
      register.fields.Add2 cscFcTMPId, Id, csId
      
      register.fields.HaveLastUpdate = False
      register.fields.HaveWhoModify = False
      
      If Not gDB.Save(register, , "pSaveotros", C_Module, c_ErrorSave) Then Exit Function
    Next
    
  End If
  
  pSaveOtros = True
End Function

Private Function pSaveLegajos(ByVal Id As Long, ByVal Cotizacion As Double, ByVal bMonedaLegal As Boolean) As Boolean
  Dim register  As cRegister
  Dim IProperty As cIABMProperty
  Dim iOrden    As Long
  Dim Origen    As Double
  
  With m_Items.Properties.Item(c_Legajos)
    Dim Row  As cIABMGridRow
    Dim Cell As cIABMGridCellValue
    
    For Each Row In .Grid.Rows
    
      Set register = New cRegister
      With register
        
        .fieldId = cscFcLgjTMPId
        .Table = csTFacturaCompraLegajoTMP
        .Id = csNew
      
        With .fields
        
          For Each Cell In Row
            Select Case Cell.Key
              
              Case KIL_FCLGJ_ID
                If m_Copy Then
                  .Add2 cscFcLgjId, csNew, csInteger
                Else
                  .Add2 cscFcLgjId, Val(Cell.Value), csInteger
                End If
              Case KIL_LGJ_ID
                .Add2 cscLgjId, Cell.Id, csId
              Case KIL_IMPORTE
                Origen = Val(Cell.Value)
                .Add2 cscFcLgjImporte, Origen * Cotizacion, csCurrency
              Case KI_CCOS_ID
                .Add2 cscCcosId, Cell.Id, csId
              Case KIL_DESCRIP
                .Add2 cscFcLgjDescrip, Cell.Value, csText
            End Select
          Next
          
          If bMonedaLegal Then
            .Add2 cscFcLgjImporteOrigen, 0, csCurrency
          Else
            .Add2 cscFcLgjImporteOrigen, Origen, csCurrency
          End If
          
          iOrden = iOrden + 1
          .Add2 cscFcLgjOrden, iOrden, csInteger
          .Add2 cscFcTMPId, Id, csId
          
          .HaveLastUpdate = False
          .HaveWhoModify = False
        
        End With
      End With
      
      If Not gDB.Save(register, , "pSaveLegajos", C_Module, c_ErrorSave) Then Exit Function
    Next
  End With
  
  Dim sqlstmt As String
  
  If m_LegajosDeleted <> vbNullString And m_Id <> csNO_ID And Not m_Copy Then
  
    Dim vDeletes As Variant
    Dim i As Long
    
    m_LegajosDeleted = RemoveLastColon(m_LegajosDeleted)
    vDeletes = Split(m_LegajosDeleted, ",")
    
    For i = 0 To UBound(vDeletes)
    
      Set register = New cRegister
      With register
        .fieldId = cscFcLgjbTMPId
        .Table = csTFacturaCompraLegajoBorradoTMP
        .Id = csNew
        
        With .fields
          .Add2 cscFcLgjId, Val(vDeletes(i)), csInteger
          .Add2 cscFcId, m_Id, csId
          .Add2 cscFcTMPId, Id, csId
        
          .HaveLastUpdate = False
          .HaveWhoModify = False
        End With
      End With
      
      If Not gDB.Save(register, , "pSaveLegajos", C_Module, c_ErrorSave) Then Exit Function
    Next
    
  End If
  
  pSaveLegajos = True
End Function

' Reglas del Objeto de Negocios
Private Function pDocAsistTipo() As csETipoFactura
  Dim Doc     As cDocumento
  Dim rtn     As Boolean
  Dim DocId   As Long
  
  ' Si todavia no se cargo el form no se que
  ' documento es, asi que no puede ser sobre orden
  If pGetDocId() Is Nothing Then Exit Function
  
  DocId = pGetDocId().HelpId
  
  ' Si no hay un documento activo no se hace nada
  If DocId = csNO_ID Then Exit Function
  
  Set Doc = New cDocumento
  
  pDocAsistTipo = Doc.GetData(DocId, cscDocTipoFactura, csInteger)
End Function

Private Function pDocDesdeOrden() As Boolean
  pDocDesdeOrden = pDocAsistTipo = csETFacOrden
End Function

Private Function pDocDesdeRemito() As Boolean
  pDocDesdeRemito = pDocAsistTipo = csETFacRemito
End Function

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
  
Private Sub pShowImporteAndIvaManual(ByRef Row As CSInterfacesABM.cIABMGridRow)
  Dim Importe As Double
  Dim Neto    As Double
  Dim IvaRi   As Double
  Dim IvaRni  As Double
  
  Neto = Val(pCell(Row, KI_CANTIDAD).Value) * Val(pCell(Row, KI_PRECIO).Value)
  IvaRi = pCell(Row, KI_IVARI).Value
  If m_bIvaRni Then
    IvaRni = (Neto * Val(pCell(Row, KI_IVARNIPercent).Value)) / 100
  End If
  Importe = Neto + IvaRi + IvaRni
  
  pCell(Row, KI_NETO).Value = Neto
  pCell(Row, KI_IVARNI).Value = IvaRni
  pCell(Row, KI_IMPORTE).Value = Importe
End Sub
  
Private Sub pShowTotales()
  Dim Rows       As CSInterfacesABM.cIABMGridRows
  Dim RowsOtros  As CSInterfacesABM.cIABMGridRows
  Dim RowsPercep As CSInterfacesABM.cIABMGridRows
  
  Dim Neto      As Double
  Dim IvaRi     As Double
  Dim IvaRni    As Double
  Dim Desc1     As Double
  Dim Desc2     As Double
  Dim Otros     As Double
  Dim Percep    As Double
  Dim Row       As CSInterfacesABM.cIABMGridRow
  
  Set Rows = GetItems(m_Items, c_Items).Grid.Rows
  Set RowsOtros = m_Items.Properties(c_Otros).Grid.Rows
  Set RowsPercep = m_Items.Properties(c_Percepciones).Grid.Rows
  
  For Each Row In Rows
    Neto = Neto + Val(pCell(Row, KI_NETO).Value)
    IvaRi = IvaRi + Val(pCell(Row, KI_IVARI).Value)
    IvaRni = IvaRni + Val(pCell(Row, KI_IVARNI).Value)
  Next
  
  For Each Row In RowsOtros
    Otros = Otros + Val(pCell(Row, KI_DEBE).Value) - Val(pCell(Row, KI_HABER).Value)
  Next
  
  For Each Row In RowsPercep
    Percep = Percep + Val(pCell(Row, KIP_IMPORTE).Value)
  Next
  
  With m_Footer.Properties
    .Item(cscFcSubtotal).Value = Neto
  
    Desc1 = m_ObjAbm.Properties(cscFcDescuento1).Value
    Desc2 = m_ObjAbm.Properties(cscFcDescuento2).Value
    
    IvaRi = IvaRi - (IvaRi * Desc1 / 100)
    IvaRni = IvaRni - (IvaRni * Desc1 / 100)
    
    IvaRi = IvaRi - (IvaRi * Desc2 / 100)
    IvaRni = IvaRni - (IvaRni * Desc2 / 100)
    
    Desc1 = Neto * Desc1 / 100
    .Item(cscFcImportedesc1).Value = Desc1
    
    Neto = Neto - Desc1
    
    Desc2 = Neto * Desc2 / 100
    .Item(cscFcImportedesc2).Value = Desc2
    
    Neto = Neto - Desc2
    
    .Item(cscFcNeto).Value = Neto
    .Item(cscFcIvari).Value = IvaRi
    .Item(cscFcIvarni).Value = IvaRni
    .Item(cscFcTotalOtros).Value = Otros
    .Item(cscFcTotalPercepciones).Value = Percep
    .Item(cscFcTotal).Value = Neto + IvaRni + IvaRi + Otros + Percep
  End With
  
  m_Footer.RefreshControls
End Sub

Private Sub pSetTasasImpositivas(ByRef Row As CSInterfacesABM.cIABMGridRow, ByVal PR_ID As Long, ByVal pr_nombre As String)
  Dim ti_ri    As Long
  Dim ti_rni   As Long
  
  If PR_ID = 0 Then Exit Sub
  
  If Not GetTasaFromProducto(PR_ID, ti_ri, ti_rni, True) Then Exit Sub
  
  If ti_ri = 0 Then
    MsgWarning "El producto [" & pr_nombre & "] no tiene definida su tasa impositiva de Compras para el iva responsable inscripto"
    Exit Sub
  End If
  
  If ti_rni = 0 Then
    MsgWarning "El producto [" & pr_nombre & "] no tiene definida su tasa impositiva de Compras para el iva responsable no inscripto"
    Exit Sub
  End If
  
  Dim sqlstmt As String
  Dim rs      As Recordset
  
  If m_bIva Then
    sqlstmt = "select ti_porcentaje,cue_id from tasaimpositiva where ti_id = " & ti_ri
    If Not gDB.OpenRs(sqlstmt, rs) Then Exit Sub
    
    If Not rs.EOF Then
      pCell(Row, KI_IVARIPercent).Value = gDB.ValField(rs.fields, cscTiPorcentaje)
      pCell(Row, KI_CUE_ID_IVARI).Value = gDB.ValField(rs.fields, cscCueId)
    End If
  Else
    pCell(Row, KI_IVARIPercent).Value = 0
    pCell(Row, KI_CUE_ID_IVARI).Value = csNO_ID
  End If
  
  If m_bIvaRni Then
    sqlstmt = "select ti_porcentaje,cue_id from tasaimpositiva where ti_id = " & ti_rni
    If Not gDB.OpenRs(sqlstmt, rs) Then Exit Sub
    
    If Not rs.EOF Then
      pCell(Row, KI_IVARNIPercent).Value = gDB.ValField(rs.fields, cscTiPorcentaje)
      pCell(Row, KI_CUE_ID_IVARNI).Value = gDB.ValField(rs.fields, cscCueId)
    End If
  Else
    pCell(Row, KI_IVARNIPercent).Value = 0
    pCell(Row, KI_CUE_ID_IVARNI).Value = csNO_ID
  End If
End Sub

Private Sub pSetDataProducto(ByRef Row As CSInterfacesABM.cIABMGridRow, ByVal PR_ID As Long)
  Dim sqlstmt As String
  Dim rs      As Recordset
  
  Dim bChanged As Boolean
  
  bChanged = PR_ID <> pCell(Row, KI_PR_ID).Id
  
  sqlstmt = "sp_StockProductoGetData " & PR_ID & ",Null," & pGetProvId()
  
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Sub
  
  If Not rs.EOF Then
    pCell(Row, KI_UNIDAD).Value = gDB.ValField(rs.fields, "unidadCompra")
    pCell(Row, KI_CUE_ID).Value = gDB.ValField(rs.fields, cscCueidCompra)
    
    ' Si el documento no mueve stock no se exigen los numeros de serie
    '
    If m_bShowStockData Then
      pCell(Row, KI_PR_LLEVANROSERIE).Id = gDB.ValField(rs.fields, cscPrLlevaNroSerie)
      ' Lote
      '
      pCell(Row, KI_PR_LLEVALOTE).Id = gDB.ValField(rs.fields, cscPrLlevaNroLote)
    Else
      pCell(Row, KI_PR_LLEVANROSERIE).Id = False
      pCell(Row, KI_PR_LLEVALOTE).Id = False
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

Private Sub pSetPrecios(ByRef Row As CSInterfacesABM.cIABMGridRow, ByVal PR_ID As Long)
  Dim LP        As cListaPrecio
  Dim lp_id     As Long
  Dim Precio    As Double
  
  lp_id = m_ObjAbm.Properties(cscLpId).HelpId
    
  If lp_id <> csNO_ID Then
    Set LP = New cListaPrecio
    Precio = LP.GetPrecio(lp_id, PR_ID)
  End If
  
  pCell(Row, KI_PRECIO_LP).Value = Precio
  pCell(Row, KI_PRECIO_USR).Value = Precio
End Sub

Private Sub pSetDescuentos(ByRef Row As CSInterfacesABM.cIABMGridRow, ByVal PR_ID As Long, ByVal Precio As Double)
  Dim LD        As cListaDescuento
  Dim ld_id     As Long
  Dim Descuento As String
  
  ld_id = m_ObjAbm.Properties(cscLdId).HelpId
  
  If ld_id <> csNO_ID Then
    Set LD = New cListaDescuento
    Precio = LD.GetPrecio(ld_id, PR_ID, Precio)
    Descuento = LD.GetDescuentoStr(ld_id, PR_ID)
  End If
  
  pCell(Row, KI_PRECIO).Value = Precio
  pCell(Row, KI_DESCUENTO).Value = Descuento
End Sub

Private Sub pSetEnabled()
  Dim bState As Boolean
  
  ' Si se genera desde una orden de compra y es nuevo
  ' no puede editar, tiene que hacer click en
  ' nuevo y llamar al asistente
  If pDocDesdeOrden And m_Id = csNO_ID Then
    bState = False
  ElseIf pDocDesdeRemito And m_Id = csNO_ID Then
    bState = False
  ElseIf m_DocEditable Then
    bState = pGetDocId().HelpId <> csNO_ID
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
  
  If bState Then
    With m_ObjAbm.Properties
      .Item(cscDeplIdOrigen).Enabled = m_bShowStockData
    End With
  End If
  
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

Private Function pSetDatosProveedor() As Boolean
  Dim lp_id             As Long
  Dim ld_id             As Long
  Dim cpg_id            As Long
  Dim cpg_nombre        As String
  Dim LP                As cListaPrecio
  Dim LD                As cListaDescuento
  Dim iProp             As cIABMProperty
  Dim Filter            As String
  Dim bProveedorChange  As Boolean
  
  With m_ObjAbm.Properties.Item(cscProvId)
    If m_LastProv = .HelpId Then
      Exit Function
    End If
    bProveedorChange = True
    m_LastProv = .HelpId
  End With
  
  pSetDatosProveedor = bProveedorChange

  If Not GetProveedorDataEx(m_LastProv, lp_id, ld_id, cpg_id, m_LastDoc) Then Exit Function
  
  ' Condicion de pago
  If cpg_id <> csNO_ID Then
    
    If Not gDB.GetData(csTCondicionPago, cscCpgId, cpg_id, cscCpgNombre, cpg_nombre) Then Exit Function
    
    Set iProp = m_ObjAbm.Properties.Item(cscCpgId)
    iProp.Value = cpg_nombre
    iProp.HelpId = cpg_id
    m_ObjAbm.ShowValue iProp
  End If
  
  ' Lista de precios
  Set iProp = m_ObjAbm.Properties.Item(cscLpId)
  iProp.HelpFilter = GetListaPrecioGetXProveedor(m_LastDoc, m_LastProv)
  
  If lp_id <> csNO_ID Then
    Set LP = New cListaPrecio
    iProp.Value = LP.GetData(lp_id, cscLpNombre, csText)
    iProp.HelpId = lp_id
  End If
  
  m_ObjAbm.ShowValue iProp
  
  ' Lista de descuentos
  Set iProp = m_ObjAbm.Properties.Item(cscLdId)
  iProp.HelpFilter = GetListaDescGetXProveedor(m_LastDoc, m_LastProv)
  
  If ld_id <> csNO_ID Then
    Set LD = New cListaDescuento
    iProp.Value = LD.GetData(ld_id, cscLdNombre, csText)
    iProp.HelpId = ld_id
  End If
  
  m_ObjAbm.ShowValue iProp
  
  ' Talonario y Categoria fiscal
  pGetIvaFromProveedor m_LastProv

  pShowFechaVto
End Function

Private Sub pGetIvaFromProveedor(ByVal prov_id As Long)
  Dim sqlstmt     As String
  Dim rs          As ADODB.Recordset
  Dim bIvaChanged As Boolean
  Dim bLastIva    As Boolean
  
  sqlstmt = "sp_ProveedorGetIva " & prov_id
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Sub
  
  If rs.EOF Then Exit Sub
  
  bLastIva = m_bIva
  m_bIva = gDB.ValField(rs.fields, "bIva")
  If bLastIva <> m_bIva Then bIvaChanged = True
  
  bLastIva = m_bIvaRni
  m_bIvaRni = gDB.ValField(rs.fields, "bIvaRni")
  If bLastIva <> m_bIvaRni Then bIvaChanged = True
  
  If bIvaChanged Then
    pShowTotales
  End If
End Sub

Private Function pGetCueIdProveedor(ByRef Mon_id As Long, ByRef Cue_id As Long) As Boolean
  Dim sqlstmt As String
  Dim rs      As Recordset
  
  ' Cuenta contable del Proveedor
  sqlstmt = "sp_DocGetCueId " & m_LastProv & "," & m_LastDoc
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Function

  If rs.EOF Then Exit Function

  Cue_id = gDB.ValField(rs.fields, cscCueId)
  Mon_id = gDB.ValField(rs.fields, cscMonId)
  
  pGetCueIdProveedor = True
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
  
  sqlstmt = "sp_DocFacturaCompraFirmar " & m_Id & "," & Us_id
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Function
  
  m_est_id = gDB.ValField(rs.fields, cscEstId)
  m_Estado = gDB.ValField(rs.fields, cscEstNombre)
  
  Dim iProp As cIABMProperty
  Set iProp = m_ObjAbm.Properties(csDocEstateID)
  
  With iProp
    .HelpId = m_est_id
    .Value = m_Estado
  End With
  
  gDB.GetData csTFacturaCompra, cscFcId, m_Id, cscFcFirmado, m_Firmado
  
  m_ObjAbm.ShowValue iProp
  
  pFirmar = True
End Function

Private Function pMove(ByVal MoveTo As ABM_MSG) As Boolean
  Dim sqlstmt As String
  Dim rs      As Recordset
  Dim doc_id  As Long
  
  doc_id = pGetDocId().HelpId
  
  If doc_id = csNO_ID Then MsgInfo "Debe seleccionar un documento"
  
  sqlstmt = "sp_DocFacturaCompraMover " & MoveTo & "," & m_Numero & "," & doc_id
  
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Function
  
  ' Si no obtuve ningun id al moverme
  '
  If rs.EOF Then
    
    Select Case MoveTo
    
      ' Si era siguiente ahora busco el ultimo
      '
      Case MSG_DOC_NEXT
        pMove MSG_DOC_LAST  ' Llamada recursiva
      
      ' Si era anterior ahora busco el primero
      '
      Case MSG_DOC_PREVIOUS
        pMove MSG_DOC_FIRST ' Llamada recursiva
       
      ' Si no encontre ni ultimo ni primero
      ' es por que no hay ningun comprobante para
      ' este documento
      '
      Case MSG_DOC_FIRST, MSG_DOC_LAST
        
        ' Limpio incluso el ultimo proveedor
        '
        m_LastProv = csNO_ID
        m_LastProvName = vbNullString
        
        ' Cargo un registro vacio
        '
        Load csNO_ID
        
        ' Obtengo un nuevo numero de comprobante
        '
        GetDocNumberForProveedor m_LastProv, m_LastDoc, m_ObjAbm, m_TaPropuesto
        
        ' Refresco el formulario
        '
        pRefreshProperties
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
    
    Set c = .Item(cscFcFecha)
    c.Value = m_Fecha
    
    Set c = .Item(cscFcFechaentrega)
    c.Value = m_Fechaentrega
    
    Set c = .Item(cscFcFechaIva)
    c.Value = m_FechaIva
    
    Set c = .Item(cscProvId)
    c.HelpId = m_Prov_id
    c.Value = m_proveedor
    
    Set c = .Item(csDocNumberID)
    c.Value = m_Numero
    
    Set c = .Item(csDocEstateID)
    c.Value = m_Estado
    
    Set c = .Item(cscFcNrodoc)
    c.Value = m_Nrodoc
    c.TextMask = m_TaMascara
    c.TextAlign = vbRightJustify
    
    Set c = .Item(cscFcDescuento1)
    c.Value = m_Descuento1
    
    Set c = .Item(cscFcDescuento2)
    c.Value = m_Descuento2
    
    Set c = .Item(cscCpgId)
    c.HelpId = m_cpg_id
    c.Value = m_CondicionPago
    
    Set c = .Item(cscFcFechaVto)
    c.Value = m_FechaVto
    
    Set c = .Item(cscFcCotizacion)
    c.Value = m_Cotizacion
    
    Set c = .Item(cscLpId)
    c.HelpFilter = GetListaPrecioGetXProveedor(m_doc_id, m_Prov_id)
    c.HelpId = m_Lp_id
    c.Value = m_ListaPrecio
    
    Set c = .Item(cscLdId)
    c.HelpFilter = GetListaDescGetXProveedor(m_doc_id, m_Prov_id)
    c.HelpId = m_Ld_id
    c.Value = m_ListaDescuento
    
    Set c = .Item(cscCcosId)
    c.HelpId = m_ccos_id
    c.Value = m_CentroCosto
    
    Set c = .Item(cscSucId)
    c.HelpId = m_suc_id
    c.Value = m_Sucursal
    
    Set c = .Item(cscFcDescrip)
    c.Value = m_Descrip
    
    Set c = .Item(cscFcCai)
    c.Value = m_Cai
  
    Set c = .Item(cscLgjId)
    c.HelpId = m_lgj_id
    c.Value = m_Legajo
    
    Set c = .Item(cscProIdOrigen)
    c.HelpId = m_pro_id_origen
    c.Value = m_ProOrigen
    
    Set c = .Item(cscProIdDestino)
    c.HelpId = m_pro_id_destino
    c.Value = m_ProDestino
  
    Set c = .Item(cscDeplIdOrigen)
    If m_depl_id <> csNO_ID Or Not m_bShowStockData Then
      c.HelpId = m_depl_id
      c.Value = m_Deposito
    Else
      ' Preferencias del usuario
      '
      c.HelpId = m_UserCfg.DeplId
      c.Value = m_UserCfg.DeplNombre
    End If
    
    Set c = .Item(cscFcTipoComprobante)
    c.ListItemData = m_tipoComprobante
  
  End With
  
  Set AbmGen = m_ObjAbm
  AbmGen.ShowValues m_ObjAbm.Properties
  
  If m_Cotizacion <> 0 Then
    Cotizacion = m_Cotizacion
  Else
    Cotizacion = 1
  End If
  
  Set c = GetItems(m_Items, c_Items)
  If Not pLoadItems(c, Cotizacion) Then Exit Sub
  
  m_ItemsDeleted = vbNullString
  
  Set c = m_Items.Properties.Item(c_Otros)
  If Not pLoadOtros(c, Cotizacion) Then Exit Sub
  
  m_OtrosDeleted = vbNullString
  
  Set c = m_Items.Properties.Item(c_Percepciones)
  If Not pLoadPercepciones(c, Cotizacion) Then Exit Sub
  
  m_PercepcionesDeleted = vbNullString
  
  Set c = m_Items.Properties.Item(c_Legajos)
  If Not pLoadLegajos(c, Cotizacion) Then Exit Sub
  
  m_LegajosDeleted = vbNullString
  
  Set AbmGen = m_Items
  AbmGen.ShowValues m_Items.Properties
  
  With m_Footer.Properties
  
    Set c = .Item(cscFcSubtotal)
    c.Value = m_SubTotal
    
    Set c = .Item(cscFcImportedesc1)
    c.Value = m_ImporteDesc1
    
    Set c = .Item(cscFcImportedesc2)
    c.Value = m_ImporteDesc2
    
    Set c = .Item(cscFcNeto)
    c.Value = m_Neto
    
    Set c = .Item(cscFcIvari)
    c.Value = m_Ivari
    
    Set c = .Item(cscFcIvarni)
    c.Value = m_Ivarni
    
    Set c = .Item(cscFcTotalOtros)
    c.Value = m_TotalOtros
    
    Set c = .Item(cscFcTotalPercepciones)
    c.Value = m_TotalPercepciones
    
    Set c = .Item(cscFcTotal)
    c.Value = m_Total
  
  End With
  
  Set AbmGen = m_Footer
  AbmGen.ShowValues m_Footer.Properties
  
  pSetEnabled

  pShowCotizacion
  pShowFechaVto
  
End Sub

Private Function pGetDocFilter() As String
  pGetDocFilter = "'doct_id = " & csEDT_FacturaCompra & " or " & _
                  " doct_id = " & csEDT_NotaCreditoCompra & " or " & _
                  " doct_id = " & csEDT_NotaDebitoCompra & "'"
End Function

Private Sub pShowApply()
    
  If Not DocSecurityCanAccess(csPreCpraModifyAplic, m_doc_id, csEDocTPreAplicar) Then Exit Sub

  If m_ObjApply Is Nothing Then
    Set m_ObjApply = New cFacturaCompraAplic
  
  ' Edit Apply
  '
  Else
    If m_ObjApply.Id <> m_Id Then
      Set m_ObjApply.ObjectClient = Nothing
      Set m_ObjApply = New cFacturaCompraAplic
    End If
  End If

  ' Edit Apply
  '
  Set m_ObjApply.ObjectClient = Me
  
  If Not m_ObjApply.Show(m_Id, _
                         m_Total * IIf( _
                                m_Cotizacion <> 0, m_Cotizacion, 1 _
                                      ), _
                         m_Nrodoc, _
                         m_Prov_id, _
                         m_proveedor, _
                         m_suc_id, _
                         m_doc_id, _
                         m_Doct_id = csEDT_NotaCreditoCompra) Then
    Set m_ObjApply = Nothing
  End If
End Sub

Private Sub pShowStartWizardRemito()
  On Error GoTo ControlError
  
  Dim oWizard As cFacturaCompraRemitoWiz
  Set oWizard = New cFacturaCompraRemitoWiz
  
  Dim Mouse As cMouseWait
  Set Mouse = New cMouseWait
  
  If Not oWizard.Load() Then Exit Sub

  With oWizard
    .prov_id = m_Prov_id
    .Proveedor = m_proveedor
    .RcIds = m_RcIds
    .doc_id = m_LastDoc
    .Documento = m_LastDocName
    Set .ObjClient = Me
  End With
  
  'Dim iEditGeneric As cIEditGeneric
  'Set iEditGeneric = oWizard
  'Set iEditGeneric.ObjTree = m_ObjTree
  
  Dim iObjWizard As cIWizardGeneric
  Dim oObjWizard   As cWizardGeneric
  
  Set iObjWizard = CSKernelClient2.CreateObject("CSABMInterface2.cWizardGeneric")
  Set oObjWizard = iObjWizard
  Set oObjWizard.ObjClient = oWizard
  
  iObjWizard.Show "CSCompra2.cFacturaCompraRemitoWiz"
  
  oObjWizard.ObjAbm.ObjForm.ZOrder
  
  GoTo ExitProc
ControlError:
  MngError Err, "pShowStartWizardRemito", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub pShowStartWizard()
  On Error GoTo ControlError
  
  Dim oWizard As cFacturaCompraWizard
  Set oWizard = New cFacturaCompraWizard
  
  Dim Mouse As cMouseWait
  Set Mouse = New cMouseWait
  
  If Not oWizard.Load() Then Exit Sub

  With oWizard
    .prov_id = m_Prov_id
    .Proveedor = m_proveedor
    .OcIds = m_OcIds
    .doc_id = m_LastDoc
    .Documento = m_LastDocName
    Set .ObjClient = Me
  End With
  
  'Dim iEditGeneric As cIEditGeneric
  'Set iEditGeneric = oWizard
  'Set iEditGeneric.ObjTree = m_ObjTree
  
  Dim iObjWizard As cIWizardGeneric
  Dim oObjWizard   As cWizardGeneric
  
  Set iObjWizard = CSKernelClient2.CreateObject("CSABMInterface2.cWizardGeneric")
  Set oObjWizard = iObjWizard
  Set oObjWizard.ObjClient = oWizard
  
  iObjWizard.Show "CSCompra2.cFacturaCompraWizard"
  
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
  
  Set m_NrosSerie = New Collection
  Set m_GeneralConfig = New cGeneralConfig
  m_GeneralConfig.Load
  ReDim m_OcIds(0)
  ReDim m_RcIds(0)

  ' Preferencias del Usuario
  '
  Set m_UserCfg = New cUsuarioConfig
  m_UserCfg.Load
  m_UserCfg.ValidateFC

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
  ReDim m_OcIds(0)
  ReDim m_RcIds(0)
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

Private Sub pSetShowStockData()
  Dim DocId     As Long
  Dim DocIdRto  As Long
  Dim Doc       As cDocumento
  
  Set Doc = New cDocumento
  
  m_bShowStockData = False
  
  DocId = pGetDocId().HelpId
  
  ' Si la factura mueve stock
  '
  If CBool(Doc.GetData(DocId, cscDocMueveStock, csBoolean)) Then
    m_bShowStockData = True
    
  ' Verifico si genera remito que mueve stock
  '
  Else
    ' Si genera remito
    '
    If CBool(Doc.GetData(DocId, cscDocGeneraRemito, csBoolean)) Then
      ' Obtengo el docid del remito
      '
      DocIdRto = Doc.GetData(DocId, cscDocIdRemito, csLong)
      
      ' Si el remito mueve stock
      '
      m_bShowStockData = CBool(Doc.GetData(DocIdRto, cscDocMueveStock, csBoolean))
    End If
  End If
End Sub

'///////////////////////////////////////////////////////////////////////////////////////////////////////////
Private Function pSaveItemNroSerie(ByRef Row As CSInterfacesABM.cIABMGridRow, _
                                   ByRef iOrden As Long, _
                                   ByVal PrId As Long, _
                                   ByVal FcTMPId As Long, _
                                   ByVal FciTMPId As Long, _
                                   ByVal Grupo As Long) As Boolean
                                   
  Dim pt        As cProductoSerieType
  Dim register  As cRegister
  
  ' Si lleva numero de serie
  '
  If pCell(Row, KI_PR_LLEVANROSERIE).Id Then
  
    ' Obtengo los numeros de serie y guardo un Item por cada uno
    '
    For Each pt In m_NrosSerie.Item(GetKey(Grupo))
      
      If pt.deleted Then
      
        If Not m_Copy And pt.prns_id Then
        
          Set register = New cRegister
          register.fieldId = cscFcisbTMPId
          register.Table = csTFacturaCompraItemSerieBTMP
          register.Id = csNew
        
          register.fields.Add2 cscFcTMPId, FcTMPId, csId
          register.fields.Add2 cscPrnsId, pt.prns_id, csId
        
          register.fields.HaveLastUpdate = False
          register.fields.HaveWhoModify = False
          
          If Not gDB.Save(register, , _
                          "pSaveItemNroSerie", _
                          C_Module, _
                          "Error al grabar el factura de compra") Then Exit Function
        
        End If
      
      Else
      
        Set register = New cRegister
        register.fieldId = cscFcisTMPId
        register.Table = csTFacturaCompraItemSerieTMP
        register.Id = csNew
        
        register.fields.Add2 cscPrId, PrId, csId
        
        If m_Copy Then
          register.fields.Add2 cscPrnsId, csNew, csInteger
        Else
          register.fields.Add2 cscPrnsId, pt.prns_id, csId
        End If
        
        register.fields.Add2 cscPrnsCodigo, pt.codigo, csText
        register.fields.Add2 cscPrnsDescrip, pt.Descrip, csText
        register.fields.Add2 cscPrnsFechavto, pt.FechaVto, csDate
        
        register.fields.Add2 cscFcTMPId, FcTMPId, csId
        register.fields.Add2 cscFciTMPId, FciTMPId, csId
        
        iOrden = iOrden + 1
        register.fields.Add2 cscFcisOrden, iOrden, csInteger
        
        register.fields.HaveLastUpdate = False
        register.fields.HaveWhoModify = False
        
        If Not gDB.Save(register, , _
                        "pSaveItemNroSerie", _
                        C_Module, _
                        "Error al grabar el Factura de compra") Then Exit Function
        
      End If
    Next
  End If
  
  pSaveItemNroSerie = True
End Function

Private Function pGetPrId(ByVal PrId As Long) As Long
  If Not pGetIsInput() Then
    pGetPrId = PrId
  End If
End Function

Private Function pGetIsInput() As Boolean
  pGetIsInput = m_LastDoctId <> csEDocumentoTipo.csEDT_NotaCreditoCompra
End Function

'////////////////////////////////////////////////////////////////////////////////////////////////
' nrs devolucion
Private Function pGetDeplId() As Long
  If m_LastDoctId <> csEDocumentoTipo.csEDT_NotaCreditoCompra Then
    pGetDeplId = csE_DepositosInternos.csEDeplIdTercero
  Else
    pGetDeplId = m_ObjAbm.Properties(cscDeplIdOrigen).HelpId
  End If
End Function

Private Function pGetProvId() As Long
  pGetProvId = m_ObjAbm.Properties(cscProvId).HelpId
End Function

Private Function pGetFecha() As Date
  pGetFecha = m_ObjAbm.Properties.Item(cscFcFecha).Value
End Function


