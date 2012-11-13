VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cImportAsiento"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements CSInterfacesABM.cIABMClient
Implements CSMenu.cIMenuClient
'--------------------------------------------------------------------------------
' cImportAsiento
' 18-11-2007

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cImportAsiento"

Private Const cscDocId = "doc_id"
Private Const c_file = "file"
Private Const c_Progress = "prg"
Private Const c_log = "log"
Private Const c_logFile = "logFile"
Private Const csDocumento = 4001

Private Const K_FECHA = 1
Private Const K_DOCUMENTO = 2
Private Const K_FILE = 5
Private Const K_LABEL = 6
Private Const K_PROGRESS = 7
Private Const K_CANCEL = 8
Private Const K_NRODOC = 9
Private Const K_LOGFILE = 12
Private Const K_LOG = 13

Private Const c_ErrorSaveFactura = "Error al grabar la factura de compra"

Private Const cscCcosId                             As String = "ccos_id"
Private Const cscCcosNombre                         As String = "ccos_nombre"

Private Const cscDocNombre                          As String = "doc_nombre"

'Asiento
Private Const csTAsiento                         As String = "Asiento"
Private Const cscAsId                            As String = "as_id"
Private Const cscAsNumero                        As String = "as_numero"
Private Const cscAsNrodoc                        As String = "as_nrodoc"
Private Const cscAsDescrip                       As String = "as_descrip"
Private Const cscAsFecha                         As String = "as_fecha"
Private Const cscAsDocCliente                    As String = "as_doc_cliente"
Private Const cscIdCliente                       As String = "id_cliente"
Private Const cscDoctIdCliente                   As String = "doct_id_cliente"

'AsientoItem
Private Const csTAsientoItem                           As String = "AsientoItem"
Private Const cscAsiId                                 As String = "asi_id"
Private Const cscAsiOrden                              As String = "asi_orden"
Private Const cscAsiDescrip                            As String = "asi_descrip"
Private Const cscAsiDebe                               As String = "asi_debe"
Private Const cscAsiHaber                              As String = "asi_haber"
Private Const cscAsiOrigen                             As String = "asi_origen"

'AsientoItemTMP
Private Const csTAsientoItemTMP                        As String = "AsientoItemTMP"
Private Const cscAsiTMPId                              As String = "asiTMP_id"

'AsientoTMP
Private Const csTAsientoTMP                      As String = "AsientoTMP"
Private Const cscAsTMPId                         As String = "asTMP_id"

' estructuras
Private Type t_Items
  Cue_id      As Long
  cue_codigo  As String
  debe        As Double
  haber       As Double
  ccos_id     As Double
  ccos_codigo As String
  descrip     As String
End Type
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
  
  Dim file          As String
  Dim doc_id        As Long
  Dim doc_idneg     As Long
  Dim fecha         As Date
  
  m_ObjAbm.Properties.Item(c_log).Value = ""
  m_ObjAbm.ShowValue m_ObjAbm.Properties.Item(c_log)

  m_logFile = m_ObjAbm.Properties.Item(c_logFile).Value
  
  pAddToLog "*****************************************", True
  pAddToLog LNGGetText(3935, vbNullString), True
            'Iniciando importación de Asientos
  pAddToLog "", True
  
  doc_id = m_ObjAbm.Properties.Item(cscDocId).HelpId
  
  file = m_ObjAbm.Properties.Item(c_file).Value
  
  fecha = m_ObjAbm.Properties.Item(cscAsFecha).Value
    
  pAddToLog LNGGetText(3936, vbNullString, m_ObjAbm.Properties.Item(cscDocId).Value), True
            'Documento:  & m_ObjAbm.Properties.Item(cscDocId).Value
  pAddToLog LNGGetText(3150, vbNullString, file), True
            'Archivo:  & file
  pAddToLog LNGGetText(3152, vbNullString, fecha), True
            'Fecha:  & fecha, True
                                   
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
  Dim bCentroCostoFromExcel   As Boolean
    
  Dim nroDoc                  As String
  Dim descrip                 As String
  
  pAddToLog LNGGetText(3155, vbNullString, file), True
            'Obteniendo hoja 1:  & file
  Set Sheet = exFile.Sheets(1)
    
  colName = LCase(Sheet.cells(1, 1))
  If colName <> "comprobante" Then
    MsgWarning LNGGetText(3940, vbNullString)
              'La primera columna del archivo debe llamarse cuenta
    GoTo ExitProc
  End If
    
  colName = LCase(Sheet.cells(1, 2))
  If colName <> "cuenta" Then
    MsgWarning LNGGetText(3940, vbNullString)
              'La segunda columna del archivo debe llamarse cuenta
    GoTo ExitProc
  End If
    
  colName = LCase(Sheet.cells(1, 3))
  If colName <> "debe" Then
    MsgWarning LNGGetText(3941, vbNullString)
              'La tercera columna del archivo debe llamarse debe
    GoTo ExitProc
  End If
  
  colName = LCase(Sheet.cells(1, 4))
  If colName <> "haber" Then
    MsgWarning LNGGetText(3942, vbNullString)
              'La cuarta columna del archivo debe llamarse haber
    GoTo ExitProc
  End If
  
  colName = LCase(Sheet.cells(1, 5))
  If colName = "fecha" Then
    bFechaFromExcel = True
  End If
    
  colName = LCase(Sheet.cells(1, 6))
  If colName = "centro de costo" Then
    bCentroCostoFromExcel = True
  End If
    
  Dim i     As Long
  Dim ID    As String
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
  
  Dim bErrors     As Boolean
  Dim bImport     As Boolean
  Dim vItems()    As t_Items
  Dim lastNroDoc  As String
  
  ReDim vItems(0)
  
  i = 2
  
  Do
    
    If Sheet.cells(i, 1) = "" Then Exit Do
    
    nroDoc = Sheet.cells(i, 1)
    
    If lastNroDoc <> nroDoc Then

      If lastNroDoc <> "" Then
      
        If Not pSave(doc_id, fecha, lastNroDoc, descrip, vItems()) Then
          
          pAddToLog CSKernelClient2.LastErrorDescription, False, ID
          bErrors = True
          
        Else
          pAddToLog LNGGetText(3182, vbNullString, _
                    m_ObjAbm.Properties.Item(cscAsNrodoc).Value), True, ID
                    'Movimiento generado:  & _
                    m_ObjAbm.Properties.Item(cscAsNrodoc).Value
        End If
      
      End If
      
      lastNroDoc = nroDoc
      ReDim vItems(0)
    
    End If
    
    ReDim Preserve vItems(UBound(vItems) + 1)
    
    ID = Sheet.cells(i, 1)
    
    If bFechaFromExcel Then
      fecha = Sheet.cells(i, 5)
    End If
            
    With vItems(UBound(vItems))
    
      .cue_codigo = Sheet.cells(i, 2)
      .ccos_codigo = Sheet.cells(i, 6)

      .debe = Val(Sheet.cells(i, 3))
      .haber = Val(Sheet.cells(i, 4))
      .descrip = Sheet.cells(i, 8)
      If .debe <> 0 Then .haber = 0
      
    End With
    
    descrip = Sheet.cells(i, 7)
        
    iProg.Value = DivideByCero(i, count) * 100
    m_ObjAbm.ShowValue iProg
    DoEvents
    
    If m_bCancel Then GoTo ExitProc
    
    i = i + 1
    If i > Sheet.Rows.count Then Exit Do
  Loop
  
  If lastNroDoc <> "" Then
  
    If Not pSave(doc_id, fecha, lastNroDoc, descrip, vItems()) Then
      
      pAddToLog CSKernelClient2.LastErrorDescription, False, ID
      bErrors = True
    Else
      pAddToLog LNGGetText(3182, vbNullString, _
                m_ObjAbm.Properties.Item(cscAsNrodoc).Value), True, ID
                'Movimiento generado:  & _
                m_ObjAbm.Properties.Item(cscAsNrodoc).Value
    End If
  
  End If
  
  
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
  
  If Not exFile Is Nothing Then
    exFile.Workbooks.Close
  End If
End Function

Private Sub pAddToLog(ByVal msg As String, _
                      ByVal bOnlyToFile As Boolean, _
                      Optional ByVal ID As String)
  On Error Resume Next
  
  If LenB(ID) Then
    msg = msg & " - [" & ID & "]"
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
  cIABMClient_Title = LNGGetText(3945, vbNullString) 'Importar Saldos Asientos Contables
End Property

Private Function cIABMClient_Validate() As Boolean

  Dim IProperty As cIABMProperty

  CSKernelClient2.Title = LNGGetText(3945, vbNullString) 'Importar Saldos Asientos Contables

  For Each IProperty In m_ObjAbm.Properties
    With IProperty
      Select Case .Key
        Case K_FECHA
          If Not IsDate(.Value) Then
            MsgWarning LNGGetText(1558, vbNullString) 'Debe indicar una fecha
            Exit Function
          End If
        Case K_DOCUMENTO
          If .HelpId = csNO_ID Then
            MsgWarning LNGGetText(3937, vbNullString)
                       'Debe indicar un documento para los asientos
            Exit Function
          End If
        Case K_FILE
          If LenB(.Value) = 0 Then
            MsgWarning LNGGetText(3946, vbNullString)
                       'Debe indicar un archivo Excel con los asientos contables
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
  Dim str_1032    As String

  str_1032 = LNGGetText(1032, vbNullString) '&Contabilidad
  
  Set m_Host = Host
  m_Host.Server.AddMenu str_1032, csMenuConfigContabilidad, C_MenuConfig, 0, True, False, False, False, True, Nothing
  m_Host.Server.AddMenu LNGGetText(3938, vbNullString), csPreGImportarAsientos, str_1032, 0, True, False, False, False, False, Me
                        '&Importar Asientos Contables
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
  
  If Not SecurityCanAccess(csPreGImportarAsientos) Then Exit Sub

  If Not LoadCollection() Then Exit Sub
  
  m_Editing = True
  
  Exit Sub
ControlError:
  MngError Err, "pEdit", C_Module, vbNullString
End Sub

Private Function LoadCollection() As Boolean

  m_ObjAbm.Properties.Clear

  With m_ObjAbm.Properties.Add(Nothing, cscAsFecha)
    .PropertyType = cspDate
    .Name = LNGGetText(1569, vbNullString)  'Fecha
    .Key = K_FECHA
    .Value = VDGetDateById(csToday)
  End With
  
  With m_ObjAbm.Properties.Add(Nothing, cscDocId)
    .PropertyType = cspHelp
    .Width = 3000
    .Table = csDocumento
    .HelpFilter = "'doct_id = 15'"
    .Name = LNGGetText(1567, vbNullString)  'Documento
    .Key = K_DOCUMENTO
    .HelpId = csNO_ID
  End With
        
  With m_ObjAbm.Properties.Add(Nothing, c_log)
    .PropertyType = cspText
    .LeftFromProperty = cscAsFecha
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
    .Value = LNGGetText(3939, vbNullString)
              'El archivo debe tener una sola hoja _
                Y las siguientes tres columnas: _
                   - Cuenta _
                   - Debe _
                   - Haber _
                 Opcionalmente puede tener: _
                   - Fecha _
                   - Centro de Costo _
                   - Comprobante _
                Se debe respetar el orden.

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
  
  With m_ObjAbm.Properties.Add(Nothing, cscAsNrodoc)
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

Private Function pSave(ByVal doc_id As Long, _
                       ByVal fecha As Date, _
                       ByVal nroDoc As String, _
                       ByVal descrip As String, _
                       ByRef vItems() As t_Items) As Boolean
  
  Dim register     As cRegister
  Dim Neto         As Double
  
  ' Save and State
  '
  ' TODO: Verificar permisos sobre los documentos
  '
  'If Not DocCanEdit(m_DocEditable, m_DocEditMsg) Then
  '  cIABMClient_Save = True
  '  Exit Function
  'End If
  'If Not DocCanSave(m_ObjAbm, cscAsFecha) Then
  '  cIABMClient_Save = False
  '  Exit Function
  'End If
  
  Dim Mouse As cMouseWait
  Set Mouse = New cMouseWait
  
  DoEvents: DoEvents: DoEvents: DoEvents
  
  Set register = New cRegister
  With register
    .fieldId = cscAsTMPId
    .Table = csTAsientoTMP
    
    .ID = csNew
      
    With .Fields
      .Add2 cscAsId, csNew, csLong
      .Add2 cscAsNumero, 0, csLong
      
      pGetDocNumberFromExcel doc_id, nroDoc
      
      .Add2 cscAsNrodoc, _
                   m_ObjAbm.Properties.Item(cscAsNrodoc).Value, _
                   csText
      
      .Add2 cscAsFecha, fecha, csDate
      .Add2 cscAsDescrip, descrip, csText
      
      .Add2 cscDocId, doc_id, csId
      .Add2 "doct_id", 15, csId
      
      .HaveLastUpdate = True
      .HaveWhoModify = True
    End With
  End With
  
  If Not register.BeginTrans(gDB) Then Exit Function
  
  If Not gDB.Save(register, , "pSave", C_Module, c_ErrorSaveFactura) Then Exit Function
  
  If Not pSaveItems(register.ID, vItems()) Then Exit Function
  If Not register.CommitTrans() Then Exit Function
  
  Dim sqlstmt As String
  Dim rs      As Recordset
  sqlstmt = "sp_DocAsientoSave " & register.ID
  
  If Not gDB.OpenRs(sqlstmt, rs, , , , "cIABMClient_Save", C_Module, c_ErrorSaveFactura) Then
    
    ' Si el error es por clave duplicada
    If CSKernelClient2.LastErrorNumber = -2147217900 Then
      If InStr(1, CSKernelClient2.LastErrorDescription, "IX_AsientoNroDocEmpresa") Then
        
        Dim msg As String
        
        With m_ObjAbm.Properties
          msg = LNGGetText(3947, vbNullString, .Item(cscAsNrodoc).Value, _
                                               .Item(cscProvNombre).Value)
          'Ya se ha cargado un asiento con numero #1# en esta empresa.
        End With
        MsgWarning msg
      End If
    End If
    Exit Function
  End If
  
  If rs.EOF Then Exit Function
  
  Dim ID As Long
  If Not GetDocIDFromRecordset(rs, ID) Then Exit Function
  
  pSave = ID <> csNO_ID
End Function

Private Function pSaveItems(ByVal ID As Long, ByRef vItems() As t_Items) As Boolean
  
  Dim register  As cRegister
  Dim iOrden    As Long
  Dim i         As Long
          
  For i = 1 To UBound(vItems)
  
    vItems(i).Cue_id = pGetCueId(vItems(i).cue_codigo)
    vItems(i).ccos_id = pGetCcosId(vItems(i).ccos_codigo)
    
    If vItems(i).Cue_id = csNO_ID Then
      pAddToLog LNGGetText(3944, vbNullString, vItems(i).cue_codigo), False
                ' No se encontro la cuenta con codigo [ vItems(i).cue_codigo ]
      Exit Function
    End If
  
    Set register = New cRegister
    
    With register
      .fieldId = cscAsiTMPId
      .Table = csTAsientoItemTMP
      .ID = csNew
      
      With .Fields
        .Add2 cscAsiId, csNew, csInteger
        .Add2 cscCueId, vItems(i).Cue_id, csId
        .Add2 cscCcosId, vItems(i).ccos_id, csId
        .Add2 cscAsiDebe, vItems(i).debe, csDouble
        .Add2 cscAsiHaber, vItems(i).haber, csDouble
        .Add2 cscAsiDescrip, vItems(i).descrip, csText
          
        iOrden = iOrden + 1
        .Add2 cscAsiOrden, iOrden, csInteger
        .Add2 cscAsTMPId, ID, csId
          
        .HaveLastUpdate = False
        .HaveWhoModify = False
      End With
    End With
    
    If Not gDB.Save(register, , "pSaveItems", C_Module, c_ErrorSaveFactura) Then Exit Function
  
  Next
  
  pSaveItems = True
End Function

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

Private Sub pGetDocNumberFromExcel(ByVal doc_id As Long, _
                                   ByVal nroDoc As String)
  Dim Tl           As Object
  Dim tal_id       As Long
  Dim iProp        As cIABMProperty
  Dim sqlstmt      As String
  Dim rs           As ADODB.Recordset
  Dim Mask         As String
  Dim bTaPropuesto As Boolean
  
  sqlstmt = "select ta_id from Documento where doc_id = " & doc_id
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Sub
  
  If rs.EOF Then Exit Sub
    
  tal_id = gDB.ValField(rs.Fields, 0)
  
  Set Tl = CSKernelClient2.CreateObject("CSDocumento2.cTalonario")
  
  Set iProp = m_ObjAbm.Properties.Item(cscAsNrodoc)
  Tl.GetNextNumber tal_id, Mask, bTaPropuesto
  iProp.Value = nroDoc
  iProp.TextMask = Mask
  iProp.Enabled = bTaPropuesto
  
  m_ObjAbm.ShowValue iProp
End Sub

Private Function pGetCueId(ByVal CueCodigo As String) As Long
  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  
  sqlstmt = "select cue_id from cuenta where cue_codigo = " & gDB.sqlString(CueCodigo)
  
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Function
  If rs.EOF Then
  
    sqlstmt = "select cue_id from cuenta where cue_identificacionexterna = " & gDB.sqlString(CueCodigo)
    
    If Not gDB.OpenRs(sqlstmt, rs) Then Exit Function
    If rs.EOF Then Exit Function
    
  End If
  
  pGetCueId = gDB.ValField(rs.Fields, 0)
  
End Function

Private Function pGetCcosId(ByVal ccos_codigo As String) As Long
  Dim ccos_id       As Long
  Dim ccos_nombre   As String
  
  If LenB(ccos_codigo) Then
  
    pGetCentroCostoFromCodigo ccos_codigo, ccos_nombre, ccos_id
    
  Else
    ccos_nombre = vbNullString
    ccos_id = csNO_ID
  End If
  
  pGetCcosId = ccos_id

End Function
