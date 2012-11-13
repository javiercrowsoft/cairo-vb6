VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cPedidoVenta"
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
'--------------------------------------------------------------------------------
' NOMBRE_CLASE
' 09-05-2003

'--------------------------------------------------------------------------------
' notas:

' PREFIJO_TABLA       reemplazar por el prefijo de la tabla (ej pro para provincias)
' PREFIJO_TBL_ITEM    reemplazar por le prefijo de la tabla item (ej pvi para pedidos de venta)
' NOMBRE_TABLA        reemplazar por el nombre de la tabla (ej Provincia)
' NOMBRE_DLL          reemplazar por le nombre de la dll (ej PedidoVenta no poner el CS)
' NOMBRE_CLASE        reemplazar por el nombre de la clase (ej cProvincia)
' TITULO_CLASE        reemplazar por el nombre logico del abm (ej Provincias)
' PREFIJO_PRESTACION  reemplazar por el nombre logico del abm (ej PreG)
' TITULO_MSG_STATE    reemplazar por el titulo del mensaje de estado de edicion (ej "Pedidos de Venta" sin comillas)
' ENUM_DOC_TIPO       reemplazar por el valor correspondiente al documento tipo (ej csEDT_PedidoVenta para Pedidos de venta)
' TITULO_ERROR_GRABAR reemplazar por el mensaje de error al grabar (ej "Error al grabar el Pedido de Venta" sin comillas)
' MSG_VALIDAR_PRODUCTO  reemplazar por el mensaje segun sea compras o ventas (Ej: (sin comillas)
'                                                                                "Debe indicar un producto de venta"
'                                                                                "Debe indicar un producto de compra")
' CAMPO_NOMBRE_PRODUCTO reemplzar por el nombre del campo producto segun sea ventas o compras (cscPrNombreventa = ventas)

' MENU_MAIN_DOCUMENTO   reemplazar por el menu principal del documento ejemplo &Ventas para pedidos de venta, para facturas de venta, etc.
'                                                               mas ejemplos:  &Compras para pedidos de compra, facturas de compra, etc.

' MENU_MAIN_ID          reemplazar por el id del menu principal ejemplo csMenuVentas en pedidos de venta y facturas de venta, etc
' NOMBRE_PRESTACION     reemplazar por el nombre de las prestaciones ejemplo en pedido de venta la
'                       prestacion es csPrePvListPedidoVta y hay que poner PedidoVta

' IVA_MSG_RI            reemplazar por el mensaje de iva ej. (sin comillas)
'                       "El producto [" & pr_nombre & "] no tiene definida su tasa impositiva de ventas para el iva responsable inscripto"

' IVA_MSG_RNI           reemplazar por el mensaje de iva ej. (sin comillas)
'                       "El producto [" & pr_nombre & "] no tiene definida su tasa impositiva de ventas para el iva responsable no inscripto"

' CAMPOTIID             reemplazar por el nombre del campo de tasa impositiva que corresponda ej Venta si el circuito es ventas
'                       o Compra si el circuito es compras

' CAMPO_UNIDAD          reemplazar por el campo de unidad segun el circuito del documento un_id_venta para ventas y un_id_compra para compras

' CAMPO_CLIENTE_PROVEEDOR           reemplazar por cli_id o prov_id segun el circuito
' CAMPO_NOMBRE_CLIENTE_PROVEEDOR    reemplazar por cliente o proveedor segun circuito

' LAST_CLIENTE_PROVEEDOR            reemplazar por m_LastCli o m_LastProv segun circuito
' NOMBRE_SP                         reemplazar por el nombre del SP ej. PedidoVenta
'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "NOMBRE_CLASE"

Private Const C_Items = "ITEMS"

Private Const K_NUMERO                         As Integer = 1
Private Const K_NRODOC                         As Integer = 2
Private Const K_DESCRIP                        As Integer = 3
Private Const K_FECHA                          As Integer = 4
Private Const K_FECHAENTREGA                   As Integer = 5
Private Const K_NETO                           As Integer = 6
Private Const K_IVARI                          As Integer = 7
Private Const K_IVARNI                         As Integer = 8
Private Const K_TOTAL                          As Integer = 9
Private Const K_CAMPO_CLIENTE_PROVEEDOR                         As Integer = 10
Private Const K_DOC_ID                         As Integer = 11
Private Const K_DOCT_ID                        As Integer = 12
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

Private Const KI_PREFIJO_TABLA_ID                          As Integer = 1
Private Const KI_PREFIJO_TBL_ITEM_ID                         As Integer = 2
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
Private m_Descuento1                   As Double
Private m_Descuento2                   As Double
Private m_ImporteDesc1                 As Double
Private m_ImporteDesc2                 As Double
Private m_Cpg_id                       As Long
Private m_CondicionPago                As String
Private m_ccos_id                      As Long
Private m_CentroCosto                  As String
Private m_Suc_id                       As Long
Private m_Sucursal                     As String
Private m_CAMPO_CLIENTE_PROVEEDOR                       As Long
Private m_CAMPO_NOMBRE_CLIENTE_PROVEEDOR                      As String
Private m_doc_id                       As Long
Private m_Documento                    As String
Private m_Doct_id                      As Long
'Private m_DocumentoTipo                As String
Private m_Lp_id                        As Long
Private m_ListaPrecio                  As String
Private m_Ld_id                        As Long
Private m_ListaDescuento               As String
Private m_Creado                       As Date
Private m_Modificado                   As Date
Private m_Modifico                     As Long
Private m_Firmado                      As Boolean

Private m_Editing           As Boolean

Private m_Footer            As cIABMGeneric
Private m_Items             As cIABMGeneric
Private m_ObjAbm            As cIABMGeneric
Private m_ObjTree           As Object

Private m_LastDoc           As Long
Private LAST_CLIENTE_PROVEEDOR           As Long
Private m_LastDocName       As String
Private LAST_CLIENTE_PROVEEDORName       As String

Private m_IsNew             As Boolean

Private m_BranchId          As Long
Private m_TreeId            As Long

Private m_Host              As CSMenu.cIMenuHost

Private m_ItemsDeleted      As String

Private m_Copy              As Boolean

Private m_GeneralConfig     As cGeneralConfig

Private m_DocEditable       As Boolean
Private m_DocEditMsg        As String
' propiedades publicas

'Public Property Get ID() As Long
'  ID = m_Id
'End Property
'
'Public Property Let ID(ByVal rhs As Long)
'  m_Id = rhs
'End Property
'
'Public Property Get Numero() As Long
'  Numero = m_Numero
'End Property
'
'Public Property Let Numero(ByVal rhs As Long)
'  m_Numero = rhs
'End Property
'
'Public Property Get Nrodoc() As String
'  Nrodoc = m_Nrodoc
'End Property
'
'Public Property Let Nrodoc(ByVal rhs As String)
'  m_Nrodoc = rhs
'End Property
'
'Public Property Get Descrip() As String
'  Descrip = m_Descrip
'End Property
'
'Public Property Let Descrip(ByVal rhs As String)
'  m_Descrip = rhs
'End Property
'
'Public Property Get Fecha() As Date
'  Fecha = m_Fecha
'End Property
'
'Public Property Let Fecha(ByVal rhs As Date)
'  m_Fecha = rhs
'End Property
'
'Public Property Get Fechaentrega() As Date
'  Fechaentrega = m_Fechaentrega
'End Property
'
'Public Property Let Fechaentrega(ByVal rhs As Date)
'  m_Fechaentrega = rhs
'End Property
'
'Public Property Get Neto() as double
'  Neto = m_Neto
'End Property
'
'Public Property Let Neto(ByVal rhs as double)
'  m_Neto = rhs
'End Property
'
'Public Property Get IvaRi() as double
'  IvaRi = m_Ivari
'End Property
'
'Public Property Let IvaRi(ByVal rhs as double)
'  m_Ivari = rhs
'End Property
'
'Public Property Get IvaRni() as double
'  IvaRni = m_Ivarni
'End Property
'
'Public Property Let IvaRni(ByVal rhs as double)
'  m_Ivarni = rhs
'End Property
'
'Public Property Get Total() as double
'  Total = m_Total
'End Property
'
'Public Property Let Total(ByVal rhs as double)
'  m_Total = rhs
'End Property
'
'Public Property Get CAMPO_CLIENTE_PROVEEDOR() As Long
'  CAMPO_CLIENTE_PROVEEDOR = m_CAMPO_CLIENTE_PROVEEDOR
'End Property
'
'Public Property Let CAMPO_CLIENTE_PROVEEDOR(ByVal rhs As Long)
'  m_CAMPO_CLIENTE_PROVEEDOR = rhs
'End Property
'
'Public Property Get CAMPO_NOMBRE_CLIENTE_PROVEEDOR() As String
'  m_CAMPO_NOMBRE_CLIENTE_PROVEEDOR = m_CAMPO_NOMBRE_CLIENTE_PROVEEDOR
'End Property
'
'Public Property Let CAMPO_NOMBRE_CLIENTE_PROVEEDOR(ByVal rhs As String)
'  m_CAMPO_NOMBRE_CLIENTE_PROVEEDOR = rhs
'End Property
'
'Public Property Get Doc_id() As Long
'  Doc_id = m_Doc_id
'End Property
'
'Public Property Let Doc_id(ByVal rhs As Long)
'  m_Doc_id = rhs
'End Property
'
'Public Property Get Documento() As String
'  m_Documento = m_Documento
'End Property
'
'Public Property Let Documento(ByVal rhs As String)
'  m_Documento = rhs
'End Property
'
'Public Property Get Doct_id() As Long
'  Doct_id = m_Doct_id
'End Property
'
'Public Property Let Doct_id(ByVal rhs As Long)
'  m_Doct_id = rhs
'End Property
'
'Public Property Get DocumentoTipo() As String
'  m_DocumentoTipo = m_DocumentoTipo
'End Property
'
'Public Property Let DocumentoTipo(ByVal rhs As String)
'  m_DocumentoTipo = rhs
'End Property
'
'Public Property Get LP_ID() As Long
'  LP_ID = m_Lp_id
'End Property
'
'Public Property Let LP_ID(ByVal rhs As Long)
'  m_Lp_id = rhs
'End Property
'
'Public Property Get ListaPrecio() As String
'  m_ListaPrecio = m_ListaPrecio
'End Property
'
'Public Property Let ListaPrecio(ByVal rhs As String)
'  m_ListaPrecio = rhs
'End Property
'
'Public Property Get LD_ID() As Long
'  LD_ID = m_Ld_id
'End Property
'
'Public Property Let LD_ID(ByVal rhs As Long)
'  m_Ld_id = rhs
'End Property
'
'Public Property Get ListaDescuento() As String
'  m_ListaDescuento = m_ListaDescuento
'End Property
'
'Public Property Let ListaDescuento(ByVal rhs As String)
'  m_ListaDescuento = rhs
'End Property
'
'Public Property Get Creado() As Date
'  Creado = m_Creado
'End Property
'
'Public Property Let Creado(ByVal rhs As Date)
'  m_Creado = rhs
'End Property
'
'Public Property Get Modificado() As Date
'  Modificado = m_Modificado
'End Property
'
'Public Property Let Modificado(ByVal rhs As Date)
'  m_Modificado = rhs
'End Property
'
'Public Property Get Modifico() As Long
'  Modifico = m_Modifico
'End Property
'
'Public Property Let Modifico(ByVal rhs As Long)
'  m_Modifico = rhs
'End Property
'
'Public Property Get CPG_ID() As Long
'  CPG_ID = m_Cpg_id
'End Property
'
'Public Property Let CPG_ID(ByVal rhs As Long)
'  m_Cpg_id = rhs
'End Property
'
'Public Property Get CondicionPago() As String
'  CondicionPago = m_CondicionPago
'End Property
'
'Public Property Let CondicionPago(ByVal rhs As String)
'  m_CondicionPago = rhs
'End Property

' propiedades privadas
' funciones publicas


' Implementacion de cIABMClient
Private Function cIABMClient_Copy() As Boolean
  
  cIABMClient_Terminate
  m_IsNew = True
  
  m_Copy = True
  pGetDocNumber
End Function

Private Function cIABMClient_EditNew() As Boolean
  
  cIABMClient_Terminate
  m_IsNew = True

  cIEditGeneric_Edit csNO_ID
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

  Doc.ClientTable = csTNOMBRE_TABLA
  Doc.ClientTableID = m_Id

  cIABMClient_ShowDocDigital = Doc.ShowDocs(gDB)

  GoTo ExitProc
ControlError:
  MngError Err, "cIABMClient_ShowDocDigital", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Private Function cIABMClient_MessageEx(ByVal MessageID As Long, ByVal Info As Variant) As Boolean
    
  Select Case MessageID
    Case MSG_DOC_FIRST, MSG_DOC_PREVIOUS, MSG_DOC_NEXT, MSG_DOC_LAST
      cIABMClient_MessageEx = pMove(MessageID)
    Case MSG_DOC_SIGNATURE
      cIABMClient_MessageEx = pFirmar()
    Case MSG_GRID_ROW_DELETED
      cIABMClient_MessageEx = True
      pShowTotales m_Items.Properties(C_Items).Grid.Rows
    
    Case MSG_DOC_EDIT_STATE
      MsgInfo m_DocEditMsg, "TITULO_MSG_STATE"
      
    Case MSG_DOC_DELETE
      If cIEditGeneric_Delete(m_Id) Then
        pMove MSG_DOC_NEXT
      End If
    Case MSG_DOC_ANULAR
      pAnular
  
    Case MSG_DOC_REFRESH
      Load m_Id
      pRefreshProperties
  
    ' SI HAY WIZARD DESCOMENTAR
    '
    'Case MSG_DOC_NEW_WITH_WIZARD
    '  cIABMClient_MessageEx = True
    
    Case MSG_DOC_EX_GET_ITEMS
      Set cIABMClient_MessageEx = m_Items
    
    Case MSG_DOC_EX_GET_FOOTERS
      Set cIABMClient_MessageEx = m_Footer
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
      pSetEnabled
      pGetDocNumber
    Case K_CAMPO_CLIENTE_PROVEEDOR
      pSetDatosCAMPO_NOMBRE_CLIENTE_PROVEEDOR
    Case K_DESCUENTO1, K_DESCUENTO2
      pShowTotales m_Items.Properties(C_Items).Grid.Rows
  End Select
End Function

Private Function cIABMClient_Save() As Boolean
  Dim register As cRegister
  
  Dim Mouse As cMouseWait
  Set Mouse = New cMouseWait
  
  DoEvents: DoEvents: DoEvents: DoEvents
  
  Set register = New cRegister
  register.fieldId = cscPREFIJO_TABLATMPId
  register.Table = csTNOMBRE_TABLATMP
  
  register.Id = csNew
    
  If m_Copy Then
    register.Fields.Add2 cscPREFIJO_TABLAId, csNew, csLong
  Else
    register.Fields.Add2 cscPREFIJO_TABLAId, m_Id, csLong
  End If
  
  If register.Id = csNew Then
    m_est_id = CSDocumento.csEEstado.csEEst_Pendiente
  End If
  
  Dim IProperty As cIABMProperty
  For Each IProperty In m_ObjAbm.Properties
    With IProperty
      Select Case .Key
        Case K_NUMERO
          register.Fields.Add2 cscPREFIJO_TABLANumero, .Value, csLong
        Case K_NRODOC
          register.Fields.Add2 cscPREFIJO_TABLANrodoc, .Value, csText
        Case K_DESCRIP
          register.Fields.Add2 cscPREFIJO_TABLADescrip, .Value, csText
        Case K_FECHA
          register.Fields.Add2 cscPREFIJO_TABLAFecha, .Value, csDate
        Case K_FECHAENTREGA
          register.Fields.Add2 cscPREFIJO_TABLAFechaentrega, .Value, csDate
        Case K_CAMPO_CLIENTE_PROVEEDOR
          register.Fields.Add2 cscCliId, .HelpId, csId
        Case K_CCOS_ID
          register.Fields.Add2 cscCcosId, .HelpId, csId
        Case K_SUC_ID
          register.Fields.Add2 cscSucId, .HelpId, csId
        Case K_DESCUENTO1
          register.Fields.Add2 cscPREFIJO_TABLADescuento1, .Value, csCurrency
        Case K_DESCUENTO2
          register.Fields.Add2 cscPREFIJO_TABLADescuento2, .Value, csCurrency
        Case K_DOC_ID
          register.Fields.Add2 cscDocId, .HelpId, csId
        Case K_DOCT_ID
          register.Fields.Add2 cscDoctId, .HelpId, csId
        Case K_LP_ID
          register.Fields.Add2 cscLpId, .HelpId, csId
        Case K_LD_ID
          register.Fields.Add2 cscLdId, .HelpId, csId
        Case K_CPG_ID
          register.Fields.Add2 cscCpgId, .HelpId, csId
      End Select
    End With
  Next
  
  For Each IProperty In m_Footer.Properties
    With IProperty
      Select Case .Key
        Case K_TOTAL
          register.Fields.Add2 cscPREFIJO_TABLATotal, .Value, csCurrency
        Case K_NETO
          register.Fields.Add2 cscPREFIJO_TABLANeto, .Value, csCurrency
        Case K_IVARI
          register.Fields.Add2 cscPREFIJO_TABLAIvari, .Value, csCurrency
        Case K_IVARNI
          register.Fields.Add2 cscPREFIJO_TABLAIvarni, .Value, csCurrency
        Case K_SUBTOTAL
          register.Fields.Add2 cscPREFIJO_TABLASubTotal, .Value, csCurrency
        Case K_IMPORTEDESC1
          register.Fields.Add2 cscPREFIJO_TABLAImporteDesc1, .Value, csCurrency
        Case K_IMPORTEDESC2
          register.Fields.Add2 cscPREFIJO_TABLAImporteDesc2, .Value, csCurrency
      End Select
    End With
  Next
  
  register.Fields.Add2 cscEstId, m_est_id, csId
  register.Fields.Add2 cscDoctId, CSDocumento.csEDocumentoTipo.ENUM_DOC_TIPO, csId
  
  register.Fields.HaveLastUpdate = True
  register.Fields.HaveWhoModify = True
  
  If Not register.BeginTrans(gDB) Then Exit Function
  
  Const c_ErrorSave = "TITULO_ERROR_GRABAR"
  
  If Not gDB.Save(register, , "cIABMClient_Save", "NOMBRE_CLASE", c_ErrorSave) Then Exit Function
  
  If Not pSaveItems(register.Id) Then Exit Function
  If Not register.CommitTrans() Then Exit Function
  
  
  Dim sqlstmt As String
  Dim rs      As Recordset
  sqlstmt = "sp_DoNOMBRE_CLASESave " & register.Id
  
  If Not gDB.OpenRs(sqlstmt, rs, , , , "cIABMClient_Save", "NOMBRE_CLASE", c_ErrorSave) Then Exit Function
  
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
  
  m_ObjTree.sqlstmt = "sp_lsdoc_NOMBRE_SP"
  
  If m_IsNew Then
    m_ObjTree.AddLine m_Id
  Else
    m_ObjTree.RefreshLine m_Id
  End If
ControlError:
End Function

Private Property Get cIABMClient_Title() As String
  cIABMClient_Title = "TITULO_CLASE"
End Property

Private Function cIABMClient_Validate() As Boolean

  Dim IProperty As cIABMProperty

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
        Case K_CAMPO_CLIENTE_PROVEEDOR
          If ValEmpty(.HelpId, csId) Then
            MsgInfo "Debe indicar un CAMPO_NOMBRE_CLIENTE_PROVEEDOR"
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
  MngError Err, "cIABMClientGrid_ValidateRow", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
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
  cIEditGeneric_ShowList = SecurityCanAccess(csPREFIJO_PRESTACIONListNOMBRE_PRESTACION)
End Function

Private Property Set cIEditGeneric_ObjAbm(rhs As CSInterfacesABM.cIABMGeneric)
  Set m_ObjAbm = rhs
  m_ObjAbm.IsDocument = True
End Property

Private Property Get cIEditGeneric_Editing() As Boolean
  cIEditGeneric_Editing = m_Editing
End Property

Private Function cIEditGeneric_Delete(Id As Long) As Boolean
  If Not SecurityCanAccess(csPREFIJO_PRESTACIONDeleteNOMBRE_PRESTACION) Then Exit Function

  Dim sqlstmt As String
  
  sqlstmt = "sp_DoNOMBRE_CLASEDelete " & Id
  
  cIEditGeneric_Delete = gDB.Execute(sqlstmt, "cIEditGeneric_Delete", "NOMBRE_CLASE")
End Function

Private Function cIEditGeneric_Search(Id As Long, Cancela As Boolean) As Boolean

End Function

Private Function cIEditGeneric_Edit(Id As Long, Optional ByVal InModalWindow As Boolean) As Boolean
  On Error GoTo ControlError
  
  If Id = csNO_ID Then
    m_IsNew = True
    If Not SecurityCanAccess(csPREFIJO_PRESTACIONNewNOMBRE_PRESTACION) Then Exit Function
  Else
    m_IsNew = False
    If Not SecurityCanAccess(csPREFIJO_PRESTACIONEditNOMBRE_PRESTACION) Then Exit Function
  End If

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
  MngError Err, "cIEditGeneric_Edit", "NOMBRE_CLASE", ""
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
      pShowImporteAndIva .Grid.Rows(lRow)
      pShowTotales .Grid.Rows
      cIABMClientGrid_ColumnAfterUpdate = True
  End Select

  GoTo ExitProc
ControlError:
  MngError Err, "cIABMClientGrid_ColumnAfterUpdate", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Private Function cIABMClientGrid_ColumnAfterEdit(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long, ByVal NewValue As Variant, ByVal NewValueID As Long) As Boolean
  On Error GoTo ControlError

  Dim IProperty As cIABMProperty
  For Each IProperty In m_Items.Properties
    With IProperty
      If .Key = Key Then
        Select Case .Key
          Case K_ITEMS
            cIABMClientGrid_ColumnAfterEdit = pColumnAfterEdit(IProperty, lRow, lCol, NewValue, NewValueID)
        End Select
      End If
    End With
  Next
  
  GoTo ExitProc
ControlError:
  MngError Err, "cIABMClientGrid_ColumnAfterEdit", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Private Function cIABMClientGrid_ColumnBeforeEdit(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long, ByVal iKeyAscii As Integer) As Boolean
  On Error GoTo ControlError

  Dim IProperty As cIABMProperty
  For Each IProperty In m_Items.Properties
    With IProperty
      If .Key = Key Then
        Select Case .Key
          Case K_ITEMS
            cIABMClientGrid_ColumnBeforeEdit = pColumnBeforeEdit(IProperty, lRow, lCol, iKeyAscii)
        End Select
      End If
    End With
  Next
  
  GoTo ExitProc
ControlError:
  MngError Err, "cIABMClientGrid_ColumnBeforeEdit", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Private Function pColumnBeforeEdit(ByRef IProperty As cIABMProperty, ByVal lRow As Long, ByVal lCol As Long, ByVal iKeyAscii As Integer)
  pColumnBeforeEdit = True
End Function

Private Function pGetPrecioFromRow(ByVal Row As cIABMGridRow) As Double
  Dim Precio  As Double
  
  With pGetCellFromKey(Row, KI_PRECIO_USR)
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
      pSetDescuentos Row, NewValueID, pGetPrecioFromRow(Row)
      pSetTasasImpositivas Row, NewValueID, NewValue
      
    Case KI_PRECIO_USR
      Set Row = IProperty.Grid.Rows(lRow)
      pSetDescuentos Row, pGetCellFromKey(Row, KI_PR_ID).Id, NewValue
      
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
  
  Id = Val(pCell(Row, KI_PREFIJO_TBL_ITEM_ID).Value)
  
  If Id <> csNO_ID Then m_ItemsDeleted = m_ItemsDeleted & Id & ","
  
  cIABMClientGrid_DeleteRow = True
End Function

Private Function cIABMClientGrid_ListAdHock(ByVal Key As Integer, Row As CSInterfacesABM.cIABMGridRow, ByVal ColIndex As Long, List As CSInterfacesABM.cIABMList) As Boolean

End Function

Private Sub cIABMClientGrid_NewRow(ByVal Key As Integer, ByVal Rows As Integer)

End Sub

Private Function cIABMClientGrid_ValidateRow(ByVal Key As Integer, Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  On Error GoTo ControlError

  Dim IProperty As cIABMProperty
  For Each IProperty In m_Items.Properties
    With IProperty
      If .Key = Key Then
        Select Case .Key
          Case K_ITEMS
            cIABMClientGrid_ValidateRow = pValidateRow(Row, RowIndex)
        End Select
      End If
    End With
  Next
  
  GoTo ExitProc
ControlError:
  MngError Err, "cIABMClientGrid_ValidateRow", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
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
          MsgInfo "MSG_VALIDAR_PRODUCTO" & strRow
          Exit Function
        End If
    End Select
  Next
  
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
  Dim AbmGen  As cABMGeneric
  
  Set AbmGen = m_ObjAbm
  AbmGen.ResetLayoutMembers
  m_ObjAbm.Properties.Clear

  Set c = m_ObjAbm.Properties.Add(c, cscDocId)
  c.PropertyType = cspHelp
  c.Table = CSDocumento.CSDocumento
  c.Name = "Documento"
  c.Key = K_DOC_ID
  c.HelpId = m_doc_id
  c.Value = m_Documento
  c.HelpFilter = "doct_id = " & csTypeDoNOMBRE_CLASE
  Set c = Nothing
  
  Set c = m_ObjAbm.Properties.Add(c, csDocNumberID)
  c.PropertyType = cspNumeric
  c.SubType = cspInteger
  c.Name = "Número"
  c.Key = K_NUMERO
  c.Value = m_Numero
  c.Enabled = False
  Set c = Nothing
  
  Set c = m_ObjAbm.Properties.Add(c, csDocEstateID)
  c.PropertyType = cspText
  c.Name = "Estado"
  c.Key = K_EST_ID
  c.Value = m_Estado
  c.Enabled = False
  Set c = Nothing
  
  Set c = m_ObjAbm.Properties.Add(c, cscPREFIJO_TABLAFecha)
  c.PropertyType = cspDate
  c.Name = "Fecha"
  c.LeftLabel = -580
  c.Left = 700
  c.Key = K_FECHA
  c.Value = m_Fecha
  Set c = Nothing
  
  Set c = m_ObjAbm.Properties.Add(c, cscPREFIJO_TABLAFechaentrega)
  c.PropertyType = cspDate
  c.Name = "Entrega"
  c.Key = K_FECHAENTREGA
  c.Value = m_Fechaentrega
  Set c = Nothing
  
  Set c = m_ObjAbm.Properties.Add(c, cscCliId)
  c.PropertyType = cspHelp
  c.Table = csCliente
  c.TopFromProperty = cscPREFIJO_TABLAFecha
  c.Left = 2700
  c.LeftLabel = -580
  c.Name = "CAMPO_NOMBRE_CLIENTE_PROVEEDOR"
  c.Key = K_CAMPO_CLIENTE_PROVEEDOR
  c.HelpId = m_CAMPO_CLIENTE_PROVEEDOR
  c.Value = m_CAMPO_NOMBRE_CLIENTE_PROVEEDOR
  Set c = Nothing
  
  Set c = m_ObjAbm.Properties.Add(c, cscPREFIJO_TABLANrodoc)
  c.PropertyType = cspText
  c.Name = "Numero"
  c.Size = 50
  c.Key = K_NRODOC
  c.Value = m_Nrodoc
  c.TextAlign = vbRightJustify
  Set c = Nothing
  
  Set c = m_ObjAbm.Properties.Add(c, cscCpgId)
  c.PropertyType = cspHelp
  c.Table = csCondicionPago
  c.Name = "Cond. pago"
  c.TopFromProperty = cscPREFIJO_TABLAFecha
  c.Left = 5900
  c.LeftLabel = -900
  c.Key = K_CPG_ID
  c.HelpId = m_Cpg_id
  c.Value = m_CondicionPago
  Set c = Nothing
  
  Set c = m_ObjAbm.Properties.Add(c, cscPREFIJO_TABLADescuento1)
  c.PropertyType = cspNumeric
  c.SubType = cspPercent
  c.LeftLabel = -600
  c.Name = "Desc. 1"
  c.Key = K_DESCUENTO1
  c.Value = m_Descuento1
  c.Width = 1000
  Set c = Nothing
  
  Set c = m_ObjAbm.Properties.Add(c, cscPREFIJO_TABLADescuento2)
  c.PropertyType = cspNumeric
  c.SubType = cspPercent
  c.TopFromProperty = cscPREFIJO_TABLADescuento1
  c.Left = 7150
  c.LeftLabel = -150
  c.Name = "2"
  c.Key = K_DESCUENTO2
  c.Value = m_Descuento2
  c.Width = 1000
  Set c = Nothing
  
  Set c = m_ObjAbm.Properties.Add(c, cscLpId)
  c.PropertyType = cspHelp
  c.Table = csListaPrecio
  c.Name = "Lista de Precios"
  
  Filter = "exists(select lp_id from listaprecioCAMPO_NOMBRE_CLIENTE_PROVEEDOR where CAMPO_CLIENTE_PROVEEDOR =" & m_CAMPO_CLIENTE_PROVEEDOR
  Filter = Filter & " and lp_id = listaprecio.lp_id)"
  
  c.HelpFilter = Filter
  c.TopFromProperty = cscPREFIJO_TABLAFecha
  c.Left = 9400
  c.Key = K_LP_ID
  c.HelpId = m_Lp_id
  c.Value = m_ListaPrecio
  Set c = Nothing
  
  Set c = m_ObjAbm.Properties.Add(c, cscLdId)
  c.PropertyType = cspHelp
  c.Table = csListaDescuento
  c.Name = "Lista de Descuentos"
  
  Filter = "exists(select ld_id from listadescuentoCAMPO_NOMBRE_CLIENTE_PROVEEDOR where CAMPO_CLIENTE_PROVEEDOR =" & m_CAMPO_CLIENTE_PROVEEDOR
  Filter = Filter & " and ld_id = listadescuento.ld_id)"
  
  c.HelpFilter = Filter
  c.Key = K_LD_ID
  c.HelpId = m_Ld_id
  c.Value = m_ListaDescuento
  Set c = Nothing
  
  Set c = m_ObjAbm.Properties.Add(c, cscCcosId)
  c.PropertyType = cspHelp
  c.Table = csCentroCosto
  c.Name = "Centro de Costo"
  c.Key = K_CCOS_ID
  c.HelpId = m_ccos_id
  c.Value = m_CentroCosto
  Set c = Nothing
  
  Set c = m_ObjAbm.Properties.Add(c, cscSucId)
  c.PropertyType = cspHelp
  c.Table = csSucursal
  c.Name = "Sucursal"
  c.Key = K_SUC_ID
  c.HelpId = m_Suc_id
  c.Value = m_Sucursal
  Set c = Nothing
  
  Set c = m_ObjAbm.Properties.Add(c, cscPREFIJO_TABLADescrip)
  c.PropertyType = cspText
  c.SubType = cspMemo
  c.Name = "Observ."
  c.LeftLabel = -600
  c.Size = 5000
  c.Key = K_DESCRIP
  c.Value = m_Descrip
  c.LeftFromProperty = cscPREFIJO_TABLAFecha
  c.TopFromProperty = cscPREFIJO_TABLANrodoc
  c.Width = 7450
  c.Height = 800
  c.TopToPrevious = 440
  Set c = Nothing
  
  If Not m_ObjAbm.Show(Me) Then Exit Function
      
  m_Items.Tabs.Clear
  
  Set iTab = m_Items.Tabs.Add(iTab)
  iTab.Index = 0
  iTab.Name = "Items"
  Set iTab = Nothing
  
  Set AbmGen = m_Items
  AbmGen.ResetLayoutMembers
  m_Items.Properties.Clear
  
  Set c = m_Items.Properties.Add(c, C_Items)
  c.PropertyType = cspGrid
  c.LeftLabel = -1
  If Not pLoadItems(c) Then Exit Function
  c.Name = C_Items
  c.Key = K_ITEMS
  c.TabIndex = 0
  c.GridAdd = True
  c.GridEdit = True
  c.GridRemove = True
  Set c = Nothing
  
  m_ItemsDeleted = ""
  
  If Not m_Items.Show(Me) Then Exit Function
  
  Set AbmGen = m_Footer
  AbmGen.ResetLayoutMembers
  m_Footer.Properties.Clear
  
  Set c = m_Footer.Properties.Add(c, cscPREFIJO_TABLASubTotal)
  c.PropertyType = cspNumeric
  c.SubType = cspMoney
  c.Name = "Sub Total"
  c.Key = K_SUBTOTAL
  c.Value = m_SubTotal
  c.Format = m_GeneralConfig.FormatDecImporte
  c.Enabled = False
  Set c = Nothing
  
  Set c = m_Footer.Properties.Add(c, cscPREFIJO_TABLAImporteDesc1)
  c.PropertyType = cspNumeric
  c.SubType = cspMoney
  c.Name = "Desc. 1"
  c.Key = K_DESCUENTO1
  c.Value = m_ImporteDesc1
  c.Format = m_GeneralConfig.FormatDecImporte
  c.Enabled = False
  Set c = Nothing
  
  Set c = m_Footer.Properties.Add(c, cscPREFIJO_TABLAImporteDesc2)
  c.PropertyType = cspNumeric
  c.SubType = cspMoney
  c.Name = "Desc. 2"
  c.Key = K_DESCUENTO2
  c.Value = m_ImporteDesc2
  c.Format = m_GeneralConfig.FormatDecImporte
  c.Enabled = False
  Set c = Nothing
  
  Set c = m_Footer.Properties.Add(c, cscPREFIJO_TABLANeto)
  c.PropertyType = cspNumeric
  c.SubType = cspMoney
  c.Name = "Neto"
  c.Key = K_NETO
  c.Value = m_Neto
  c.Format = m_GeneralConfig.FormatDecImporte
  c.Enabled = False
  Set c = Nothing
  
  Set c = m_Footer.Properties.Add(c, cscPREFIJO_TABLAIvari)
  c.PropertyType = cspNumeric
  c.Name = "IVA RI"
  c.SubType = cspMoney
  c.Key = K_IVARI
  c.Value = m_Ivari
  c.Format = m_GeneralConfig.FormatDecImporte
  c.Enabled = False
  Set c = Nothing
  
  Set c = m_Footer.Properties.Add(c, cscPREFIJO_TABLAIvarni)
  c.PropertyType = cspNumeric
  c.Name = "IVA RNI"
  c.SubType = cspMoney
  c.Key = K_IVARNI
  c.Value = m_Ivarni
  c.Format = m_GeneralConfig.FormatDecImporte
  c.Enabled = False
  Set c = Nothing
  
  Set c = m_Footer.Properties.Add(c, cscPREFIJO_TABLATotal)
  c.PropertyType = cspNumeric
  c.Format = m_GeneralConfig.FormatDecImporte
  c.Name = "Total"
  c.SubType = cspMoney
  c.Key = K_TOTAL
  c.Value = m_Total
  c.Enabled = False
  Set c = Nothing
  
  pSetEnabled
  
  If Not m_Footer.Show(Me) Then Exit Function
  
  LoadCollection = True
End Function

Private Function pLoadItems(ByRef Propiedad As cIABMProperty) As Boolean
  Dim sqlstmt As String
  
  Dim rs As ADODB.Recordset
  
  sqlstmt = "sp_DoNOMBRE_CLASEGetItems " & m_Id
  
  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, "pLoadItems", C_Module) Then Exit Function
  
  Dim o As cIABMGridColumn
  
  Propiedad.Grid.Columns.Clear
  Propiedad.Grid.Rows.Clear
  
  Set o = Propiedad.Grid.Columns.Add(Nothing)
  o.Name = "PREFIJO_TBL_ITEM_id"
  o.Visible = False
  o.Key = KI_PREFIJO_TBL_ITEM_ID
  
  Set o = Propiedad.Grid.Columns.Add(Nothing)
  o.Name = "Articulo"
  o.PropertyType = cspHelp
  o.Table = csProducto
  o.Width = 1800
  o.Key = KI_PR_ID
  
  Set o = Propiedad.Grid.Columns.Add(Nothing)
  o.Name = "Descripción"
  o.PropertyType = cspText
  o.Width = 1200
  o.Key = KI_DESCRIP
  
  Set o = Propiedad.Grid.Columns.Add(Nothing)
  o.Name = "Cantidad"
  o.Format = m_GeneralConfig.FormatDecCantidad
  o.PropertyType = cspNumeric
  o.SubType = cspDouble
  o.Width = 1200
  o.Key = KI_CANTIDAD
  
  Set o = Propiedad.Grid.Columns.Add(Nothing)
  o.Name = "Descuento"
  o.PropertyType = cspNumeric
  o.Format = m_GeneralConfig.FormatDecImporte
  o.SubType = cspMoney
  o.Width = 1200
  o.Key = KI_DESCUENTO
  o.Enabled = False
  
  Set o = Propiedad.Grid.Columns.Add(Nothing)
  o.Name = "Unidad"
  o.PropertyType = cspNumeric
  o.SubType = cspMoney
  o.Width = 1200
  o.Key = KI_UNIDAD
  o.Enabled = False
  
  Set o = Propiedad.Grid.Columns.Add(Nothing)
  o.Name = "Precio (LP)"
  o.PropertyType = cspNumeric
  o.SubType = cspMoney
  o.Format = m_GeneralConfig.FormatDecImporte
  o.Width = 1200
  o.Key = KI_PRECIO_LP
  o.Enabled = False

  Set o = Propiedad.Grid.Columns.Add(Nothing)
  o.Name = "Precio"
  o.PropertyType = cspNumeric
  o.SubType = cspMoney
  o.Width = 1200
  o.Format = m_GeneralConfig.FormatDecImporte
  o.Key = KI_PRECIO_USR
  
  Set o = Propiedad.Grid.Columns.Add(Nothing)
  o.Name = "Precio c/desc."
  o.PropertyType = cspNumeric
  o.SubType = cspMoney
  o.Width = 1200
  o.Format = m_GeneralConfig.FormatDecImporte
  o.Key = KI_PRECIO
  o.Enabled = False
  
  Set o = Propiedad.Grid.Columns.Add(Nothing)
  o.Name = "Neto"
  o.PropertyType = cspNumeric
  o.SubType = cspMoney
  o.Format = m_GeneralConfig.FormatDecImporte
  o.Width = 1200
  o.Key = KI_NETO
  o.Enabled = False
  
  Set o = Propiedad.Grid.Columns.Add(Nothing)
  o.Name = "IVA RI"
  o.PropertyType = cspNumeric
  o.SubType = cspMoney
  o.Format = m_GeneralConfig.FormatDecImporte
  o.Width = 1200
  o.Key = KI_IVARI
  o.Enabled = False
  
  Set o = Propiedad.Grid.Columns.Add(Nothing)
  o.Name = "IVA RNI"
  o.PropertyType = cspNumeric
  o.Format = m_GeneralConfig.FormatDecImporte
  o.SubType = cspMoney
  o.Width = 1200
  o.Key = KI_IVARNI
  o.Enabled = False
  
  Set o = Propiedad.Grid.Columns.Add(Nothing)
  o.Name = "Importe"
  o.PropertyType = cspNumeric
  o.Format = m_GeneralConfig.FormatDecImporte
  o.SubType = cspMoney
  o.Width = 1200
  o.Key = KI_IMPORTE
  o.Enabled = False
  
  Set o = Propiedad.Grid.Columns.Add(Nothing)
  o.Name = "% IVA RI"
  o.Format = "00.00"
  o.PropertyType = cspNumeric
  o.SubType = cspMoney
  o.Width = 1200
  o.Visible = False
  o.Key = KI_IVARIPercent
  o.Enabled = False
  
  Set o = Propiedad.Grid.Columns.Add(Nothing)
  o.Name = "% IVA RNI"
  o.Format = "00.00"
  o.PropertyType = cspNumeric
  o.SubType = cspMoney
  o.Width = 1200
  o.Visible = False
  o.Key = KI_IVARNIPercent
  o.Enabled = False
  
  Set o = Propiedad.Grid.Columns.Add(Nothing)
  o.Name = "Centro de Costo"
  o.PropertyType = cspHelp
  o.Table = csCentroCosto
  o.Width = 1800
  o.Key = KI_CCOS_ID
  
  Dim F  As cIABMGridRow
  Dim fv As cIABMGridCellValue
  
  While Not rs.EOF
  
    Set F = Propiedad.Grid.Rows.Add(Nothing, rs(cscPREFIJO_TBL_ITEMId).Value)
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscPREFIJO_TBL_ITEMId)
    fv.Key = KI_PREFIJO_TBL_ITEM_ID
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, CAMPO_NOMBRE_PRODUCTO)
    fv.Id = gDB.ValField(rs.Fields, cscPrId)
    fv.Key = KI_PR_ID
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscPREFIJO_TBL_ITEMDescrip)
    fv.Key = KI_DESCRIP
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscPREFIJO_TBL_ITEMCantidad)
    fv.Key = KI_CANTIDAD
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscPREFIJO_TBL_ITEMDescuento)
    fv.Key = KI_DESCUENTO
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscUnNombre)
    fv.Key = KI_UNIDAD
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscPREFIJO_TBL_ITEMPrecioLista)
    fv.Key = KI_PRECIO_LP
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscPREFIJO_TBL_ITEMPrecioUsr)
    fv.Key = KI_PRECIO_USR
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscPREFIJO_TBL_ITEMPrecio)
    fv.Key = KI_PRECIO
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscPREFIJO_TBL_ITEMNeto)
    fv.Key = KI_NETO

    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscPREFIJO_TBL_ITEMIvari)
    fv.Key = KI_IVARI

    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscPREFIJO_TBL_ITEMIvarni)
    fv.Key = KI_IVARNI

    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscPREFIJO_TBL_ITEMImporte)
    fv.Key = KI_IMPORTE

    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, "iva_ri_porcentaje")
    fv.Key = KI_IVARIPercent

    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, "iva_rni_porcentaje")
    fv.Key = KI_IVARNIPercent
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscCcosNombre)
    fv.Id = gDB.ValField(rs.Fields, cscCcosId)
    fv.Key = KI_CCOS_ID
    
    rs.MoveNext
  Wend
  
  pLoadItems = True
End Function

Private Function Load(ByVal Id As Long) As Boolean

  Dim sqlstmt As String

  sqlstmt = "sp_DoNOMBRE_CLASEGet " & Id & "," & gDB.UserId
  
  Dim rs As Recordset

  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, "Load", "cDepositoLogico") Then Exit Function

  If Not rs.EOF Then

    m_Id = gDB.ValField(rs.Fields, cscPREFIJO_TABLAId)
    m_Numero = gDB.ValField(rs.Fields, cscPREFIJO_TABLANumero)
    m_Nrodoc = gDB.ValField(rs.Fields, cscPREFIJO_TABLANrodoc)
    m_Descrip = gDB.ValField(rs.Fields, cscPREFIJO_TABLADescrip)
    m_Fecha = gDB.ValField(rs.Fields, cscPREFIJO_TABLAFecha)
    m_Fechaentrega = gDB.ValField(rs.Fields, cscPREFIJO_TABLAFechaentrega)
    m_Neto = gDB.ValField(rs.Fields, cscPREFIJO_TABLANeto)
    m_Ivari = gDB.ValField(rs.Fields, cscPREFIJO_TABLAIvari)
    m_Ivarni = gDB.ValField(rs.Fields, cscPREFIJO_TABLAIvarni)
    m_Total = gDB.ValField(rs.Fields, cscPREFIJO_TABLATotal)
    m_SubTotal = gDB.ValField(rs.Fields, cscPREFIJO_TABLASubTotal)
    m_Descuento1 = gDB.ValField(rs.Fields, cscPREFIJO_TABLADescuento1)
    m_Descuento2 = gDB.ValField(rs.Fields, cscPREFIJO_TABLADescuento2)
    m_ImporteDesc1 = gDB.ValField(rs.Fields, cscPREFIJO_TABLAImporteDesc1)
    m_ImporteDesc2 = gDB.ValField(rs.Fields, cscPREFIJO_TABLAImporteDesc2)
    m_CAMPO_CLIENTE_PROVEEDOR = gDB.ValField(rs.Fields, cscCliId)
    m_CAMPO_NOMBRE_CLIENTE_PROVEEDOR = gDB.ValField(rs.Fields, cscCliNombre)
    m_ccos_id = gDB.ValField(rs.Fields, cscCcosId)
    m_CentroCosto = gDB.ValField(rs.Fields, cscCcosNombre)
    m_Suc_id = gDB.ValField(rs.Fields, cscSucId)
    m_Sucursal = gDB.ValField(rs.Fields, cscSucNombre)
    m_doc_id = gDB.ValField(rs.Fields, cscDocId)
    m_Documento = gDB.ValField(rs.Fields, cscDocNombre)
    m_Doct_id = gDB.ValField(rs.Fields, cscDoctId)
    m_Lp_id = gDB.ValField(rs.Fields, cscLpId)
    m_ListaPrecio = gDB.ValField(rs.Fields, cscLpNombre)
    m_Cpg_id = gDB.ValField(rs.Fields, cscCpgId)
    m_CondicionPago = gDB.ValField(rs.Fields, cscCpgNombre)
    m_Ld_id = gDB.ValField(rs.Fields, cscLdId)
    m_ListaDescuento = gDB.ValField(rs.Fields, cscLdNombre)
    m_Creado = gDB.ValField(rs.Fields, cscCreado)
    m_Modificado = gDB.ValField(rs.Fields, cscModificado)
    m_Modifico = gDB.ValField(rs.Fields, cscModifico)
    m_est_id = gDB.ValField(rs.Fields, cscEstId)
    m_Estado = gDB.ValField(rs.Fields, cscEstNombre)
    m_Firmado = gDB.ValField(rs.Fields, cscPREFIJO_TABLAFirmado)

    m_DocEditable = gDB.ValField(rs.Fields, cscDocEditable)
    m_DocEditMsg = gDB.ValField(rs.Fields, cscDoceditMsg)

    m_LastDoc = m_doc_id
    LAST_CLIENTE_PROVEEDOR = m_CAMPO_CLIENTE_PROVEEDOR
    m_LastDocName = m_Documento
    LAST_CLIENTE_PROVEEDORName = m_CAMPO_NOMBRE_CLIENTE_PROVEEDOR

  Else
    m_Id = csNO_ID
    m_Numero = 0
    m_Nrodoc = ""
    m_Descrip = ""
    m_Fecha = VDGetDateById(csToday)
    m_Fechaentrega = VDGetDateById(csTomorrow)
    m_Neto = 0
    m_Ivari = 0
    m_Ivarni = 0
    m_Total = 0
    m_SubTotal = 0
    m_Descuento1 = 0
    m_Descuento2 = 0
    m_ImporteDesc1 = 0
    m_ImporteDesc2 = 0
    m_CAMPO_CLIENTE_PROVEEDOR = csNO_ID
    m_CAMPO_NOMBRE_CLIENTE_PROVEEDOR = ""
    m_ccos_id = csNO_ID
    m_CentroCosto = ""
    m_doc_id = csNO_ID
    m_Documento = ""
    m_Doct_id = csNO_ID
    m_Lp_id = csNO_ID
    m_Ld_id = csNO_ID
    m_Cpg_id = csNO_ID
    m_CondicionPago = ""
    m_ListaPrecio = ""
    m_ListaDescuento = ""
    m_Creado = csNoDate
    m_Modificado = csNoDate
    m_Modifico = 0
    m_est_id = csNO_ID
    m_Estado = ""
    m_Suc_id = csNO_ID
    m_Sucursal = ""
    m_Firmado = False
  
    m_doc_id = m_LastDoc
    m_CAMPO_CLIENTE_PROVEEDOR = LAST_CLIENTE_PROVEEDOR
    m_CAMPO_NOMBRE_CLIENTE_PROVEEDOR = LAST_CLIENTE_PROVEEDORName
    m_Documento = m_LastDocName
  
    m_DocEditable = True
    m_DocEditMsg = ""
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
  m_Host.Server.AddMenu "MENU_MAIN_DOCUMENTO", csMenuEnum.MENU_MAIN_ID, "", 1, False, False, False, True, False, Nothing
  m_Host.Server.AddMenu "&TITULO_CLASE", csPREFIJO_PRESTACIONListNOMBRE_PRESTACION, "MENU_MAIN_DOCUMENTO", 0, True, False, False, False, False, Me
  cIMenuClient_Initialize = True
  
  GoTo ExitProc
ControlError:
  MngError Err, "cIMenuClient_Initialize", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Private Function cIMenuClient_ProcessMenu(ByVal Id As Long) As Variant
  m_Host.MenuListDocClick "CSABMInterface.CABMGeneric", "CSNOMBRE_DLL.NOMBRE_CLASE", "CSABMInterface.CABMGenericListDoc", "CSNOMBRE_DLL.NOMBRE_CLASEListDoc", Me, "TITULO_CLASE", 0
End Function

Private Function pSaveItems(ByVal Id As Long) As Boolean
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
            register.fieldId = cscPREFIJO_TBL_ITEMTMPId
            register.Table = csTNOMBRE_TABLAItemTMP
            register.Id = csNew
            
            For Each Cell In Row
              Select Case Cell.Key
                
                Case KI_PREFIJO_TBL_ITEM_ID
                  If m_Copy Then
                    register.Fields.Add2 cscPREFIJO_TBL_ITEMId, csNew, csInteger
                  Else
                    register.Fields.Add2 cscPREFIJO_TBL_ITEMId, Val(Cell.Value), csInteger
                  End If
                Case KI_CANTIDAD
                  register.Fields.Add2 cscPREFIJO_TBL_ITEMCantidad, Cell.Value, csDouble
                Case KI_DESCRIP
                  register.Fields.Add2 cscPREFIJO_TBL_ITEMDescrip, Cell.Value, csText
                Case KI_PRECIO
                  register.Fields.Add2 cscPREFIJO_TBL_ITEMPrecio, Cell.Value, csCurrency
                Case KI_PRECIO_LP
                  register.Fields.Add2 cscPREFIJO_TBL_ITEMPrecioLista, Cell.Value, csCurrency
                Case KI_PRECIO_USR
                  register.Fields.Add2 cscPREFIJO_TBL_ITEMPrecioUsr, Cell.Value, csCurrency
                Case KI_IMPORTE
                  register.Fields.Add2 cscPREFIJO_TBL_ITEMImporte, Cell.Value, csCurrency
                Case KI_NETO
                  register.Fields.Add2 cscPREFIJO_TBL_ITEMNeto, Cell.Value, csCurrency
                Case KI_IVARI
                  register.Fields.Add2 cscPREFIJO_TBL_ITEMIvari, Cell.Value, csCurrency
                Case KI_IVARNI
                  register.Fields.Add2 cscPREFIJO_TBL_ITEMIvarni, Cell.Value, csCurrency
                Case KI_IVARIPercent
                  register.Fields.Add2 cscPREFIJO_TBL_ITEMIvariPorc, Cell.Value, csDouble
                Case KI_IVARNIPercent
                  register.Fields.Add2 cscPREFIJO_TBL_ITEMIvarniPorc, Cell.Value, csDouble
                Case KI_PR_ID
                  register.Fields.Add2 cscPrId, Cell.Id, csId
                Case KI_CCOS_ID
                  register.Fields.Add2 cscCcosId, Cell.Id, csId
              End Select
            Next
            
            iOrden = iOrden + 1
            register.Fields.Add2 cscPREFIJO_TBL_ITEMOrden, iOrden, csInteger
            register.Fields.Add2 cscPREFIJO_TABLATMPId, Id, csId
            
            register.Fields.HaveLastUpdate = False
            register.Fields.HaveWhoModify = False
            
            If Not gDB.Save(register, , "pSaveItems", "NOMBRE_CLASE", "TITULO_ERROR_GRABAR") Then Exit Function
          Next
      End Select
    End With
  Next
  
  Dim sqlstmt As String
  
  If m_ItemsDeleted <> "" And m_Id <> csNO_ID Then
  
    Dim vDeletes As Variant
    Dim i As Long
    
    m_ItemsDeleted = RemoveLastColon(m_ItemsDeleted)
    vDeletes = Split(m_ItemsDeleted, ",")
    
    For i = 0 To UBound(vDeletes)
    
      Set register = New cRegister
      register.fieldId = cscPREFIJO_TBL_ITEMbTMPId
      register.Table = csTNOMBRE_TABLAItemBorradoTMP
      register.Id = csNew
      
      register.Fields.Add2 cscPREFIJO_TBL_ITEMId, Val(vDeletes(i)), csInteger
      register.Fields.Add2 cscPREFIJO_TABLAId, m_Id, csId
      
      register.Fields.HaveLastUpdate = False
      register.Fields.HaveWhoModify = False
      
      If Not gDB.Save(register, , "pSaveItems", "NOMBRE_CLASE", "TITULO_ERROR_GRABAR") Then Exit Function
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
  
  Neto = Val(pGetCellFromKey(Row, KI_CANTIDAD).Value) * Val(pGetCellFromKey(Row, KI_PRECIO).Value)
  IvaRi = (Neto * Val(pGetCellFromKey(Row, KI_IVARIPercent).Value)) / 100
  IvaRni = (Neto * Val(pGetCellFromKey(Row, KI_IVARNIPercent).Value)) / 100
  Importe = Neto + IvaRi + IvaRni
  
  pGetCellFromKey(Row, KI_NETO).Value = Neto
  pGetCellFromKey(Row, KI_IVARI).Value = IvaRi
  pGetCellFromKey(Row, KI_IVARNI).Value = IvaRni
  pGetCellFromKey(Row, KI_IMPORTE).Value = Importe
End Sub
  
Private Sub pShowTotales(ByRef Rows As CSInterfacesABM.cIABMGridRows)
  Dim Neto      As Double
  Dim IvaRi     As Double
  Dim IvaRni    As Double
  Dim Desc1     As Double
  Dim Desc2     As Double
  
  Dim Row       As CSInterfacesABM.cIABMGridRow
  
  For Each Row In Rows
    Neto = Neto + Val(pGetCellFromKey(Row, KI_NETO).Value)
    IvaRi = IvaRi + Val(pGetCellFromKey(Row, KI_IVARI).Value)
    IvaRni = IvaRni + Val(pGetCellFromKey(Row, KI_IVARNI).Value)
  Next
  
  m_Footer.Properties(cscPREFIJO_TABLASubTotal).Value = Neto
  
  Desc1 = m_ObjAbm.Properties(cscPREFIJO_TABLADescuento1).Value
  Desc2 = m_ObjAbm.Properties(cscPREFIJO_TABLADescuento2).Value
  
  Desc1 = Neto * Desc1 / 100
  m_Footer.Properties(cscPREFIJO_TABLAImporteDesc1).Value = Desc1
  
  Neto = Neto - Desc1
  
  Desc2 = Neto * Desc2 / 100
  m_Footer.Properties(cscPREFIJO_TABLAImporteDesc2).Value = Desc2
  
  Neto = Neto - Desc2
  
  m_Footer.Properties(cscPREFIJO_TABLANeto).Value = Neto
  m_Footer.Properties(cscPREFIJO_TABLAIvari).Value = IvaRi
  m_Footer.Properties(cscPREFIJO_TABLAIvarni).Value = IvaRni
  m_Footer.Properties(cscPREFIJO_TABLATotal).Value = Neto + IvaRni + IvaRi
  
  m_Footer.RefreshControls
End Sub

Private Sub pSetTasasImpositivas(ByRef Row As CSInterfacesABM.cIABMGridRow, ByVal PR_ID As Long, ByVal pr_nombre As String)
  Dim PR       As cProducto
  Dim ti_ri    As Long
  Dim ti_rni   As Long
  
  Set PR = New cProducto
  
  If PR_ID = 0 Then Exit Sub
  
  ti_ri = PR.GetData(PR_ID, cscPrTiIdRiCAMPOTIID, csId)
  ti_rni = PR.GetData(PR_ID, cscPrTiIdRniCAMPOTIID, csId)
  
  If ti_ri = 0 Then
    MsgWarning "IVA_MSG_RI"
    Exit Sub
  End If
  
  If ti_rni = 0 Then
    MsgWarning "IVA_MSG_RNI"
    Exit Sub
  End If
  
  Dim ti As cTasaImpositiva
  Set ti = New cTasaImpositiva
  
  pGetCellFromKey(Row, KI_IVARIPercent).Value = Val(ti.Data(ti_ri, cscTiPorcentaje))
  pGetCellFromKey(Row, KI_IVARNIPercent).Value = Val(ti.Data(ti_rni, cscTiPorcentaje))
End Sub

Private Sub pSetDataProducto(ByRef Row As CSInterfacesABM.cIABMGridRow, ByVal PR_ID As Long)
  Dim sqlstmt As String
  Dim rs      As Recordset
  
  sqlstmt = "select un_nombre from producto, unidad where CAMPO_UNIDAD = un_id and pr_id = " & PR_ID
  
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Sub
  
  If Not rs.EOF Then
    pGetCellFromKey(Row, KI_UNIDAD).Value = gDB.ValField(rs.Fields, cscUnNombre)
  End If
End Sub

Private Sub pSetPrecios(ByRef Row As CSInterfacesABM.cIABMGridRow, ByVal PR_ID As Long)
  Dim LP        As cListaPrecio
  Dim LP_ID     As Long
  Dim Precio    As Double
  
  LP_ID = m_ObjAbm.Properties(cscLpId).HelpId
    
  If LP_ID <> 0 Then
    Set LP = New cListaPrecio
    Precio = LP.GetPrecio(LP_ID, PR_ID)
  End If
  
  pGetCellFromKey(Row, KI_PRECIO_LP).Value = Precio
  pGetCellFromKey(Row, KI_PRECIO_USR).Value = Precio
End Sub

Private Sub pSetDescuentos(ByRef Row As CSInterfacesABM.cIABMGridRow, ByVal PR_ID As Long, ByVal Precio As Double)
  Dim LD        As cListaDescuento
  Dim LD_ID     As Long
  Dim Descuento As String
  
  LD_ID = m_ObjAbm.Properties(cscLdId).HelpId
  
  If LD_ID <> 0 Then
    Set LD = New cListaDescuento
    Precio = LD.GetPrecio(LD_ID, PR_ID, Precio)
    Descuento = LD.GetDescuentoStr(LD_ID, PR_ID)
  End If
  
  pGetCellFromKey(Row, KI_PRECIO).Value = Precio
  pGetCellFromKey(Row, KI_DESCUENTO).Value = Descuento
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
    
      If bState And Prop.Key <> K_NRODOC Then
        Prop.Enabled = bState
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

Private Sub pSetDatosCAMPO_NOMBRE_CLIENTE_PROVEEDOR()
  Dim CL        As cCAMPO_NOMBRE_CLIENTE_PROVEEDOR
  Dim LP_ID     As Long
  Dim LD_ID     As Long
  Dim CPG_ID    As Long
  Dim CondPago  As cCondicionPago
  Dim LP        As cListaPrecio
  Dim LD        As cListaDescuento
  Dim iProp     As cIABMProperty
  Dim Filter    As String
  
  With m_ObjAbm.Properties.Item(cscCliId)
    If LAST_CLIENTE_PROVEEDOR = .HelpId Then
      Exit Sub
    End If
    LAST_CLIENTE_PROVEEDOR = .HelpId
  End With

  Set CL = New cCAMPO_NOMBRE_CLIENTE_PROVEEDOR
  
  ' Condicion de pago
  CPG_ID = CL.GetData(LAST_CLIENTE_PROVEEDOR, cscCpgId, csId)
  If CPG_ID <> csNO_ID Then
    Set CondPago = New cCondicionPago
    Set iProp = m_ObjAbm.Properties.Item(cscCpgId)
    iProp.Value = CondPago.GetData(CPG_ID, cscCpgNombre, csText)
    iProp.HelpId = CPG_ID
    
    m_ObjAbm.ShowValue iProp
  End If
  
  ' Lista de precios
  Set iProp = m_ObjAbm.Properties.Item(cscLpId)
  
  Filter = "exists(select lp_id from listaprecioCAMPO_NOMBRE_CLIENTE_PROVEEDOR where CAMPO_CLIENTE_PROVEEDOR =" & LAST_CLIENTE_PROVEEDOR
  Filter = Filter & " and lp_id = listaprecio.lp_id)"
  
  iProp.HelpFilter = Filter
  
  LP_ID = CL.GetData(LAST_CLIENTE_PROVEEDOR, cscLpId, csId)
  If LP_ID <> csNO_ID Then
    Set LP = New cListaPrecio
    iProp.Value = LP.GetData(LP_ID, cscLpNombre, csText)
    iProp.HelpId = LP_ID
  End If
  
  m_ObjAbm.ShowValue iProp
  
  ' Lista de descuentos
  Set iProp = m_ObjAbm.Properties.Item(cscLdId)
  
  Filter = "exists(select ld_id from listadescuentoCAMPO_NOMBRE_CLIENTE_PROVEEDOR where CAMPO_CLIENTE_PROVEEDOR =" & LAST_CLIENTE_PROVEEDOR
  Filter = Filter & " and ld_id = listadescuento.ld_id)"
  
  iProp.HelpFilter = Filter
  
  LD_ID = CL.GetData(LAST_CLIENTE_PROVEEDOR, cscLdId, csId)
  If LD_ID <> csNO_ID Then
    Set LD = New cListaDescuento
    iProp.Value = LD.GetData(LD_ID, cscLdNombre, csText)
    iProp.HelpId = LD_ID
  End If
  
  m_ObjAbm.ShowValue iProp
End Sub

Private Sub pGetDocNumber()
  Dim Tl          As cTalonario
  Dim Doc         As cDocumento
  Dim TAL_ID      As Long
  Dim iProp       As cIABMProperty
  Dim Mask        As String
  Dim bEditable   As Boolean
  
  With m_ObjAbm.Properties.Item(cscDocId)
    If m_LastDoc = .HelpId And Not m_Copy Then
      Exit Sub
    End If
    m_LastDoc = .HelpId
  End With
  
  Set Tl = New cTalonario
  Set Doc = New cDocumento
  
  TAL_ID = Doc.GetData(m_LastDoc, cscTaNOMBRE_PRESTACION, csId)
  
  Set iProp = m_ObjAbm.Properties.Item(cscPREFIJO_TABLANrodoc)
  iProp.Value = Tl.GetNextNumber(TAL_ID, Mask, bEditable)
  iProp.TextMask = Mask
  iProp.Enabled = bEditable
  
  m_ObjAbm.ShowValue iProp
End Sub

Private Function pFirmar() As Boolean
  Dim Doc     As cDocumento
  Dim us_id   As Long
  
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
  
  If Not Doc.Firmar(m_doc_id, us_id) Then Exit Function
  
  Dim sqlstmt As String
  Dim rs      As Recordset
  
  sqlstmt = "sp_DoNOMBRE_CLASEFirmar " & m_Id & "," & us_id
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Function
  
  m_est_id = gDB.ValField(rs.Fields, cscEstId)
  m_Estado = gDB.ValField(rs.Fields, cscEstNombre)
  
  Dim iProp As cIABMProperty
  Set iProp = m_ObjAbm.Properties(csDocEstateID)
  
  With iProp
    .HelpId = m_est_id
    .Value = m_Estado
  End With
  
  gDB.GetData csTNOMBRE_TABLA, cscPREFIJO_TABLAId, m_Id, cscPREFIJO_TABLAFirmado, m_Firmado
  
  m_ObjAbm.ShowValue iProp
  
  pFirmar = True
End Function

Private Function pAnular() As Boolean
  Dim Doc     As cDocumento
  Dim us_id   As Long
  Dim bAnular As Boolean
  
  Set Doc = New cDocumento
  
  If m_Id = csNO_ID Then
    MsgWarning "Antes de poder anular el documento debe guardarlo."
    Exit Function
  End If
  
  If m_est_id = csEEst_Anulado Then
    If Not Ask("El documento ya ha sido anulado.;;¿Desea des-anularlo?", vbYes, "Anular") Then
      Exit Function
    End If
    If Not SecurityCanAccess(csPREFIJO_PRESTACIONDesAnular) Then Exit Function
    bAnular = False
  Else
    If Not SecurityCanAccess(csPREFIJO_PRESTACIONAnular) Then Exit Function
    bAnular = True
  End If
  
  Dim sqlstmt As String
  Dim rs      As Recordset
  
  If bAnular Then
    sqlstmt = "sp_DoNOMBRE_CLASEAnular " & m_Id & ",1,1"
  Else
    sqlstmt = "sp_DoNOMBRE_CLASEAnular " & m_Id & ",0,1"
  End If
  
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Function
  
  m_est_id = gDB.ValField(rs.Fields, cscEstId)
  m_Estado = gDB.ValField(rs.Fields, cscEstNombre)
  
  Dim iProp As cIABMProperty
  Set iProp = m_ObjAbm.Properties(csDocEstateID)
  
  With iProp
    .HelpId = m_est_id
    .Value = m_Estado
  End With
  
  m_ObjAbm.ShowValue iProp
  
  pAnular = True
End Function

Private Function pMove(ByVal MoveTo As ABM_MSG) As Boolean
  Dim sqlstmt As String
  Dim rs      As Recordset
  Dim doc_id  As Long
  
  doc_id = m_ObjAbm.Properties(cscDocId).HelpId
  
  If doc_id = csNO_ID Then MsgInfo "Debe seleccionar un documento"
  
  sqlstmt = "sp_DoNOMBRE_CLASEMover " & MoveTo & "," & m_Numero & "," & doc_id
  
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Function
  
  If rs.EOF Then
    
    Select Case MoveTo
      Case MSG_DOC_NEXT
        pMove MSG_DOC_LAST
      Case MSG_DOC_PREVIOUS
        pMove MSG_DOC_FIRST
      Case MSG_DOC_FIRST, MSG_DOC_LAST
        Load csNO_ID
        pRefreshProperties
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
  Dim Filter  As String
  
  Set c = m_ObjAbm.Properties.Item(cscDocId)
  c.HelpId = m_doc_id
  c.Value = m_Documento
  
  Set c = m_ObjAbm.Properties.Item(cscPREFIJO_TABLAFecha)
  c.Value = m_Fecha
  
  Set c = m_ObjAbm.Properties.Item(cscPREFIJO_TABLAFechaentrega)
  c.Value = m_Fechaentrega
  
  Set c = m_ObjAbm.Properties.Item(cscCliId)
  c.HelpId = m_CAMPO_CLIENTE_PROVEEDOR
  c.Value = m_CAMPO_NOMBRE_CLIENTE_PROVEEDOR
  
  Set c = m_ObjAbm.Properties.Item(csDocNumberID)
  c.Value = m_Numero
  
  Set c = m_ObjAbm.Properties.Item(csDocEstateID)
  c.Value = m_Estado
  
  Set c = m_ObjAbm.Properties.Item(cscPREFIJO_TABLANrodoc)
  c.Value = m_Nrodoc
  c.TextAlign = vbRightJustify
  
  Set c = m_ObjAbm.Properties.Item(cscPREFIJO_TABLADescuento1)
  c.Value = m_Descuento1
  
  Set c = m_ObjAbm.Properties.Item(cscPREFIJO_TABLADescuento2)
  c.Value = m_Descuento2
  
  Set c = m_ObjAbm.Properties.Item(cscCpgId)
  c.HelpId = m_Cpg_id
  c.Value = m_CondicionPago
  
  Set c = m_ObjAbm.Properties.Item(cscLpId)
  Filter = "exists(select lp_id from listaprecioCAMPO_NOMBRE_CLIENTE_PROVEEDOR where CAMPO_CLIENTE_PROVEEDOR =" & m_CAMPO_CLIENTE_PROVEEDOR
  Filter = Filter & " and lp_id = listaprecio.lp_id)"
  c.HelpFilter = Filter
  c.HelpId = m_Lp_id
  c.Value = m_ListaPrecio
  
  Set c = m_ObjAbm.Properties.Item(cscLdId)
  Filter = "exists(select ld_id from listadescuentoCAMPO_NOMBRE_CLIENTE_PROVEEDOR where CAMPO_CLIENTE_PROVEEDOR =" & m_CAMPO_CLIENTE_PROVEEDOR
  Filter = Filter & " and ld_id = listadescuento.ld_id)"
  c.HelpFilter = Filter
  c.HelpId = m_Ld_id
  c.Value = m_ListaDescuento
  
  Set c = m_ObjAbm.Properties.Item(cscCcosId)
  c.HelpId = m_ccos_id
  c.Value = m_CentroCosto
  
  Set c = m_ObjAbm.Properties.Item(cscSucId)
  c.HelpId = m_Suc_id
  c.Value = m_Sucursal
  
  Set c = m_ObjAbm.Properties.Item(cscPREFIJO_TABLADescrip)
  c.Value = m_Descrip
  
  Set AbmGen = m_ObjAbm
  AbmGen.ShowValues m_ObjAbm.Properties
  
  Set c = m_Items.Properties.Item(C_Items)
  If Not pLoadItems(c) Then Exit Sub
  
  m_ItemsDeleted = ""
  
  Set AbmGen = m_Items
  AbmGen.ShowValues m_Items.Properties
  
  Set c = m_Footer.Properties.Item(cscPREFIJO_TABLASubTotal)
  c.Value = m_SubTotal
  
  Set c = m_Footer.Properties.Item(cscPREFIJO_TABLAImporteDesc1)
  c.Value = m_ImporteDesc1
  
  Set c = m_Footer.Properties.Item(cscPREFIJO_TABLAImporteDesc2)
  c.Value = m_ImporteDesc2
  
  Set c = m_Footer.Properties.Item(cscPREFIJO_TABLANeto)
  c.Value = m_Neto
  
  Set c = m_Footer.Properties.Item(cscPREFIJO_TABLAIvari)
  c.Value = m_Ivari
  
  Set c = m_Footer.Properties.Item(cscPREFIJO_TABLAIvarni)
  c.Value = m_Ivarni
  
  Set c = m_Footer.Properties.Item(cscPREFIJO_TABLATotal)
  c.Value = m_Total
  
  Set AbmGen = m_Footer
  AbmGen.ShowValues m_Footer.Properties
  
  pSetEnabled
End Sub

' Construccion - Destruccion
Private Sub Class_Initialize()
  Set m_GeneralConfig = New cGeneralConfig
  m_GeneralConfig.Load
End Sub

Private Sub Class_Terminate()
  Set m_ObjAbm = Nothing
  Set m_ObjTree = Nothing
  Set m_Footer = Nothing
  Set m_Items = Nothing
End Sub

