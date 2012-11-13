VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cImportRemito"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements CSInterfacesABM.cIABMClient
Implements CSMenu.cIMenuClient
'--------------------------------------------------------------------------------
' cImportRemito
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
Private Const C_Module = "cImportRemito"

Private Const cscPrId = "pr_id"
Private Const c_file = "file"
Private Const c_Progress = "prg"
Private Const c_log = "log"
Private Const c_logFile = "logFile"

Private Const K_FECHA = 1
Private Const K_DOCUMENTO_POS = 2
Private Const K_FILE = 5
Private Const K_LABEL = 6
Private Const K_PROGRESS = 7
Private Const K_CANCEL = 8
Private Const K_NRODOC = 9
Private Const K_SUC_ID = 10
Private Const K_LOGFILE = 12
Private Const K_LOG = 13

Private Const c_col_emp = 1
Private Const c_col_cli = 2
Private Const c_col_remito = 3
Private Const c_col_fecha = 4
Private Const c_col_producto = 5
Private Const c_col_descrip = 6
Private Const c_col_codigo = 7
Private Const c_col_importe = 8

Private Const c_col_lote = 10

Private Const c_ErrorSaveRemito = "Error al grabar el remito de venta"

Private Const cscToId                               As String = "to_id"

Private Const cscCliId                              As String = "cli_id"
Private Const cscCliNombre                          As String = "cli_nombre"

Private Const cscCcosId                             As String = "ccos_id"
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

' RemitoVenta
Private Const cscRvId                            As String = "rv_id"
Private Const cscRvNumero                        As String = "rv_numero"
Private Const cscRvNrodoc                        As String = "rv_nrodoc"
Private Const cscRvDescrip                       As String = "rv_descrip"
Private Const cscRvFecha                         As String = "rv_fecha"
Private Const cscRvFechaentrega                  As String = "rv_fechaentrega"
Private Const cscRvNeto                          As String = "rv_neto"
Private Const cscRvIvari                         As String = "rv_ivari"
Private Const cscRvIvarni                        As String = "rv_ivarni"
Private Const cscRvSubtotal                      As String = "rv_subtotal"
Private Const cscRvTotal                         As String = "rv_total"
Private Const cscRvPendiente                     As String = "rv_pendiente"
Private Const cscRvFirmado                       As String = "rv_firmado"
Private Const cscRvDescuento1                    As String = "rv_descuento1"
Private Const cscRvDescuento2                    As String = "rv_descuento2"
Private Const cscRvImportedesc1                  As String = "rv_importedesc1"
Private Const cscRvImportedesc2                  As String = "rv_importedesc2"
Private Const cscRvGrabarAsiento                 As String = "rv_grabarasiento"
Private Const cscRvCai                           As String = "rv_cai"

' RemitoVentaTMP
Private Const csTRemitoVentaTMP                  As String = "RemitoVentaTMP"
Private Const cscRvTMPId                         As String = "rvTMP_id"

' RemitoVentaItem
Private Const cscRviId                                 As String = "rvi_id"
Private Const cscRviOrden                              As String = "rvi_orden"
Private Const cscRviCantidad                           As String = "rvi_cantidad"
Private Const cscRviCantidadaremitir                   As String = "rvi_cantidadaremitir"
Private Const cscRviPendiente                          As String = "rvi_pendiente"
Private Const cscRviDescrip                            As String = "rvi_descrip"
Private Const cscRviPrecio                             As String = "rvi_precio"
Private Const cscRviPrecioUsr                          As String = "rvi_precioUsr"
Private Const cscRviPrecioLista                        As String = "rvi_precioLista"
Private Const cscRviDescuento                          As String = "rvi_descuento"
Private Const cscRviNeto                               As String = "rvi_neto"
Private Const cscRviIvari                              As String = "rvi_ivari"
Private Const cscRviIvarni                             As String = "rvi_ivarni"
Private Const cscRviIvariporc                          As String = "rvi_ivariporc"
Private Const cscRviIvarniporc                         As String = "rvi_ivarniporc"
Private Const cscRviImporte                            As String = "rvi_importe"
Private Const cscRviImportCodigo                       As String = "rvi_importCodigo"
Private Const cscCueIdIvaRI                            As String = "cue_id_IvaRI"
Private Const cscCueIdIvaRNI                           As String = "cue_id_IvaRNI"

' RemitoVentaItemTMP
Private Const csTRemitoVentaItemTMP                    As String = "RemitoVentaItemTMP"
Private Const cscRviTMPId                              As String = "rviTMP_id"

' estructuras
Private Type T_Item
  pr_codigo       As String
  pr_descrip      As String
  cantidad        As Double
  precio          As Double
  codigo          As String
  lote            As String
  
  pr_id           As Long
  pr_nombre       As String
  Neto            As Double
  ivaRi           As Double
  ivaRni          As Double
  ivaRiPorc       As Double
  ivaRniPorc      As Double
  cue_idProducto  As Long
  cue_idIvaRi     As Long
  cue_idIvaRni    As Long

End Type

' variables privadas
Private m_Editing           As Boolean
Private m_Host              As CSMenu.cIMenuHost
Private m_ObjAbm            As cIABMGeneric

Private m_bCancel           As Boolean
Private m_logFile           As String

Private m_file              As String
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
      If Ask(LNGGetText(3147, vbNullString), vbNo) Then
              'Confirma que desea cancelar la importación de Remitos
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
  Dim doc_id      As Long
  Dim suc_id      As Long
  Dim fecha       As Date
  
  m_ObjAbm.Properties.Item(c_log).Value = ""
  m_ObjAbm.ShowValue m_ObjAbm.Properties.Item(c_log)

  m_logFile = m_ObjAbm.Properties.Item(c_logFile).Value
  
  pAddToLog "*****************************************", True
  pAddToLog LNGGetText(3148, vbNullString), True
            'Iniciando importación de Remitos de Venta
            
  pAddToLog "", True
  
  doc_id = m_ObjAbm.Properties.Item(cscDocId).HelpId
  
  file = m_ObjAbm.Properties.Item(c_file).Value
  suc_id = m_ObjAbm.Properties.Item(cscSucId).HelpId
  fecha = m_ObjAbm.Properties.Item(cscRvFecha).Value
  
  ' Para grabar en ImportacionID.impid_descrip
  '
  m_file = file
  
  pAddToLog LNGGetText(3149, vbNullString, m_ObjAbm.Properties.Item(cscDocId).Value), True
            'Documento:  & m_ObjAbm.Properties.Item(cscDocId).Value
  pAddToLog LNGGetText(3150, vbNullString, file), True
            'Archivo:  & file
  pAddToLog LNGGetText(3150, vbNullString, m_ObjAbm.Properties.Item(cscSucId).Value), True
            'Sucursal:  & m_ObjAbm.Properties.Item(cscSucId).Value
  pAddToLog LNGGetText(3150, vbNullString, fecha), True
            'Fecha:  & fecha
  
  Dim exFile As Object 'As Excel.Application
  pAddToLog LNGGetText(3153, vbNullString), True
            'Creando objeto Excel
  Set exFile = CSKernelClient2.CreateObject("Excel.Application")
  
  pAddToLog LNGGetText(3154, vbNullString, file), True
            'Abriendo Archivo Excel: & file
  exFile.Workbooks.Open file
  
  Dim Sheet     As Object 'Excel.Worksheet
  Dim bIsCuit   As Boolean
  Dim bCantidad As Boolean
  
  pAddToLog LNGGetText(3155, vbNullString, file), True
            'Obteniendo hoja 1:  & file
  Set Sheet = exFile.Sheets(1)
  
  If Not pValidateCols(Sheet, bIsCuit, bCantidad) Then GoTo ExitProc
  
  Dim i           As Long
  Dim strFecha    As String
  Dim emp_codigo  As String
  Dim count       As Long
  Dim iProg       As cIABMProperty
  
  pAddToLog LNGGetText(3156, vbNullString), True
            'Obteniendo la cantidad de filas
            
  ' Obtengo la cantidad de filas que hay en el archivo
  '
  i = 2
    
  Do
    
    If Sheet.cells(i, c_col_cli) = "" Then Exit Do
    
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
  
  If pSaveAux(True, Sheet, bIsCuit, bCantidad, _
              count, iProg, doc_id, suc_id, fecha, _
              strFecha, emp_codigo) Then
    
    If Ask(LNGGetText(3157, vbNullString), vbNo) Then
            'El análisis del archivo terminó con éxito.;;¿Confirma la importación
      pSaveAux False, Sheet, bIsCuit, bCantidad, _
               count, iProg, doc_id, suc_id, fecha, _
               strFecha, emp_codigo
    End If
  End If
  
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

Private Function pSaveAux(ByVal bTest As Boolean, _
                          ByRef Sheet As Object, _
                          ByVal bIsCuit As Boolean, _
                          ByVal bCantidad As Boolean, _
                          ByVal count As Long, _
                          ByRef iProg As cIABMProperty, _
                          ByVal doc_id As Long, _
                          ByVal suc_id As Long, _
                          ByVal fecha As Date, _
                          ByVal strFecha As String, _
                          ByVal emp_codigo As String) As Boolean
                          
  Dim i           As Long
  Dim ID          As String
  Dim bErrors     As Boolean
  Dim remito      As String
  Dim vItems()    As T_Item
  Dim filas       As String
  Dim impid_id    As Long
  
  remito = ""
  
  i = 2
  
  ReDim vItems(0)
  
  If Not bTest Then
  
    impid_id = pGetImpId()
    
    If impid_id = csNO_ID Then
      MsgWarning LNGGetText(3158, vbNullString)
                  'No es posible iniciar la importación por que no se pudo & _
                  obtener un ID de importación.
      Exit Function
    End If
  End If
  
  Do
    
    ' Si no hay mas datos termine
    '
    If Sheet.cells(i, c_col_cli) = "" Then
      
      ' Si tengo un remito leido lo guardo
      '
      If LenB(remito) Then
        
        pSaveRemito ID, remito, bIsCuit, doc_id, _
                    suc_id, fecha, strFecha, _
                    emp_codigo, _
                    vItems(), filas, bErrors, bTest, impid_id
      End If
      
      Exit Do
    End If
    
    filas = filas & i & ","
    
    ' Si cambie de remito o de cliente
    '
    If Sheet.cells(i, c_col_remito) <> remito Or ID <> Sheet.cells(i, c_col_cli) Then
      
      ' Si tengo un remito leido lo guardo
      '
      If LenB(remito) Then
        
        pSaveRemito ID, remito, bIsCuit, doc_id, _
                    suc_id, fecha, strFecha, _
                    emp_codigo, _
                    vItems(), filas, bErrors, bTest, impid_id
      End If
            
      ' Nueva cabecera de remito
      '
      ID = Sheet.cells(i, c_col_cli)
      strFecha = Sheet.cells(i, c_col_fecha)
      emp_codigo = Sheet.cells(i, c_col_emp)
      filas = ""
      
      ' Incializo el remito
      '
      remito = Sheet.cells(i, c_col_remito)
      ReDim vItems(0)
      
    End If
    
    ReDim Preserve vItems(UBound(vItems) + 1)
    With vItems(UBound(vItems))
      If bCantidad Then
        .cantidad = Val(Sheet.cells(i, c_col_codigo))
      Else
        .cantidad = 1
      End If
      .precio = Val(Sheet.cells(i, c_col_importe))
      .pr_codigo = Trim(Sheet.cells(i, c_col_producto))
      .pr_descrip = Trim(Sheet.cells(i, c_col_descrip))
      .codigo = Trim(Sheet.cells(i, c_col_codigo))
      .lote = Trim(Sheet.cells(i, c_col_lote))
      
      If .lote = "" Then
        .lote = m_file
      End If
    End With
    
    iProg.Value = DivideByCero(i, count) * 100
    m_ObjAbm.ShowValue iProg
    DoEvents
    
    If m_bCancel Then Exit Function
    
    i = i + 1
    If i > Sheet.Rows.count Then Exit Do
  Loop
  
  Dim msg As String
  Dim bWarnning As Boolean
  
  If bErrors Then
    msg = LNGGetText(3159, vbNullString)
          'La importación terminó con algunos errores.;;Consulte el archivo de & _
          log para ver que registros nos se importaron.
    bWarnning = True
  Else
    msg = LNGGetText(3160, vbNullString)  'La importación terminó con éxito
  End If
  
  pAddToLog msg, True
  
  If Not bTest Or bWarnning Then
    MsgInfo msg
  End If

  pSaveAux = Not bErrors

End Function

Private Function pGetCliente(ByRef cli_id As Long, _
                             ByRef bIva As Boolean, _
                             ByRef bIvaRni As Boolean, _
                             ByVal ID As String, _
                             ByVal bIsCuit As Boolean, _
                             ByRef cliente As String) As Boolean
  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  
  sqlstmt = "sp_rv_getCliente " & gDB.sqlString(ID) & "," & CInt(bIsCuit)
  
  If Not gDB.OpenRs(sqlstmt, rs) Then
    pAddToLog LNGGetText(3161, vbNullString, ID), False, ID, cliente
              'No se pudo obtener el cli_id para el Cliente  & ID
    pAddToLog CSKernelClient2.LastErrorDescription, False
    Exit Function
  End If
  
  If rs.EOF Then
        
    If bIsCuit Then
                'No existe un cliente con CUIT
      pAddToLog LNGGetText(3195, vbNullString, _
                           ID), _
                False, ID, cliente
    Else
                'No existe un cliente con código
      pAddToLog LNGGetText(3196, vbNullString, _
                           ID), _
                False, ID, cliente
    End If
    
    pAddToLog CSKernelClient2.LastErrorDescription, False
    Exit Function
  End If
  
  cliente = gDB.ValField(rs.Fields, cscCliNombre)
  cli_id = gDB.ValField(rs.Fields, cscCliId)
  
  If Not pGetIvaFromCliente(cli_id, bIva, bIvaRni) Then
    pAddToLog LNGGetText(3162, vbNullString, ID), False, ID, cliente
              'No se pudo encontrar la definición de IVA para el cliente  & ID
    pAddToLog CSKernelClient2.LastErrorDescription, False
    Exit Function
  End If
  
  pGetCliente = True
End Function

Private Sub pAddToLog(ByVal msg As String, _
                      ByVal bOnlyToFile As Boolean, _
                      Optional ByVal ID As String, _
                      Optional ByVal cliente As String, _
                      Optional ByVal filas As String)
  On Error Resume Next
  
  If LenB(ID) Then
    msg = msg & " - [" & ID & " " & cliente & " (" & filas & ")]"
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
  cIABMClient_Title = LNGGetText(3163, vbNullString)  'Importar Remitos de Venta
End Property

Private Function cIABMClient_Validate() As Boolean

  Dim IProperty As cIABMProperty

  CSKernelClient2.Title = LNGGetText(3163, vbNullString)  'Importar Remitos de Venta

  For Each IProperty In m_ObjAbm.Properties
    With IProperty
      Select Case .Key
        Case K_FECHA
          If Not IsDate(.Value) Then
            MsgWarning LNGGetText(1558, vbNullString)  'Debe indicar una fecha
            Exit Function
          End If
        Case K_DOCUMENTO_POS
          If .HelpId = csNO_ID Then
            MsgWarning LNGGetText(3164, vbNullString)
                      'Debe indicar un documento para los Remitos
            Exit Function
          End If
        Case K_SUC_ID
          If .HelpId = csNO_ID Then
            MsgWarning LNGGetText(3143, vbNullString)
                       'Debe indicar una sucursal para guardar los movimientos
            Exit Function
          End If
        Case K_FILE
          If LenB(.Value) = 0 Then
            MsgWarning LNGGetText(3165, vbNullString)
                       'Debe indicar un archivo Excel con los Remitos
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
  Dim str_1033 As String
  
  str_1033 = LNGGetText(1033, vbNullString) 'Ve&ntas
  Set m_Host = Host
  m_Host.Server.AddMenu str_1033, csMenuConfigVentas, C_MenuConfig, 0, True, False, False, False, True, Nothing
  m_Host.Server.AddMenu LNGGetText(3166, vbNullString), csPreGVentaImportRemito, str_1033, 0, True, False, False, False, False, Me
                        '&Importar Remitos
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
  
  If Not SecurityCanAccess(csPreGVentaImportRemito) Then Exit Sub

  If Not LoadCollection() Then Exit Sub
  
  m_Editing = True
  
  Exit Sub
ControlError:
  MngError Err, "pEdit", C_Module, vbNullString
End Sub

Private Function LoadCollection() As Boolean

  m_ObjAbm.Properties.Clear

  With m_ObjAbm.Properties.Add(Nothing, cscRvFecha)
    .PropertyType = cspDate
    .Name = LNGGetText(1569, vbNullString)  'Fecha
    .Key = K_FECHA
    .Value = VDGetDateById(csToday)
  End With
  
  With m_ObjAbm.Properties.Add(Nothing, cscDocId)
    .PropertyType = cspHelp
    .Width = 3000
    .Table = csDocumento
    .HelpFilter = "'doct_id = 3'"
    .Name = LNGGetText(1567, vbNullString)  'Documento
    .Key = K_DOCUMENTO_POS
    .HelpId = csNO_ID
  End With
  
  With m_ObjAbm.Properties.Add(Nothing, cscSucId)
    .PropertyType = cspHelp
    .Table = csSucursal
    .Name = LNGGetText(1281, vbNullString)  'Sucursal
    .Key = K_SUC_ID
    .HelpId = csNO_ID
  End With
  
  With m_ObjAbm.Properties.Add(Nothing, c_log)
    .PropertyType = cspText
    .LeftFromProperty = cscRvFecha
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
    .Value = GetValidPath(App.Path) & "importar_remitos.log"
    .HelpFilter = LNGGetText(2989, vbNullString)  'Archivo de Log|*.log
  End With
  
  With m_ObjAbm.Properties.Add(Nothing, "Label")
    .PropertyType = cspLabel
    .TopToPrevious = 540
    .Width = 5000
    .Height = 800
    .FontBold = True
    .Value = LNGGetText(3167, vbNullString)
             'El archivo debe contener una sola hoja & _
              Y las siguientes columnas en este orden: & _
                - empresa, cliente, remito, fecha, producto,  & _
                 descrip, codigo e importe
    .Key = K_LABEL
  End With
  
  With m_ObjAbm.Properties.Add(Nothing, c_file)
    .PropertyType = cspFile
    .Name = LNGGetText(2966, vbNullString)  'Archivo
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
  
  With m_ObjAbm.Properties.Add(Nothing, cscRvNrodoc)
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
  
  With m_ObjAbm.Properties.Add(Nothing, cscRvCai)
    .PropertyType = cspLabel
    .Visible = False
  End With
  
  Dim AbmObj As cABMGeneric
  Set AbmObj = m_ObjAbm
  AbmObj.bDontAskForSave = True
  AbmObj.OkCancelDialog = True
  AbmObj.MinHeight = 8500
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
                       ByVal remito As String, _
                       ByVal fecha As Date, _
                       ByRef vItems() As T_Item, _
                       ByVal bIva As Boolean, _
                       ByVal bIvaRni As Boolean, _
                       ByVal bTest As Boolean, _
                       ByVal impid_id As Long) As Boolean
  
  Dim register     As cRegister
  Dim Neto         As Double
  Dim i            As Integer
  Dim ivaRi        As Double
  Dim ivaRni       As Double
  
  Dim Mouse As cMouseWait
  Set Mouse = New cMouseWait
  
  DoEvents: DoEvents: DoEvents: DoEvents
  
  Set register = New cRegister
  With register
    .fieldId = cscRvTMPId
    .Table = csTRemitoVentaTMP
    
    .ID = csNew
      
    With .Fields
      .Add2 cscRvId, csNew, csLong
      .Add2 cscRvNumero, 0, csLong
      
      pSetRemitoNroDoc remito, doc_id

      .Add2 cscRvNrodoc, _
                   m_ObjAbm.Properties.Item(cscRvNrodoc).Value, _
                   csText
      
      .Add2 cscRvDescrip, "", csText
      .Add2 cscRvFecha, fecha, csDate
      .Add2 cscRvFechaentrega, fecha, csDate
      .Add2 cscCliId, cli_id, csId
      .Add2 cscCcosId, csNO_ID, csId
      .Add2 cscSucId, suc_id, csId
      .Add2 cscRvDescuento1, 0, csCurrency
      .Add2 cscRvDescuento2, 0, csCurrency
      .Add2 cscDocId, doc_id, csId
      .Add2 cscLpId, csNO_ID, csId
      .Add2 cscLdId, csNO_ID, csId
                                    
                                    ' Fecha del documento
      .Add2 cscCpgId, -2, csId
      
      .Add2 cscVenId, csNO_ID, csId
      .Add2 cscLgjId, csNO_ID, csId
      .Add2 cscProIdOrigen, csNO_ID, csId
      .Add2 cscProIdDestino, csNO_ID, csId
      .Add2 cscTransId, csNO_ID, csId
      .Add2 cscDeplId, csNO_ID, csId
      
      For i = 1 To UBound(vItems)
        
        vItems(i).Neto = vItems(i).cantidad * vItems(i).precio
        Neto = Neto + vItems(i).Neto
                                   
        If Not pSetDataProducto(vItems(i)) Then
          pAddToLog LNGGetText(3133, vbNullString, vItems(i).pr_descrip), False
                    'No se pudo obtener la informacion impositiva y contable & _
                    asociada al articulo vItems(i).pr_descrip
                    
          Exit Function
        End If

        If bIva Then
          vItems(i).ivaRi = (vItems(i).cantidad * vItems(i).precio) * vItems(i).ivaRiPorc / 100
          ivaRi = ivaRi + vItems(i).ivaRi
        Else
          ivaRi = 0
        End If
        
        If bIvaRni Then
          vItems(i).ivaRni = (vItems(i).cantidad * vItems(i).precio) * vItems(i).ivaRniPorc / 100
          ivaRni = ivaRni + vItems(i).ivaRni
        Else
          ivaRni = 0
        End If

      Next

      .Add2 cscRvNeto, Neto, csCurrency
      .Add2 cscRvIvari, ivaRi, csCurrency
      .Add2 cscRvIvarni, ivaRni, csCurrency
      .Add2 cscRvSubtotal, Neto + ivaRi + ivaRni, csCurrency
      .Add2 cscRvImportedesc1, 0, csCurrency
      .Add2 cscRvImportedesc2, 0, csCurrency
      
      .Add2 cscRvTotal, Neto + ivaRi + ivaRni, csCurrency
      .Add2 cscEstId, CSGeneralEx2.csEEstado.csEEst_Pendiente, csId
      
      .HaveLastUpdate = True
      .HaveWhoModify = True
    End With
  End With
  
  If Not register.BeginTrans(gDB) Then Exit Function
  
  If Not gDB.Save(register, , "pSave", C_Module, c_ErrorSaveRemito) Then Exit Function
  
  If Not pSaveItems(register.ID, _
                    vItems()) Then Exit Function
                    
  If Not register.CommitTrans() Then Exit Function
  
  Dim sqlstmt As String
  Dim rs      As Recordset
  
  sqlstmt = "sp_rv_importSave " & register.ID & ", " _
                                & CInt(bTest) & "," _
                                & impid_id & "," _
                                & gDB.sqlString(LNGGetText(3171, vbNullString, m_file, vItems(1).lote))
                                                'Archivo: " & m_file & " - Lote " & vItems(1).lote
  If Not gDB.OpenRs(sqlstmt, rs, , , , "cIABMClient_Save", C_Module, c_ErrorSaveRemito) Then
    
    ' Si el error es por clave duplicada
    If CSKernelClient2.LastErrorNumber = -2147217900 Then
      If InStr(1, CSKernelClient2.LastErrorDescription, "IX_RemitoVentaNroDocEmpresa") Then
        pShowRemitoDuplicado
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
                            ByRef vItems() As T_Item) As Boolean
                            
  Dim register  As cRegister
  Dim iOrden    As Long
  Dim Origen    As Double
  Dim i         As Integer
  
  ' Para numeros de serie
  '
  Dim iOrden2     As Long
  Dim Grupo       As Long
        
  For i = 1 To UBound(vItems)
  
    Set register = New cRegister
    
    With register
      .fieldId = cscRviTMPId
      .Table = csTRemitoVentaItemTMP
      .ID = csNew
      
      With .Fields
        .Add2 cscRviId, csNew, csInteger
        .Add2 cscRviCantidad, 1, csDouble
        .Add2 cscRviDescrip, vItems(i).pr_descrip, csText
        .Add2 cscRviPrecio, vItems(i).precio, csCurrency
        .Add2 cscRviPrecioLista, 0, csCurrency
        .Add2 cscRviPrecioUsr, vItems(i).precio, csCurrency
        .Add2 cscRviNeto, vItems(i).Neto, csCurrency
        .Add2 cscRviIvari, vItems(i).ivaRi, csCurrency
        .Add2 cscRviIvarni, vItems(i).ivaRni, csCurrency
        .Add2 cscRviIvariporc, vItems(i).ivaRiPorc, csDouble
        .Add2 cscRviIvarniporc, vItems(i).ivaRniPorc, csDouble
        .Add2 cscPrId, vItems(i).pr_id, csId
        .Add2 cscCcosId, csNO_ID, csId
        
        Origen = vItems(i).Neto + vItems(i).ivaRi + vItems(i).ivaRni
        
        .Add2 cscRviImporte, Origen, csCurrency
          
        iOrden = iOrden + 1
        .Add2 cscRviOrden, iOrden, csInteger
        .Add2 cscRvTMPId, ID, csId
        
        .Add2 cscRviImportCodigo, vItems(i).codigo, csText
          
        .HaveLastUpdate = False
        .HaveWhoModify = False
      End With
    End With
    
    If Not gDB.Save(register, , "pSaveItems", C_Module, c_ErrorSaveRemito) Then Exit Function
  
  Next
  
  pSaveItems = True
End Function

Private Sub pShowRemitoDuplicado()
  Dim nroDoc    As String
  Dim sqlstmt   As String
  Dim rs        As ADODB.Recordset
  Dim msg       As String
  
  nroDoc = m_ObjAbm.Properties.Item(cscRvNrodoc).Value
  sqlstmt = "sp_DocRemitoVentaGetForNroDoc " & gDB.sqlString(nroDoc) & "," & EmpId
  
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Sub
  
  If Not rs.EOF Then
    With rs.Fields
      msg = LNGGetText(3169, vbNullString, .Item(cscRvNrodoc).Value, .Item(cscCliNombre).Value, .Item(cscDocNombre).Value, .Item(cscRvFecha).Value)
            'El remito  & .Item(cscRvNrodoc).Value &  pertenece al cliente  & _
            .Item(cscCliNombre).Value &  en el documento  & .Item(cscDocNombre).Value &  generado el  & .Item(cscRvFecha).Value
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
            'Advertencia: & msg
  CSKernelClient2.MsgWarning msg
End Sub

'///////////////////////////////////////////////////////////////////////////////////////////////
'///////////////////////////////////////////////////////////////////////////////////////////////
'///////////////////////////////////////////////////////////////////////////////////////////////
'///////////////////////////////////////////////////////////////////////////////////////////////

Private Function pSetDataProducto(ByRef Item As T_Item) As Boolean
  Dim sqlstmt     As String
  Dim rs          As Recordset
  Dim ti_ri       As Long
  Dim ti_rni      As Long
  
  If Not pGetPrId(Item) Then Exit Function
  
  sqlstmt = "sp_StockProductoGetData " & Item.pr_id
  
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Function
  
  If Not rs.EOF Then
    Item.cue_idProducto = gDB.ValField(rs.Fields, cscCueidventa)
  End If

  If Not GetTasaFromProducto(Item.pr_id, ti_ri, ti_rni, False) Then Exit Function
  
  If ti_ri = 0 Then
    MsgWarning LNGGetText(1597, vbNullString, Item.pr_nombre)
                'El producto [" & Item.pr_nombre & "] no tiene definida su tasa & _
                impositiva de ventas para el iva responsable inscripto
    Exit Function
  End If
  
  If ti_rni = 0 Then
    MsgWarning LNGGetText(1598, vbNullString, Item.pr_nombre)
              'El producto [" & Item.pr_nombre & "] no tiene definida su tasa & _
              impositiva de ventas para el iva responsable no inscripto
    Exit Function
  End If
  
  sqlstmt = "select ti_porcentaje,cue_id from tasaimpositiva where ti_id = " & ti_ri
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Function
  
  If Not rs.EOF Then
    Item.ivaRiPorc = gDB.ValField(rs.Fields, cscTiPorcentaje)
    Item.cue_idIvaRi = gDB.ValField(rs.Fields, cscCueId)
  End If
  
  sqlstmt = "select ti_porcentaje,cue_id from tasaimpositiva where ti_id = " & ti_rni
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Function
  
  If Not rs.EOF Then
    Item.ivaRniPorc = gDB.ValField(rs.Fields, cscTiPorcentaje)
    Item.cue_idIvaRni = gDB.ValField(rs.Fields, cscCueId)
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

Private Function pValidateCols(ByRef Sheet As Object, _
                               ByRef bIsCuit As Boolean, _
                               ByRef bCantidad As Boolean) As Boolean
  Dim colName As String
  
  colName = LCase(Sheet.cells(1, c_col_cli))
  If colName <> "cliente" And colName <> "cuit" Then
    MsgWarning LNGGetText(3172, vbNullString)
              'La primer columna debe llamarse cliente o cuit.  & _
               Si se llama cliente debe indicar el código, sino el CUIT
    Exit Function
  Else
    bIsCuit = colName = "cuit"
  End If
  
  colName = LCase(Sheet.cells(1, c_col_emp))
  If colName <> "empresa" Then
    MsgWarning LNGGetText(3177, vbNullString, c_col_emp)
               'La columna # debe llamarse Empresa
    Exit Function
  End If
  
  colName = LCase(Sheet.cells(1, c_col_remito))
  If colName <> "remito" Then
    MsgWarning LNGGetText(3178, vbNullString, c_col_remito)
              'La columna # debe llamarse Remito
    Exit Function
  End If
  
  colName = LCase(Sheet.cells(1, c_col_fecha))
  If colName <> "fecha" Then
    MsgWarning LNGGetText(3173, vbNullString, c_col_fecha)
    'La columna # debe llamarse Fecha
    Exit Function
  End If

  colName = LCase(Sheet.cells(1, c_col_producto))
  If colName <> "producto" Then
    MsgWarning LNGGetText(3174, vbNullString, c_col_producto)
              'La columna # debe llamarse Producto
    Exit Function
  End If

  colName = LCase(Sheet.cells(1, c_col_descrip))
  If colName <> "descrip" Then
    MsgWarning LNGGetText(3175, vbNullString, c_col_descrip)
               'La columna # debe llamarse Descrip
    Exit Function
  End If
  
  colName = LCase(Sheet.cells(1, c_col_codigo))
  If colName <> "codigo" Then
    MsgWarning LNGGetText(3179, vbNullString, c_col_codigo)
                'La columna # debe llamarse Código
    Exit Function
  End If
  
  colName = LCase(Sheet.cells(1, c_col_importe))
  If colName <> "importe" Then
    MsgWarning LNGGetText(3176, vbNullString, c_col_importe)
               'La columna # debe llamarse Importe
    Exit Function
  End If

  colName = LCase(Sheet.cells(1, 9))
  bCantidad = colName = "cantidad"

  pValidateCols = True
End Function

Private Sub pSaveRemito(ByVal ID As String, _
                        ByVal remito As String, _
                        ByVal bIsCuit As Boolean, _
                        ByVal doc_id As Long, _
                        ByVal suc_id As Long, _
                        ByVal fecha As Date, _
                        ByVal strFecha As String, _
                        ByVal emp_codigo As String, _
                        ByRef vItems() As T_Item, _
                        ByVal filas As String, _
                        ByRef bErrors As Boolean, _
                        ByVal bTest As Boolean, _
                        ByVal impid_id As Long)
  
  Dim cli_id    As Long
  Dim cliente   As String
  Dim bIva      As Boolean
  Dim bIvaRni   As Boolean
  Dim rv_fecha  As Date
  Dim bCancel   As Boolean
  
  cliente = ID
  
  filas = RemoveLastColon(filas)
  
  If pValidate(emp_codigo, strFecha, rv_fecha) Then
    
    If fecha <> rv_fecha Then
    
      If Not pAsk(LNGGetText(3180, vbNullString), vbNo) Then
                  'La fecha de este registro no coincide  & _
                  con la que Ud. indicó en los parámetros de la importación;; & _
                  ¿Confirma la importación de este registro?
                  
        pAddToLog LNGGetText(3181, vbNullString, remito), False, ID, cliente, filas
                   'El remito " & remito & " no se importó por que la fecha no & _
                    conicidio con la indicada en los parámetros de importación
                   
        bCancel = True
        bErrors = True
      End If
    End If
    
    If Not bCancel Then
    
      ' Obtengo los datos del cliente para este remito
      '
      If pGetCliente(cli_id, bIva, bIvaRni, ID, bIsCuit, cliente) Then
      
        ' El remito se guardo con exito
        '
        If pSave(cli_id, doc_id, suc_id, remito, rv_fecha, _
                 vItems(), bIva, bIvaRni, bTest, impid_id) Then
          
          If Not bTest Then
            pAddToLog LNGGetText(3182, vbNullString, m_ObjAbm.Properties.Item(cscRvNrodoc).Value), _
                      True, ID, cliente, filas
                      'Movimiento generado: m_ObjAbm.Properties.Item(cscRvNrodoc).Value
          End If
          
        ' Si no puedo guardar el remito genero un log con error
        '
        Else
          
          pAddToLog CSKernelClient2.LastErrorDescription, False, ID, cliente, filas
          bErrors = True
        End If
      
      Else
        bErrors = True
      End If
    End If
  Else
    bErrors = True
  End If
End Sub

Private Function pGetPrId(ByRef Item As T_Item) As Boolean
  Dim bExists As Boolean
  
  If Not gDB.GetDataWithCondition("producto", cscPrId, _
                                  "pr_codigo = " & gDB.sqlString(Item.pr_codigo), _
                                  Item.pr_id, bExists) Then
    MsgWarning LNGGetText(3183, vbNullString, Item.pr_codigo)
                'No se pudo encontrar el Producto asociado al código  & Item.pr_codigo
    Exit Function
  Else
    If Not bExists Then
      MsgWarning LNGGetText(3184, vbNullString, Item.pr_codigo)
                  'El código de producto & Item.pr_codigo &  no existe en Cairo
      Exit Function
    End If
  End If
  pGetPrId = True
End Function

Private Function pValidate(ByVal emp_codigo As String, _
                           ByVal strFecha As String, _
                           ByRef rv_fecha As Date) As Boolean
  Dim bExists As Boolean
  Dim emp_id  As Long
  
  If Not gDB.GetDataWithCondition(csTEmpresa, cscEmpId, _
                                  "emp_codigo = " & gDB.sqlString(emp_codigo), _
                                  emp_id, bExists) Then
  
    MsgWarning LNGGetText(3185, vbNullString, emp_codigo)
                'No se pudo encontrar una empresa asociada al código & emp_codigo
    Exit Function
  Else
    If Not bExists Then
      MsgWarning LNGGetText(3186, vbNullString, emp_codigo)
                  'El código de la empresa  & emp_codigo &  no existe en Cairo.
      Exit Function
    Else
      If emp_id <> EmpId Then
        MsgWarning LNGGetText(3187, vbNullString, emp_codigo, CSOAPI2.EmpNombre)
                   'La empresa de este registro no coincide con la empresa activa " & _
                   (registro: & emp_codigo & | empresa activa:  & CSOAPI2.EmpNombre & )
        Exit Function
      End If
    End If
  End If
  
  If Not pIsDate(strFecha, rv_fecha) Then
    MsgWarning LNGGetText(3188, vbNullString, strFecha)
                'La fecha [ & strFecha & ] no es válida
    Exit Function
  End If
  
  pValidate = True
End Function

Private Function pIsDate(ByVal strFecha As String, _
                         ByRef rtnDate As Date) As Boolean
  On Error Resume Next
  
  Err.Clear
  
  rtnDate = DateSerial(Mid$(strFecha, 1, 4), _
                       Mid$(strFecha, 5, 2), _
                       Mid$(strFecha, 7, 2))

  pIsDate = Err.Number = 0
End Function

Private Sub pSetRemitoNroDoc(ByVal remito As String, _
                             ByVal doc_id As Long)
                             
  Dim iProp       As cIABMProperty
  Dim Tl          As Object
  Dim tal_id      As Long
  Dim Mask        As String
  Dim nroDoc      As String
  
  If Not gDB.GetData("documento", "doc_id", doc_id, "ta_id", tal_id) Then
    Exit Sub
  End If

  Set Tl = CSKernelClient2.CreateObject("CSDocumento2.cTalonario")

  Set iProp = m_ObjAbm.Properties.Item(cscRvNrodoc)
  nroDoc = Tl.GetNextNumber(tal_id, Mask, True, "")
  iProp.Value = remito
  iProp.TextMask = Mask
  m_ObjAbm.ShowValue iProp
End Sub

Private Function pAsk(ByVal msg As String, ByVal default As VbMsgBoxStyle) As Boolean
  Dim rtn As VbMsgBoxResult
  rtn = MsgBox(Replace(msg, ";", vbCrLf), vbQuestion + vbYesNoCancel + vbDefaultButton2)
  pAsk = rtn = vbYes
  If rtn = vbCancel Then
    cIABMClient_PropertyChange K_CANCEL
  End If
End Function

Private Function pGetImpId() As Long
  Dim impid_id As Long
  If Not gDB.GetNewId("ImportacionID", "impid_id", impid_id) Then Exit Function
  pGetImpId = impid_id
End Function
