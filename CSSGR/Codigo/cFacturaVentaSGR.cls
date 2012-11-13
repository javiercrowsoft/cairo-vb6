VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cFacturaVentaSGR"
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
' cFacturaVenta
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
Private Const C_Module = "cFacturaVenta"

Private Const c_Items = "ITEMS"
Private Const c_Percepciones = "PERCEPCIONES"

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
Private Const K_CLI_ID                         As Integer = 10
Private Const K_DOC_ID                         As Integer = 11
Private Const K_DOCT_ID                        As Integer = 12
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

Private Const K_PERCEPCIONES                   As Integer = 35
Private Const K_TOTAPERCEPCIONES               As Integer = 36

Private Const K_ORDENCOMPRA                    As Integer = 40

Private Const KI_FVI_ID                         As Integer = 2
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
Private Const KI_CUE_ID                         As Integer = 23
Private Const KI_CUE_ID_IVARI                   As Integer = 24
Private Const KI_CUE_ID_IVARNI                  As Integer = 25

' TO
Private Const KI_TO_ID                          As Integer = 400


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
Private m_Fechaentrega                 As Date
Private m_FechaVto                     As Date
Private m_FechaIva                     As Date
Private m_Neto                         As Double
Private m_Ivari                        As Double
Private m_Ivarni                       As Double
Private m_Total                        As Double
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

Private m_pro_id_origen                As Long
Private m_ProOrigen                    As String
Private m_pro_id_destino               As Long
Private m_ProDestino                   As String

Private m_OrdenCompra                  As String

Private m_Cai                          As String

Private m_Cotizacion                   As Double
Private m_ccos_id                      As Long
Private m_CentroCosto                  As String
Private m_suc_id                       As Long
Private m_Sucursal                     As String
Private m_cli_id                       As Long
Private m_Cliente                      As String
Private m_doc_id                       As Long
Private m_Documento                    As String
Private m_Doct_id                      As Long
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

Private m_Editing           As Boolean

Private m_Footer            As cIABMGeneric
Private m_Items             As cIABMGeneric
Private m_ObjAbm            As cIABMGeneric
Private m_ObjTree           As Object

Private m_LastDoc           As Long
Private m_LastDoctId        As Long ' nrs devolucion
Private m_LastCli           As Long
Private m_LastDocName       As String
Private m_LastCliName       As String

Private m_LastCpgId         As Long

Private m_bIva              As Boolean
Private m_bIvaRni           As Boolean
Private m_CatFiscal         As Long
Private m_bCatFiscalChanged As Boolean

Private m_IsNew             As Boolean

Private m_BranchId          As Long
Private m_TreeId            As Long

Private m_Host              As CSMenu.cIMenuHost

Private m_ItemsDeleted        As String
Private m_PercepcionesDeleted As String

Private m_Copy              As Boolean

Private m_GeneralConfig     As cGeneralConfig
Private m_StockConfig       As cStockConfig

Private m_DocEditable       As Boolean
Private m_DocEditMsg        As String

Private m_PvIds()           As Long
Private m_RvIds()           As Long
Private m_PklstIds()        As Long
Private m_HoraIds()         As Long

Private m_TaPropuesto       As Boolean
Private m_TaMascara         As String

Private m_ObjApply          As Object

Private m_NrosSerie         As Collection
Private m_CollKitInfo       As Collection

' Preferencias del Usuario
'
Private m_UserCfg           As cUsuarioConfig

' Percepciones
'
Private m_doc_sin_perc      As Boolean
Private m_vPercepciones()   As T_Percepcion

Private m_Title As String
Private m_tipo  As csE_SGR_FacturaTipo

' propiedades publicas
Public Property Let AuxParam(ByVal rhs As String)
  If rhs = "@aux_Credito" Then
    m_Title = LNGGetText(3713, vbNullString) 'Aval s/Credito
    m_tipo = csE_SGR_FV_Credito
  ElseIf rhs = "@aux_AccionParticipe" Then
    m_Title = LNGGetText(3714, vbNullString) 'Venta de Acciones Soc. Participe
    m_tipo = csE_SGR_FV_AccionParticipe
  ElseIf rhs = "@aux_AccionProtector" Then
    m_Title = LNGGetText(3712, vbNullString) 'Venta de Acciones Soc. Protector
    m_tipo = csE_SGR_FV_AccionProtector
  ElseIf rhs = "@aux_Cheque" Then
    m_Title = LNGGetText(3715, vbNullString) 'Venta de Cheques
    m_tipo = csE_SGR_FV_Cheque
  ElseIf rhs = "@aux_OrdenCompra" Then
    m_Title = LNGGetText(3716, vbNullString) 'Aval s/Credito si Vtos
    m_tipo = csE_SGR_FV_OrdenCompra
  End If
End Property
' propiedades privadas
' funciones publicas

' Edit Apply
'
Public Sub Refresh()
  Load m_Id
  pRefreshProperties
End Sub

Public Function TerminateWizard(ByVal id As Long)
  On Error Resume Next
  If id <> csNO_ID Then
    cIEditGeneric_Edit id
  End If
End Function

Private Function pInitMembers() As Boolean
  Set cIEditGeneric_ObjAbm = New cABMGeneric
  Set cIEditGenericDoc_Footer = New cABMGeneric
  Set cIEditGenericDoc_Items = New cABMGeneric
  
  If Not DocSecurityCanAccess(csPreSGRNewFactura, _
                              csNO_ID, _
                              csEDocTPreNew) Then
    Exit Function
  End If
  pInitMembers = True
End Function

' Implementacion de cIABMClient
Private Function cIABMClient_Copy() As Boolean
  
  If Not DocSecurityCanAccessEx(csPreSGRNewFactura, _
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
  GetDocNumberForCliente m_LastCli, m_LastDoc, m_ObjAbm, m_TaPropuesto
  
  pSetEnabled
End Function

Private Function cIABMClient_EditNew() As Boolean
  
  cIABMClient_Terminate
  m_IsNew = True

  cIEditGeneric_Edit csNO_ID
  m_LastCli = csNO_ID
  
  If m_UserCfg.CliIdxDefecto Then
    Dim iProp As cIABMProperty
    Set iProp = m_ObjAbm.Properties.Item(cscCliId)
    With iProp
      .HelpId = m_UserCfg.CliIdxDefecto
      .Value = m_UserCfg.ClienteXDefecto
    End With
    m_ObjAbm.ShowValue iProp
  End If
  
  ' Obtengo los datos por defecto del cliente
  '
  pSetDatosCliente
  
  ' Obtengo el numero para este comprobante
  '
  GetDocNumberForCliente m_LastCli, m_LastDoc, m_ObjAbm, m_TaPropuesto

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

  Doc.ClientTable = csTFacturaVenta
  Doc.ClientTableID = m_Id

  cIABMClient_ShowDocDigital = Doc.ShowDocs(gDB)

  GoTo ExitProc
ControlError:
  MngError Err, "cIABMClient_ShowDocDigital", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Private Function cIABMClient_MessageEx(ByVal MessageID As Long, _
                                       ByVal Info As Variant) As Variant
    
  Select Case MessageID
    Case MSG_DOC_FIRST, MSG_DOC_PREVIOUS, MSG_DOC_NEXT, MSG_DOC_LAST
      cIABMClient_MessageEx = pMove(MessageID)
    
    Case MSG_DOC_SIGNATURE
      cIABMClient_MessageEx = pFirmar()
    
    Case MSG_GRID_ROW_DELETED
      cIABMClient_MessageEx = True
      If Info <> K_PERCEPCIONES Then
        pCalcularPercepciones
      End If
      pShowTotales
    
    Case MSG_DOC_APPLY
      pShowApply
    
    Case MSG_DOC_EDIT_STATE
      ShowEditState m_DocEditMsg, LNGGetText(1648, vbNullString)  'Factura de Venta
      
    Case MSG_DOC_DELETE
      If cIEditGeneric_Delete(m_Id) Then
        cIABMClient_MessageEx = True
        pMove MSG_DOC_NEXT
      End If
    
    Case MSG_DOC_ANULAR
      DocAnular m_Id, m_est_id, m_Estado, csPreSGRAnularFactura, csPreSGRDesAnularFactura, m_ObjAbm, m_DocEditable, m_DocEditMsg, "sp_DocFacturaVentaAnular", "sp_DocFacturaVentaEditableGet"
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
      DocumentSearch csEDT_FacturaVenta, Me, Not CBool(Info)
  
    Case MSG_DOC_DOC_AUX
      
      If m_Id Then
      
          ShowDocAux m_as_id, _
                     "CSContabilidad2.cAsiento", _
                     "CSABMInterface2.cABMGeneric"
      Else
        MsgInfo LNGGetText(1620, vbNullString)
        'MsgInfo "Debe editar un comprobante guardado para poder ver los documentos auxiliares"
      End If
      
    Case MSG_DOC_DOC_EDIT
      
      If m_Id Then
      
        If m_DocEditable Then
          MsgInfo LNGGetText(1555, vbNullString)
          'MsgInfo "Este documento puede editarse normalmente
        Else
          
          If DocCanSave(m_ObjAbm, cscFvFecha) Then
            
            Dim EditDoc As cEditDocEx
            Set EditDoc = New cEditDocEx
            
            Set EditDoc.ObjectClient = Me
            EditDoc.Edit m_Id, _
                         m_Doct_id, _
                         csTFacturaVenta, _
                         cscFvId, _
                         csTFacturaVentaItem, _
                         cscFviId, _
                         csPreSGRNewFactura, _
                         csPreSGREditFactura, _
                         m_cli_id, csNO_ID, _
                         True
          End If
          
        End If
      
      Else
        MsgInfo LNGGetText(1556, vbNullString)
                'Esta opción solo sirve para modificar documentos guardados y aplicados
      End If
      
    Case MSG_DOC_DOC_ACTION
    
      If m_Id Then
        pShowCobranza
      Else
        MsgInfo LNGGetText(1556, vbNullString)
                'Esta opción solo sirve para modificar documentos guardados y aplicados
      End If
    
    Case MSG_MENU_AUX
      
      Select Case Val(Info)
        Case 1 ' Asiento
          ShowDocAux m_as_id, _
                     "CSContabilidad2.cAsiento", _
                     "CSABMInterface2.cABMGeneric"

          
      End Select
  
    Case MSG_DOC_HISTORY
    
      If m_Id <> csNO_ID Then
    
        ShowHistory csFacturaVenta, m_Id, m_Documento & " " & m_Nrodoc
      Else
        
        MsgInfo LNGGetText(1552, vbNullString) ' "El documento aun no ha sido guardado
      End If
  
    Case MSG_EXPORT_GET_EMAIL
    
      With m_ObjAbm.Properties.Item(cscCliId)
        cIABMClient_MessageEx = GetEmailFromCliente(.HelpId)
      End With
  
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
        
        ' Obtengo el tipo de documento
        If Not gDB.GetData(csTDocumento, cscDocId, m_LastDoc, cscDoctId, m_LastDoctId) Then Exit Function ' nrs devolucion
        
        ' Si cambie de documento y estoy en un comprobante ya guardado
        ' tengo que mostrar el formulario sin datos, para evitar
        ' que presione guardar y le cambie el doc_id al comprobante por error
        '
        If m_Id <> csNO_ID And m_doc_id <> m_LastDoc Then
          If m_Copy Then
            ' TODO: Aca falta validar que sean de la misma moneda
            '       en caso contrario hay que aplicar la cotizacion
            '       a todo el documento, y obtener el estado de edicion
            '       del documento verificando la seguridad
            '       (debe tener permiso para agregar un nuevo documento)
            '
            '       Tambien hay que corregir el control de fechas
            '       para que no permita crear o modificar documento
            '       fuera del intervalo permitido
            '
            If Not Ask(LNGGetText(1621, vbNullString), vbYes, LNGGetText(1622, vbNullString)) Then
            'If Not Ask("Ud. ha cambiado el documento.;;¿Desea utilizar los datos ya cargados en el formulario para el nuevo comprobante?", vbYes, "CrowSoft") Then
              cIEditGeneric_Edit csDocChanged
            End If
          Else
            cIEditGeneric_Edit csDocChanged
          End If
        End If
        
        ' Obtengo el numero para este comprobante
        '
        GetDocNumberForCliente m_LastCli, m_LastDoc, m_ObjAbm, m_TaPropuesto
        
        ' Si corresponde muestro la cotizacion de la moneda del documento
        '
        pShowCotizacion
              
        ' Obtengo si lleva percepciones
        '
        If Not gDB.GetData(csTDocumento, _
                           cscDocId, _
                           m_LastDoc, _
                           cscDocFvSinPercepcion, _
                           m_doc_sin_perc) Then
          Exit Function
        End If
      
      End If
      
      ' Defino el estado de edicion del comprobante
      '
      pSetEnabled
    
    Case K_CLI_ID
    
      ' Obtengo los datos del cliente
      '
      If pSetDatosCliente Then
        
        ' Si cambie de cliente y estoy en un comprobante ya guardado
        ' pregunto si desea conservar el numero de comprobante
        '
        If m_Id <> csNO_ID Then
        
          ' Si cambio la categoria fiscal
          '
          If m_bCatFiscalChanged Then
            If Not Ask(LNGGetText(1623, vbNullString), vbYes, LNGGetText(1622, vbNullString)) Then
            'If Not Ask("Ud. ha cambiado el cliente y la categoria fiscal del cliente anterior no coincide con la del cliente actual.;;¿Desea conservar el numero de comprobante?", vbYes, "CrowSoft") Then
              GetDocNumberForCliente m_LastCli, m_LastDoc, m_ObjAbm, m_TaPropuesto
            End If
          End If
        
        ' Si el documento es nuevo siempre obtengo un
        ' nuevo numero de comprobante
        '
        Else
          GetDocNumberForCliente m_LastCli, m_LastDoc, m_ObjAbm, m_TaPropuesto
        End If
      End If
      
    Case K_DESCUENTO1, K_DESCUENTO2
      
      pShowTotales
    
    Case K_FECHA
      
      ' Cotizacion
      If m_lastFecha <> pGetFecha() Then
        m_lastFecha = pGetFecha()
        m_lastMonIdCotizacion = csNO_ID
        pShowCotizacion
        
        With m_ObjAbm.Properties
          .Item(cscFvFechaIva).Value = .Item(cscFvFecha).Value
          m_ObjAbm.ShowValue .Item(cscFvFechaIva)
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
  Dim TotalPercep  As Double
  Dim IvaRi        As Double
  Dim IvaRni       As Double
  Dim DocId        As Long
  Dim bIsNew       As Boolean
  
  ' Save and State
  '
  If Not DocCanEdit(m_DocEditable, m_DocEditMsg) Then
    cIABMClient_Save = True
    Exit Function
  End If
  If Not DocCanSave(m_ObjAbm, cscFvFecha) Then
    cIABMClient_Save = False
    Exit Function
  End If
  
  Dim Mouse As cMouseWait
  Set Mouse = New cMouseWait
  
  DoEvents: DoEvents: DoEvents: DoEvents
  
  Set register = New cRegister
  register.fieldId = cscFvTMPId
  register.Table = csTFacturaVentaTMP
  
  register.id = csNew
    
  If m_Copy Then
    register.fields.Add2 cscFvId, csNew, csLong
    bIsNew = True
  Else
    register.fields.Add2 cscFvId, m_Id, csLong
    bIsNew = m_Id = csNO_ID
  End If
  
  If m_est_id = csNO_ID Then
    m_est_id = CSGeneralEx2.csEEstado.csEEst_Pendiente
  End If
  
  Dim IProperty As cIABMProperty
  For Each IProperty In m_ObjAbm.Properties
    With IProperty
      Select Case .Key
        Case K_NUMERO
          register.fields.Add2 cscFvNumero, .Value, csLong
        Case K_NRODOC
          register.fields.Add2 cscFvNrodoc, .Value, csText
        Case K_DESCRIP
          register.fields.Add2 cscFvDescrip, .Value, csText
        Case K_FECHA
          register.fields.Add2 cscFvFecha, .Value, csDate
        Case K_FECHAENTREGA
          register.fields.Add2 cscFvFechaentrega, .Value, csDate
        Case K_FECHAIVA
          register.fields.Add2 cscFvFechaIva, .Value, csDate
        Case K_FECHAVTO
          register.fields.Add2 cscFvFechaVto, .Value, csDate
        Case K_CLI_ID
          register.fields.Add2 cscCliId, .HelpId, csId
        Case K_CCOS_ID
          register.fields.Add2 cscCcosId, .HelpId, csId
        Case K_SUC_ID
          register.fields.Add2 cscSucId, .HelpId, csId
        Case K_DESCUENTO1
          register.fields.Add2 cscFvDescuento1, .Value, csCurrency
        Case K_DESCUENTO2
          register.fields.Add2 cscFvDescuento2, .Value, csCurrency
        Case K_DOC_ID
          DocId = .HelpId
          register.fields.Add2 cscDocId, DocId, csId
        Case K_CPG_ID
          register.fields.Add2 cscCpgId, .HelpId, csId
        Case K_COTIZACION
          Cotizacion = .Value
          register.fields.Add2 cscFvCotizacion, .Value, csDouble
        Case K_CAI
          register.fields.Add2 cscFvCai, .Value, csText
        Case K_LGJ_ID
          register.fields.Add2 cscLgjId, .HelpId, csId
        Case K_PRO_ID_ORIGEN
          register.fields.Add2 cscProIdOrigen, .HelpId, csId
        Case K_PRO_ID_DESTINO
          register.fields.Add2 cscProIdDestino, .HelpId, csId
        Case K_ORDENCOMPRA
          register.fields.Add2 cscFvOrdenCompra, .Value, csText
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
          register.fields.Add2 cscFvNeto, Neto * Cotizacion, csCurrency
        Case K_IVARI
          IvaRi = Val(.Value)
          register.fields.Add2 cscFvIvari, IvaRi * Cotizacion, csCurrency
        Case K_IVARNI
          IvaRni = Val(.Value)
          register.fields.Add2 cscFvIvarni, IvaRni * Cotizacion, csCurrency
        Case K_SUBTOTAL
          register.fields.Add2 cscFvSubtotal, Val(.Value) * Cotizacion, csCurrency
        Case K_IMPORTEDESC1
          register.fields.Add2 cscFvImportedesc1, Val(.Value) * Cotizacion, csCurrency
        Case K_IMPORTEDESC2
          register.fields.Add2 cscFvImportedesc2, Val(.Value) * Cotizacion, csCurrency
        Case K_TOTAPERCEPCIONES
          TotalPercep = Val(.Value)
          register.fields.Add2 cscFvTotalPercepciones, TotalPercep * Cotizacion, csCurrency
      End Select
    End With
  Next
  
  TotalOrigen = Neto + TotalPercep
  If m_bIva Then
    TotalOrigen = TotalOrigen + IvaRi
  End If
  If m_bIvaRni Then
    TotalOrigen = TotalOrigen + IvaRni
  End If
  
  register.fields.Add2 cscFvTotal, TotalOrigen * Cotizacion, csCurrency
  register.fields.Add2 cscFvGrabarAsiento, 1, csBoolean
  register.fields.Add2 cscEstId, m_est_id, csId
  
  If bMonedaLegal Then
    register.fields.Add2 cscFvTotalOrigen, 0, csCurrency
  Else
    register.fields.Add2 cscFvTotalOrigen, TotalOrigen, csCurrency
  End If
  
  register.fields.HaveLastUpdate = True
  register.fields.HaveWhoModify = True
  
  If Not register.BeginTrans(gDB) Then Exit Function
  
  If Not gDB.Save(register, , "cIABMClient_Save", C_Module, c_ErrorSave) Then Exit Function
  
  If Not pSaveItems(register.id, Cotizacion, bMonedaLegal) Then Exit Function
  If Not SavePercepciones(GetItems(m_Items, c_Percepciones), _
                          register.id, Cotizacion, bMonedaLegal, _
                          m_Copy, m_PercepcionesDeleted, _
                          m_Id, C_Module) Then Exit Function
  
  If Not register.CommitTrans() Then Exit Function
  
  Dim sqlstmt As String
  Dim rs      As Recordset
  sqlstmt = "sp_DocFacturaVentaSave " & register.id
  
  If Not gDB.SaveSp(sqlstmt, rs, DocGetTimeOut(m_NrosSerie), _
                "cIABMClient_Save", C_Module, c_ErrorSave) Then
    
    ' Si el error es por clave duplicada
    If CSKernelClient2.LastErrorNumber = -2147217900 Then
      If InStr(1, CSKernelClient2.LastErrorDescription, "IX_FacturaVentaNroDocEmpresa") Then
        pShowFacturaDuplicada
      End If
    End If
    Exit Function
  End If
  
  If rs.EOF Then Exit Function
  
  Dim id As Long
  If Not GetDocIDFromRecordset(rs, id) Then Exit Function
  
  m_Copy = False
  
  If Load(id) Then

    Dim AbmGen As cABMGeneric
    Set AbmGen = m_ObjAbm
    
    If bIsNew Then
    
      If m_UserCfg.NuevoAlGrabar Then
        AbmGen.PrintDocumento
      End If

                        If IsCobranzaContado(m_Id) Then
              ShowCobranzaContado m_cli_id, m_Id, m_Fecha, m_Total * Cotizacion, _
                                  m_suc_id, m_ccos_id, m_lgj_id
                        End If
    End If
  
    AbmGen.SendNewDoc = m_UserCfg.NuevoAlGrabar
    
    cIABMClient_Save = True
    
  Else
  
    cIABMClient_Save = False
    
  End If
End Function

Private Sub pShowFacturaDuplicada()
  Dim NroDoc    As String
  Dim sqlstmt   As String
  Dim rs        As ADODB.Recordset
  Dim msg       As String
  
  NroDoc = m_ObjAbm.Properties.Item(cscFvNrodoc).Value
  sqlstmt = "sp_DocFacturaVentaGetForNroDoc " & gDB.sqlString(NroDoc) & "," & EmpId
  
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Sub
  
  If Not rs.EOF Then
    With rs.fields
      msg = LNGGetText(1647, vbNullString, _
                      .Item(cscFvNrodoc).Value, _
                      .Item(cscCliNombre).Value, _
                      .Item(cscDocNombre).Value, _
                      .Item(cscFvFecha).Value)
      'La factura " & .Item(cscFvNrodoc).Value & " pertenece al cliente " & .Item(cscCliNombre).Value & " en el documento " & .Item(cscDocNombre).Value & " generada el " & .Item(cscFvFecha).Value
      
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
  
  m_ObjTree.sqlstmt = "sp_lsdoc_FacturaVenta"
  
  If m_IsNew Then
    m_ObjTree.AddLine m_Id
  Else
    m_ObjTree.RefreshLine m_Id
  End If
ControlError:
End Function

Private Property Get cIABMClient_Title() As String
  cIABMClient_Title = m_Title
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
        Case K_FECHAENTREGA
          If ValEmpty(.Value, csDate) Then
            MsgInfo LNGGetText(1564, vbNullString)  'Debe indicar una fecha de entrega
            Exit Function
          End If
        Case K_FECHAVTO
          If ValEmpty(.Value, csDate) And .Visible Then
            MsgInfo LNGGetText(1625, vbNullString)  'Debe indicar una fecha de vencimiento
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
        Case K_CPG_ID
          If ValEmpty(.HelpId, csId) Then
            MsgInfo LNGGetText(1561, vbNullString)  'Debe indicar una condición de pago
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
      End Select
    End With
  Next
  
  If Not pValidateCuentaMoneda() Then Exit Function
  
  If Not pValidateCuit(m_ObjAbm.Properties.Item(cscCliId).HelpId) Then Exit Function
  
  cIABMClient_Validate = True
End Function

Private Function pValidateCuit(ByVal CliId As Long) As Boolean
  On Error GoTo ControlError

  Dim sqlstmt  As String
  Dim rs       As Recordset
  Dim Cuit     As String
  
  If CliId <> csNO_ID Then
    
    sqlstmt = "select cli_catfiscal, cli_cuit from cliente where cli_id=" & CliId
  
    If Not gDB.OpenRs(sqlstmt, rs) Then Exit Function
    
    If Not rs.EOF Then
    
      Cuit = gDB.ValField(rs.fields, cscCliCuit)
    
      Select Case gDB.ValField(rs.fields, cscCliCatfiscal)
        Case csCatFConsumidorFinal, csCatFExento, csCatFExtranjero, csCatFNoCategorizado
        Case Else 'csCatFExtranjeroIva,csCatFMonoTributo, csCatFInscripto,
                  'csCatFNoInscripto, csCatFNoResponsableExento, csCatFInscriptoM
          If Trim(Cuit) = vbNullString Then
            MsgWarning LNGGetText(1627, vbNullString)
            'Para poder crear la factura debe dar de alta el CUIT del cliente
            Exit Function
          Else
            If Not ValidateNroCuit(Cuit, True) Then Exit Function
          End If
      End Select
    Else
      MsgWarning LNGGetText(1627, vbNullString)
                  'No se pudo obtener el Cuit del Cliente
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
  Dim MonIdCliente      As Long
  Dim MonIdDocumento    As Long
  
  If Not pGetCueIdCliente(MonIdCliente, 0) Then Exit Function
  If Not gDB.GetData(csTDocumento, cscDocId, m_LastDoc, cscMonId, MonIdDocumento) Then Exit Function
  
  If MonIdCliente <> MonIdDocumento Then
    MsgInfo LNGGetText(1629, vbNullString)
            'La cuenta asociada al Cliente y la cuenta del Documento tienen diferentes monedas
    Exit Function
  End If
  pValidateCuentaMoneda = True
End Function

Private Function cIABMClientGrid_IsEmptyRow(ByVal Key As Integer, Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  On Error GoTo ControlError

  Select Case Key
    Case K_ITEMS
      cIABMClientGrid_IsEmptyRow = pIsEmptyRow(Row, RowIndex)
  
    Case K_PERCEPCIONES
      cIABMClientGrid_IsEmptyRow = IsEmptyRowPercepciones(Row, RowIndex)
  
  End Select
  
  GoTo ExitProc
ControlError:
  MngError Err, "cIABMClientGrid_IsEmptyRow", C_Module, vbNullString
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
  
  sqlstmt = "select doct_id, doc_id from FacturaVenta where fv_id = " & id
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Function
  
  m_Id = id
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
  cIEditGeneric_ShowList = SecurityCanAccess(csPreSGRListFactura)
End Function

Private Property Set cIEditGeneric_ObjAbm(rhs As CSInterfacesABM.cIABMGeneric)
  Set m_ObjAbm = rhs
  m_ObjAbm.IsDocument = True

#If Not PREPROC_SFS Then
  Dim AbmGen      As cABMGenericDocEx

  Set AbmGen = m_ObjAbm
  With AbmGen
    .FactoryObject = "CSABMInterface2.cFactory"
    .ObjForm = "CSABMInterface2.fFacturaVenta"
  End With
#End If
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
                          csTFacturaVenta, _
                          cscFvId, _
                          doc_id) Then
      Exit Function
    End If
  End If
  
  If Not DocSecurityCanAccess( _
                  csPreSGRDeleteFactura, _
                  doc_id, _
                  csEDocTPreDelete) Then
    Exit Function
  End If

  Dim sqlstmt As String
  
  sqlstmt = "sp_DocFacturaVentaDelete " & id & "," & EmpId & "," & User.id
  
  cIEditGeneric_Delete = gDB.Execute(sqlstmt, "cIEditGeneric_Delete", C_Module)
End Function

Private Function cIEditGeneric_Search(id As Long, Cancela As Boolean) As Boolean

End Function

Private Function cIEditGeneric_Edit(id As Long, Optional ByVal InModalWindow As Boolean) As Boolean
  On Error GoTo ControlError
  
  If Not DocSecurityCanAccess(csPreSGRListFactura, _
                              GetdocIdFromObjAbm(m_ObjAbm), _
                              csEDocTPreList) Then Exit Function
                     
                            ' Id = csDocChanged esto significa que se cambio
                            '                   el documento estando en un
                            '                   comprobante ya guardado
                            '
  m_IsNew = id = csNO_ID Or id = csDocChanged

  If Not Load(id) Then Exit Function

  If m_ObjAbm.Properties.count = 0 Then
    If Not LoadCollection() Then Exit Function
  Else
    pRefreshProperties
  End If
  
  Dim AbmGen As cABMGeneric
  Set AbmGen = m_ObjAbm
  
  AbmGen.NewKeyPropFocus = cscCliId
  
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
      With pGetItems()
        
        Dim Row As cIABMGridRow
        Set Row = .Grid.Rows(lRow)
        
        pShowImporteAndIva Row
        pCalcularPercepciones
        pShowTotales
        cIABMClientGrid_ColumnAfterUpdate = True
      End With
  
    Case K_PERCEPCIONES
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

Private Function pProcessMultiRow(ByVal Info As Variant) As Boolean
  
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
              pAddMultiRows oCell.HelpValueProcess, Info
              pProcessMultiRow = True
            End If
          End If
        End If
      End With
  End Select
  
End Function

Private Sub pAddMultiRows(ByVal Ids As String, _
                          ByRef Info As Variant)
  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
    
  sqlstmt = "select pr_nombreventa, pr_id from Producto where pr_id in (" & Ids & ")"
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Sub
  
  While Not rs.EOF
  
    Info.NewId.Add gDB.ValField(rs.fields, cscPrId)
    Info.NewValue.Add gDB.ValField(rs.fields, cscPrNombreVenta)
    
    rs.MoveNext
  Wend
  
  ' No lo toquen, es mas 1 :( o explota todooo :P
  ' ups al final no era jeje
  '
  Info.iAddRows = Info.NewId.count '+ 1
End Sub

Private Function cIABMClientGrid_ColumnAfterEdit(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long, ByVal NewValue As Variant, ByVal NewValueID As Long) As Boolean
  On Error GoTo ControlError

  Select Case Key
    Case K_ITEMS
      cIABMClientGrid_ColumnAfterEdit = pColumnAfterEdit( _
                                            pGetItems(), _
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
      cIABMClientGrid_ColumnBeforeEdit = pColumnBeforeEdit( _
                                                  pGetItems(), _
                                                  lRow, _
                                                  lCol, _
                                                  iKeyAscii)
    Case K_PERCEPCIONES
      cIABMClientGrid_ColumnBeforeEdit = True
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
      pSetTasasImpositivas Row, NewValueID, NewValue
    
    Case KI_PRECIO_USR
      Set Row = IProperty.Grid.Rows(lRow)
      SetDescuento Row, _
                   pCell(Row, KI_PR_ID).id, _
                   NewValue, _
                   m_ObjAbm.Properties(cscFvDescuento1), _
                   KI_PRECIO, _
                   KI_DESCUENTO
      
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
  Dim id As Long
  
  Select Case Key
    Case K_ITEMS
      id = Val(pCell(Row, KI_FVI_ID).Value)
      If id <> csNO_ID Then m_ItemsDeleted = m_ItemsDeleted & id & ","
  
    Case K_PERCEPCIONES
      id = Val(pCell(Row, KIP_FVPERC_ID).Value)
      If id <> csNO_ID Then m_PercepcionesDeleted = m_PercepcionesDeleted & id & ","
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
    Case K_PERCEPCIONES
      cIABMClientGrid_ValidateRow = ValidateRowPercepciones(Row, RowIndex)
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
        If Not ValEmpty(Cell.id, csId) Then
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
  Dim Cantidad              As Double
  
  strRow = " (Fila " & RowIndex & ")"
  
  For Each Cell In Row
    Select Case Cell.Key
      
      Case KI_CANTIDAD
        Cantidad = Val(Cell.Value)
        If ValEmpty(Cell.Value, csCurrency) Then
          MsgInfo LNGGetText(1365, vbNullString, strRow)
                  'Debe indicar una cantidad (1)
          Exit Function
        End If
      
      Case KI_PRECIO
        If ValEmpty(Cell.Value, csCurrency) Then
          
          If Not Ask(LNGGetText(2538, vbNullString, strRow), vbYes) Then
                     'Confirma el precio cero para el item (1)
            MsgInfo LNGGetText(1667, vbNullString, strRow)
                    'Debe indicar un precio (1)
            Exit Function
          End If
        End If
      
      Case KI_PR_ID
        If ValEmpty(Cell.id, csId) Then
          MsgInfo LNGGetText(1565, vbNullString, strRow)
                  'Debe indicar un producto de venta (1)
          Exit Function
        End If
      
      ' TO
      Case KI_TO_ID
        If ValEmpty(Cell.id, csId) Then
          MsgInfo LNGGetText(1633, vbNullString, strRow)
                    'Debe indicar un Tipo de Operación (1)
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
  
  Set AbmGen = m_ObjAbm
  AbmGen.ResetLayoutMembers
  AbmGen.SendNewDoc = m_UserCfg.NuevoAlGrabar
  m_ObjAbm.Properties.Clear
  
  With m_ObjAbm.Tabs
    
    .Clear
    
    With .Add(Nothing)
      .Name = C_strGeneral
    End With
    
    With .Add(Nothing)
      .Index = 1
      .Name = LNGGetText(1566, vbNullString)  'Adicionales
    End With
  
  End With
  
  With m_ObjAbm.Properties
  
    With .Add(Nothing, cscDocId)
      .PropertyType = cspHelp
      .Table = CSDocumento2.CSDocumento
      .Name = LNGGetText(1567, vbNullString)  'Documento
      .Key = K_DOC_ID
      
      If m_doc_id <> csNO_ID Then
        .HelpId = m_doc_id
        .Value = m_Documento
      Else
        ' Preferencias del usuario
        '
        .HelpId = m_UserCfg.DocFvId
        .Value = m_UserCfg.DocFvNombre
        
        bValidateDocDefault = .HelpId <> csNO_ID
      End If
      
      .HelpFilter = pGetDocFilter
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
    
    With .Add(Nothing, cscFvFecha)
      .PropertyType = cspDate
      .Name = LNGGetText(1569, vbNullString)  'Fecha
      .LeftLabel = -580
      .Left = 700
      .Key = K_FECHA
      .Value = m_Fecha
    End With
        
    With .Add(Nothing, cscCliId)
      .PropertyType = cspHelp
      .Table = csCliente
      .TopFromProperty = cscFvFecha
      .Left = 2700
      .LeftLabel = -500
      .Name = LNGGetText(3705, vbNullString)  'Socio
      .Key = K_CLI_ID
      .HelpId = m_cli_id
      .Value = m_Cliente
      AbmGen.NewKeyPropFocus = cscCliId
    End With
    
    With .Add(Nothing, cscFvNrodoc)
      .PropertyType = cspText
      .Name = LNGGetText(1065, vbNullString)  'Número
      .Size = 50
      .Key = K_NRODOC
      .LeftLabel = -640
      .Value = m_Nrodoc
      .TextMask = m_TaMascara
      .TextAlign = vbRightJustify
    End With
    
    With .Add(Nothing, cscCpgId)
      .PropertyType = cspHelp
      .Table = csCondicionPago
      .Name = LNGGetText(1571, vbNullString)  'Cond. pago
      .TopFromProperty = cscFvFecha
      .Left = 5900
      .LeftLabel = -900
      .Key = K_CPG_ID
      .HelpId = m_cpg_id
      .Value = m_CondicionPago
    End With
    
    With .Add(Nothing, cscFvFechaVto)
      .PropertyType = cspDate
      .Name = LNGGetText(1634, vbNullString)  'Vto.
      .LeftLabel = -350
      .Key = K_FECHAVTO
      .Value = m_FechaVto
    End With
    
    With .Add(Nothing, cscFvCotizacion)
      .PropertyType = cspNumeric
      .SubType = cspMoney
      .LeftLabel = -800
      .Name = LNGGetText(1635, vbNullString)  'Cotización
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
                
    With .Add(Nothing, cscSucId)
      .PropertyType = cspHelp
      .Table = csSucursal
      .Name = LNGGetText(1281, vbNullString)  'Sucursal
      .Key = K_SUC_ID
      .HelpId = m_suc_id
      .Value = m_Sucursal
      .TopFromProperty = cscFvFecha
      .Left = 10000
      .LeftLabel = -750
    End With
    
    With .Add(Nothing, cscFvFechaentrega)
      .PropertyType = cspDate
      .Name = LNGGetText(3717, vbNullString)  'Entrega
      .Key = K_FECHAENTREGA
      .Value = m_Fechaentrega
      .LeftLabel = -1300
    End With
    
    With .Add(Nothing, cscFvFechaIva)
      .PropertyType = cspDate
      .Name = LNGGetText(3718, vbNullString)  'Fecha IVA
      .Key = K_FECHAIVA
      .Value = m_FechaIva
      .LeftLabel = -1150
    End With
    
    With .Add(Nothing, cscFvDescrip)
      .PropertyType = cspText
      .SubType = cspMemo
      .Name = LNGGetText(1211, vbNullString)  'Observ.
      .LeftLabel = -600
      .Size = 5000
      .Key = K_DESCRIP
      .Value = m_Descrip
      .LeftFromProperty = cscFvFecha
      .TopFromProperty = cscFvNrodoc
      .Width = 4300
      .Height = 800
      .TopToPrevious = 440
    End With
    
    With .Add(Nothing, cscLgjId)
      .PropertyType = cspHelp
      .Table = csLegajo
      .Left = 1500
      .Name = LNGGetText(1575, vbNullString)  'Legajo
      .Key = K_LGJ_ID
      .HelpId = m_lgj_id
      .Value = m_Legajo
      .TabIndex = 1
    End With
            
    With .Add(Nothing, cscFvOrdenCompra)
      .PropertyType = cspText
      .Name = LNGGetText(1924, vbNullString)    'Orden de Compra
      .Key = K_ORDENCOMPRA
      .Value = m_OrdenCompra
      .TabIndex = 1
    End With
    
    With .Add(Nothing, cscProIdOrigen)
      .PropertyType = cspHelp
      .Table = csProvincia
      .Name = LNGGetText(1577, vbNullString)  'Pcia. Origen
      .Key = K_PRO_ID_ORIGEN
      .HelpId = m_pro_id_origen
      .Value = m_ProOrigen
      .TabIndex = 1
    End With
    
    With .Add(Nothing, cscProIdDestino)
      .PropertyType = cspHelp
      .Table = csProvincia
      .Name = LNGGetText(1578, vbNullString)  'Pcia. Destino
      .Key = K_PRO_ID_DESTINO
      .HelpId = m_pro_id_destino
      .Value = m_ProDestino
      .TabIndex = 1
    End With
    
    With .Add(Nothing, cscFvCai)
      .PropertyType = cspText
      .Name = LNGGetText(1636, vbNullString)  'Cai
      .Key = K_CAI
      .Value = m_Cai
      .TabIndex = 1
    End With
    
    With .Add(Nothing, cscCcosId)
      .PropertyType = cspHelp
      .Table = csCentroCosto
      .Name = LNGGetText(1057, vbNullString)  'Centro de Costo
      .Key = K_CCOS_ID
      .HelpId = m_ccos_id
      .Value = m_CentroCosto
      .TabIndex = 1
    End With
  
    With .Add(Nothing, cscFvDescuento1)
      .PropertyType = cspNumeric
      .SubType = cspPercent
      .LeftLabel = -600
      .Name = LNGGetText(1573, vbNullString)  'Desc. 1
      .Key = K_DESCUENTO1
      .Value = m_Descuento1
      .Width = 1000
      .TabIndex = 1
    End With
    
    With .Add(Nothing, cscFvDescuento2)
      .PropertyType = cspNumeric
      .SubType = cspPercent
      .LeftLabel = -150
      .Name = "2"
      .Key = K_DESCUENTO2
      .Value = m_Descuento2
      .Width = 1000
      .TabIndex = 1
    End With
  
  End With
  
  If Not m_ObjAbm.Show(Me) Then Exit Function
  
  With m_Items.Tabs
    
    .Clear
  
    With .Add(Nothing)
      .Index = 0
      .Name = LNGGetText(1371, vbNullString)  'Items
    End With
    
    With .Add(Nothing)
      .Index = 1
      .Name = LNGGetText(1248, vbNullString)  'Percepciones
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
    
    Set c = .Add(Nothing, c_Percepciones)
    With c
      .PropertyType = cspGrid
      .LeftLabel = -1
      If Not pLoadPercepciones(c, Cotizacion) Then Exit Function
      .Name = c_Percepciones
      .Key = K_PERCEPCIONES
      .TabIndex = 1
      .GridAdd = True
      .GridEdit = True
      .GridRemove = True
    End With
    
    m_PercepcionesDeleted = vbNullString
    
  End With
  
  If Not m_Items.Show(Me) Then Exit Function
  
  Set AbmGen = m_Footer
  AbmGen.ResetLayoutMembers
  
  With m_Footer.Properties
    
    .Clear
  
    With .Add(Nothing, cscFvSubtotal)
      .PropertyType = cspNumeric
      .SubType = cspMoney
      .Name = LNGGetText(1579, vbNullString)  'Sub Total
      .Key = K_SUBTOTAL
      .Value = m_SubTotal
      .Format = m_GeneralConfig.FormatDecImporte
      .Enabled = False
    End With
    
    With .Add(Nothing, cscFvImportedesc1)
      .PropertyType = cspNumeric
      .SubType = cspMoney
      .Name = LNGGetText(1573, vbNullString)  'Desc. 1
      .Key = K_IMPORTEDESC1
      .Value = m_ImporteDesc1
      .Format = m_GeneralConfig.FormatDecImporte
      .Enabled = False
    End With
    
    With .Add(Nothing, cscFvImportedesc2)
      .PropertyType = cspNumeric
      .SubType = cspMoney
      .Name = LNGGetText(1580, vbNullString)  'Desc. 2
      .Key = K_IMPORTEDESC2
      .Value = m_ImporteDesc2
      .Format = m_GeneralConfig.FormatDecImporte
      .Enabled = False
    End With
    
    With .Add(Nothing, cscFvNeto)
      .PropertyType = cspNumeric
      .SubType = cspMoney
      .Name = LNGGetText(1581, vbNullString)  'Neto
      .Key = K_NETO
      .Value = m_Neto
      .Format = m_GeneralConfig.FormatDecImporte
      .Enabled = False
    End With
    
    With .Add(Nothing, cscFvIvari)
      .PropertyType = cspNumeric
      .Name = LNGGetText(1582, vbNullString)  'IVA RI
      .SubType = cspMoney
      .Key = K_IVARI
      .Value = m_Ivari
      .Format = m_GeneralConfig.FormatDecImporte
      .Enabled = False
    End With
    
    With .Add(Nothing, cscFvIvarni)
      .PropertyType = cspNumeric
      .Name = LNGGetText(1583, vbNullString)  'IVA RNI
      .SubType = cspMoney
      .Key = K_IVARNI
      .Value = m_Ivarni
      .Format = m_GeneralConfig.FormatDecImporte
      .Enabled = False
    End With
    
    With .Add(Nothing, cscFvTotalPercepciones)
      .PropertyType = cspNumeric
      .Format = m_GeneralConfig.FormatDecImporte
      .Name = LNGGetText(1248, vbNullString)  'Percepciones
      .SubType = cspMoney
      .Key = K_TOTAPERCEPCIONES
      .Value = m_TotalPercepciones
      .Enabled = False
    End With
    
    With .Add(Nothing, cscFvTotal)
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
  
  ' Preferencias del Usuario
  '
  If bValidateDocDefault Then
    cIABMClient_PropertyChange K_DOC_ID
  End If
  
  pShowCotizacion
  pShowFechaVto
  
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
  
  Set iProp = m_ObjAbm.Properties.Item(cscFvCotizacion)
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
    
    Set iProp = m_ObjAbm.Properties.Item(cscFvFechaVto)
    iProp.Visible = bEsLibre
    m_ObjAbm.ShowValue iProp
  End If
End Sub

Private Function pGetCondicionPago() As cIABMProperty
  Set pGetCondicionPago = m_ObjAbm.Properties.Item(cscCpgId)
End Function

Private Function pLoadItems(ByRef Propiedad As cIABMProperty, ByVal Cotizacion As Double) As Boolean
  Dim sqlstmt As String
  Dim PrId    As Long
  Dim oCol    As cABMGridColumn
  Dim iCol    As cIABMGridColumn
  Dim rs      As ADODB.Recordset
  
  sqlstmt = "sp_DocFacturaVentaGetItems " & m_Id
  
  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, "pLoadItems", C_Module) Then Exit Function
  
  With Propiedad.Grid
  
    .Columns.Clear
    .Rows.Clear
    
    With .Columns
  
      With .Add(Nothing)
        .Visible = False
        .Key = KI_FVI_ID
      End With
      
      Set iCol = .Add(Nothing)
      Set oCol = iCol
      With iCol
        .Name = LNGGetText(1367, vbNullString)  'Articulo
        .PropertyType = cspHelp
        .Table = csProductoVenta
        .Width = 1800
        .Key = KI_PR_ID
      End With
      If m_UserCfg.MultiSelect Then
        oCol.HelpType = csMultiSelect
      End If
      Set iCol = Nothing
      Set oCol = Nothing
      
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
        .Name = C_strDescrip
        .PropertyType = cspText
        .SubType = cspTextButtonEx
        .Width = 1200
        .Key = KI_DESCRIP
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(1374, vbNullString)  'Cantidad
        .Format = m_GeneralConfig.FormatDecCantidad
        .PropertyType = cspNumeric
        .SubType = cspDouble
        .Width = 1200
        .Key = KI_CANTIDAD
      
        Set .DefaultValue = New cABMGridRowValue
        .DefaultValue.Value = 1
      End With
            
      With .Add(Nothing)
        .Name = LNGGetText(1585, vbNullString)  'Descuento
        .PropertyType = cspNumeric
        .Format = m_GeneralConfig.FormatDecImporte
        .SubType = cspMoney
        .Width = 1200
        .Key = KI_DESCUENTO
        .Visible = False
        .Enabled = False
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(1165, vbNullString)  'Unidad
        .PropertyType = cspText
        .Width = 1200
        .Key = KI_UNIDAD
        .Visible = False
        .Enabled = False
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(1587, vbNullString)  'Precio (LP)
        .PropertyType = cspNumeric
        .SubType = cspMoney
        .Format = m_GeneralConfig.FormatDecImporte
        .Width = 1200
        .Key = KI_PRECIO_LP
        .Visible = False
        .Enabled = False
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(1586, vbNullString)  'Precio
        .PropertyType = cspNumeric
        .SubType = cspMoney
        .Width = 1200
        .Format = m_GeneralConfig.FormatDecImporte
        .Key = KI_PRECIO_USR
        .Enabled = SecurityCanAccessSilent(csPreVtaEditPriceFac)
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(1588, vbNullString)  'Precio c/desc.
        .PropertyType = cspNumeric
        .SubType = cspMoney
        .Width = 1200
        .Format = m_GeneralConfig.FormatDecImporte
        .Key = KI_PRECIO
        .Visible = False
        .Enabled = False
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(1581, vbNullString)  'Neto
        .PropertyType = cspNumeric
        .SubType = cspMoney
        .Format = m_GeneralConfig.FormatDecImporte
        .Width = 1200
        .Key = KI_NETO
        .Enabled = False
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(1582, vbNullString)  'IVA RI
        .PropertyType = cspNumeric
        .SubType = cspMoney
        .Format = m_GeneralConfig.FormatDecImporte
        .Width = 1200
        .Key = KI_IVARI
        .Enabled = False
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(1583, vbNullString)  'IVA RNI
        .PropertyType = cspNumeric
        .Format = m_GeneralConfig.FormatDecImporte
        .SubType = cspMoney
        .Width = 1200
        .Key = KI_IVARNI
        .Visible = False
        .Enabled = False
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(1228, vbNullString)  'Importe
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
        .Name = LNGGetText(1057, vbNullString)  'Centro de Costo
        .PropertyType = cspHelp
        .Table = csCentroCosto
        .Width = 1800
        .Key = KI_CCOS_ID
      End With
      
      ' TO
      With .Add(Nothing)
        .Name = LNGGetText(1492, vbNullString)  'Tipo Operación
        .PropertyType = cspHelp
        .Table = csTipoOperacion
        .Width = 1800
        Set .DefaultValue = New cABMGridRowValue
        With .DefaultValue
          .id = C_TO_ComercialId
          .Value = C_TO_Comercial
        End With
        .Key = KI_TO_ID
      End With
          
    End With
  
    With .Rows
    
      While Not rs.EOF
      
        With .Add(Nothing, rs(cscFviId).Value)
        
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscFviId)
            .Key = KI_FVI_ID
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscPrNombreVenta)
            .id = gDB.ValField(rs.fields, cscPrId)
            .Key = KI_PR_ID
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscCueId)
            .Key = KI_CUE_ID
          End With
          
          With .Add(Nothing)
            If m_bIva Then
              .Value = gDB.ValField(rs.fields, cscCueIdIvaRI)
            Else
              .Value = csNO_ID
            End If
            .Key = KI_CUE_ID_IVARI
          End With
          
          With .Add(Nothing)
            If m_bIvaRni Then
              .Value = gDB.ValField(rs.fields, cscCueIdIvaRNI)
            Else
              .Value = csNO_ID
            End If
            .Key = KI_CUE_ID_IVARNI
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscFviDescrip)
            .Key = KI_DESCRIP
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscFviCantidad)
            .Key = KI_CANTIDAD
          End With
                    
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscFviDescuento)
            .Key = KI_DESCUENTO
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscUnNombre)
            .Key = KI_UNIDAD
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscFviPrecioLista) / Cotizacion
            .Key = KI_PRECIO_LP
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscFviPrecioUsr) / Cotizacion
            .Key = KI_PRECIO_USR
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscFviPrecio) / Cotizacion
            .Key = KI_PRECIO
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscFviNeto) / Cotizacion
            .Key = KI_NETO
          End With
      
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscFviIvari) / Cotizacion
            .Key = KI_IVARI
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscFviIvarni) / Cotizacion
            .Key = KI_IVARNI
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscFviImporte) / Cotizacion
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
            .id = gDB.ValField(rs.fields, cscCcosId)
            .Key = KI_CCOS_ID
          End With
          
          ' TO
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscToNombre)
            .id = gDB.ValField(rs.fields, cscToId)
            .Key = KI_TO_ID
          End With
                    
        End With
        
        rs.MoveNext
      Wend
    End With
  End With
  
  pLoadItems = True
End Function

Private Function Load(ByVal id As Long) As Boolean
  Dim Cotizacion  As Double
  Dim sqlstmt     As String

  sqlstmt = "sp_DocFacturaVentaGet " & EmpId & "," & id & "," & gDB.UserId
  
  Dim rs As Recordset

  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, C_LoadFunction, C_Module) Then Exit Function

  If Not rs.EOF Then

    m_Cotizacion = gDB.ValField(rs.fields, cscFvCotizacion)
    Cotizacion = IIf(m_Cotizacion <> 0, m_Cotizacion, 1)

    m_Id = gDB.ValField(rs.fields, cscFvId)
    m_Numero = gDB.ValField(rs.fields, cscFvNumero)
    m_Nrodoc = gDB.ValField(rs.fields, cscFvNrodoc)
    m_Descrip = gDB.ValField(rs.fields, cscFvDescrip)
    m_Fecha = gDB.ValField(rs.fields, cscFvFecha)
    m_Fechaentrega = gDB.ValField(rs.fields, cscFvFechaentrega)
    m_FechaVto = gDB.ValField(rs.fields, cscFvFechaVto)
    m_FechaIva = gDB.ValField(rs.fields, cscFvFechaIva)
    m_Neto = gDB.ValField(rs.fields, cscFvNeto) / Cotizacion
    m_Ivari = gDB.ValField(rs.fields, cscFvIvari) / Cotizacion
    m_Ivarni = gDB.ValField(rs.fields, cscFvIvarni) / Cotizacion
    m_Total = gDB.ValField(rs.fields, cscFvTotal) / Cotizacion
    m_TotalPercepciones = gDB.ValField(rs.fields, cscFvTotalPercepciones) / Cotizacion
    m_SubTotal = gDB.ValField(rs.fields, cscFvSubtotal) / Cotizacion
    m_Descuento1 = gDB.ValField(rs.fields, cscFvDescuento1)
    m_Descuento2 = gDB.ValField(rs.fields, cscFvDescuento2)
    m_ImporteDesc1 = gDB.ValField(rs.fields, cscFvImportedesc1) / Cotizacion
    m_ImporteDesc2 = gDB.ValField(rs.fields, cscFvImportedesc2) / Cotizacion
    m_cli_id = gDB.ValField(rs.fields, cscCliId)
    m_Cliente = gDB.ValField(rs.fields, cscCliNombre)
    m_ccos_id = gDB.ValField(rs.fields, cscCcosId)
    m_CentroCosto = gDB.ValField(rs.fields, cscCcosNombre)
    m_suc_id = gDB.ValField(rs.fields, cscSucId)
    m_Sucursal = gDB.ValField(rs.fields, cscSucNombre)
    m_doc_id = gDB.ValField(rs.fields, cscDocId)
    m_Documento = gDB.ValField(rs.fields, cscDocNombre)
    m_Doct_id = gDB.ValField(rs.fields, cscDoctId)
    m_cpg_id = gDB.ValField(rs.fields, cscCpgId)
    m_CondicionPago = gDB.ValField(rs.fields, cscCpgNombre)
    m_lgj_id = gDB.ValField(rs.fields, cscLgjId)
    m_Legajo = gDB.ValField(rs.fields, cscLgjCodigo)
    m_Cai = gDB.ValField(rs.fields, cscFvCai)
    m_OrdenCompra = gDB.ValField(rs.fields, cscFvOrdenCompra)
    m_pro_id_origen = gDB.ValField(rs.fields, cscProIdOrigen)
    m_ProOrigen = gDB.ValField(rs.fields, "ProOrigen")
    m_pro_id_destino = gDB.ValField(rs.fields, cscProIdDestino)
    m_ProDestino = gDB.ValField(rs.fields, "ProDestino")
    m_Creado = gDB.ValField(rs.fields, cscCreado)
    m_Modificado = gDB.ValField(rs.fields, cscModificado)
    m_Modifico = gDB.ValField(rs.fields, cscModifico)
    m_est_id = gDB.ValField(rs.fields, cscEstId)
    m_Estado = gDB.ValField(rs.fields, cscEstNombre)
    m_Firmado = gDB.ValField(rs.fields, cscFvFirmado)
    m_mon_id = gDB.ValField(rs.fields, cscMonId)
      
    m_doc_sin_perc = gDB.ValField(rs.fields, cscDocFvSinPercepcion)
    
    m_DocEditable = gDB.ValField(rs.fields, cscDocEditable)
    m_DocEditMsg = gDB.ValField(rs.fields, cscDoceditMsg)
        
    ' Para ver documentos auxiliares
    '
    m_as_id = gDB.ValField(rs.fields, cscAsId)
    
    m_bIva = gDB.ValField(rs.fields, cscbIvaRi)
    m_bIvaRni = gDB.ValField(rs.fields, cscbIvaRni)

    m_TaPropuesto = gDB.ValField(rs.fields, cscTa_Propuesto)
    m_TaMascara = gDB.ValField(rs.fields, cscTa_Mascara)
    
    m_LastDoc = m_doc_id
    m_LastDoctId = m_Doct_id ' nrs devolucion
    m_LastCli = m_cli_id
    m_LastDocName = m_Documento
    m_LastCliName = m_Cliente
    
    m_lastMonIdCotizacion = m_mon_id
    m_lastFecha = m_Fecha
    
    ' Percepciones
    LoadPercepcionesForCliente m_LastCli, m_vPercepciones(), m_ObjAbm.Properties(cscFvFecha).Value
    
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
    m_TotalPercepciones = 0
    m_SubTotal = 0
    m_Descuento1 = 0
    m_Descuento2 = 0
    m_ImporteDesc1 = 0
    m_ImporteDesc2 = 0
    m_cli_id = csNO_ID
    m_Cliente = vbNullString
    m_ccos_id = csNO_ID
    m_CentroCosto = vbNullString
    m_doc_id = csNO_ID
    m_Documento = vbNullString
    m_Doct_id = csNO_ID
    m_cpg_id = csNO_ID
    m_Cai = vbNullString
    m_OrdenCompra = vbNullString
    m_lgj_id = csNO_ID
    m_Legajo = vbNullString
    m_pro_id_origen = csNO_ID
    m_ProOrigen = vbNullString
    m_pro_id_destino = csNO_ID
    m_ProDestino = vbNullString
    m_CondicionPago = vbNullString
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
      
    m_doc_sin_perc = False
        
    ' Para ver documentos auxiliares
    '
    m_as_id = csNO_ID
    
    m_doc_id = m_LastDoc
    m_Doct_id = m_LastDoctId ' nrs devolucion
    m_cli_id = m_LastCli
    m_Cliente = m_LastCliName
    m_Documento = m_LastDocName
  
    m_TaPropuesto = False
    m_TaMascara = vbNullString
  
    m_bIvaRni = False
    m_bIva = False
    
    m_lastMonIdCotizacion = csNO_ID
    m_lastFecha = csNoDate

    ' Cotizacion
    If m_doc_id <> csNO_ID Then
      m_Cotizacion = DocGetCotizacion(m_doc_id, m_Fecha)
    End If
  
    DocEditableGet m_doc_id, m_DocEditable, m_DocEditMsg, csPreSGRNewFactura
  
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
  
  '-------------------------------
  
  Dim str_3700 As String
  str_3700 = LNGGetText(3700, vbNullString) '&Avales
  
  m_Host.Server.AddMenu str_3700, csMenuEnum.csAvales, vbNullString, 1, False, False, False, True, False, Nothing
  
  m_Host.Server.AddMenu LNGGetText(3702, vbNullString), csPreSGRListFacturaAvalCredito, str_3700, 0, True, False, False, False, False, Me
                          '&Avales sobre Creditos Bancarios
  m_Host.Server.AddMenu LNGGetText(3703, vbNullString), csPreSGRListFacturaAvalCheque, str_3700, 0, True, False, False, False, False, Me
                          '&Venta de Cheques en Bolsa de Comercio
  m_Host.Server.AddMenu LNGGetText(3708, vbNullString), csPreSGRListFacturaAvalOrdenCompra, str_3700, 0, True, False, False, False, False, Me
                          '&Avales sobre Creditos Bancarios con Vto. Libre
  
  '-------------------------------
  
  Dim str_3701 As String
  str_3701 = LNGGetText(3701, vbNullString) '&Acciones
  
  m_Host.Server.AddMenu str_3701, csMenuEnum.csAcciones, vbNullString, 1, False, False, False, True, False, Nothing
  m_Host.Server.AddMenu LNGGetText(3714, vbNullString), csPreSGRListFacturaAccionParticipe, str_3701, 0, True, False, False, False, False, Me
                          '&Venta de Acciones
  m_Host.Server.AddMenu LNGGetText(3712, vbNullString), csPreSGRListFacturaAccionProtector, str_3701, 0, True, False, False, False, False, Me
                          '&Venta de Acciones
  
  cIMenuClient_Initialize = True
  
  GoTo ExitProc
ControlError:
  MngError Err, "cIMenuClient_Initialize", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Private Function cIMenuClient_ProcessMenu(ByVal id As Long) As Variant
#If PREPROC_SFS Then
  
  If id = csPreSGRListFacturaAvalCredito Then
  
    m_Host.MenuListDocClick "CSABMInterface2.CABMGeneric", _
                            "CSSGR.cFacturaVentaSGR_@aux_Credito", _
                            "CSABMInterface2.CABMGenericListDoc", _
                            "CSSGR.cFacturaVentaSGRListDoc", _
                            Me, _
                            LNGGetText(3709, vbNullString), 0
  
  ElseIf id = csPreSGRListFacturaAccionParticipe Then
  
    m_Host.MenuListDocClick "CSABMInterface2.CABMGeneric", _
                            "CSSGR.cFacturaVentaSGR_@aux_AccionParticipe", _
                            "CSABMInterface2.CABMGenericListDoc", _
                            "CSSGR.cFacturaVentaSGRListDoc", _
                            Me, _
                            LNGGetText(3714, vbNullString), 0
    
  ElseIf id = csPreSGRListFacturaAccionProtector Then
  
    m_Host.MenuListDocClick "CSABMInterface2.CABMGeneric", _
                            "CSSGR.cFacturaVentaSGR_@aux_AccionProtector", _
                            "CSABMInterface2.CABMGenericListDoc", _
                            "CSSGR.cFacturaVentaSGRListDoc", _
                            Me, _
                            LNGGetText(3712, vbNullString), 0
    
  ElseIf id = csPreSGRListFacturaAvalCheque Then
  
    m_Host.MenuListDocClick "CSABMInterface2.CABMGeneric", _
                            "CSSGR.cFacturaVentaSGR_@aux_Cheque", _
                            "CSABMInterface2.CABMGenericListDoc", _
                            "CSSGR.cFacturaVentaSGRListDoc", _
                            Me, _
                            LNGGetText(3710, vbNullString), 0
  
  ElseIf id = csPreSGRListFacturaAvalOrdenCompra Then
  
    m_Host.MenuListDocClick "CSABMInterface2.CABMGeneric", _
                            "CSSGR.cFacturaVentaSGR_@aux_OrdenCompra", _
                            "CSABMInterface2.CABMGenericListDoc", _
                            "CSSGR.cFacturaVentaSGRListDoc", _
                            Me, _
                            LNGGetText(3711, vbNullString), 0
  
  End If
                                                                                                                                                            'Facturas de Venta
#Else
  m_Host.MenuListDocClick "CSABMInterface2.CABMGenericDocEx", "CSSGR.cFacturaVentaSGR", "CSABMInterface2.CABMGenericListDoc", "CSSGR.cFacturaVentaSGRListDoc", Me, LNGGetText(1624, vbNullString), 0
#End If
End Function

Private Function pSaveItems(ByVal id As Long, ByVal Cotizacion As Double, ByVal bMonedaLegal As Boolean) As Boolean
  Dim register  As cRegister
  Dim iOrden    As Long
  Dim Origen    As Double
  Dim Neto      As Double
  Dim IvaRi     As Double
  Dim IvaRni    As Double
          
  Dim Row  As cIABMGridRow
  Dim Cell As cIABMGridCellValue
  
  For Each Row In m_Items.Properties(c_Items).Grid.Rows
  
    Set register = New cRegister
    register.fieldId = cscFviTMPId
    register.Table = csTFacturaVentaItemTMP
    register.id = csNew
    
    For Each Cell In Row
      Select Case Cell.Key
        
        Case KI_FVI_ID
          If m_Copy Then
            register.fields.Add2 cscFviId, csNew, csInteger
          Else
            register.fields.Add2 cscFviId, Val(Cell.Value), csInteger
          End If
        Case KI_CANTIDAD
          register.fields.Add2 cscFviCantidad, Cell.Value, csDouble
        Case KI_DESCRIP
          register.fields.Add2 cscFviDescrip, Cell.Value, csText
        Case KI_PRECIO
          register.fields.Add2 cscFviPrecio, Val(Cell.Value) * Cotizacion, csCurrency
        Case KI_PRECIO_LP
          register.fields.Add2 cscFviPrecioLista, Val(Cell.Value) * Cotizacion, csCurrency
        Case KI_PRECIO_USR
          register.fields.Add2 cscFviPrecioUsr, Val(Cell.Value) * Cotizacion, csCurrency
        Case KI_NETO
          Neto = Val(Cell.Value)
          register.fields.Add2 cscFviNeto, Neto * Cotizacion, csCurrency
        Case KI_IVARI
          ' Por seguridad
          If m_bIva Then
            IvaRi = Val(Cell.Value)
            register.fields.Add2 cscFviIvari, IvaRi * Cotizacion, csCurrency
          End If
        Case KI_IVARNI
          ' Por seguridad
          If m_bIvaRni Then
            IvaRni = Val(Cell.Value)
            register.fields.Add2 cscFviIvarni, IvaRni * Cotizacion, csCurrency
          End If
        Case KI_IVARIPercent
          register.fields.Add2 cscFviIvariporc, Cell.Value, csDouble
        Case KI_IVARNIPercent
          register.fields.Add2 cscFviIvarniporc, Cell.Value, csDouble
        Case KI_PR_ID
          register.fields.Add2 cscPrId, Cell.id, csId
        Case KI_CCOS_ID
          register.fields.Add2 cscCcosId, Cell.id, csId
        ' TO
        Case KI_TO_ID
          register.fields.Add2 cscToId, Cell.id, csId
        Case KI_CUE_ID
          register.fields.Add2 cscCueId, Val(Cell.Value), csId
        Case KI_CUE_ID_IVARI
          register.fields.Add2 cscCueIdIvaRI, Val(Cell.Value), csId
        Case KI_CUE_ID_IVARNI
          register.fields.Add2 cscCueIdIvaRNI, Val(Cell.Value), csId
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
    
    register.fields.Add2 cscFviImporte, Origen * Cotizacion, csCurrency
    If bMonedaLegal Then
      register.fields.Add2 cscFviImporteOrigen, 0, csCurrency
    Else
      register.fields.Add2 cscFviImporteOrigen, Origen, csCurrency
    End If
    
    iOrden = iOrden + 1
    register.fields.Add2 cscFviOrden, iOrden, csInteger
    register.fields.Add2 cscFvTMPId, id, csId
    
    register.fields.HaveLastUpdate = False
    register.fields.HaveWhoModify = False
    
    If Not gDB.Save(register, , "pSaveItems", C_Module, c_ErrorSave) Then Exit Function
  
  Next
  
  Dim sqlstmt As String
  
  If m_ItemsDeleted <> vbNullString And m_Id <> csNO_ID Then
  
    Dim vDeletes As Variant
    Dim i As Long
    
    m_ItemsDeleted = RemoveLastColon(m_ItemsDeleted)
    vDeletes = Split(m_ItemsDeleted, ",")
    
    For i = 0 To UBound(vDeletes)
    
      Set register = New cRegister
      register.fieldId = cscFvibTMPId
      register.Table = csTFacturaVentaItemBorradoTMP
      register.id = csNew
      
      register.fields.Add2 cscFviId, Val(vDeletes(i)), csInteger
      register.fields.Add2 cscFvId, m_Id, csId
      register.fields.Add2 cscFvTMPId, id, csId
      
      register.fields.HaveLastUpdate = False
      register.fields.HaveWhoModify = False
      
      If Not gDB.Save(register, , "pSaveItems", C_Module, c_ErrorSave) Then Exit Function
    Next
    
  End If
  
  pSaveItems = True
End Function

' Reglas del Objeto de Negocios
Private Function pDocAsistTipo() As csETipoFactura
  Dim Doc     As cDocumento
  Dim rtn     As Boolean
  Dim DocId   As Long
  
  ' Si todavia no se cargo el form no se que
  ' documento es, asi que no puede ser sobre pedido
  If m_ObjAbm.Properties.Item(cscDocId) Is Nothing Then Exit Function
  
  DocId = m_ObjAbm.Properties.Item(cscDocId).HelpId
  
  ' Si no hay un documento activo no se hace nada
  If DocId = csNO_ID Then Exit Function
  
  Set Doc = New cDocumento
  
  pDocAsistTipo = Doc.GetData(DocId, cscDocTipoFactura, csInteger)
End Function

Private Function pDocDesdePedido() As Boolean
  pDocDesdePedido = pDocAsistTipo = csETFacPedido
End Function

Private Function pDocDesdePacking() As Boolean
  pDocDesdePacking = pDocAsistTipo = csETFacPackingList
End Function

Private Function pDocDesdeRemito() As Boolean
  pDocDesdeRemito = pDocAsistTipo = csETFacRemito
End Function

Private Function pDocDesdeProyecto() As Boolean
  pDocDesdeProyecto = pDocAsistTipo = csETFacProyecto
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
  
Private Sub pShowTotales()
  Dim Rows       As CSInterfacesABM.cIABMGridRows
  Dim RowsPercep As CSInterfacesABM.cIABMGridRows
  
  Dim Neto      As Double
  Dim IvaRi     As Double
  Dim IvaRni    As Double
  Dim Desc1     As Double
  Dim Desc2     As Double
  Dim Percep    As Double
  Dim Row       As CSInterfacesABM.cIABMGridRow
  
  Set Rows = GetItems(m_Items, c_Items).Grid.Rows
  Set RowsPercep = m_Items.Properties(c_Percepciones).Grid.Rows

  For Each Row In Rows
    Neto = Neto + Val(pCell(Row, KI_NETO).Value)
    IvaRi = IvaRi + Val(pCell(Row, KI_IVARI).Value)
    IvaRni = IvaRni + Val(pCell(Row, KI_IVARNI).Value)
  Next
  
  For Each Row In RowsPercep
    Percep = Percep + Val(pCell(Row, KIP_IMPORTE).Value)
  Next
  
  With m_Footer.Properties
    .Item(cscFvSubtotal).Value = Neto
  
    Desc1 = m_ObjAbm.Properties(cscFvDescuento1).Value
    Desc2 = m_ObjAbm.Properties(cscFvDescuento2).Value
    
    IvaRi = IvaRi - (IvaRi * Desc1 / 100)
    IvaRni = IvaRni - (IvaRni * Desc1 / 100)
    
    IvaRi = IvaRi - (IvaRi * Desc2 / 100)
    IvaRni = IvaRni - (IvaRni * Desc2 / 100)
    
    Desc1 = Neto * Desc1 / 100
    .Item(cscFvImportedesc1).Value = Desc1
    
    Neto = Neto - Desc1
    
    Desc2 = Neto * Desc2 / 100
    .Item(cscFvImportedesc2).Value = Desc2
    
    Neto = Neto - Desc2
    
    .Item(cscFvNeto).Value = Neto
    .Item(cscFvIvari).Value = IvaRi
    .Item(cscFvIvarni).Value = IvaRni
    .Item(cscFvTotalPercepciones).Value = Percep
    .Item(cscFvTotal).Value = Neto + IvaRni + IvaRi + Percep
  End With
  
  m_Footer.RefreshControls
End Sub

Private Sub pSetTasasImpositivas(ByRef Row As CSInterfacesABM.cIABMGridRow, ByVal pr_id As Long, ByVal pr_nombre As String)
  Dim ti_ri    As Long
  Dim ti_rni   As Long
  
  If pr_id = 0 Then Exit Sub
  
  If Not GetTasaFromProducto(pr_id, ti_ri, ti_rni, False) Then Exit Sub
  
  If ti_ri = 0 Then
    MsgWarning LNGGetText(1597, vbNullString, pr_nombre)
    'El producto [" & pr_nombre & "] no tiene definida su tasa impositiva de ventas para el iva responsable inscripto"
    Exit Sub
  End If
  
  If ti_rni = 0 Then
    MsgWarning LNGGetText(1598, vbNullString, pr_nombre)
    'El producto [" & pr_nombre & "] no tiene definida su tasa impositiva de ventas para el iva responsable no inscripto
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

' Reglas del Objeto de Negocios
Private Sub pSetDataProducto(ByRef Row As CSInterfacesABM.cIABMGridRow, _
                             ByVal pr_id As Long)
  Dim sqlstmt As String
  Dim rs      As Recordset
  
  Dim bChanged As Boolean
  
  bChanged = pr_id <> pCell(Row, KI_PR_ID).id
  
  sqlstmt = "sp_StockProductoGetData " & pr_id & "," & pGetCliId() & ",Null"
  
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Sub
  
  If Not rs.EOF Then

    pCell(Row, KI_UNIDAD).Value = gDB.ValField(rs.fields, "unidadVenta")
    pCell(Row, KI_CUE_ID).Value = gDB.ValField(rs.fields, cscCueidventa)
  
  End If

End Sub

Private Sub pSetEnabled()
  Dim bState As Boolean
  
  ' Si se genera desde un pedido y es nuevo
  ' no puede editar, tiene que hacer click en
  ' nuevo y llamar al asistente
  If pDocDesdePedido And m_Id = csNO_ID Then
    bState = False
  ElseIf pDocDesdeRemito And m_Id = csNO_ID Then
    bState = False
  ElseIf pDocDesdePacking And m_Id = csNO_ID Then
    bState = False
  ElseIf m_DocEditable Then
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
        If Prop.Key = K_NRODOC Then
          Prop.Enabled = m_TaPropuesto
        Else
          Prop.Enabled = bState
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

Private Function pSetDatosCliente() As Boolean
  Dim lp_id         As Long
  Dim ld_id         As Long
  
  Dim cpg_id        As Long
  Dim cpg_nombre    As String
  
  Dim trans_id      As Long
  Dim pro_id        As Long
  Dim ven_id        As Long
  
  Dim trans_nombre      As String
  Dim pro_nombre        As String
  Dim ven_nombre        As String
  
  Dim LP            As cListaPrecio
  Dim LD            As cListaDescuento
  Dim iProp         As cIABMProperty
  Dim Filter        As String
  Dim bClientChange As Boolean
  
  With m_ObjAbm.Properties.Item(cscCliId)
    If m_LastCli = .HelpId Then
      Exit Function
    End If
    bClientChange = True
    m_LastCli = .HelpId
  End With

  ' Esto va aca
  pSetDatosCliente = bClientChange

  If Not GetClienteDataEx2(m_LastCli, _
                          lp_id, _
                          ld_id, _
                          cpg_id, _
                          trans_id, pro_id, ven_id, _
                          trans_nombre, pro_nombre, ven_nombre, _
                          m_LastDoc) Then Exit Function
  
  ' Condicion de pago
  If cpg_id <> csNO_ID Then
    
    If Not gDB.GetData(csTCondicionPago, cscCpgId, cpg_id, cscCpgNombre, cpg_nombre) Then Exit Function
    
    Set iProp = m_ObjAbm.Properties.Item(cscCpgId)
    iProp.Value = cpg_nombre
    iProp.HelpId = cpg_id
    m_ObjAbm.ShowValue iProp
  End If
      
'////////////////////////////////////////////////////////////
  If pro_id <> csNO_ID Then
    Set iProp = m_ObjAbm.Properties.Item(cscProIdDestino)
    With iProp
      .Value = pro_nombre
      .HelpId = pro_id
    End With
    m_ObjAbm.ShowValue iProp
  End If
  
'////////////////////////////////////////////////////////////
  
  ' Talonario y Categoria fiscal
  pGetIvaFromCliente m_LastCli
  
  pShowFechaVto

'////////////////////////////////////////////////////////////

  ' Percepciones
  LoadPercepcionesForCliente m_LastCli, m_vPercepciones(), m_ObjAbm.Properties(cscFvFecha).Value
  
End Function

Private Sub pGetIvaFromCliente(ByVal cli_id As Long)
  Dim sqlstmt        As String
  Dim rs             As ADODB.Recordset
  Dim bIvaChanged    As Boolean
  Dim bLastIva       As Boolean
  Dim LastCatFiscal  As Long
  
  sqlstmt = "sp_clienteGetIva " & cli_id
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Sub
  
  If rs.EOF Then Exit Sub
  
  LastCatFiscal = m_CatFiscal
  m_CatFiscal = gDB.ValField(rs.fields, cscCliCatfiscal)
  m_bCatFiscalChanged = LastCatFiscal <> m_CatFiscal
  
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

Private Function pGetCueIdCliente(ByRef Mon_id As Long, ByRef Cue_id As Long) As Boolean
  Dim sqlstmt As String
  Dim rs      As Recordset
  
  ' Cuenta contable del cliente
  sqlstmt = "sp_DocGetCueId " & m_LastCli & "," & m_LastDoc
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Function

  If rs.EOF Then Exit Function

  Cue_id = gDB.ValField(rs.fields, cscCueId)
  Mon_id = gDB.ValField(rs.fields, cscMonId)
  
  pGetCueIdCliente = True
End Function

Private Function pFirmar() As Boolean
  Dim Doc     As cDocumento
  Dim us_id   As Long
  
  Set Doc = New cDocumento
  
  If m_Id = csNO_ID Then
    MsgWarning LNGGetText(1592, vbNullString)
              'Antes de poder firmar el documento debe guardarlo
    Exit Function
  End If
  
  If m_Firmado Then
    'If Not Ask("El documento ya ha sido firmado desea borrar la firma", vbYes, "Firmar") Then
    If Not Ask(LNGGetText(1593, vbNullString), vbYes, LNGGetText(1594, vbNullString)) Then
      Exit Function
    End If
  End If
  
  If Not Doc.Firmar(m_doc_id, us_id) Then Exit Function
  
  Dim sqlstmt As String
  Dim rs      As Recordset
  
  sqlstmt = "sp_DocFacturaVentaFirmar " & m_Id & "," & us_id
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Function
  
  m_est_id = gDB.ValField(rs.fields, cscEstId)
  m_Estado = gDB.ValField(rs.fields, cscEstNombre)
  
  Dim iProp As cIABMProperty
  Set iProp = m_ObjAbm.Properties(csDocEstateID)
  
  With iProp
    .HelpId = m_est_id
    .Value = m_Estado
  End With
  
  gDB.GetData csTFacturaVenta, cscFvId, m_Id, cscFvFirmado, m_Firmado
  
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
  
  sqlstmt = "sp_DocFacturaVentaMover " & MoveTo & "," & m_Numero & "," & doc_id
  
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Function
  
  ' Si no obtuve ningun id al moverme
  '
  If rs.EOF Then
    
    Select Case MoveTo
      
      ' Si era siguiente ahora busco el ultimo
      '
      Case MSG_DOC_NEXT
        pMove MSG_DOC_LAST ' Llamada recursiva
      
      ' Si era anterior ahora busco el primero
      '
      Case MSG_DOC_PREVIOUS
        pMove MSG_DOC_FIRST ' Llamada recursiva
      
      ' Si no encontre ni ultimo ni primero
      ' es por que no hay ningun comprobante para
      ' este documento
      '
      Case MSG_DOC_FIRST, MSG_DOC_LAST
        
        ' Limpio incluso el ultimo cliente
        '
        m_LastCli = csNO_ID
        m_LastCliName = vbNullString
        
        ' Cargo un registro vacio
        '
        Load csNO_ID
        
        ' Obtengo un nuevo numero de comprobante
        '
        GetDocNumberForCliente m_LastCli, m_LastDoc, m_ObjAbm, m_TaPropuesto
        
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
    
    Set c = .Item(cscFvFecha)
    c.Value = m_Fecha
    
    Set c = .Item(cscFvFechaentrega)
    c.Value = m_Fechaentrega
    
    Set c = .Item(cscCliId)
    c.HelpId = m_cli_id
    c.Value = m_Cliente
    
    Set c = .Item(csDocNumberID)
    c.Value = m_Numero
    
    Set c = .Item(csDocEstateID)
    c.Value = m_Estado
    
    Set c = .Item(cscFvNrodoc)
    c.Value = m_Nrodoc
    c.TextMask = m_TaMascara
    c.TextAlign = vbRightJustify
    
    Set c = .Item(cscFvDescuento1)
    c.Value = m_Descuento1
    
    Set c = .Item(cscFvDescuento2)
    c.Value = m_Descuento2
    
    Set c = .Item(cscCpgId)
    c.HelpId = m_cpg_id
    c.Value = m_CondicionPago
    
    Set c = .Item(cscFvFechaVto)
    c.Value = m_FechaVto
        
    Set c = .Item(cscFvCotizacion)
    c.Value = m_Cotizacion
        
    Set c = .Item(cscCcosId)
    c.HelpId = m_ccos_id
    c.Value = m_CentroCosto
    
    Set c = .Item(cscSucId)
    c.HelpId = m_suc_id
    c.Value = m_Sucursal
    
    Set c = .Item(cscFvDescrip)
    c.Value = m_Descrip
    
    Set c = .Item(cscLgjId)
    c.HelpId = m_lgj_id
    c.Value = m_Legajo
    
    Set c = .Item(cscProIdOrigen)
    c.HelpId = m_pro_id_origen
    c.Value = m_ProOrigen
    
    Set c = .Item(cscProIdDestino)
    c.HelpId = m_pro_id_destino
    c.Value = m_ProDestino
        
    Set c = .Item(cscFvCai)
    c.Value = m_Cai
    
    Set c = .Item(cscFvOrdenCompra)
    c.Value = m_OrdenCompra
            
    Set c = .Item(cscFvFechaIva)
    c.Value = m_FechaIva
    
  End With
  
  Set AbmGen = m_ObjAbm
  AbmGen.ShowValues m_ObjAbm.Properties
  
  AbmGen.ResetChanged
  
  If m_Cotizacion <> 0 Then
    Cotizacion = m_Cotizacion
  Else
    Cotizacion = 1
  End If
  
  Set c = pGetItems()
  If Not pLoadItems(c, Cotizacion) Then Exit Sub
  
  m_ItemsDeleted = vbNullString
  
  Set c = m_Items.Properties.Item(c_Percepciones)
  If Not pLoadPercepciones(c, Cotizacion) Then Exit Sub
  
  m_PercepcionesDeleted = vbNullString
  
  Set AbmGen = m_Items
  AbmGen.ShowValues m_Items.Properties
  
  With m_Footer.Properties
  
    Set c = .Item(cscFvSubtotal)
    c.Value = m_SubTotal
    
    Set c = .Item(cscFvImportedesc1)
    c.Value = m_ImporteDesc1
    
    Set c = .Item(cscFvImportedesc2)
    c.Value = m_ImporteDesc2
    
    Set c = .Item(cscFvNeto)
    c.Value = m_Neto
    
    Set c = .Item(cscFvIvari)
    c.Value = m_Ivari
    
    Set c = .Item(cscFvIvarni)
    c.Value = m_Ivarni
    
    Set c = .Item(cscFvTotalPercepciones)
    c.Value = m_TotalPercepciones
    
    Set c = .Item(cscFvTotal)
    c.Value = m_Total
  End With
  
  Set AbmGen = m_Footer
  AbmGen.ShowValues m_Footer.Properties
  
  pSetEnabled
  
  pShowCotizacion
  pShowFechaVto
  
End Sub

Private Function pGetDocFilter() As String
  pGetDocFilter = "'(doct_id = " & csEDT_FacturaVenta & " or " & _
                  "doct_id = " & csEDT_NotaCreditoVenta & " or " & _
                  "doct_id = " & csEDT_NotaDebitoVenta & _
                  pGetDocFilterAux() & "'"
                  
End Function

Private Function pGetDocFilterAux() As String
  Select Case m_tipo
    Case csE_SGR_FacturaTipo.csE_SGR_FV_Credito
      pGetDocFilterAux = ") and (doc_escreditobanco<>0)"
    Case csE_SGR_FacturaTipo.csE_SGR_FV_AccionParticipe
      pGetDocFilterAux = ") and (doc_esventaaccion <>0)"
    Case csE_SGR_FacturaTipo.csE_SGR_FV_AccionProtector
      pGetDocFilterAux = ") and (doc_esventaaccion <>0)"
    Case csE_SGR_FacturaTipo.csE_SGR_FV_Cheque
      pGetDocFilterAux = ") and (doc_esventacheque<>0)"
    Case csE_SGR_FacturaTipo.csE_SGR_FV_OrdenCompra
      pGetDocFilterAux = ") and (doc_escreditobanco<>0)"
    Case Else
      pGetDocFilterAux = ")"
  End Select

End Function

Private Sub pShowApply()

  If Not DocSecurityCanAccess(csPreVtaModifyAplic, _
                              m_doc_id, _
                              csEDocTPreAplicar) Then Exit Sub
  
  If m_ObjApply Is Nothing Then
    Set m_ObjApply = CSKernelClient2.CreateObject("CSVenta2.cFacturaVentaAplic")
  
  ' Edit Apply
  '
  Else
    If m_ObjApply.id <> m_Id Then
      Set m_ObjApply.ObjectClient = Nothing
      Set m_ObjApply = CSKernelClient2.CreateObject("CSVenta2.cFacturaVentaAplic")
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
                         m_cli_id, _
                         m_Cliente, _
                         m_suc_id, _
                         m_doc_id, _
                         m_Doct_id = csEDocumentoTipo.csEDT_NotaCreditoVenta) Then
    Set m_ObjApply = Nothing
  End If
                  
End Sub

' Construccion - Destruccion
Private Sub Class_Initialize()
  On Error GoTo ControlError
  
  c_ErrorSave = LNGGetText(2220, vbNullString)  'Error al grabar la Factura de Venta
  
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
  m_UserCfg.ValidateFV
  
  ReDim m_PvIds(0)
  ReDim m_RvIds(0)
  ReDim m_HoraIds(0)
  ReDim m_PklstIds(0)
  
  ReDim m_vPercepciones(0)
  
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

  ' Lote
  '
  Set m_StockConfig = Nothing

  ' Preferencias del Usuario
  '
  Set m_UserCfg = Nothing

  Set m_Host = Nothing
  ReDim m_PvIds(0)
  ReDim m_RvIds(0)
  ReDim m_HoraIds(0)
  ReDim m_PklstIds(0)
  CollClear m_NrosSerie
  Set m_NrosSerie = Nothing

  GoTo ExitProc
ControlError:
  MngError Err, "Class_Terminate", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Function pGetCliId() As Long
  pGetCliId = m_ObjAbm.Properties(cscCliId).HelpId
End Function

Private Function pGetFecha() As Date
  pGetFecha = m_ObjAbm.Properties.Item(cscFvFecha).Value
End Function

'//////////////////////////////////////////////////////////////////////////////
'
' Percepciones
'
Private Function pLoadPercepciones(ByRef Propiedad As cIABMProperty, ByVal Cotizacion As Double) As Boolean
  Dim sqlstmt As String
  
  Dim rs As ADODB.Recordset
  
  sqlstmt = "sp_DocFacturaVentaGetPercepciones " & m_Id
  
  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, "pLoadPercepciones", C_Module) Then Exit Function
  
  Dim o As cIABMGridColumn
  
  With Propiedad.Grid
    .Columns.Clear
    .Rows.Clear
  
    LoadPercepciones Propiedad.Grid, m_GeneralConfig
    
    With .Rows
      
      While Not rs.EOF
      
        With .Add(Nothing, rs(cscFvPercId).Value)
        
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscFvPercId)
            .Key = KIP_FVPERC_ID
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscPercNombre)
            .id = gDB.ValField(rs.fields, cscPercId)
            .Key = KIP_PERC_ID
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscFvPercBase) / Cotizacion
            .Key = KIP_BASE
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscFvPercPorcentaje)
            .Key = KIP_PORCENTAJE
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscFvPercImporte) / Cotizacion
            .Key = KIP_IMPORTE
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscFvPercDescrip)
            .Key = KIP_DESCRIP
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscCcosNombre)
            .id = gDB.ValField(rs.fields, cscCcosId)
            .Key = KI_CCOS_ID
          End With
        End With
        
        rs.MoveNext
      Wend
    End With
  End With
  
  pLoadPercepciones = True
End Function

Private Sub pCalcularPercepciones()

  Dim Row       As cIABMGridRow
  Dim i         As Long
  Dim perc_id   As Long
  
  If m_doc_sin_perc Then Exit Sub
  
  For Each Row In pGetPercepcion().Grid.Rows
    perc_id = Val(pCell(Row, KIP_FVPERC_ID).Value)
    If perc_id Then
      m_PercepcionesDeleted = m_PercepcionesDeleted & perc_id & ","
    End If
  Next
  
  For i = 1 To UBound(m_vPercepciones)
    With m_vPercepciones(i)
      
      .base = 0
      
      For Each Row In pGetItems().Grid.Rows
        Select Case .tipo_base
          Case csE_PercepcionBase.csEPB_Neto
            .base = .base + Val(pCell(Row, KI_NETO).Value)
          Case csE_PercepcionBase.csEPB_NetoGravado
            If Val(pCell(Row, KI_IVARI).Value) Then
              .base = .base + Val(pCell(Row, KI_NETO).Value)
            End If
          Case csE_PercepcionBase.csEPB_Total
            .base = .base + Val(pCell(Row, KI_IMPORTE).Value)
        End Select
      Next
      
      If .base > .minimo Then
      
        If .base >= .desde And .base <= .hasta Then
        
          .percepcion = .base * .porc / 100 + .fijo
        End If
      End If
      
    End With
  Next
  
  Dim Rows As cIABMGridRows
  Dim Cell As cIABMGridCellValue
  
  Set Rows = pGetPercepcion().Grid.Rows
  
  Rows.Clear
  
  For i = 1 To UBound(m_vPercepciones)
    
    With m_vPercepciones(i)
      
      If .percepcion Then
            
        Set Row = Rows.Add(Nothing)
              
        Set Cell = Row.Add(Nothing)
        Cell.Value = 0
        Cell.Key = KIP_FVPERC_ID
        
        Set Cell = Row.Add(Nothing)
        Cell.Value = .nombre
        Cell.id = .perc_id
        Cell.Key = KIP_PERC_ID
        
        Set Cell = Row.Add(Nothing)
        Cell.Value = .base
        Cell.Key = KIP_BASE
        
        Set Cell = Row.Add(Nothing)
        Cell.Value = .porc
        Cell.Key = KIP_PORCENTAJE
        
        Set Cell = Row.Add(Nothing)
        Cell.Value = .percepcion
        Cell.Key = KIP_IMPORTE
        
        Set Cell = Row.Add(Nothing)
        Cell.Value = vbNullString
        Cell.Key = KIP_DESCRIP
        
        Set Cell = Row.Add(Nothing)
        Cell.Value = vbNullString
        Cell.id = csNO_ID
        Cell.Key = KI_CCOS_ID
      
      End If
    End With
  Next
  
  Dim AbmObj As cABMGeneric
  Set AbmObj = m_ObjAbm
  
  AbmObj.ShowValue pGetPercepcion(), True
  
End Sub

Private Function pGetItems() As cIABMProperty
  Set pGetItems = m_Items.Properties.Item(c_Items)
End Function

Private Function pGetPercepcion() As cIABMProperty
  Set pGetPercepcion = m_Items.Properties.Item(c_Percepciones)
End Function

Private Sub pShowCobranza()
  On Error GoTo ControlError

  Dim o As Object

  Set o = CSKernelClient2.CreateObject("CSTesoreria2.cCobranza")
  
  o.ShowCobranza pGetCliId(), pGetFvIds()

  GoTo ExitProc
ControlError:
  MngError Err, "pShowCobranza", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Function pGetFvIds() As Long()
  Dim rtn() As Long
  ReDim rtn(1)
  rtn(1) = m_Id
  pGetFvIds = rtn
End Function

