VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cPrintManager"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

'--------------------------------------------------------------------------------
' cPrintManager
' 28-10-2003

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cPrintManager"

Private Const KEY_NODO = "N"
Private Const DT_RIGHT = &H2&

Private Const C_PRINT_SERVICE_STATE_WRITING = 1
Private Const C_PRINT_SERVICE_STATE_READY = 2

Private Enum csECols
  colRptId = 1
  colSelected
  colNombre
  colCopias
  colFile
  colObject
  
  colMaxAux
End Enum

Private Const c_GrupoUsuarioConfig = "Usuario-Config"

' Usar el tamaño de papel que reporta la impresora
Private Const c_UsePrinterSize = "Usar el Tamaño de Papel que Reporta la Impresora"

'Private Enum csRptLaunchActionEx
'  csRptLaunchFile = csRptLaunchAction.csRptLaunchFile
'  csRptLaunchPreview = csRptLaunchAction.csRptLaunchPreview
'  csRptLaunchPrinter = csRptLaunchAction.csRptLaunchPrinter
'  csRptLaunExportPdf
'End Enum

Private Const colMax = colMaxAux - 1

' estructuras
' variables privadas
#If PREPROC_PRINT_SRV = 0 Then
Private WithEvents m_fPrint             As fPrint
Attribute m_fPrint.VB_VarHelpID = -1
#End If
Private m_Path                          As String
Private m_Id                            As String
Private m_ConnectionTimeout             As Long
Private m_CommandTimeout                As Long
Private m_DocId                         As Long
Private m_TblId                         As Long

Private m_DocImpreso                    As Boolean

Private m_emailAddress                  As String
Private m_emailSubject                  As String
Private m_emailBody                     As String

Private m_IsTabla                       As Boolean

Private m_IsForEmail                    As Boolean

Private m_DescripUser                   As String

Private m_bUsePrinterSizeLoaded   As Boolean
Private m_bUsePrinterSize         As Boolean

Private m_Title                   As String

Private m_AutoPrint               As Boolean

' eventos
' propiedades publicas
Public Property Get DescripUser() As String
  DescripUser = m_DescripUser
End Property

Public Property Let DescripUser(ByVal rhs As String)
  m_DescripUser = rhs
End Property

Public Property Get Title() As String
  Title = m_Title
End Property

Public Property Let Title(ByVal rhs As String)
  m_Title = rhs
End Property

Public Property Get IsForEmail() As Boolean
  IsForEmail = m_IsForEmail
End Property

Public Property Let IsForEmail(ByVal rhs As Boolean)
  m_IsForEmail = rhs
End Property

Public Property Get emailAddress() As String
  emailAddress = m_emailAddress
End Property

Public Property Get emailSubject() As String
  emailSubject = m_emailSubject
End Property

Public Property Get emailBody() As String
  emailBody = m_emailBody
End Property

Public Property Get DocImpreso() As Boolean
  DocImpreso = m_DocImpreso
End Property

Public Property Get Path() As String
   Path = m_Path
End Property

Public Property Let Path(ByVal rhs As String)
   m_Path = rhs
End Property

Public Property Get id() As String
   id = m_Id
End Property

Public Property Let id(ByVal rhs As String)
   m_Id = rhs
End Property

Public Property Get DocId() As Long
   DocId = m_DocId
End Property

Public Property Let DocId(ByVal rhs As Long)
   m_DocId = rhs
End Property

Public Property Get TblId() As Long
   TblId = m_TblId
End Property

Public Property Let TblId(ByVal rhs As Long)
   m_TblId = rhs
End Property

Public Property Get ConnectionTimeout() As Long
   ConnectionTimeout = m_ConnectionTimeout
End Property

Public Property Let emailAddress(ByRef rhs As String)
  m_emailAddress = rhs
End Property

Public Property Let emailSubject(ByRef rhs As String)
  m_emailSubject = rhs
End Property

Public Property Let emailBody(ByRef rhs As String)
  m_emailBody = rhs
End Property

Public Property Let ConnectionTimeout(ByVal rhs As Long)
   m_ConnectionTimeout = rhs
End Property

Public Property Get CommandTimeout() As Long
   CommandTimeout = m_CommandTimeout
End Property

Public Property Let CommandTimeout(ByVal rhs As Long)
   m_CommandTimeout = rhs
End Property

Public Property Get AutoPrint() As String
  AutoPrint = m_AutoPrint
End Property

Public Property Let AutoPrint(ByVal rhs As String)
  m_AutoPrint = rhs
End Property
' propiedades friend
' propiedades privadas
' funciones publicas
#If PREPROC_PRINT_SRV = 0 Then

  Public Function ShowPrint(ByVal id As Long, _
                            Optional ByVal TblId As Long, _
                            Optional ByVal DocId As Long) As Boolean
                            
    On Error GoTo ControlError
    
    Dim sqlstmt As String
    Dim rs As Recordset
    Dim rowIndex As Long
    
    m_DocImpreso = False
    
    m_TblId = csNO_ID
    m_DocId = csNO_ID
    m_Id = csNO_ID
    
    If TblId = 0 And DocId = 0 Then
      MsgWarning LNGGetText(3207, vbNullString), LNGGetText(3209, vbNullString) 'Error
                'Error: se llamó a la función ShowPrint y no se pasó ningún ID de _
                Tabla o ID de Documento
                
      Exit Function
    End If
    
    If DocId <> csNO_ID Then
      If Not pValidateFirma(id, DocId) Then
        Exit Function
      End If
      m_DocId = DocId
    Else
      m_DocId = csNO_ID
    End If
    
    Set m_fPrint = New fPrint
    
    Load m_fPrint
    
    pInitGrid
      
    If m_IsForEmail Then
      sqlstmt = "select rptf_Id, rptf_nombre, rptf_copias, rptf_sugeridoemail as rptf_sugerido, rptf_csrfile, rptf_object from reporteformulario"
    Else
      sqlstmt = "select rptf_Id, rptf_nombre, rptf_copias, rptf_sugerido, rptf_csrfile, rptf_object from reporteformulario"
    End If
    
    If TblId <> 0 Then
      If TblId < 0 Then
        TblId = TblId * -1
        m_Id = id
      Else
        m_Id = KEY_NODO & id
      End If
      sqlstmt = sqlstmt & " where tbl_id = " & TblId
      m_IsTabla = True
      m_TblId = TblId
    Else
      sqlstmt = sqlstmt & " where doc_id = " & DocId
      m_Id = id
      m_IsTabla = False
    End If
    
    sqlstmt = sqlstmt & " and activo <> 0"
    
    If Not gDb.OpenRs(sqlstmt, rs) Then Exit Function
    
    If Not rs.EOF Then
      rs.MoveLast
      rs.MoveFirst
      
      m_fPrint.grReports.Rows = rs.RecordCount
    End If
    
    While Not rs.EOF
    
      rowIndex = rowIndex + 1
    
      With m_fPrint.grReports
        .Cell(rowIndex, colRptId).Text = gDb.ValField(rs.fields, cscrptfId)
        With .Cell(rowIndex, colSelected)
          .ItemData = Val(gDb.ValField(rs.fields, cscrptfSugerido))
          .IconIndex = IIf(.ItemData, csECheck, csEUncheck)
        End With
        .Cell(rowIndex, colNombre).Text = gDb.ValField(rs.fields, cscrptfNombre)
        
        With .Cell(rowIndex, colCopias)
          .Text = gDb.ValField(rs.fields, cscrptfCopias)
          .TextAlign = DT_RIGHT
        End With
        
        .Cell(rowIndex, colFile).Text = gDb.ValField(rs.fields, cscrptfCsrfile)
        .Cell(rowIndex, colObject).Text = gDb.ValField(rs.fields, cscrptfObject)
      End With
      
      rs.MoveNext
    Wend
    
    Dim mouse As cMouse
    Set mouse = New cMouse
    mouse.MouseDefault
    
    If LenB(m_Title) Then
      m_fPrint.lbTitle = "Imprimir - " & m_Title
    Else
      m_fPrint.lbTitle = "Imprimir"
    End If
    
    If m_AutoPrint Then
      m_fPrint.tmAutoPrint.Interval = 1000
    Else
      m_fPrint.tmAutoPrint.Interval = 0
    End If
    m_fPrint.Show vbModal
    
    ShowPrint = True
    
    GoTo ExitProc
ControlError:
    MngError Err, "cPrintManager", C_Module, vbNullString
    If Err.Number Then Resume ExitProc
ExitProc:
    On Error Resume Next
    Unload m_fPrint
    Set m_fPrint = Nothing
  End Function

#End If

' funciones friend
' funciones privadas
Private Function pValidateFirma(ByVal id As Long, ByVal DocId As Long) As Boolean
  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  
  sqlstmt = "sp_DocRequiereFirma " & id & ", " & DocId
  If Not gDb.OpenRs(sqlstmt, rs) Then Exit Function
  
  If rs.EOF Then Exit Function
  
  If gDb.ValField(rs.fields, 0) Then
    MsgWarning LNGGetText(3208, vbNullString)
                'Este documento requiere firma. No se podrá imprimir hasta que no _
                esté firmado por un usuario autorizado.
                
    Exit Function
  End If

  pValidateFirma = True
End Function

#If PREPROC_PRINT_SRV = 0 Then
  Private Sub pInitGrid()
    Dim i As Long
    
    With m_fPrint.grReports
      .Redraw = False
      .Clear True
      
      .Editable = True
      
      For i = 1 To colMax
        .Columns.Add Nothing
      Next i
      
      .Columns(colRptId).Visible = False
      .Columns(colFile).Visible = False
      .Columns(colObject).Visible = False
      
      With .Columns(colSelected)
        .width = 400
        .EditType = cspCheck
      End With
      
      With .Columns(colNombre)
        .Caption = C_strNombre
        .width = 4000
        .Enabled = False
      End With
      
      With .Columns(colCopias)
        .Caption = LNGGetText(2574, vbNullString) 'Copias
        .width = 800
        .EditType = cspNumeric
        .EditSubType = cspInteger
      End With
      
      .HeaderDragReOrderColumns = True
      .Header = True
     
      .Redraw = True
    End With
  End Sub
#End If

#If PREPROC_PRINT_SRV = 0 Then
  #If PREPROC_DEBUG Then
  Private Sub Class_Initialize()
    gdbInitInstance C_Module
  End Sub
  #End If
  
  Private Sub Class_Terminate()
    On Error Resume Next
    Set m_fPrint = Nothing
  
  #If PREPROC_DEBUG Then
    gdbTerminateInstance C_Module
  #End If
  End Sub
#End If

#If PREPROC_PRINT_SRV = 0 Then
  Private Sub m_fPrint_CloseForm()
    On Error Resume Next
    m_fPrint.Hide
    With m_fPrint.grReports
      .Redraw = False
      .Columns.Clear
    End With
  End Sub
  
  Private Sub m_fPrint_DoPrint()
    If pPrintReports(csRptLaunchPrinter) Then
      pSetDocumentoImpreso
    End If
    
    pHideForm
  End Sub
#End If

#If PREPROC_PRINT_SRV = 0 Then
  Private Sub pHideForm()
    
    ' Viene de:
    '
    ' 2009-05-25 - si ocultamos el form aca
    ' lo que sigue no impide que la interfaz
    ' se ejecute y por ende se pueden dar errores
    ' como los que hubo en pedido de venta
    '
    ' OJO: ante cualquier comportamiento raro, deberiamos
    '      echarle un ojo a este cambio
    '
    ' Ahora si, una vez que termine de imprimir oculto el form
    '
    m_fPrint.Hide
  
  End Sub
#End If

#If PREPROC_PRINT_SRV = 0 Then
  Private Sub m_fPrint_ExportPdf()
    Dim collRpts As Collection
    
    Set collRpts = New Collection
    
    pPrintReports csRptLaunchPreview, collRpts, True
    
    Dim rpt       As cReport
    Dim RptPrint  As cReportPrint
    Dim OutputFile    As String
    Dim sDescripUser  As String
  
    For Each rpt In collRpts
      
      Set RptPrint = rpt.LaunchInfo.ObjPaint
      'RptPrint.ExportPdf
      
      If LenB(m_DescripUser) > 0 And LenB(rpt.DescripUser) > 0 Then
        sDescripUser = rpt.DescripUser & "-" & m_DescripUser
      Else
        sDescripUser = IIf(LenB(m_DescripUser), m_DescripUser, rpt.DescripUser)
      End If
      
      RptPrint.ExportFileName = pGetFileNameFromRptName(sDescripUser)
      If Not RptPrint.ExportPDFEx(OutputFile, True) Then Exit Sub
      
    Next
    
    pHideForm
  End Sub
#End If

Private Function pGetFileNameFromRptName(ByVal rptName As String) As String
  rptName = Replace(rptName, " ", "_")
  rptName = Replace(rptName, "/", "_")
  rptName = Replace(rptName, "\", "_")
  rptName = Replace(rptName, ":", "_")
  rptName = Replace(rptName, "*", "_")
  rptName = Replace(rptName, "?", "_")
  rptName = Replace(rptName, """", "_")
  rptName = Replace(rptName, "<", "_")
  rptName = Replace(rptName, ">", "_")
  rptName = Replace(rptName, "|", "_")
  rptName = Replace(rptName, ".", "_")
  pGetFileNameFromRptName = rptName
End Function

#If PREPROC_PRINT_SRV = 0 Then
  Private Sub m_fPrint_ExportPdfToFolder()
    Dim collRpts As Collection
    
    Set collRpts = New Collection
    
    pPrintReports csRptLaunchPreview, collRpts, True
    
    Dim rpt       As cReport
    Dim RptPrint  As cReportPrint
    Dim OutputFile    As String
    Dim sDescripUser  As String
    Dim UserFolder    As String
    
    UserFolder = pGetUserFolder()
  
    For Each rpt In collRpts
      
      Set RptPrint = rpt.LaunchInfo.ObjPaint
      'RptPrint.ExportPdf
      
      If LenB(m_DescripUser) > 0 And LenB(rpt.DescripUser) > 0 Then
        sDescripUser = rpt.DescripUser & "-" & m_DescripUser
      Else
        sDescripUser = IIf(LenB(m_DescripUser), m_DescripUser, rpt.DescripUser)
      End If
      
      RptPrint.ExportFileName = pGetFileNameFromRptName(sDescripUser)
      If Not RptPrint.ExportPDFEx(OutputFile, False) Then Exit Sub
      
      If Not pCopyFileToUserFolder(OutputFile, UserFolder) Then Exit Sub
      
    Next
    
    pHideForm
  End Sub
#End If

#If PREPROC_PRINT_SRV = 0 Then
  Private Function pCopyFileToUserFolder(ByVal File As String, ByVal Folder As String) As Boolean
    On Error GoTo ControlError
  
    Dim FileOut As String
    Dim oFile As CSKernelFile.cFile
    Set oFile = New CSKernelFile.cFile
    
    FileOut = GetValidPath(Folder) & oFile.GetFileName(File)
    
    FileCopy File, FileOut
  
    pCopyFileToUserFolder = True
  
    Exit Function
ControlError:
    MngError Err, "pCopyFileToUserFolder", C_Module, vbNullString
    If Err.Number Then Resume ExitProc
ExitProc:
    On Error Resume Next
    m_fPrint.Show vbModal
  End Function
  
  Private Function pGetUserFolder() As String
    Dim sqlstmt As String
    Dim rs      As ADODB.Recordset
    Dim rtn     As String
    
    sqlstmt = "select cfg_valor from configuracion " & _
              "where cfg_aspecto = 'Carpeta destino de exportación PDF Gral_" & User.id & "'" & _
              " and emp_id = " & EmpId
              
    If Not gDb.OpenRs(sqlstmt, rs) Then Exit Function
    
    If Not rs.EOF Then
      rtn = gDb.ValField(rs.fields, 0)
    End If
    
    If LenB(rtn) = 0 Then
      rtn = GetEspecialFolders(sfidDESKTOP)
    End If
    
    pGetUserFolder = rtn
  End Function
  
  Private Sub m_fPrint_SendEmail()
    Dim emailAddress As String
    
    emailAddress = m_emailAddress
    
    If Not GetInput(emailAddress, "Si lo desea puede modificar la dirección de e-mail") Then Exit Sub
    
    m_emailAddress = emailAddress
    
    Dim collRpts As Collection
    
    Set collRpts = New Collection
    
    pPrintReports csRptLaunchPreview, collRpts, True
    
    Dim rpt           As cReport
    Dim RptPrint      As cReportPrint
    Dim OutputFile    As String
    Dim Files         As String
    Dim sDescripUser  As String
    
    For Each rpt In collRpts
        
      Set RptPrint = rpt.LaunchInfo.ObjPaint
      
      If LenB(m_DescripUser) > 0 And LenB(rpt.DescripUser) > 0 Then
        sDescripUser = rpt.DescripUser & "-" & m_DescripUser
      Else
        sDescripUser = IIf(LenB(m_DescripUser), m_DescripUser, rpt.DescripUser)
      End If
      
      RptPrint.ExportFileName = pGetFileNameFromRptName(sDescripUser)
      If Not RptPrint.ExportPDFEx(OutputFile, False) Then Exit Sub
      
      RptPrint.ClosePreviewWindow
      
      If LenB(OutputFile) Then
        Files = Files & OutputFile & "|"
      End If
      
    Next
    
    If LenB(Files) Then
      RptPrint.SendMail left$(Files, Len(Files) - 1), emailAddress
    End If
  
    pHideForm

  End Sub
    
  Private Sub m_fPrint_Preview()
    pHideForm
    pPrintReports csRptLaunchPreview
  End Sub
  
  Private Sub m_fPrint_PrinterAdvanced()
  '
  End Sub
#End If

#If PREPROC_PRINT_SRV = 0 Then
  Private Function pHaveToPrintOnService() As Boolean
    ' Solo si se trata de un documento
    '
    If IsNumeric(m_Id) And Not m_IsTabla Then
    
      Dim sqlstmt As String
      Dim rs      As ADODB.Recordset
    
      sqlstmt = "sp_DocGetPrinter " & m_DocId & "," & m_Id & "," & gDb.sqlString(GetComputerName)
      
      If Not gDb.OpenRs(sqlstmt, rs) Then Exit Function
      If rs.EOF Then Exit Function
      pHaveToPrintOnService = gDb.ValField(rs.fields, "doci_printbyservice")
      
    End If
  End Function
  
  Private Function pSetTrabajoImpresionStateReadyToPrint(ByVal timp_id As Long) As Boolean
    Dim sqlstmt As String
    Dim rs      As ADODB.Recordset
  
    sqlstmt = "sp_TrabajoImpresionSave " & timp_id & ", " _
                              & gDb.sqlDate(Now) & "," _
                              & gDb.sqlString(GetComputerName) & "," _
                              & C_PRINT_SERVICE_STATE_READY & "," _
                              & m_TblId & "," _
                              & m_DocId & "," _
                              & m_Id & "," _
                              & User.id & "," _
                              & EmpId

    If Not gDb.Execute(sqlstmt) Then Exit Function
    
    pSetTrabajoImpresionStateReadyToPrint = True
  
  End Function
  
  Private Function pGetTrabajoImpresionId() As Long
    Dim sqlstmt As String
    Dim rs      As ADODB.Recordset
  
    sqlstmt = "sp_TrabajoImpresionSave 0, " _
                              & gDb.sqlDate(Now) & "," _
                              & gDb.sqlString(GetComputerName) & "," _
                              & C_PRINT_SERVICE_STATE_WRITING & "," _
                              & m_TblId & "," _
                              & m_DocId & "," _
                              & m_Id & "," _
                              & User.id & "," _
                              & EmpId
                                
    If Not gDb.OpenRs(sqlstmt, rs) Then Exit Function
    If rs.EOF Then Exit Function
    
    pGetTrabajoImpresionId = gDb.ValField(rs.fields, "timp_id")
  End Function
  
  Private Function pPrintReportToService(ByVal timp_id As Long, _
                                         ByVal rptName As String, _
                                         ByVal rptFile As String, _
                                         ByVal action As csRptLaunchAction, _
                                         ByVal copies As Long, _
                                         ByVal strObject As String) As Boolean
    Dim sqlstmt As String
    
    sqlstmt = "sp_TrabajoImpresionSaveItem " _
                              & timp_id & ", " _
                              & "0," _
                              & gDb.sqlString(rptName) & "," _
                              & gDb.sqlString(rptFile) & "," _
                              & action & "," _
                              & copies & "," _
                              & gDb.sqlString(strObject)
                                
    pPrintReportToService = gDb.Execute(sqlstmt)
    
  End Function
  
  Private Function pPrintReports(ByVal action As csRptLaunchAction, _
                                 Optional ByRef collRpts As Collection, _
                                 Optional ByVal bHidePreviewWindow As Boolean) As Boolean
    On Error GoTo ControlError
  
    Dim i As Long
    
    ' 2009-05-25 - si ocultamos el form aca
    ' lo que sigue no impide que la interfaz
    ' se ejecute y por ende se pueden dar errores
    ' como los que hubo en pedido de venta
    '
    ' OJO: ante cualquier comportamiento raro, deberiamos
    '      echarle un ojo a este cambio
    '
    ' m_fPrint.Hide
  
    If pHaveToPrintOnService() Then
    
      Dim timp_id As Long
      
      timp_id = pGetTrabajoImpresionId()
      If timp_id = csNO_ID Then GoTo ExitProc
      
      With m_fPrint.grReports
        For i = 1 To .Rows
          If .Cell(i, colSelected).ItemData <> 0 Then
            If Not pPrintReportToService( _
                                timp_id, _
                                .Cell(i, colNombre).Text, _
                                .Cell(i, colFile).Text, _
                                action, _
                                Val(.Cell(i, colCopias).Text), _
                                .Cell(i, colObject).Text) Then GoTo ExitProc
          End If
        Next i
      End With
      
      If Not pSetTrabajoImpresionStateReadyToPrint(timp_id) Then GoTo ExitProc
    
    Else
  
      Dim rpt As cReport
    
      With m_fPrint.grReports
        For i = 1 To .Rows
          If .Cell(i, colSelected).ItemData <> 0 Then
            If Not pPrintReport(.Cell(i, colNombre).Text, _
                                .Cell(i, colFile).Text, _
                                action, _
                                Val(.Cell(i, colCopias).Text), _
                                .Cell(i, colObject).Text, _
                                rpt, bHidePreviewWindow) Then GoTo ExitProc
            If Not collRpts Is Nothing Then
              collRpts.Add rpt
            End If
          End If
        Next i
      End With
    
    End If
    
    pPrintReports = True
  
    Exit Function
ControlError:
    MngError Err, "pPrintReports", C_Module, vbNullString
    If Err.Number Then Resume ExitProc
ExitProc:
    On Error Resume Next
    m_fPrint.Show vbModal
  End Function
#End If

Public Function PrintReport(ByVal rptName As String, _
                            ByVal rptFile As String, _
                            ByVal action As csRptLaunchAction, _
                            ByVal copies As Long, _
                            ByVal strObject As String, _
                            Optional ByRef rpt As cReport, _
                            Optional ByVal bHidePreviewWindow As Boolean) As Boolean
  PrintReport = pPrintReport(rptName, rptFile, action, copies, _
                             strObject, rpt, bHidePreviewWindow)
End Function

Private Function pPrintReport(ByVal rptName As String, _
                              ByVal rptFile As String, _
                              ByVal action As csRptLaunchAction, _
                              ByVal copies As Long, _
                              ByVal strObject As String, _
                              Optional ByRef rpt As cReport, _
                              Optional ByVal bHidePreviewWindow As Boolean) As Boolean
                             
  If strObject = "" Then
    serverPrintMessage "Imprimiendo reporte sin objeto"
    pPrintReport = pPrintReportEx(rptName, rptFile, action, copies, rpt, bHidePreviewWindow)
  Else
    serverPrintMessage "Imprimiendo reporte con objeto: " & strObject
    pPrintReport = pPrintToObject(rptName, rptFile, action, copies, strObject)
  End If
End Function

Private Function pPrintReportEx(ByVal rptName As String, _
                                ByVal rptFile As String, _
                                ByVal action As csRptLaunchAction, _
                                ByVal copies As Long, _
                                Optional ByRef rpt As cReport, _
                                Optional ByVal bHidePreviewWindow As Boolean) As Boolean
  On Error GoTo ControlError

  Dim c_OpenRpt As String
  c_OpenRpt = LNGGetText(2888, vbNullString) 'Abrir Reporte

  'Dim RptPrint As CSReportPaint2.cReportPrint
  Dim RptPrint As cReportPrint

  Dim mouse As cMouseWait
  Set mouse = New cMouseWait

  Set rpt = New cReport

  serverPrintMessage "Inicializando reporte"

  If Not rpt.Init(New cReportLaunchInfo) Then Exit Function
  
  serverPrintMessage "Reporte inicializado con éxito"

  'Set RptPrint = New CSReportPaint2.cReportPrint
  Set RptPrint = New cReportPrint
  Set rpt.LaunchInfo.ObjPaint = RptPrint

  ' Deben apuntar al mismo objeto o sino
  ' no se toman las modificaciones que hace
  ' el usuario al seleccionar la impresora
  '
  Set rpt.PaperInfo = rpt.LaunchInfo.Printer.PaperInfo
    
  ' Me guardo la defincion de PaperInfo que
  ' sale de la impresora default
  '
  ' Este codigo solo sirve para cuando trabajo
  ' con la bandeja por defecto
  '
  Dim PaperInfo As cReportPaperInfo
  Set PaperInfo = New cReportPaperInfo
  PaperInfo.PaperSize = rpt.PaperInfo.PaperSize
  PaperInfo.Orientation = rpt.PaperInfo.Orientation
  PaperInfo.height = rpt.PaperInfo.height
  
  ' Necesito saber en que bandeja vamos a imprimir
  '
  '   Esto lo vamos hacer mas abajo ya que necesito
  '   cargar la definicion de Documento Impresora
  
  '
  '-----------------------------------------------------
  
  rptFile = GetValidPath(m_Path) & rptFile

  RptPrint.HidePreviewWindow = bHidePreviewWindow

  Dim FileEx As CSKernelFile.cFileEx
  Set FileEx = New CSKernelFile.cFileEx

  serverPrintMessage "Comprobando que el archivo " & rptFile & " existe"

  If Not FileEx.FileExists(rptFile) Then
    MsgWarning LNGGetText(2889, vbNullString, rptFile), c_OpenRpt
                'El archivo;; & rptFile & ;;no existe.;;Verifique la ubicación _
                de los reportes.
    Exit Function
  End If
  
  serverPrintMessage "Cargando el archivo " & rptFile

  If Not rpt.LoadSilent(rptFile) Then
    MsgWarning LNGGetText(3105, vbNullString, rptFile), c_OpenRpt
               'No se pudo cargar el reporte  & rptFile & ; _
               ( & CSKernelClient2.LastErrorDescription & ")

    Exit Function
  End If

  serverPrintMessage "Definiendo conexiones a la base de datos"

  rpt.Connect.StrConnect = gDb.StrConnect
  
  Dim ConnectAux As cReportConnect
  For Each ConnectAux In rpt.ConnectsAux
    ConnectAux.StrConnect = gDb.StrConnect
    pSetParamEmpIdInLogos ConnectAux
  Next
    
  '
  '-------------------------------------------------------
  
  serverPrintMessage "Definiendo el tamaño del papel segun la impresora"
  
  pLoadUsePrinterSize
  
  If m_bUsePrinterSize Then
    '
    ' Vamos a tomar el tamaño del papel desde la
    ' impresora si esto trae problemas lo vamos
    ' a parametrizar por usuario por ahora lo usamos
    ' asi :)
    '
    If rpt.PaperInfo.PaperSize <> PaperInfo.PaperSize Then
          
      ' Aca en documentos no toqueteamos
      ' las secciones. Eso solo lo hacemos
      ' en informes
      '
          
      rpt.PaperInfo.PaperSize = PaperInfo.PaperSize
      
    End If
    
    If pIsPaperSizeSetInRptFile(rptFile) Then
      rpt.PaperInfo.PaperSize = pGetPaperSizeFromRptFile(rptFile)
    End If
    
  End If
  
  serverPrintMessage "Cargando LaunchInfo"
  
  With rpt.LaunchInfo
    With .Printer.PaperInfo
      .PaperSize = rpt.PaperInfo.PaperSize
      .Orientation = rpt.PaperInfo.Orientation
      .CustomHeight = rpt.PaperInfo.CustomHeight
      .CustomWidth = rpt.PaperInfo.CustomWidth
    End With
    If pSetDefaultPrinter(rpt, PaperInfo) Then
      .ShowPrintersDialog = False
    Else
      .ShowPrintersDialog = True
    End If
    .copies = copies
    .action = action
  End With

  rpt.DescripUser = rptName
  rpt.ExportEmailAddress = m_emailAddress
  
  serverPrintMessage "Definiendo parametros"
  
  pSetParams rpt
  pSetPoweredBy rpt
  
  serverPrintMessage "Definiendo timeout"

  If m_CommandTimeout > 0 Then rpt.Connect.CommandTimeout = m_CommandTimeout
  If m_ConnectionTimeout > 0 Then rpt.Connect.ConnectionTimeout = m_ConnectionTimeout

  rpt.LaunchInfo.InternalPreview = True

  serverPrintMessage "Ejecutando el reporte"

  pPrintReportEx = rpt.Launch()

  GoTo ExitProc
ControlError:
  MngError Err, "pPrintReportEx", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Private Function pIsPaperSizeSetInRptFile(ByVal rptFile As String) As Boolean
  pIsPaperSizeSetInRptFile = InStr(1, rptFile, "[@PS-")
End Function

Private Function pGetPaperSizeFromRptFile(ByVal rptFile As String) As Long
  Dim ps As String
  Dim n  As Long
  n = InStr(1, rptFile, "[@PS-")
  ps = Mid$(rptFile, n + 5)
  n = InStr(1, ps, "]")
  ps = LCase$(Trim$(left$(ps, n - 1)))
  Select Case ps
    Case "b5"
      pGetPaperSizeFromRptFile = vbPRPSB5
    Case "a5"
      pGetPaperSizeFromRptFile = vbPRPSA5
    Case Else
      pGetPaperSizeFromRptFile = vbPRPSA4
  End Select
End Function

Private Function pPrintToObject(ByVal rptName As String, _
                                ByVal rptFile As String, _
                                ByVal action As csRptLaunchAction, _
                                ByVal copies As Long, _
                                ByVal strObject As String) As Boolean
  On Error GoTo ControlError
  
  Dim obj As Object
  
  Set obj = CSKernelClient2.CreateObject(strObject)
  
  obj.DoPrint rptName, rptFile, action, copies, m_Id, _
              m_Path, m_CommandTimeout, m_ConnectionTimeout
  
  pPrintToObject = True
  
  GoTo ExitProc
ControlError:
  MngError Err, "pPrintToObject", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Private Sub pSetParams(ByRef rpt As cReport)
  On Error Resume Next
  rpt.Connect.Parameters.Item(1).value = m_Id
End Sub

Private Sub pSetParamEmpIdInLogos(ByRef Connect As cReportConnect)
  Dim dts As String
  Dim p   As cParameter
  
  dts = LCase(Connect.DataSource)
  If dts = "sp_rptgetlogosgrande" Or dts = "sp_rptgetlogoschico" Then

    If Connect.Parameters.Count = 0 Then
      
      Set p = Connect.Parameters.Add(Nothing)
      p.Name = "@@emp_id"
      p.TypeColumn = csTDInteger
    
    Else
      Set p = Connect.Parameters.Item(1)
    End If
    
    p.value = EmpId

  End If
End Sub

Private Sub pSetDocumentoImpreso()
  Dim sqlstmt As String
  
  sqlstmt = "sp_DocSetImpreso " & m_DocId & "," & Val(m_Id)
  
  gDb.Execute sqlstmt
  
  m_DocImpreso = True
End Sub

Private Sub pSetDocSentByEmail()
  Dim sqlstmt As String
  
  sqlstmt = "sp_DocSetSentByEmail " & m_DocId & "," & Val(m_Id)
  
  gDb.Execute sqlstmt
  
End Sub

Private Function pSetDefaultPrinter(ByRef rpt As cReport, _
                                    ByRef PaperInfo As cReportPaperInfo) As Boolean
  On Error GoTo ControlError

  ' Solo si se trata de un documento
  '
  If IsNumeric(m_Id) And Not m_IsTabla Then
  
    Dim sqlstmt As String
    Dim rs      As ADODB.Recordset
  
    sqlstmt = "sp_DocGetPrinter " & m_DocId & "," & m_Id & "," & gDb.sqlString(GetComputerName)
    
    If Not gDb.OpenRs(sqlstmt, rs) Then Exit Function
    
    If Not rs.EOF Then
    
      Dim DeviceName      As String
      Dim DriverName      As String
      Dim port            As String
      Dim strPrinters     As String
      Dim PrinterRealName As String
      Dim PaperBin        As String
      
      PrinterRealName = gDb.ValField(rs.fields, "doci_impresora")
      PaperBin = gDb.ValField(rs.fields, "doci_bandeja")
      
      While Not rs.EOF
      
        If LCase(gDb.ValField(rs.fields, "doci_pc")) = LCase(GetComputerName) Then
          PrinterRealName = gDb.ValField(rs.fields, "doci_impresora")
          PaperBin = gDb.ValField(rs.fields, "doci_bandeja")
        End If
        
        rs.MoveNext
      Wend
      
      DeviceName = LCase$(PrinterRealName)
    
      Dim oPrn As Printer
      
      For Each oPrn In Printers
        If LCase$(oPrn.DeviceName) = DeviceName Then
          DeviceName = oPrn.DeviceName
          DriverName = oPrn.DriverName
          port = oPrn.port
          Exit For
        End If
        strPrinters = strPrinters & oPrn.DeviceName & vbCrLf
      Next
      
      If LenB(DriverName) = 0 Then
      
        Dim mouse As cMouse
        Set mouse = New cMouse
        mouse.MouseDefault
        
        #If PREPROC_PRINT_SRV = 0 Then
          With fPrinterError
            .lbMessage.Caption = LNGGetText(3551, vbNullString, PrinterRealName)
                     ' La configuración de impresoras del sistema indica que _
                       para esta comprobante se debe usar la impresora xxx _
                       pero esta no se encuentra instalada en esta pc. _
                       Esta es la lista de impresoras disponibles en su pc:
            
            .txPrinters.Text = strPrinters
            .Show vbModal
          End With
          
          Unload fPrinterError
        
        #Else
          
          Dim vPrinters As Variant
          Dim i As Long
          fMain.addError ""
          fMain.addError "La impresora indicada en la configuracion no esta instalada"
          fMain.addError "Impresora: " & PrinterRealName
          vPrinters = Split(strPrinters, vbCrLf)
          fMain.addError "***"
          fMain.addError "Lista de Impresoras instaladas"
          For i = 0 To UBound(vPrinters)
            fMain.addError vPrinters(i)
          Next
          fMain.addError "***"
        
        #End If
      
      Else
    
        On Error Resume Next
        
        rpt.LaunchInfo.InitPrinter DeviceName, DriverName, port
        rpt.LaunchInfo.SetPaperBin PaperBin
        
        ' Al final no esto no funciono :(
        '
          'Rpt.LaunchInfo.GetPaperSizeForPaperBin PaperBin, PaperInfo.PaperSize
        '
        
        If Err.Number Then
        
          MsgWarning LNGGetText(3550, vbNullString) 'No se pudo cargar la impresora por defecto para este comprobante
        
        Else
          
          pSetDefaultPrinter = True
          
        End If
      End If
      
    End If
  
  End If
  
  GoTo ExitProc
ControlError:
  MngError Err, "pSetDefaultPrinter", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
#If PREPROC_PRINT_SRV = 0 Then
  Unload fPrinterError
#End If
End Function

Private Sub pSetPoweredBy(ByRef rpt As cReport)
  Dim ctl As cReportControl
  
  '-------------------------------------------
  ' Defino el titulo si no existe
  '
  For Each ctl In rpt.Controls
    If ctl.Name = "Control21" Then
      If ctl.Label.Text = "Impreso por CrowSoft©" Then
        ctl.Label.Text = LNGGetText(3585, vbNullString) ' Powered by CrowSoft© - www.crowsoft.com.ar
      End If
    End If
  Next
End Sub

Private Sub pLoadUsePrinterSize()
  If Not m_bUsePrinterSizeLoaded Then
    
    Dim sqlstmt               As String
    Dim rs                    As ADODB.Recordset
    Dim claveUsePrinterSize   As String
    
    claveUsePrinterSize = c_UsePrinterSize & " Gral_" & User.id
    
    sqlstmt = "select cfg_valor from configuracion where emp_id is null and cfg_grupo = " & _
                   gDb.sqlString(c_GrupoUsuarioConfig) & " and cfg_aspecto = " & gDb.sqlString(claveUsePrinterSize)
  
    If Not gDb.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, C_LoadFunction, C_Module) Then Exit Sub
    
    m_bUsePrinterSizeLoaded = True
    
    If Not rs.EOF Then
      m_bUsePrinterSize = Val(gDb.ValField(rs.fields, cscCfgValor))
    End If
  End If
End Sub

Public Function sendEmail(ByVal collRpts As Collection) As Boolean
  Dim rpt           As cReport
  Dim RptPrint      As cReportPrint
  Dim OutputFile    As String
  Dim Files         As String
  Dim sDescripUser  As String
  
  serverPrintMessage "Enviando email"
  
  For Each rpt In collRpts
      
    serverPrintMessage "Generando PDF para " & rpt.Name

    Set RptPrint = rpt.LaunchInfo.ObjPaint
    
    If LenB(m_DescripUser) > 0 And LenB(rpt.DescripUser) > 0 Then
      sDescripUser = rpt.DescripUser & "-" & m_DescripUser
    Else
      sDescripUser = IIf(LenB(m_DescripUser), m_DescripUser, rpt.DescripUser)
    End If
    
    RptPrint.ExportFileName = pGetFileNameFromRptName(sDescripUser)
    If Not RptPrint.ExportPDFEx(OutputFile, False) Then Exit Function
    
    RptPrint.ClosePreviewWindow
    
    If LenB(OutputFile) Then
    
      serverPrintMessage "Archivo generado " & OutputFile
    
      Files = Files & OutputFile & "|"
    End If
    
  Next
  
  If LenB(Files) Then
  
    serverPrintMessage "Enviando emails a " & emailAddress
    If Not RptPrint.SendMail2(left$(Files, Len(Files) - 1), emailAddress, m_emailSubject, m_emailBody) Then
      serverPrintMessage "El envio fallo"
      Exit Function
    Else
      serverPrintMessage "El email se envio con éxito"
      pSetDocSentByEmail
    End If
    
  Else
    serverPrintMessage "No hay archivos para enviar por email"
  End If

  sendEmail = True

End Function

Private Sub serverPrintMessage(ByVal msg As String)
#If PREPROC_PRINT_SRV Then
  fMain.addMessage msg
#End If
End Sub
' construccion - destruccion

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
