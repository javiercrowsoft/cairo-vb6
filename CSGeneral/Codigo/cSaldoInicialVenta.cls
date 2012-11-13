VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cSaldoInicial"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements CSInterfacesABM.cIABMClient
Implements CSMenu.cIMenuClient
'--------------------------------------------------------------------------------
' cSaldoInicial
' 04-12-2004

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cSaldoInicial"

Private Const cscDocIdPos = "doc_id1"
Private Const cscDocIdNeg = "doc_id2"
Private Const cscPrId = "pr_id"
Private Const cscPrNombreventa = "pr_nombreventa"
Private Const c_file = "file"
Private Const c_Progress = "prg"
Private Const c_log = "log"
Private Const c_logFile = "logFile"

Private Const K_FECHA = 1
Private Const K_DOCUMENTO_POS = 2
Private Const K_DOCUMENTO_NEG = 3
Private Const K_PR_ID = 4
Private Const K_FILE = 5
Private Const K_LABEL = 6
Private Const K_PROGRESS = 7
Private Const K_CANCEL = 8
Private Const K_NRODOC = 9
Private Const K_SUC_ID = 10
Private Const K_COTIZ = 11
Private Const K_LOGFILE = 12
Private Const K_LOG = 13

Private Const c_ErrorSaveFactura = "Error al grabar la factura de venta"

Private Const cscToId                               As String = "to_id"

Private Const cscCliId                              As String = "cli_id"
Private Const cscCliNombre                          As String = "cli_nombre"

Private Const cscCcosId                             As String = "ccos_id"
Private Const cscCcosNombre                         As String = "ccos_nombre"
Private Const cscSucId                              As String = "suc_id"

Private Const cscDocId                              As String = "doc_id"
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
Private Const cscFvFecha                         As String = "fv_fecha"
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
Private m_logFile           As String
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
  
  Dim file        As String
  Dim doc_idpos   As Long
  Dim doc_idneg   As Long
  Dim suc_id      As Long
  Dim fecha       As Date
  Dim cotiz       As Double
  
  m_ObjAbm.Properties.Item(c_log).Value = ""
  m_ObjAbm.ShowValue m_ObjAbm.Properties.Item(c_log)

  m_logFile = m_ObjAbm.Properties.Item(c_logFile).Value
  
  pAddToLog "*****************************************", True
  pAddToLog LNGGetText(3189, vbNullString), True
            'Iniciando importación de Saldos Iniciales
  pAddToLog "", True
  
  doc_idpos = m_ObjAbm.Properties.Item(cscDocIdPos).HelpId
  doc_idneg = m_ObjAbm.Properties.Item(cscDocIdNeg).HelpId
  
  file = m_ObjAbm.Properties.Item(c_file).Value
  suc_id = m_ObjAbm.Properties.Item(cscSucId).HelpId
  fecha = m_ObjAbm.Properties.Item(cscFvFecha).Value
  cotiz = Val(m_ObjAbm.Properties.Item(cscFvCotizacion).Value)
  
  pAddToLog LNGGetText(3190, vbNullString, m_ObjAbm.Properties.Item(cscDocIdPos).Value), True
            'Documento Positivo:  & m_ObjAbm.Properties.Item(cscDocIdPos).Value
  pAddToLog LNGGetText(3191, vbNullString, m_ObjAbm.Properties.Item(cscDocIdNeg).Value), True
            'Documento Negativo:  & m_ObjAbm.Properties.Item(cscDocIdNeg).Value
  pAddToLog LNGGetText(3150, vbNullString, file), True
            'Archivo:  & file
  pAddToLog LNGGetText(3151, vbNullString, m_ObjAbm.Properties.Item(cscSucId).Value), True
            'Sucursal:  & m_ObjAbm.Properties.Item(cscSucId).Value
  pAddToLog LNGGetText(3192, vbNullString, m_ObjAbm.Properties.Item(cscPrId).Value), True
            'Producto:  & m_ObjAbm.Properties.Item(cscPrId).Value
  pAddToLog LNGGetText(3152, vbNullString, fecha), True
            'Fecha:  & fecha, True
  pAddToLog LNGGetText(3193, vbNullString, cotiz), True
            'Cotizacion:  & cotiz
  
  Dim ivaRiPorc       As Double
  Dim ivaRniPorc      As Double
  Dim cue_idProducto  As Long
  Dim cue_idIvaRi     As Long
  Dim cue_idIvaRni    As Long
  Dim pr_id           As Long
  Dim pr_nombre       As String
  
  pGetProductoFromInterfaz pr_nombre, pr_id
                             
  If Not pSetDataProducto(cue_idProducto, ivaRiPorc, _
                          ivaRniPorc, cue_idIvaRi, cue_idIvaRni, _
                          pr_nombre, pr_id) Then
    pAddToLog LNGGetText(3133, vbNullString, m_ObjAbm.Properties.Item(cscPrId).Value), False
              'No se pudo obtener la informacion impositiva y contable & _
              asociada al articulo  & m_ObjAbm.Properties.Item(cscPrId).Value
    GoTo ExitProc
  End If
  
  Dim exFile As Object 'As Excel.Application
  pAddToLog LNGGetText(3153, vbNullString), True
            'Creando objeto Excel
  Set exFile = CSKernelClient2.CreateObject("Excel.Application")
  
  pAddToLog LNGGetText(3154, vbNullString, file), True
            'Abriendo Archivo Excel: & file
  exFile.Workbooks.Open file
  
  Dim Sheet                   As Object 'Excel.Worksheet
  Dim colName                 As String
  Dim bIsCuit                 As Boolean
  Dim bFechaFromExcel         As Boolean
  Dim bProductoFromExcel      As Boolean
  Dim bCentroCostoFromExcel   As Boolean
  Dim pr_codigo               As String
  Dim bNroDocFromExcel        As Boolean
  Dim nroDoc                  As String
  Dim ccos_id                 As Long
  Dim ccos_codigo             As String
  Dim ccos_nombre             As String
  
  pAddToLog LNGGetText(3155, vbNullString, file), True
            'Obteniendo hoja 1:  & file
  Set Sheet = exFile.Sheets(1)
  
  ' TODO: JAVIER ::ver como hacer para pasar cuit, codigo y saldo a leng _
                    y que todo siga funcionando
  
  colName = LCase(Sheet.cells(1, 1))
  If colName <> "cuit" And colName <> "codigo" Then
    MsgWarning LNGGetText(3194, vbNullString)
                'La primer columna del archivo debe llamarse cuit o codigo
    GoTo ExitProc
  Else
    bIsCuit = colName = "cuit"
  End If
  
  colName = LCase(Sheet.cells(1, 2))
  If colName <> "saldo" Then
    MsgWarning LNGGetText(3170, vbNullString)
              'La segunda columna del archivo debe llamarse saldo
    GoTo ExitProc
  End If
  
  colName = LCase(Sheet.cells(1, 4))
  If colName = "fecha" Then
    bFechaFromExcel = True
  End If
  
  colName = LCase(Sheet.cells(1, 5))
  If colName = "articulo" Then
    bProductoFromExcel = True
  End If
  
  colName = LCase(Sheet.cells(1, 6))
  If colName = "contro de costo" Then
    bCentroCostoFromExcel = True
  End If
  
  colName = LCase(Sheet.cells(1, 7))
  If colName = "comprobante" Then
    bNroDocFromExcel = True
  End If
  
  Dim i     As Long
  Dim ID    As String
  Dim saldo As Double
  Dim count As Long
  Dim iProg As cIABMProperty
  
  pAddToLog LNGGetText(3156, vbNullString), True
            'Obteniendo la cantidad de filas

  ' Obtengo la cantidad de filas que hay en el archivo
  '
  i = 2
    
  Do
    
    If Sheet.cells(i, 1) = "" Then Exit Do
    
    i = i + 1
    If i > Sheet.Rows.count Then Exit Do
  Loop
  
  count = i
  pAddToLog LNGGetText(2987, vbNullString, count), True
            'Cantidad de filas:  & count
  Set iProg = m_ObjAbm.Properties.Item(c_Progress)
  
  Set Mouse = Nothing
  
  Dim mouseex As cMouse
  Set mouseex = New cMouse
  
  mouseex.MouseSet vbArrowHourglass
  
  Dim cliente     As String
  Dim cli_id      As Long
  Dim doc_id      As Long
  Dim ivaRi       As Double
  Dim ivaRni      As Double
  Dim bIva        As Boolean
  Dim bIvaRni     As Boolean
  Dim ivaRiPorc2  As Double
  Dim ivaRniPorc2 As Double
  Dim bErrors     As Boolean
  Dim bImport     As Boolean
  
  i = 2
  
  Do
    
    If Sheet.cells(i, 1) = "" Then
      Exit Do
    End If
    bImport = True

    ID = Sheet.cells(i, 1)
    saldo = Val(Sheet.cells(i, 2))
    If IsNull(Sheet.cells(i, 3)) Then
      cliente = ""
    Else
      cliente = Sheet.cells(i, 3)
    End If
    
    If bFechaFromExcel Then
      fecha = Sheet.cells(i, 4)
    End If
    
    ' Producto
    '
    If bProductoFromExcel Then
      
      pr_codigo = Sheet.cells(i, 5)
      
      pGetProductoFromCodigo pr_codigo, pr_nombre, pr_id
      
      If Not pSetDataProducto(cue_idProducto, ivaRiPorc, _
                              ivaRniPorc, cue_idIvaRi, cue_idIvaRni, pr_nombre, pr_id) Then
        pAddToLog LNGGetText(3133, vbNullString, m_ObjAbm.Properties.Item(cscPrId).Value), False
                  'No se pudo obtener la informacion impositiva y contable & _
                  asociada al articulo  & m_ObjAbm.Properties.Item(cscPrId).Value
        bImport = False
        bErrors = True
      End If
    End If
    
    ' Centro de costo
    '
    If bCentroCostoFromExcel Then
    
      ccos_codigo = Sheet.cells(i, 6)
      
      If LenB(ccos_codigo) Then
      
        pGetCentroCostoFromCodigo ccos_codigo, ccos_nombre, ccos_id
        
        If Not pSetDataProducto(cue_idProducto, ivaRiPorc, _
                                ivaRniPorc, cue_idIvaRi, cue_idIvaRni, pr_nombre, pr_id) Then
          pAddToLog LNGGetText(3133, vbNullString, m_ObjAbm.Properties.Item(cscPrId).Value), False
                    'No se pudo obtener la informacion impositiva y contable & _
                    asociada al articulo  & m_ObjAbm.Properties.Item(cscPrId).Value
          bImport = False
          bErrors = True
        End If
      Else
        ccos_nombre = vbNullString
        ccos_id = csNO_ID
      End If
    End If
    
    If bNroDocFromExcel Then
      nroDoc = Sheet.cells(i, 7)
    End If
    
    If saldo < 0 Then
      doc_id = doc_idneg
      saldo = Abs(saldo)
    Else
      doc_id = doc_idpos
    End If
    
    If bImport Then
    
      If pGetCliente(cli_id, bIva, bIvaRni, ID, bIsCuit, cliente, saldo) Then
      
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
      
        If bImport Then
      
          If Not pSave(cli_id, doc_id, suc_id, fecha, cotiz, _
                       saldo, ivaRi, ivaRni, ivaRiPorc2, ivaRniPorc2, _
                       cue_idProducto, cue_idIvaRi, cue_idIvaRni, _
                       pr_id, ccos_id, bNroDocFromExcel, nroDoc) Then
            
            pAddToLog CSKernelClient2.LastErrorDescription, False, ID, cliente, saldo
            bErrors = True
          
            ' Debug
            'Stop
          
          Else
            
            pAddToLog LNGGetText(2987, vbNullString, _
                      m_ObjAbm.Properties.Item(cscFvNrodoc).Value), True, ID, _
                      cliente, saldo
                      'Movimiento generado:  & _
                      m_ObjAbm.Properties.Item(cscFvNrodoc).Value
          End If
        
        ' Debug
        'Else
        '  Stop
        End If
      
      ' Debug
      'Else
      '  Stop
      End If
      
    ' Debug
    'Else
    '  Stop
    End If
    
    iProg.Value = DivideByCero(i, count) * 100
    m_ObjAbm.ShowValue iProg
    DoEvents
    
    If m_bCancel Then GoTo ExitProc
    
    i = i + 1
    If i > Sheet.Rows.count Then Exit Do
  Loop
  
  Dim msg As String
  
  If bErrors Then
    msg = LNGGetText(3159, vbNullString)
          'La importación termino con algunos errores.;;Consulte el archivo & _
          de log para ver que registros nos se importaron.
  Else
    msg = LNGGetText(3160, vbNullString)  'La importación termino con éxito
  End If
  
  pAddToLog msg, True
  MsgInfo msg
  
  CSKernelClient2.EditFile m_logFile, 0
  
  cIABMClient_Save = True

  GoTo ExitProc
ControlError:
  MngError Err, "cIABMClient_Save", C_Module, vbNullString
  pAddToLog CSKernelClient2.LastErrorDescription, False
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
  exFile.Workbooks.Close
End Function

Private Function pGetCliente(ByRef cli_id As Long, _
                             ByRef bIva As Boolean, _
                             ByRef bIvaRni As Boolean, _
                             ByVal ID As String, _
                             ByVal bIsCuit As Boolean, _
                             ByVal cliente As String, _
                             ByVal saldo As Double) As Boolean
  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  
  sqlstmt = "sp_si_getCliente " & gDB.sqlString(ID) & "," & CInt(bIsCuit)
  
  If Not gDB.OpenRs(sqlstmt, rs) Then
    pAddToLog LNGGetText(3161, vbNullString, ID), False, ID, cliente, saldo
              'No se pudo obtener el cli_id para el cliente  & ID
    pAddToLog CSKernelClient2.LastErrorDescription, False
    Exit Function
  End If
  
  If rs.EOF Then
    
    If bIsCuit Then
                'No existe un cliente con CUIT
      pAddToLog LNGGetText(3195, vbNullString, _
                           ID), _
                False, ID, cliente, saldo
    Else
                'No existe un cliente con código
      pAddToLog LNGGetText(3196, vbNullString, _
                           ID), _
                False, ID, cliente, saldo
    End If
    
    pAddToLog CSKernelClient2.LastErrorDescription, False
    Exit Function
  End If
  
  cli_id = gDB.ValField(rs.Fields, cscCliId)
  
  If Not pGetIvaFromCliente(cli_id, bIva, bIvaRni) Then
    pAddToLog LNGGetText(3162, vbNullString, ID), False, ID, cliente, saldo
              'No se pudo la definicion de IVA para el cliente  & ID
    pAddToLog CSKernelClient2.LastErrorDescription, False
    Exit Function
  End If
  
  pGetCliente = True
End Function

Private Sub pAddToLog(ByVal msg As String, _
                      ByVal bOnlyToFile As Boolean, _
                      Optional ByVal ID As String, _
                      Optional ByVal cliente As String, _
                      Optional ByVal saldo As Double)
  On Error Resume Next
  
  If LenB(ID) Then
    msg = msg & " - [" & ID & " " & cliente & " (" & saldo & ")]"
  End If
  
  pSaveLog msg
  
  If Not bOnlyToFile Then
    Dim iProp As cIABMProperty
    Set iProp = m_ObjAbm.Properties.Item(c_log)
    With iProp
      .Value = .Value & msg & vbCrLf
    End With
    m_ObjAbm.ShowValue iProp
  End If
End Sub

Private Function cIABMClient_Terminate() As Boolean
  m_Editing = False
  cIABMClient_Terminate = True
End Function

Private Property Get cIABMClient_Title() As String
  cIABMClient_Title = LNGGetText(3197, vbNullString) 'Importar Saldos Iniciales
End Property

Private Function cIABMClient_Validate() As Boolean

  Dim IProperty As cIABMProperty

  CSKernelClient2.Title = LNGGetText(3197, vbNullString) 'Importar Saldos Iniciales

  For Each IProperty In m_ObjAbm.Properties
    With IProperty
      Select Case .Key
        Case K_FECHA
          If Not IsDate(.Value) Then
            MsgWarning LNGGetText(1558, vbNullString) 'Debe indicar una fecha
            Exit Function
          End If
        Case K_DOCUMENTO_POS
          If .HelpId = csNO_ID Then
            MsgWarning LNGGetText(3140, vbNullString)
                       'Debe indicar un documento para los Saldos positivos
            Exit Function
          End If
        Case K_DOCUMENTO_NEG
          If .HelpId = csNO_ID Then
            MsgWarning LNGGetText(3198, vbNullString)
                       'Debe indicar un documento para los Saldos negativos
            Exit Function
          End If
        Case K_PR_ID
          If .HelpId = csNO_ID Then
            MsgWarning LNGGetText(3141, vbNullString)
                       'Debe indicar un artículo para guardar los movimientos
            Exit Function
          End If
        Case K_COTIZ
          If Val(.Value) < 0 Then
            MsgWarning LNGGetText(3142, vbNullString)
                        'La cotización no puede ser menor a cero. Si se trata de & _
                        documentos en moneda legal indicar 1.
            Exit Function
          End If
        Case K_SUC_ID
          If .HelpId = csNO_ID Then
            MsgWarning LNGGetText(3142, vbNullString)
                        'Debe indicar una sucursal para guardar los movimientos
            Exit Function
          End If
        Case K_FILE
          If LenB(.Value) = 0 Then
            MsgWarning LNGGetText(3199, vbNullString)
                       'Debe indicar un archivo Excel con los Saldos Iniciales
            Exit Function
          End If
        Case K_LOGFILE
          If LenB(.Value) = 0 Then
            MsgWarning LNGGetText(2975, vbNullString)
                       'Debe indicar un archivo para el log de las operaciones
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
  
  str_1033 = LNGGetText(1033, vbNullString) 'Ve&ntas
  Set m_Host = Host
  m_Host.Server.AddMenu str_1033, csMenuConfigVentas, C_MenuConfig, 0, True, False, False, False, True, Nothing
  m_Host.Server.AddMenu LNGGetText(3200, vbNullString), csPreGVentaSaldoInicial, str_1033, 0, True, False, False, False, False, Me
                        '&Saldos Iniciales
  cIMenuClient_Initialize = True

  GoTo ExitProc
ControlError:
  MngError Err, C_MenuClientInit, C_Module, vbNullString
  If Err.Number Then Resume ExitProc

ExitProc:
  On Error Resume Next
End Function

Private Function cIMenuClient_ProcessMenu(ByVal ID As Long) As Variant
  pEdit
End Function

Private Sub pEdit()
  On Error GoTo ControlError
  
  Set m_ObjAbm = New cABMGeneric
  
  If Not SecurityCanAccess(csPreGVentaSaldoInicial) Then Exit Sub

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
  
  With m_ObjAbm.Properties.Add(Nothing, cscDocIdPos)
    .PropertyType = cspHelp
    .Width = 3000
    .Table = csDocumento
    .HelpFilter = "'doct_id = 1'"
    .Name = LNGGetText(3201, vbNullString)  'Documento Positivo
    .Key = K_DOCUMENTO_POS
    .HelpId = csNO_ID
  End With
  
  With m_ObjAbm.Properties.Add(Nothing, cscDocIdNeg)
    .PropertyType = cspHelp
    .Table = csDocumento
    .HelpFilter = "'doct_id = 7'"
    .Name = LNGGetText(3202, vbNullString)  'Documento Negativo
    .Key = K_DOCUMENTO_NEG
    .HelpId = csNO_ID
  End With
  
  With m_ObjAbm.Properties.Add(Nothing, cscPrId)
    .PropertyType = cspHelp
    .TopFromProperty = cscFvFecha
    .Left = 6000
    .Table = csProductoVenta
    .Name = LNGGetText(1367, vbNullString)  'Articulo
    .Key = K_PR_ID
    .HelpId = csNO_ID
  End With
  
  With m_ObjAbm.Properties.Add(Nothing, cscSucId)
    .PropertyType = cspHelp
    .Table = csSucursal
    .Name = LNGGetText(1281, vbNullString)  'Sucursal
    .Key = K_SUC_ID
    .HelpId = csNO_ID
  End With
  
  With m_ObjAbm.Properties.Add(Nothing, cscFvCotizacion)
    .PropertyType = cspNumeric
    .SubType = cspDouble
    .Name = LNGGetText(1635, vbNullString)  'Cotizacion
    .Width = 1000
    .Key = K_COTIZ
  End With
  
  With m_ObjAbm.Properties.Add(Nothing, c_log)
    .PropertyType = cspText
    .LeftFromProperty = cscFvFecha
    .SubType = cspMemo
    .Height = 1320
    .Width = 7000
    .Key = K_LOG
  End With
  
  With m_ObjAbm.Properties.Add(Nothing, c_logFile)
    .PropertyType = cspFile
    .Width = 5000
    .Name = LNGGetText(2982, vbNullString)  'Archivo de Log
    .Key = K_LOGFILE
    .Value = GetValidPath(App.Path) & "importar_saldos.log"
    .HelpFilter = LNGGetText(2989, vbNullString)  'Archivo de Log|*.log
  End With
  
  With m_ObjAbm.Properties.Add(Nothing, "Label")
    .PropertyType = cspLabel
    .TopToPrevious = 540
    .Width = 5000
    .Height = 2000
    .FontBold = True
    .Value = LNGGetText(3203, vbNullString)
              'El archivo debe tener una sola hoja & _
              Y las siguientes dos columnas: & _
               - Cuit o Codigo (segun corresponda) & _
               - Saldo & _
              Opcionalmente puede tener: & _
               - fecha & _
               - articulo & _
               - centro de costo & _
               - comprobante
               
    .Key = K_LABEL
  End With
  
  With m_ObjAbm.Properties.Add(Nothing, c_file)
    .PropertyType = cspFile
    .Name = LNGGetText(2966, vbNullString) 'Archivo
    .Key = K_FILE
    .HelpFilter = LNGGetText(3168, vbNullString) 'Excel|*.xls
    .HelpId = csNO_ID
  End With
  
  With m_ObjAbm.Properties.Add(Nothing, c_Progress)
    .PropertyType = cspProgressBar
    .TopToPrevious = 560
    .Name = LNGGetText(2984, vbNullString) 'Progreso
    .Width = 7000
    .Key = K_PROGRESS
  End With
  
  With m_ObjAbm.Properties.Add(Nothing, cscFvNrodoc)
    .PropertyType = cspText
    .Name = LNGGetText(1065, vbNullString) 'Numero
    .Size = 50
    .Key = K_NRODOC
    .Enabled = False
    .TextAlign = vbRightJustify
  End With
  
  With m_ObjAbm.Properties.Add(Nothing, "cancel")
    .PropertyType = cspButton
    .Name = "Cancelar Importacion"
    .LeftLabel = -1
    .Key = K_CANCEL
  End With
  
  With m_ObjAbm.Properties.Add(Nothing, cscFvCai)
    .PropertyType = cspLabel
    .Visible = False
  End With
  
  Dim AbmObj As cABMGeneric
  Set AbmObj = m_ObjAbm
  AbmObj.bDontAskForSave = True
  AbmObj.OkCancelDialog = True
  AbmObj.MinHeight = 10000
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
                       ByVal ccos_id As Long, _
                       ByVal bNroDocFromExcel As Boolean, _
                       ByVal nroDoc As String) As Boolean
  
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
      
      If bNroDocFromExcel Then
        pGetDocNumberFromExcel cli_id, doc_id, nroDoc
      Else
        GetDocNumberForCliente cli_id, doc_id, m_ObjAbm, False
      End If
      .Add2 cscFvNrodoc, _
                   m_ObjAbm.Properties.Item(cscFvNrodoc).Value, _
                   csText
      
      .Add2 cscFvDescrip, "", csText
      .Add2 cscFvFecha, fecha, csDate
      .Add2 cscFvFechaentrega, fecha, csDate
      .Add2 cscCliId, cli_id, csId
      .Add2 cscCcosId, ccos_id, csId
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
      .Add2 cscEstId, CSGeneralEx2.csEEstado.csEEst_Pendiente, csId
      
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
      msg = LNGGetText(3145, vbNullString, .Item(cscFvNrodoc).Value, _
                                           .Item(cscCliNombre).Value, _
                                           .Item(cscDocNombre).Value, _
                                           .Item(cscFvFecha).Value)
            'La factura  & .Item(cscFvNrodoc).Value &  pertenece al cliente  & .Item(cscCliNombre).Value &  en el documento  & .Item(cscDocNombre).Value &  generada el  & .Item(cscFvFecha).Value
      MsgWarning msg
    End With
  End If
End Sub

Private Sub pSaveLog(ByVal msg As String)
  On Error Resume Next
  Dim F As Integer
  F = FreeFile
  Open m_logFile For Append As F
  Print #F, Now & " " & msg
  Close F
End Sub

Private Sub MsgWarning(ByVal msg As String)
  pAddToLog LNGGetText(2990, vbNullString, msg), True
            'Advertencia:  & msg
  CSKernelClient2.MsgWarning msg
End Sub

'///////////////////////////////////////////////////////////////////////////////////////////////
'///////////////////////////////////////////////////////////////////////////////////////////////
'///////////////////////////////////////////////////////////////////////////////////////////////
'///////////////////////////////////////////////////////////////////////////////////////////////

Private Sub pGetCentroCostoFromCodigo(ByVal ccos_codigo As String, _
                                      ByRef ccos_nombre As String, _
                                      ByRef ccos_id As Long)
  Dim sqlstmt As String
  Dim rs As ADODB.Recordset
  
  sqlstmt = "select ccos_nombre, ccos_id from CentroCosto " & _
            "where activo <> 0 and ccos_codigo = " & _
                  gDB.sqlString(ccos_codigo)
                  
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Sub
  
  If rs.EOF Then
    MsgWarning LNGGetText(3602, vbNullString, ccos_codigo)
                'No existe un centro de costo con codigo #1#
    Exit Sub
  End If
  
  ccos_id = gDB.ValField(rs.Fields, cscCcosId)
  ccos_nombre = gDB.ValField(rs.Fields, cscCcosNombre)

End Sub

Private Sub pGetProductoFromInterfaz(ByRef pr_nombre As String, _
                                     ByRef pr_id As Long)
  
  With m_ObjAbm.Properties.Item(cscPrId)
    pr_id = .HelpId
    pr_nombre = .Value
  End With

End Sub

Private Sub pGetProductoFromCodigo(ByVal pr_codigo As String, _
                                   ByRef pr_nombre As String, _
                                   ByRef pr_id As Long)
  Dim sqlstmt As String
  Dim rs As ADODB.Recordset
  
  sqlstmt = "select pr_nombreventa, pr_id from Producto " & _
            "where pr_sevende <> 0 and activo <> 0 and pr_codigo = " & _
                  gDB.sqlString(pr_codigo)
                  
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Sub
  
  If rs.EOF Then
    MsgWarning LNGGetText(3601, vbNullString, pr_codigo)
                'No existe un producto con codigo #1#
    
    Exit Sub
  End If
  
  pr_id = gDB.ValField(rs.Fields, cscPrId)
  pr_nombre = gDB.ValField(rs.Fields, cscPrNombreventa)
  
End Sub

Private Function pSetDataProducto(ByRef cue_id As Long, _
                                  ByRef ivaRiPorc As Double, _
                                  ByRef ivaRniPorc As Double, _
                                  ByRef cue_idIvaRi As Long, _
                                  ByRef cue_idIvaRni As Long, _
                                  ByVal pr_nombre As String, _
                                  ByVal pr_id As Long) As Boolean
  Dim sqlstmt     As String
  Dim rs          As Recordset
  Dim ti_ri       As Long
  Dim ti_rni      As Long
  
  sqlstmt = "sp_StockProductoGetData " & pr_id & ", -1" ' cli_id en -1 para que saque la cuenta del producto
  
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Function
  
  If Not rs.EOF Then
    cue_id = gDB.ValField(rs.Fields, cscCueidventa)
  End If

  If Not GetTasaFromProducto(pr_id, ti_ri, ti_rni, False) Then Exit Function
  
  If ti_ri = 0 Then
    MsgWarning LNGGetText(1597, vbNullString, pr_nombre)
                'El producto [" & pr_nombre & "] no tiene definida su tasa impositiva _
                  de ventas para el iva responsable inscripto
    Exit Function
  End If
  
  If ti_rni = 0 Then
    MsgWarning LNGGetText(1598, vbNullString, pr_nombre)
              'El producto [" & pr_nombre & "] no tiene definida su tasa impositiva _
              de ventas para el iva responsable no inscripto
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

Private Sub pGetDocNumberFromExcel(ByVal cli_id As Long, _
                                   ByVal doc_id As Long, _
                                   ByVal nroDoc As String)
  Dim Tl           As Object
  Dim tal_id       As Long
  Dim iProp        As cIABMProperty
  Dim sqlstmt      As String
  Dim rs           As ADODB.Recordset
  Dim Mask         As String
  Dim bTaPropuesto As Boolean
  
  sqlstmt = "sp_ClienteGetTalonario " & cli_id & "," & doc_id
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Sub
  
  If rs.EOF Then Exit Sub
    
  tal_id = gDB.ValField(rs.Fields, 0)
  
  Set Tl = CSKernelClient2.CreateObject("CSDocumento2.cTalonario")
  
  Set iProp = m_ObjAbm.Properties.Item(cscFvNrodoc)
  Tl.GetNextNumber tal_id, Mask, bTaPropuesto
  iProp.Value = nroDoc
  iProp.TextMask = Mask
  iProp.Enabled = bTaPropuesto
  
  m_ObjAbm.ShowValue iProp
End Sub
