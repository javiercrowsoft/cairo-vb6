VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cImportPercRetIIBB"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements CSInterfacesABM.cIABMClient
Implements CSMenu.cIMenuClient
'--------------------------------------------------------------------------------
' cImportPercRetIIBB
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
Private Const C_Module = "cImportPercRetIIBB"


Private Const c_filterProv = "filterprov"
Private Const c_file = "file"
Private Const c_Progress = "prg"
Private Const c_log = "log"
Private Const c_logFile = "logFile"
Private Const c_van = "van"

Private Const K_RETT_ID = 1
Private Const K_PERCT_ID = 2
Private Const K_FILE = 5
Private Const K_LABEL = 6
Private Const K_PROGRESS = 7
Private Const K_CANCEL = 8
Private Const K_LOGFILE = 12
Private Const K_LOG = 13
Private Const K_VAN = 14
Private Const K_PRO_ID = 15
Private Const K_FILTRAR_PROVINCIA = 16

Private Const c_ErrorSavePerRet = "Error al grabar percepciones y retenciones"

' estructuras
Private Type t_Registro
  FechaPub      As String
  FechaDesde    As String
  FechaHasta    As String
  cuit          As String
  TipoContr     As String
  TipoABM       As String
  HuboCambios   As String
  Percepcion    As String
  Retencion     As String
  GrupoPerc     As String
  GrupoRet      As String
  
  dRetencion    As Double
  dPercepcion   As Double
  
  dFechaDesde   As Date
  dFechaHasta   As Date
End Type

' variables privadas
Private m_Editing           As Boolean
Private m_Host              As CSMenu.cIMenuHost
Private m_ObjAbm            As cIABMGeneric

Private m_bCancel           As Boolean
Private m_logFile           As String
Private m_errorFile         As String

Private m_file              As String
Private m_rett_id           As Long
Private m_perct_id          As Long
Private m_pro_id            As Long
Private m_pro_id_filter     As Long

Private m_prov    As Variant
Private m_cli     As Variant

Private m_provOk()    As Long
Private m_cliOk()     As Long

Private m_ProvCount   As Long
Private m_CliCount    As Long

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
      If Ask(LNGGetText(3730, vbNullString), vbNo) Then
              'Confirma que desea cancelar la importación de retenciones y percepciones
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
  
  m_ObjAbm.Properties.Item(c_log).Value = ""
  m_ObjAbm.ShowValue m_ObjAbm.Properties.Item(c_log)

  m_logFile = m_ObjAbm.Properties.Item(c_logFile).Value
  m_errorFile = Mid$(m_logFile, 1, Len(m_logFile) - 4) & ".csv"
  
  pInitFile m_logFile
  pInitFile m_errorFile
  
  pAddToLog "*****************************************", True
  pAddToLog LNGGetText(3731, vbNullString), True
            'Iniciando importación de retenciones y percepciones
            
  pAddToLog "", True
  
  file = m_ObjAbm.Properties.Item(c_file).Value
  m_rett_id = m_ObjAbm.Properties.Item(cscRettId).HelpId
  m_perct_id = m_ObjAbm.Properties.Item(cscPerctId).HelpId
  m_pro_id = m_ObjAbm.Properties.Item(cscProId).HelpId
  
  If m_pro_id = csNO_ID Then
    MsgWarning LNGGetText(1077, vbNullString) ' Debe indicar una provincia
    Exit Function
  End If
  
  If Val(m_ObjAbm.Properties.Item(c_filterProv).Value) Then
    m_pro_id_filter = m_pro_id
  Else
    m_pro_id_filter = csNO_ID
  End If
  
  If m_rett_id = csNO_ID Then
    MsgWarning LNGGetText(1418, vbNullString) ' Debe indicar un tipo de retencion
    Exit Function
  End If

  If m_perct_id = csNO_ID Then
    MsgWarning LNGGetText(1249, vbNullString) ' Debe indicar un tipo de percepcion
    Exit Function
  End If
  
  ' Para grabar en ImportacionID.impid_descrip
  '
  m_file = file
  
  pAddToLog LNGGetText(3150, vbNullString, file), True
            'Archivo:  & file
  
  pAddToLog LNGGetText(3732, vbNullString, file), True
            'Abriendo Archivo: & file
  
  Dim rs As Recordset
  Dim sqlstmt As String
  
  sqlstmt = "select cli_id, replace(cli_cuit,'-','') as cli_cuit, isnull(pro_id,0) as pro_id " & _
            "from Cliente where cli_catfiscal <> 4 " & _
             IIf(m_pro_id_filter, "and pro_id = " & m_pro_id_filter, vbNullString) & _
             "and len(replace(cli_cuit,'-','')) = 11" & _
             " order by 2"
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Function
  If Not rs.EOF Then
    rs.MoveLast
    rs.MoveFirst
    m_cli = rs.GetRows()
  Else
    ReDim m_cli(0, 1)
    m_cli(0, 0) = ""
  End If
  
  sqlstmt = "select prov_id, replace(prov_cuit,'-','') as prov_cuit, isnull(pro_id,0) as pro_id " & _
            "from Proveedor where prov_catfiscal <> 4 " & _
             IIf(m_pro_id_filter, "and pro_id = " & m_pro_id_filter, vbNullString) & _
             "and len(replace(prov_cuit,'-','')) = 11" & _
             " order by 2"
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Function
  If Not rs.EOF Then
    rs.MoveLast
    rs.MoveFirst
    m_prov = rs.GetRows()
  Else
    ReDim m_prov(0, 1)
    m_prov(0, 0) = ""
  End If
  
  m_CliCount = UBound(m_cli, 2)
  m_ProvCount = UBound(m_prov, 2)
  
  ReDim m_cliOk(m_CliCount)
  ReDim m_provOk(m_ProvCount)
  
  Dim iFile As Long
  iFile = FreeFile
  
  If Not pOpenFile(iFile) Then GoTo ExitProc
    
  Dim i           As Long
  Dim count       As Long
  Dim iProg       As cIABMProperty
  Dim iProgVan    As cIABMProperty
  
  pAddToLog LNGGetText(3156, vbNullString), True
            'Obteniendo la cantidad de filas
            
  count = pGetLines(iFile)
  
  Close iFile
  
  If Not pOpenFile(iFile) Then GoTo ExitProc
  
  pAddToLog LNGGetText(2987, vbNullString, count), False
            'Cantidad de filas:  & count
  
  Set iProg = m_ObjAbm.Properties.Item(c_Progress)
  Set iProgVan = m_ObjAbm.Properties.Item(c_van)
  
  Set Mouse = Nothing
  
  Screen.MousePointer = vbArrowHourglass
  
  Dim s       As String
  Dim cuit    As String
  
  While Not EOF(iFile)
    
    If m_bCancel Then GoTo ExitProc
    
    Line Input #iFile, s
  
    i = i + 1
    
    If pIsProveedor(s, cuit) Then
    
      pProcessRegistroRetencion s, cuit
      
    End If
    
    If pIsCliente(s, cuit) Then
    
      pProcessRegistroPercepcion s, cuit
      
    End If
    
    If i Mod 100 = 0 Then
    
      iProg.Value = i / count * 100
      iProgVan.Value = i
      
      m_ObjAbm.ShowValue iProg
      m_ObjAbm.ShowValue iProgVan
    
    End If
    
    DoEvents
  
  Wend
  
  MsgWarning "El sistema ha terminado de procesar el archivo.;;" & _
             "Consulte el archivo de log para confirmar que no ocurrieron errores.;;" & _
             "Tambien verifique el archivo de clientes y proveedores no encontrados o " & _
             "con CUIT invalido."
  
  pShowNotFounds
  
  CSKernelClient2.EditFile m_logFile, 0
  CSKernelClient2.EditFile m_errorFile, 0
  
  cIABMClient_Save = True

  GoTo ExitProc
ControlError:
  MngError Err, "cIABMClient_Save", C_Module, vbNullString
  pAddToLog CSKernelClient2.LastErrorDescription, False
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
  Close iFile
  Screen.MousePointer = vbDefault
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
  cIABMClient_Title = LNGGetText(3733, vbNullString)  'Importar Perc./Ret. IIBB BS AS
End Property

Private Function cIABMClient_Validate() As Boolean

  Dim IProperty As cIABMProperty

  CSKernelClient2.Title = LNGGetText(3733, vbNullString)  'Importar Perc./Ret. IIBB BS AS

  For Each IProperty In m_ObjAbm.Properties
    With IProperty
      Select Case .Key
        Case K_FILE
          If LenB(.Value) = 0 Then
            MsgWarning LNGGetText(3766, vbNullString)
                       'Debe indicar un archivo de texto con el padron
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
  m_Host.Server.AddMenu LNGGetText(3729, vbNullString), csPreGContImportPercRetIIBB, str_1032, 0, True, False, False, False, False, Me
                        '&Importar Tabla de Perc./Ret. IIBB BS AS
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
  
  If Not SecurityCanAccess(csPreGContImportPercRetIIBB) Then Exit Sub

  If Not LoadCollection() Then Exit Sub
  
  m_Editing = True
  
  Exit Sub
ControlError:
  MngError Err, "pEdit", C_Module, vbNullString
End Sub

Private Function LoadCollection() As Boolean

  m_ObjAbm.Properties.Clear
  
  With m_ObjAbm.Properties.Add(Nothing, c_filterProv)
    .PropertyType = cspCheck
    .LeftNotChange = True
    .Left = 1970
    .LeftLabel = -1600
    .Name = LNGGetText(3735, vbNullString) ' Filtrar por provincia
    .Key = K_FILTRAR_PROVINCIA
  End With
  
  With m_ObjAbm.Properties.Add(Nothing, cscProId)
    .PropertyType = cspHelp
    .Table = csProvincia
    .Name = LNGGetText(1080, vbNullString) ' Provincia
    .Key = K_PRO_ID
    .Width = 4000
  End With
  
  With m_ObjAbm.Properties.Add(Nothing, cscRettId)
    .PropertyType = cspHelp
    .Table = csRetencionTipo
    .Name = LNGGetText(1420, vbNullString) ' Tipo de Retencion
    .Key = K_RETT_ID
    .Width = 4000
  End With
  
  With m_ObjAbm.Properties.Add(Nothing, cscPerctId)
    .PropertyType = cspHelp
    .Table = csPercepcionTipo
    .Name = LNGGetText(1253, vbNullString) ' Tipo de Percepcion
    .Key = K_PERCT_ID
  End With
  
  With m_ObjAbm.Properties.Add(Nothing, c_log)
    .PropertyType = cspText
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
    .Value = GetValidPath(App.Path) & "importar_sujetos_IIBB.log"
    .HelpFilter = LNGGetText(2989, vbNullString)  'Archivo de Log|*.log
  End With
    
  With m_ObjAbm.Properties.Add(Nothing, c_file)
    .PropertyType = cspFile
    .Name = LNGGetText(2966, vbNullString)  'Archivo
    .Key = K_FILE
    .HelpFilter = LNGGetText(3734, vbNullString) 'TXT|*.txt
    .HelpId = csNO_ID
  End With
  
  With m_ObjAbm.Properties.Add(Nothing, c_Progress)
    .PropertyType = cspProgressBar
    .TopToPrevious = 560
    .Name = LNGGetText(2984, vbNullString) 'Progreso
    .Width = 7000
    .Key = K_PROGRESS
  End With
  
  With m_ObjAbm.Properties.Add(Nothing, c_van)
    .PropertyType = cspLabel
    .Name = LNGGetText(2984, vbNullString) 'Van
    .Key = K_VAN
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

Private Function pSave() As Boolean
  pSave = True
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
            'Advertencia: & msg
  CSKernelClient2.MsgWarning msg
End Sub

Private Function pAsk(ByVal msg As String, ByVal default As VbMsgBoxStyle) As Boolean
  Dim rtn As VbMsgBoxResult
  rtn = MsgBox(Replace(msg, ";", vbCrLf), vbQuestion + vbYesNoCancel + vbDefaultButton2)
  pAsk = rtn = vbYes
  If rtn = vbCancel Then
    cIABMClient_PropertyChange K_CANCEL
  End If
End Function

Private Function pOpenFile(ByRef iFile As Long) As Boolean
  On Error GoTo ControlError
  
  Open m_file For Input As #iFile
  
  pOpenFile = True
  
  GoTo ExitProc
ControlError:
  MngError Err, "pOpenFile", C_Module, vbNullString
  pAddToLog CSKernelClient2.LastErrorDescription, False
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Private Function pGetLines(ByVal iFile As Long) As Long
  Dim s As String
  Dim i As Long
  While Not EOF(iFile)
    Line Input #iFile, s
    i = i + 1
  Wend
  
  pGetLines = i
End Function

Private Sub pLoadRegistro(ByRef Registro As t_Registro, ByVal s As String)
  With Registro
    .FechaPub = Mid$(s, 1, 8)
    .FechaDesde = Mid$(s, 10, 8)
    .FechaHasta = Mid$(s, 19, 8)
    .cuit = Mid$(s, 28, 11)
    .TipoContr = Mid$(s, 40, 1)
    .TipoABM = Mid$(s, 42, 1)
    .HuboCambios = Mid$(s, 44, 1)
    .Percepcion = Mid$(s, 46, 4)
    .Retencion = Mid$(s, 51, 4)
    .GrupoPerc = Mid$(s, 56, 2)
    .GrupoRet = Mid$(s, 59, 2)
    
    .dPercepcion = VBA.Val(Replace(.Percepcion, ",", "")) / 100
    .dRetencion = VBA.Val(Replace(.Retencion, ",", "")) / 100
    
    .dFechaDesde = DateSerial(VBA.Val(Mid$(.FechaDesde, 5, 4)), _
                              VBA.Val(Mid$(.FechaDesde, 3, 2)), _
                              VBA.Val(Mid$(.FechaDesde, 1, 2)))
    .dFechaHasta = DateSerial(VBA.Val(Mid$(.FechaHasta, 5, 4)), _
                              VBA.Val(Mid$(.FechaHasta, 3, 2)), _
                              VBA.Val(Mid$(.FechaHasta, 1, 2)))
    
  End With
End Sub

Private Sub pProcessRegistroRetencion(ByVal s As String, _
                                      ByVal cuit As String)

  Dim Registro  As t_Registro
  Dim sqlstmt   As String
  Dim rs        As ADODB.Recordset
  Dim prov_id   As Long
  Dim i         As Long
  
  pLoadRegistro Registro, s

  sqlstmt = "sp_RetencionGetByPorcentaje " & _
                m_rett_id & ", " & _
                gDB.sqlNumber(Registro.dRetencion)
  
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Sub
  
  Dim ret_id As Long
  
  If rs.EOF Then
  
    If Not pAddRetencion(ret_id, Registro.dRetencion) Then Exit Sub
  
  Else
  
    ret_id = gDB.ValField(rs.Fields, cscRetId)
  
  End If
  
  Dim rsprov As ADODB.Recordset
  
  sqlstmt = "select prov_id from proveedor where replace(prov_cuit,'-','') = " & gDB.sqlString(cuit)
  If Not gDB.OpenRs(sqlstmt, rsprov) Then Exit Sub
  
  While Not rsprov.EOF
  
    prov_id = rsprov.Fields.Item(0).Value
  
    sqlstmt = "select * from ProveedorRetencion " & _
              "where ret_id = " & ret_id & _
               " and prov_id = " & prov_id & _
               " and provret_desde =" & gDB.sqlDate(Registro.dFechaDesde) & _
               " and provret_hasta =" & gDB.sqlDate(Registro.dFechaHasta)
               
    If Not gDB.OpenRs(sqlstmt, rs) Then Exit Sub
    
    If rs.EOF Then
    
      sqlstmt = "sp_RetencionProveedorAdd " & ret_id & "," _
                                            & prov_id & "," _
                                            & gDB.sqlDate(Registro.dFechaDesde) & "," _
                                            & gDB.sqlDate(Registro.dFechaHasta) & "," _
                                            & gDB.UserId
                                            
      If Not gDB.Execute(sqlstmt) Then Exit Sub
      
    End If
    
    For i = 0 To UBound(m_prov, 2)
      If m_prov(0, i) = prov_id Then
        m_provOk(i) = prov_id
        Exit For
      End If
    Next
    
    rsprov.MoveNext
  Wend
End Sub

Private Sub pProcessRegistroPercepcion(ByVal s As String, _
                                       ByVal cuit As String)

  Dim Registro  As t_Registro
  Dim sqlstmt   As String
  Dim rs        As ADODB.Recordset
  Dim cli_id    As Long
  Dim i         As Long
    
  pLoadRegistro Registro, s
  
  sqlstmt = "sp_PercepcionGetByPorcentaje " & _
                m_perct_id & ", " & _
                gDB.sqlNumber(Registro.dPercepcion) & "," & _
                m_pro_id
  
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Sub
  
  Dim perc_id As Long
  
  If rs.EOF Then
  
    If Not pAddPercepcion(perc_id, Registro.dPercepcion) Then Exit Sub
  
  Else
  
    perc_id = gDB.ValField(rs.Fields, cscPercId)
  
  End If
  
  Dim rscli As ADODB.Recordset
  
  sqlstmt = "select cli_id from cliente where replace(cli_cuit,'-','') = " & gDB.sqlString(cuit)
  If Not gDB.OpenRs(sqlstmt, rscli) Then Exit Sub
  
  While Not rscli.EOF
  
    cli_id = rscli.Fields.Item(0).Value
    
    sqlstmt = "select * from ClientePercepcion " & _
              "where perc_id = " & perc_id & _
               " and cli_id = " & cli_id & _
               " and cliperc_desde =" & gDB.sqlDate(Registro.dFechaDesde) & _
               " and cliperc_hasta =" & gDB.sqlDate(Registro.dFechaHasta)
               
    If Not gDB.OpenRs(sqlstmt, rs) Then Exit Sub
    
    If rs.EOF Then
    
      sqlstmt = "sp_PercepcionClienteAdd " & perc_id & "," _
                                            & cli_id & "," _
                                            & gDB.sqlDate(Registro.dFechaDesde) & "," _
                                            & gDB.sqlDate(Registro.dFechaHasta) & "," _
                                            & gDB.UserId
                                            
      If Not gDB.Execute(sqlstmt) Then Exit Sub
      
    End If
    
    For i = 0 To UBound(m_cli, 2)
      If m_cli(0, i) = cli_id Then
        m_cliOk(i) = cli_id
        Exit For
      End If
    Next
    
    rscli.MoveNext
  Wend
  
End Sub

Private Function pAddRetencion(ByRef ret_id As Long, _
                               ByVal porc As Double) As Boolean
  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  
  sqlstmt = "sp_RetencionAdd " & m_rett_id & "," _
                               & gDB.sqlNumber(porc) & "," _
                               & gDB.UserId
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Function
  
  If rs.EOF Then Exit Function
  
  ret_id = gDB.ValField(rs.Fields, cscRetId)
  
  pAddRetencion = True
End Function

Private Function pAddPercepcion(ByRef perc_id As Long, _
                                ByVal porc As Double) As Boolean
  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  
  sqlstmt = "sp_PercepcionAdd " & m_perct_id & "," _
                               & gDB.sqlNumber(porc) & "," _
                               & m_pro_id & "," _
                               & gDB.UserId & "," _
                               & EmpId
                               
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Function
  
  If rs.EOF Then Exit Function
  
  perc_id = gDB.ValField(rs.Fields, cscPercId)
  
  pAddPercepcion = True
End Function

Private Function pIsProveedor(ByVal s As String, _
                              ByRef cuit As String) As Boolean
  Dim i       As Long
  Dim bFound  As Long
  Dim low     As Long
  Dim high    As Long
  
  cuit = Mid$(s, 28, 11)
  
  low = 0
  high = m_ProvCount
  
  Do While low <= high
    i = (low + high) / 2
    If m_prov(1, i) > cuit Then
      high = i - 1
    ElseIf m_prov(1, i) < cuit Then
      low = i + 1
    Else
      bFound = True
      Exit Do
    End If
  Loop
  
  If bFound Then
    pIsProveedor = True
  End If
End Function

Private Function pIsCliente(ByVal s As String, _
                            ByRef cuit As String) As Boolean
  Dim i       As Long
  Dim bFound  As Long
  Dim low     As Long
  Dim high    As Long
  
  cuit = Mid$(s, 28, 11)
  
  low = 0
  high = m_CliCount
  
  Do While low <= high
    i = (low + high) / 2
    If m_cli(1, i) > cuit Then
      high = i - 1
    ElseIf m_cli(1, i) < cuit Then
      low = i + 1
    Else
      bFound = True
      Exit Do
    End If
  Loop
  
  If bFound Then
    pIsCliente = True
  End If
End Function

Private Sub pShowNotFounds()
  Dim i As Long
  
  pAddToErrosCVS "Clientes no encontrados:"
  pAddToErrosCVS ""
  pAddToErrosCVS "Codigo,Nombre,Razon Social,CUIT"
  
  For i = 0 To m_CliCount
    If m_cliOk(i) = 0 Then
    
      If m_cli(2, i) = m_pro_id Then
        pAddToErrosCVS pGetCliente(m_cli(0, i))
      End If
    End If
  Next

  pAddToErrosCVS ""
  pAddToErrosCVS ""
  
  pAddToErrosCVS "Proveedores no encontrados:"
  pAddToErrosCVS ""
  pAddToErrosCVS "Codigo,Nombre,Razon Social,CUIT"

  For i = 0 To m_ProvCount
    If m_provOk(i) = 0 Then
    
      If m_prov(2, i) = m_pro_id Then
        pAddToErrosCVS pGetProveedor(m_prov(0, i))
      End If
    End If
  Next

  Dim rs As Recordset
  Dim sqlstmt As String

  pAddToErrosCVS ""
  pAddToErrosCVS ""
  
  pAddToErrosCVS "Clientes con cuits invalidos:"
  pAddToErrosCVS ""
  pAddToErrosCVS "Codigo,Nombre,Razon Social,CUIT"
  
  sqlstmt = "select cli_id " & _
            "from Cliente where cli_catfiscal <> 4 " & _
             IIf(m_pro_id_filter, "and pro_id = " & m_pro_id_filter, vbNullString) & _
             "and len(replace(cli_cuit,'-','')) <> 11"
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Sub
  While Not rs.EOF
    pAddToErrosCVS pGetCliente(gDB.ValField(rs.Fields, cscCliId))
    rs.MoveNext
  Wend

  pAddToErrosCVS ""
  pAddToErrosCVS ""
  
  pAddToErrosCVS "Proveedores con cuits invalidos:"
  pAddToErrosCVS ""
  pAddToErrosCVS "Codigo,Nombre,Razon Social,CUIT"
  
  sqlstmt = "select prov_id " & _
            "from Proveedor where prov_catfiscal <> 4 " & _
             IIf(m_pro_id_filter, "and pro_id = " & m_pro_id_filter, vbNullString) & _
             "and len(replace(prov_cuit,'-','')) <> 11"
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Sub
  While Not rs.EOF
    pAddToErrosCVS pGetCliente(gDB.ValField(rs.Fields, cscProvId))
    rs.MoveNext
  Wend

End Sub

Private Function pGetCliente(ByVal cli_id As Long) As String
  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  Dim rtn     As String
  
  sqlstmt = "select cli_nombre, cli_razonsocial, cli_cuit, cli_codigo from Cliente where cli_id = " & cli_id
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Function
  
  rtn = "'" & gDB.ValField(rs.Fields, cscCliCodigo) & ", " & _
        gDB.ValField(rs.Fields, cscCliNombre) & "," & _
        gDB.ValField(rs.Fields, cscCliRazonSocial) & ",'" & _
        gDB.ValField(rs.Fields, cscCliCuit)
        
  pGetCliente = rtn
End Function

Private Function pGetProveedor(ByVal prov_id As Long) As String
  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  Dim rtn     As String
  
  sqlstmt = "select prov_nombre, prov_razonsocial, prov_cuit, prov_codigo from Proveedor where prov_id = " & prov_id
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Function
  
  rtn = "'" & gDB.ValField(rs.Fields, cscProvCodigo) & "," & _
        gDB.ValField(rs.Fields, cscProvNombre) & "," & _
        gDB.ValField(rs.Fields, cscProvRazonSocial) & ",'" & _
        gDB.ValField(rs.Fields, cscProvCuit)
        
  pGetProveedor = rtn
End Function

Private Sub pInitFile(ByVal FileLog As String)
  On Error Resume Next
  Name FileLog As Mid$(FileLog, 1, Len(FileLog) - 4) & Format(Now, "yyy-mm-dd hh.nn.ss") & ".log"
  Kill FileLog
End Sub

Private Sub pAddToErrosCVS(ByVal s As String)
  On Error Resume Next
  Dim F As Integer
  F = FreeFile
  Open m_errorFile For Append As F
  Print #F, s
  Close F
End Sub
