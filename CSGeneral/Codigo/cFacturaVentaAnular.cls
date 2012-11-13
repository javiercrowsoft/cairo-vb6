VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cFacturaVentaAnular"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements CSInterfacesABM.cIABMClient
Implements CSMenu.cIMenuClient
'--------------------------------------------------------------------------------
' cFacturaVentaAnular
' 09-01-2006

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cFacturaVentaAnular"

Private Const cscDocId = "doc_id"
Private Const cscPrId = "pr_id"
Private Const cscCliId = "cli_id"
Private Const cscSucId = "suc_id"
Private Const cscFvFecha = "fv_fecha"
Private Const cscFvFechaIva = "fv_fechaIva"

Private Const c_desde = "desde"
Private Const c_hasta = "hasta"
Private Const c_Progress = "prg"

Private Const K_FECHA = 1
Private Const K_DOCUMENTO = 2
Private Const K_CLI_ID = 3
Private Const K_DESDE = 4
Private Const K_HASTA = 5
Private Const K_PR_ID = 6
Private Const K_LABEL = 7
Private Const K_PROGRESS = 8
Private Const K_CANCEL = 9
Private Const K_NRODOC = 10
Private Const K_SUC_ID = 11
Private Const K_COTIZ = 12

Private Const c_ErrorSaveFactura = "Error al anular la factura de venta"

Private Const cscToId                               As String = "to_id"

Private Const cscCliNombre                          As String = "cli_nombre"

Private Const cscCcosId                             As String = "ccos_id"

Private Const cscDocNombre                          As String = "doc_nombre"

Private Const cscLpId                               As String = "lp_id"
Private Const cscLdId                               As String = "ld_id"
Private Const cscCpgId                              As String = "cpg_id"
Private Const cscVenId                              As String = "ven_id"
Private Const cscLgjId                              As String = "lgj_Id"
Private Const cscProIdOrigen                        As String = "pro_id_origen"
Private Const cscProIdDestino                       As String = "pro_id_destino"
Private Const cscTransId                            As String = "trans_id"
Private Const cscDeplId                             As String = "depl_id"
Private Const cscEstId                              As String = "est_id"

Private Const cscCueidventa                         As String = "cue_id_venta"

Private Const cscTiPorcentaje                       As String = "ti_porcentaje"

' FacturaVenta
Private Const csTFacturaVenta                    As String = "FacturaVenta"
Private Const cscFvId                            As String = "fv_id"
Private Const cscFvNumero                        As String = "fv_numero"
Private Const cscFvNrodoc                        As String = "fv_nrodoc"
Private Const cscFvDescrip                       As String = "fv_descrip"
Private Const cscFvFechaentrega                  As String = "fv_fechaentrega"
Private Const cscFvNeto                          As String = "fv_neto"
Private Const cscFvIvari                         As String = "fv_ivari"
Private Const cscFvIvarni                        As String = "fv_ivarni"
Private Const cscFvSubtotal                      As String = "fv_subtotal"
Private Const cscFvTotal                         As String = "fv_total"
Private Const cscFvTotalOrigen                   As String = "fv_totalorigen"
Private Const cscFvPendiente                     As String = "fv_pendiente"
Private Const cscFvFirmado                       As String = "fv_firmado"
Private Const cscFvDescuento1                    As String = "fv_descuento1"
Private Const cscFvDescuento2                    As String = "fv_descuento2"
Private Const cscFvImportedesc1                  As String = "fv_importedesc1"
Private Const cscFvImportedesc2                  As String = "fv_importedesc2"
Private Const cscFvGrabarAsiento                 As String = "fv_grabarasiento"
Private Const cscFvCotizacion                    As String = "fv_cotizacion"
Private Const cscFvCai                           As String = "fv_cai"

' FacturaVentaTMP
Private Const csTFacturaVentaTMP                  As String = "FacturaVentaTMP"
Private Const cscFvTMPId                          As String = "fvTMP_id"

' FacturaVentaItem
Private Const csTFacturaVentaItem                      As String = "FacturaVentaItem"
Private Const cscFviId                                 As String = "fvi_id"
Private Const cscFviOrden                              As String = "fvi_orden"
Private Const cscFviCantidad                           As String = "fvi_cantidad"
Private Const cscFviCantidadaremitir                   As String = "fvi_cantidadaremitir"
Private Const cscFviPendiente                          As String = "fvi_pendiente"
Private Const cscFviDescrip                            As String = "fvi_descrip"
Private Const cscFviPrecio                             As String = "fvi_precio"
Private Const cscFviPrecioUsr                          As String = "fvi_precioUsr"
Private Const cscFviPrecioLista                        As String = "fvi_precioLista"
Private Const cscFviDescuento                          As String = "fvi_descuento"
Private Const cscFviNeto                               As String = "fvi_neto"
Private Const cscFviIvari                              As String = "fvi_ivari"
Private Const cscFviIvarni                             As String = "fvi_ivarni"
Private Const cscFviIvariporc                          As String = "fvi_ivariporc"
Private Const cscFviIvarniporc                         As String = "fvi_ivarniporc"
Private Const cscFviImporteOrigen                      As String = "fvi_importeorigen"
Private Const cscFviImporte                            As String = "fvi_importe"
Private Const cscCueIdIvaRI                            As String = "cue_id_IvaRI"
Private Const cscCueIdIvaRNI                           As String = "cue_id_IvaRNI"

' FacturaVentaItemTMP
Private Const csTFacturaVentaItemTMP                   As String = "FacturaVentaItemTMP"
Private Const cscFviTMPId                              As String = "fviTMP_id"

' estructuras
' variables privadas
Private m_Editing           As Boolean
Private m_Host              As CSMenu.cIMenuHost
Private m_ObjAbm            As cIABMGeneric

Private m_bCancel           As Boolean
' eventos
' propiedades publicas
' propiedades friend
' propiedades privadas
' funciones publicas
Private Function cIABMClient_Copy() As Boolean
End Function

Private Function cIABMClient_EditNew() As Boolean
End Function

Private Property Get cIABMClient_Aplication() As String
  cIABMClient_Aplication = gAppName
End Property

Private Property Get cIABMClient_CanAddDocDigital() As Boolean
  cIABMClient_CanAddDocDigital = False
End Property

Private Property Get cIABMClient_CanCopy() As Boolean
  cIABMClient_CanCopy = False
End Property

Private Property Get cIABMClient_CanNew() As Boolean
  cIABMClient_CanNew = False
End Property

Private Function cIABMClient_ShowDocDigital() As Boolean
  cIABMClient_ShowDocDigital = False
End Function

Private Function cIABMClient_MessageEx(ByVal MessageID As Long, ByVal Info As Variant) As Variant
  cIABMClient_MessageEx = True
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
    Case K_CANCEL
      If Ask(LNGGetText(2973, vbNullString), vbNo) Then
            'Confirma que desea cancelar
        m_bCancel = True
      End If
  End Select
End Function

Private Function cIABMClient_Save() As Boolean
  On Error GoTo ControlError
  
  Dim Mouse As cMouseWait
  
  Set Mouse = New cMouseWait
  
  m_bCancel = False
  
  Dim cli_id      As Long
  Dim doc_id      As Long
  Dim suc_id      As Long
  Dim pr_id       As Long
  Dim fecha       As Date
  Dim cotiz       As Double
  
  doc_id = m_ObjAbm.Properties.Item(cscDocId).HelpId
  suc_id = m_ObjAbm.Properties.Item(cscSucId).HelpId
  pr_id = m_ObjAbm.Properties.Item(cscPrId).HelpId
  fecha = m_ObjAbm.Properties.Item(cscFvFecha).Value
  cotiz = Val(m_ObjAbm.Properties.Item(cscFvCotizacion).Value)
  cli_id = m_ObjAbm.Properties.Item(cscCliId).HelpId
  
  Dim ivaRiPorc       As Double
  Dim ivaRniPorc      As Double
  Dim cue_idProducto  As Long
  Dim cue_idIvaRi     As Long
  Dim cue_idIvaRni    As Long
  Dim bIva            As Boolean
  Dim bIvaRni         As Boolean
                             
  If Not pSetDataProducto(cue_idProducto, ivaRiPorc, _
                          ivaRniPorc, cue_idIvaRi, _
                          cue_idIvaRni, cli_id) Then
    MsgWarning LNGGetText(3133, vbNullString, m_ObjAbm.Properties.Item(cscPrId).Value)
              'No se pudo obtener la información impositiva y contable asociada al artículo & _
               m_ObjAbm.Properties.Item(cscPrId).Value
    Exit Function
  End If
  
  If Not pGetCliente(cli_id, bIva, bIvaRni) Then
    MsgWarning LNGGetText(3133, vbNullString)
                'No se pudo encontrar la definición de IVA para el Cliente
    Exit Function
  End If
  
  Dim count  As Long
  Dim i      As Long
  Dim nroDoc As Long
  Dim iProg  As cIABMProperty
  
  ' TODO: obtener cantidad de facturas a anular
  With m_ObjAbm.Properties
    nroDoc = Val(.Item(c_desde).Value)
    If nroDoc < 0 Then
      MsgWarning LNGGetText(3135, vbNullString)
                'Debe indicar un 'Número Desde' mayor a cero
      Exit Function
    End If
    If Val(.Item(c_hasta).Value) < 0 Then
      MsgWarning LNGGetText(3136, vbNullString)
                  'Debe indicar un 'Número Hasta' mayor a cero
      Exit Function
    End If
    count = Val(.Item(c_hasta).Value) - nroDoc + 1
    Set iProg = .Item(c_Progress)
  End With
  
  Set Mouse = Nothing
  
  Dim mouseex As cMouse
  Set mouseex = New cMouse
  
  mouseex.MouseSet vbArrowHourglass
  
  Dim ivaRi       As Double
  Dim ivaRni      As Double
  Dim ivaRiPorc2  As Double
  Dim ivaRniPorc2 As Double
  
  Const saldo As Double = 1
  
  If bIva Then
    ivaRi = saldo * ivaRiPorc / 100
    ivaRiPorc2 = ivaRiPorc
  Else
    ivaRi = 0
    ivaRiPorc2 = 0
  End If
  
  If bIvaRni Then
    ivaRni = saldo * ivaRniPorc / 100
    ivaRniPorc2 = ivaRniPorc
  Else
    ivaRni = 0
    ivaRniPorc2 = 0
  End If
  
  For i = 1 To count
    
    If Not pSave(cli_id, doc_id, suc_id, fecha, cotiz, _
                 saldo, ivaRi, ivaRni, ivaRiPorc2, ivaRniPorc2, _
                 cue_idProducto, cue_idIvaRi, cue_idIvaRni, pr_id, nroDoc) Then
      
      MsgWarning CSKernelClient2.LastErrorDescription
    End If
    
    nroDoc = nroDoc + 1
    iProg.Value = DivideByCero(i, count) * 100
    m_ObjAbm.ShowValue iProg
    DoEvents
    
    If m_bCancel Then Exit Function
    
  Next
  
  MsgInfo LNGGetText(3137, vbNullString)  'Las Facturas se anularon con éxito
  
  cIABMClient_Save = False

  GoTo ExitProc
ControlError:
  MngError Err, "cIABMClient_Save", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Private Function pGetCliente(ByVal cli_id As Long, _
                             ByRef bIva As Boolean, _
                             ByRef bIvaRni As Boolean) As Boolean
                             
  If Not pGetIvaFromCliente(cli_id, bIva, bIvaRni) Then
    Exit Function
  End If
  
  pGetCliente = True
End Function

Private Function cIABMClient_Terminate() As Boolean
  m_Editing = False
  cIABMClient_Terminate = True
End Function

Private Property Get cIABMClient_Title() As String
  cIABMClient_Title = LNGGetText(3138, vbNullString)  'Anulación Masiva de Facturas
End Property

Private Function cIABMClient_Validate() As Boolean

  Dim IProperty As cIABMProperty

  CSKernelClient2.Title = LNGGetText(3139, vbNullString)  'Importar Saldos Iniciales

  For Each IProperty In m_ObjAbm.Properties
    With IProperty
      Select Case .Key
        Case K_FECHA
          If Not IsDate(.Value) Then
            MsgWarning LNGGetText(1558, vbNullString)  'Debe indicar una fecha
            Exit Function
          End If
        Case K_DOCUMENTO
          If .HelpId = csNO_ID Then
            MsgWarning LNGGetText(3140, vbNullString)
                       'Debe indicar un documento para los Saldos Positivos
            Exit Function
          End If
        Case K_PR_ID
          If .HelpId = csNO_ID Then
            MsgWarning LNGGetText(3141, vbNullString)
                       'Debe indicar un artículo para guardar los Movimientos
            Exit Function
          End If
        Case K_COTIZ
          If Val(.Value) < 0 Then
            MsgWarning LNGGetText(3142, vbNullString)
                       'La cotización no puede ser menor a cero. Si se trata de documentos en & _
                       moneda legal indicar 1.
            Exit Function
          End If
        Case K_SUC_ID
          If .HelpId = csNO_ID Then
            MsgWarning LNGGetText(3143, vbNullString)
                       'Debe indicar una Sucursal para guardar los movimientos
            Exit Function
          End If
      End Select
    End With
  Next

  cIABMClient_Validate = True
End Function

' ////////////////////////////////
' ////////////////////////////////
' ////////////////////////////////
' ////////////////////////////////
' ////////////////////////////////
' ////////////////////////////////

' Menu
Private Function cIMenuClient_Initialize(F As Object, Host As CSMenu.cIMenuHost) As Boolean
  On Error GoTo ControlError
  Dim str_1033  As String
  
  str_1033 = LNGGetText(1033, vbNullString)   'Ve&ntas
  Set m_Host = Host
  m_Host.Server.AddMenu str_1033, csMenuConfigVentas, C_MenuConfig, 0, True, False, False, False, True, Nothing
  m_Host.Server.AddMenu LNGGetText(3144, vbNullString), csPreGVentaFacturaAnular, str_1033, 0, True, False, False, False, False, Me
                        '&Anular Facturas
  cIMenuClient_Initialize = True

  GoTo ExitProc
ControlError:
  MngError Err, C_MenuClientInit, C_Module, vbNullString
  If Err.Number Then Resume ExitProc

ExitProc:
  On Error Resume Next
End Function

Private Function cIMenuClient_ProcessMenu(ByVal ID As Long) As Variant
  MsgWarning pGetMsg
  pEdit
End Function

Private Sub pEdit()
  On Error GoTo ControlError
  
  Set m_ObjAbm = New cABMGeneric
  
  If Not SecurityCanAccess(csPreGModifyConfigVentas) Then Exit Sub

  If Not LoadCollection() Then Exit Sub
  
  m_Editing = True
  
  Exit Sub
ControlError:
  MngError Err, "pEdit", C_Module, vbNullString
End Sub

Private Function LoadCollection() As Boolean

  m_ObjAbm.Properties.Clear

  With m_ObjAbm.Properties.Add(Nothing, cscFvFecha)
    .PropertyType = cspDate
    .Name = LNGGetText(1569, vbNullString)  'Fecha
    .Key = K_FECHA
    .Value = VDGetDateById(csToday)
  End With
  
  With m_ObjAbm.Properties.Add(Nothing, cscDocId)
    .PropertyType = cspHelp
    .Width = 3000
    .Table = csDocumento
    .HelpFilter = "'doct_id in (1,7,9) and doc_muevestock = 0'"
    .Name = LNGGetText(1567, vbNullString)  'Documento
    .Key = K_DOCUMENTO
    .Value = ""
    .HelpId = csNO_ID
  End With
  
  With m_ObjAbm.Properties.Add(Nothing, cscCliId)
    .PropertyType = cspHelp
    .Table = csCliente
    .Name = LNGGetText(1150, vbNullString)  'Cliente
    .Key = K_CLI_ID
    .Value = ""
    .HelpId = csNO_ID
  End With
  
  With m_ObjAbm.Properties.Add(Nothing, cscPrId)
    .PropertyType = cspHelp
    .Table = csProductoVenta
    .Name = LNGGetText(1367, vbNullString)  'Articulo
    .Key = K_PR_ID
    .Value = ""
    .HelpId = csNO_ID
  End With
  
  With m_ObjAbm.Properties.Add(Nothing, cscSucId)
    .PropertyType = cspHelp
    .Table = csSucursal
    .Name = LNGGetText(1281, vbNullString)  'Sucursal
    .Key = K_SUC_ID
    .Value = ""
    .HelpId = csNO_ID
  End With
  
  With m_ObjAbm.Properties.Add(Nothing, cscFvCotizacion)
    .TopFromProperty = cscFvFecha
    .Left = 6000
    .PropertyType = cspNumeric
    .SubType = cspDouble
    .Name = LNGGetText(1635, vbNullString)  'Cotizacion
    .Width = 1000
    .Key = K_COTIZ
  End With
  
  With m_ObjAbm.Properties.Add(Nothing, c_desde)
    .PropertyType = cspNumeric
    .SubType = cspInteger
    .Name = LNGGetText(2532, vbNullString)  'Desde
    .Width = 1000
    .Key = K_DESDE
  End With
  
  With m_ObjAbm.Properties.Add(Nothing, c_hasta)
    .PropertyType = cspNumeric
    .SubType = cspInteger
    .Name = LNGGetText(2533, vbNullString)  'Hasta
    .Width = 1000
    .Key = K_HASTA
  End With
  
  With m_ObjAbm.Properties.Add(Nothing, "Label")
    .PropertyType = cspLabel
    .TopToPrevious = 1460
    .LeftFromProperty = cscFvFecha
    .Width = 7000
    .Height = 1200
    .FontBold = True
    .Value = pGetMsg
    .Key = K_LABEL
  End With
  
  With m_ObjAbm.Properties.Add(Nothing, c_Progress)
    .PropertyType = cspProgressBar
    .TopToPrevious = 1300
    .Name = LNGGetText(2984, vbNullString)  'Progreso
    .Width = 7000
    .Key = K_PROGRESS
  End With
  
  With m_ObjAbm.Properties.Add(Nothing, cscFvNrodoc)
    .PropertyType = cspText
    .Name = LNGGetText(1065, vbNullString)  'Numero
    .Size = 50
    .Key = K_NRODOC
    .Value = ""
    .Enabled = False
    .TextAlign = vbRightJustify
  End With
  
  With m_ObjAbm.Properties.Add(Nothing, "cancel")
    .PropertyType = cspButton
    .Name = "Cancelar Anulación"
    .LeftLabel = -1
    .Key = K_CANCEL
  End With
  
  With m_ObjAbm.Properties.Add(Nothing, cscFvCai)
    .PropertyType = cspLabel
    .Visible = False
  End With
  
  Dim AbmObj As cABMGeneric
  Set AbmObj = m_ObjAbm
  With AbmObj
    .bDontAskForSave = True
    .OkCancelDialog = True
    .MinHeight = 8500
    .Frm.cmdCancel.Caption = LNGGetText(2232, vbNullString)  '&Cerrar
  End With
  AbmObj.NotLockWnd = True
  m_ObjAbm.InModalWindow = True

  If Not m_ObjAbm.Show(Me) Then Exit Function
  
  LoadCollection = True
End Function
' funciones friend
' funciones privadas
' construccion - destruccion
Private Sub Class_Terminate()
  On Error Resume Next
  Set m_ObjAbm = Nothing
End Sub

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

Private Function pSave(ByVal cli_id As Long, _
                       ByVal doc_id As Long, _
                       ByVal suc_id As Long, _
                       ByVal fecha As Date, _
                       ByVal cotiz As Double, _
                       ByVal saldo As Double, _
                       ByVal ivaRi As Double, _
                       ByVal ivaRni As Double, _
                       ByVal ivaRiPorc As Double, _
                       ByVal ivaRniPorc As Double, _
                       ByVal cue_id As Long, _
                       ByVal cue_idIvaRi As Long, _
                       ByVal cue_idIvaRni As Long, _
                       ByVal pr_id As Long, _
                       ByVal nroDoc As Long) As Boolean
  
  Dim register     As cRegister
  Dim Cotizacion   As Double
  Dim TotalOrigen  As Double
  Dim bMonedaLegal As Boolean
  Dim Neto         As Double
  
  ' Save and State
  '
  ' TODO: Verificar permisos sobre los documentos
  '
  'If Not DocCanEdit(m_DocEditable, m_DocEditMsg) Then
  '  cIABMClient_Save = True
  '  Exit Function
  'End If
  'If Not DocCanSave(m_ObjAbm, cscFvFecha) Then
  '  cIABMClient_Save = False
  '  Exit Function
  'End If
  
  Dim Mouse As cMouseWait
  Set Mouse = New cMouseWait
  
  DoEvents: DoEvents: DoEvents: DoEvents
  
  Set register = New cRegister
  With register
    .fieldId = cscFvTMPId
    .Table = csTFacturaVentaTMP
    
    .ID = csNew
      
    With .Fields
      .Add2 cscFvId, csNew, csLong
      .Add2 cscFvNumero, 0, csLong
      
      GetDocNumberForCliente cli_id, doc_id, m_ObjAbm, False
      
      .Add2 cscFvNrodoc, _
            pGetNroDoc(nroDoc), _
            csText
      
      .Add2 cscFvDescrip, "", csText
      .Add2 cscFvFecha, fecha, csDate
      .Add2 cscFvFechaIva, fecha, csDate
      .Add2 cscFvFechaentrega, fecha, csDate
      .Add2 cscCliId, cli_id, csId
      .Add2 cscCcosId, csNO_ID, csId
      .Add2 cscSucId, suc_id, csId
      .Add2 cscFvDescuento1, 0, csCurrency
      .Add2 cscFvDescuento2, 0, csCurrency
      .Add2 cscDocId, doc_id, csId
      .Add2 cscLpId, csNO_ID, csId
      .Add2 cscLdId, csNO_ID, csId
                                    
                                    ' Fecha del documento
      .Add2 cscCpgId, -2, csId
      
      ' Manejo de la moneda y la cotizacion
      '
      Cotizacion = cotiz
      bMonedaLegal = GetMonedaDefault = GetMonIdFromDoc(doc_id)
      If bMonedaLegal Then
        Cotizacion = 1
        .Add2 cscFvCotizacion, Cotizacion, csDouble
      Else
        If Cotizacion = 0 Then Cotizacion = 1
        .Add2 cscFvCotizacion, Cotizacion, csDouble
      End If
      
      .Add2 cscVenId, csNO_ID, csId
      .Add2 cscFvCai, "", csText
      .Add2 cscLgjId, csNO_ID, csId
      .Add2 cscProIdOrigen, csNO_ID, csId
      .Add2 cscProIdDestino, csNO_ID, csId
      .Add2 cscTransId, csNO_ID, csId
      .Add2 cscDeplId, csNO_ID, csId
      
      Neto = saldo
      .Add2 cscFvNeto, Neto * Cotizacion, csCurrency
      .Add2 cscFvIvari, ivaRi * Cotizacion, csCurrency
      .Add2 cscFvIvarni, ivaRni * Cotizacion, csCurrency
      .Add2 cscFvSubtotal, Neto + ivaRi + ivaRni * Cotizacion, csCurrency
      .Add2 cscFvImportedesc1, 0, csCurrency
      .Add2 cscFvImportedesc2, 0, csCurrency
      
      TotalOrigen = Neto + ivaRi + ivaRni
      
      .Add2 cscFvTotal, TotalOrigen * Cotizacion, csCurrency
      .Add2 cscFvGrabarAsiento, 1, csBoolean
      .Add2 cscEstId, CSGeneralEx2.csEEstado.csEEst_Anulado, csId
      
      If bMonedaLegal Then
        .Add2 cscFvTotalOrigen, 0, csCurrency
      Else
        .Add2 cscFvTotalOrigen, TotalOrigen, csCurrency
      End If
      
      .HaveLastUpdate = True
      .HaveWhoModify = True
    End With
  End With
  
  If Not register.BeginTrans(gDB) Then Exit Function
  
  If Not gDB.Save(register, , "pSave", C_Module, c_ErrorSaveFactura) Then Exit Function
  
  If Not pSaveItems(register.ID, _
                    Cotizacion, _
                    bMonedaLegal, _
                    saldo, _
                    ivaRiPorc, _
                    ivaRniPorc, _
                    cue_id, cue_idIvaRi, cue_idIvaRni, _
                    ivaRi, ivaRni, pr_id) Then Exit Function
  If Not register.CommitTrans() Then Exit Function
  
  Dim sqlstmt As String
  Dim rs      As Recordset
  sqlstmt = "sp_DocFacturaVentaSave " & register.ID
  
  If Not gDB.OpenRs(sqlstmt, rs, , , , "cIABMClient_Save", C_Module, c_ErrorSaveFactura) Then
    
    ' Si el error es por clave duplicada
    If CSKernelClient2.LastErrorNumber = -2147217900 Then
      If InStr(1, CSKernelClient2.LastErrorDescription, "IX_FacturaVentaNroDocEmpresa") Then
        pShowFacturaDuplicada
      End If
    End If
    Exit Function
  End If
  
  If rs.EOF Then Exit Function
  
  Dim ID As Long
  If Not GetDocIDFromRecordset(rs, ID) Then Exit Function
  
  pSave = ID <> csNO_ID
End Function

Private Function pSaveItems(ByVal ID As Long, _
                            ByVal Cotizacion As Double, _
                            ByVal bMonedaLegal As Boolean, _
                            ByVal saldo As Double, _
                            ByVal ivaRiPorc As Double, _
                            ByVal ivaRniPorc As Double, _
                            ByVal cue_id As Long, _
                            ByVal cue_idIvaRi As Long, _
                            ByVal cue_idIvaRni As Long, _
                            ByVal ivaRi As Double, _
                            ByVal ivaRni As Double, _
                            ByVal pr_id As Long) As Boolean
  Dim register  As cRegister
  Dim iOrden    As Long
  Dim Origen    As Double
  
  ' Para numeros de serie
  '
  Dim iOrden2     As Long
  Dim Grupo       As Long
        
  Dim Row  As cIABMGridRow
  Dim Cell As cIABMGridCellValue
  
  Set register = New cRegister
  
  With register
    .fieldId = cscFviTMPId
    .Table = csTFacturaVentaItemTMP
    .ID = csNew
    
    With .Fields
      .Add2 cscFviId, csNew, csInteger
      .Add2 cscFviCantidad, 1, csDouble
      .Add2 cscFviDescrip, "", csText
      .Add2 cscFviPrecio, saldo * Cotizacion, csCurrency
      .Add2 cscFviPrecioLista, 0, csCurrency
      .Add2 cscFviPrecioUsr, saldo * Cotizacion, csCurrency
      .Add2 cscFviNeto, saldo * Cotizacion, csCurrency
      .Add2 cscFviIvari, ivaRi * Cotizacion, csCurrency
      .Add2 cscFviIvarni, ivaRni * Cotizacion, csCurrency
      .Add2 cscFviIvariporc, ivaRiPorc, csDouble
      .Add2 cscFviIvarniporc, ivaRniPorc, csDouble
      .Add2 cscPrId, pr_id, csId
      .Add2 cscCcosId, csNO_ID, csId
      .Add2 cscToId, C_TO_ComercialId, csId
      
      .Add2 cscCueId, cue_id, csId
      .Add2 cscCueIdIvaRI, cue_idIvaRi, csId
      .Add2 cscCueIdIvaRNI, cue_idIvaRni, csId
        
      Origen = saldo + ivaRi + ivaRni
      
      .Add2 cscFviImporte, Origen * Cotizacion, csCurrency
      If bMonedaLegal Then
        .Add2 cscFviImporteOrigen, 0, csCurrency
      Else
        .Add2 cscFviImporteOrigen, Origen, csCurrency
      End If
        
      iOrden = iOrden + 1
      .Add2 cscFviOrden, iOrden, csInteger
      .Add2 cscFvTMPId, ID, csId
        
      .HaveLastUpdate = False
      .HaveWhoModify = False
    End With
  End With
  
  If Not gDB.Save(register, , "pSaveItems", C_Module, c_ErrorSaveFactura) Then Exit Function
  
  pSaveItems = True
End Function

Private Sub pShowFacturaDuplicada()
  Dim nroDoc    As String
  Dim sqlstmt   As String
  Dim rs        As ADODB.Recordset
  Dim msg       As String
  
  nroDoc = m_ObjAbm.Properties.Item(cscFvNrodoc).Value
  sqlstmt = "sp_DocFacturaVentaGetForNroDoc " & gDB.sqlString(nroDoc) & "," & EmpId
  
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Sub
  
  If Not rs.EOF Then
    With rs.Fields
      msg = LNGGetText(3145, vbNullString, .Item(cscFvNrodoc).Value, .Item(cscCliNombre).Value, .Item(cscDocNombre).Value, .Item(cscFvFecha).Value)
            'La factura " & .Item(cscFvNrodoc).Value & " pertenece al cliente " & .Item(cscCliNombre).Value & " en el documento " & .Item(cscDocNombre).Value & " generada el " & .Item(cscFvFecha).Value
      MsgWarning msg
    End With
  End If
End Sub

'///////////////////////////////////////////////////////////////////////////////////////////////
'///////////////////////////////////////////////////////////////////////////////////////////////
'///////////////////////////////////////////////////////////////////////////////////////////////
'///////////////////////////////////////////////////////////////////////////////////////////////

Private Function pSetDataProducto(ByRef cue_id As Long, _
                                  ByRef ivaRiPorc As Double, _
                                  ByRef ivaRniPorc As Double, _
                                  ByRef cue_idIvaRi As Long, _
                                  ByRef cue_idIvaRni As Long, _
                                  ByVal cli_id As Long) As Boolean
  Dim sqlstmt     As String
  Dim rs          As Recordset
  Dim ti_ri       As Long
  Dim ti_rni      As Long
  Dim pr_nombre   As String
  Dim pr_id       As Long
  
  With m_ObjAbm.Properties.Item(cscPrId)
    pr_id = .HelpId
    pr_nombre = .Value
  End With
  
  sqlstmt = "sp_StockProductoGetData " & pr_id & "," & cli_id
  
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Function
  
  If Not rs.EOF Then
    cue_id = gDB.ValField(rs.Fields, cscCueidventa)
  End If

  If Not GetTasaFromProducto(pr_id, ti_ri, ti_rni, False) Then Exit Function
  
  If ti_ri = 0 Then
    MsgWarning LNGGetText(1597, vbNullString, pr_nombre)
              'El producto [" & pr_nombre & "] no tiene definida su tasa impositiva de ventas & _
              para el iva responsable inscripto
    Exit Function
  End If
  
  If ti_rni = 0 Then
    MsgWarning LNGGetText(1598, vbNullString, pr_nombre)
              'El producto [" & pr_nombre & "] no tiene definida su tasa impositiva de ventas & _
              para el iva responsable no inscripto
    Exit Function
  End If
  
  sqlstmt = "select ti_porcentaje,cue_id from tasaimpositiva where ti_id = " & ti_ri
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Function
  
  If Not rs.EOF Then
    ivaRiPorc = gDB.ValField(rs.Fields, cscTiPorcentaje)
    cue_idIvaRi = gDB.ValField(rs.Fields, cscCueId)
  End If
  
  sqlstmt = "select ti_porcentaje,cue_id from tasaimpositiva where ti_id = " & ti_rni
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Function
  
  If Not rs.EOF Then
    ivaRniPorc = gDB.ValField(rs.Fields, cscTiPorcentaje)
    cue_idIvaRni = gDB.ValField(rs.Fields, cscCueId)
  End If
  
  pSetDataProducto = True
End Function

Private Function pGetIvaFromCliente(ByVal cli_id As Long, _
                                    ByRef bIva As Boolean, _
                                    ByRef bIvaRni As Boolean) As Boolean
  
  Dim sqlstmt        As String
  Dim rs             As ADODB.Recordset
  
  sqlstmt = "sp_clienteGetIva " & cli_id
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Function
  
  If rs.EOF Then Exit Function
  
  bIva = gDB.ValField(rs.Fields, "bIva")
  bIvaRni = gDB.ValField(rs.Fields, "bIvaRni")
  
  pGetIvaFromCliente = True
End Function

Private Function pGetMsg() As String
  pGetMsg = LNGGetText(3146, vbNullString)
            'Este proceso solo anula facturas nuevas." & vbCrLf _
            & "Si la factura ya existe el proceso no la modificará." & vbCrLf _
            & "Para documentos ya grabados debe anularlos desde la ventana de Facturación." & vbCrLf _
            & "Al terminar este proceso verifique el estado del Talonario." & vbCrLf _
            & "Durante este proceso no se deben generar facturas desde otros puestos de trabajo."
End Function

Private Function pGetNroDoc(ByVal nroDoc As Long) As String
  Dim iProp As cIABMProperty
  Set iProp = m_ObjAbm.Properties.Item(cscFvNrodoc)
  iProp.Value = nroDoc
  m_ObjAbm.ShowValue iProp
  pGetNroDoc = iProp.Value
End Function
