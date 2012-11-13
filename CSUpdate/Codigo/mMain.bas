Attribute VB_Name = "mMain"
Option Explicit
'--------------------------------------------------------------------------------
' mMain
' 01-05-2006

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones
    Private Declare Function GetComputerName Lib "kernel32" Alias "GetComputerNameA" (ByVal lpBuffer As String, nSize As Long) As Long
    Private Declare Sub Sleep Lib "kernel32" (ByVal dwMilliseconds As Long)

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "mMain"

Public Const c_setup_ini                 As String = "setup.ini"
Public Const c_setup_inf_lst             As String = "informe.lst"

Public Const c_step_init = 0
Public Const c_step_show_setup_info = 1
Public Const c_step_show_databases = 2
Public Const c_step_backup_databases = 3
Public Const c_step_show_folders = 4
Public Const c_step_show_inf = 5
Public Const c_step_unzip_files = 6
Public Const c_step_backup_db = 7
Public Const c_step_copy_files = 8
Public Const c_step_exec_scripts = 9
Public Const c_step_update_inf = 10
Public Const c_step_finish = 11

Public Const c_sec_csr        As String = "RPT-CONFIG"
Public Const c_key_csrpath    As String = "RPT_PATH_REPORTES"
Public Const c_cairo_ini      As String = "cairo.ini"

Public Const c_macro_apppath = "$apppath"
Public Const c_macro_reportpath = "$reportpath"
Public Const c_macro_windowspath = "$windowspath"
Public Const c_macro_programfilespath = "$programfilespath"
Public Const c_macro_system32path = "$system32path"
Public Const c_macro_desktoppath = "$desktoppath"
Public Const c_macro_qlaunchpath = "$qlaunchpath"
Public Const c_macro_startuppath = "$startuppath"

Public Enum csE_CopyFileError
  csEIgnore = 1
  csETryAgain = 2
  csECancel = 3
End Enum

Public Type t_Informe_lst
  csai_file         As String
  inf_codigo        As String
  inf_nombre        As String
  selected          As Boolean
End Type

Private Const c_CairoSysUser = "Cairo System Administrator"

' estructuras
' variables privadas
Private m_Client                        As cTCPIPClient
Private m_ClientProcessId               As Long

' eventos
' propiedadades publicas
Public g_SetupCfg   As T_SetupCfg
Public g_db         As t_Database

Public g_connectAux As String

Public Function ClientProcessId() As Long
  ClientProcessId = m_ClientProcessId
End Function

Public Sub Main()
    
  gAppName = App.EXEName
    
  pSplash
    
  Set m_Client = New cTCPIPClient
    
  fMain.Show
  pSetMainMenuEnabled False
  
  Unload fSplash
  
  pValidateAssoc

  ' Me conecto al server
  If Not pConnectToServer() Then
    Unload fMain
    CloseApp
  
  ' Intengo el login
  ElseIf Not pLogin() Then
    Unload fMain
    CloseApp
  
  ' Ok todo bien ahora verifico el codigo de activacion
  Else
    
    If Not pValidateActiveCode() Then
      Unload fMain
      CloseApp
    
    Else
      
      pSetMainMenuEnabled True
    End If
  End If
  
  If Command$ <> vbNullString Then
    OpenCSAFile Command$
  End If
End Sub

Public Sub MngError(ByRef Err As Object, _
                    ByVal FunctionName As String, _
                    ByVal Module As String, _
                    Optional ByVal infoAdd As String)
                    
  If infoAdd <> vbNullString Then infoAdd = vbCrLf & vbCrLf & infoAdd
                    
  MsgBox "Error en funcion " & Module & "." _
         & FunctionName & vbCrLf & vbCrLf _
         & Err.Description & infoAdd
End Sub

Public Function DivideByCero(ByVal x1 As Double, ByVal x2 As Double) As Double
  On Error Resume Next
  DivideByCero = x1 / x2
  Err.Clear
End Function

Public Function OpenCSAFile(Optional ByVal FullFileName As String) As Boolean
  On Error GoTo ControlError
  
  If FullFileName = vbNullString Then
    If Not pOpenCSAFileWithDialog(FullFileName) Then Exit Function
  End If
  
  fMain.SetCaption "CSUpdate - " & FullFileName
  fMain.ShowMsgTop "Procesando " & FullFileName
  
  fMain.lbProcess.Caption = "Abriendo el paquete de actualización"
  UpdateStatus fMain.picStatus, 0
  fMain.lsFiles.Clear

  fMain.frProgress.Visible = True
  fMain.frProgress.ZOrder
  DoEvents
  
  fMain.OpenZipFile FullFileName
  
  fMain.UnSelectAll Nothing
  fMain.ExtractFile c_setup_ini, Environ("temp")
  
  g_SetupCfg.CSA_File = FullFileName
  
  If pReadSetupIni Then
  
    fMain.SetStep c_step_show_setup_info
    fMain.ShowStep fMain.iStep
  
    OpenCSAFile = True
    
  End If
  
  GoTo ExitProc
ControlError:
  MngError Err, "OpenCSAFile", C_Module
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
  fMain.frProgress.Visible = False
End Function

Private Function pOpenCSAFileWithDialog(ByRef FullFileName As String) As Boolean
  With fMain.cdFile
  
    .Filename = vbNullString
  
    .Filter = "Archivos de Actualizacion|*.csa"
    .ShowOpen
    
    If .Filename = vbNullString Then
      Exit Function
    Else
      FullFileName = .Filename
    End If
  End With
  
  pOpenCSAFileWithDialog = True
End Function

Private Sub pValidateAssoc()
    
    Dim o As cAssocFile
    Set o = New cAssocFile
    
    o.DontAsk = "No volver a preguntar"
    o.YesButton = "&Si"
    o.NoButton = "&No"
    o.Question = "CSUpdate no es la aplicación por defecto encargada de editar los archivos %1." & vbCrLf & vbCrLf & "¿Desea que CSUpdate sea el editor por defecto?."
    
    o.ValidateAssociation "csa", App.Path & "\CSUpdate.exe", "CSUpdate"

End Sub

Public Sub ShowSetupIni()
  With fMain.lvInfo
  
    .View = lvwReport
    .LabelEdit = lvwManual
    .FullRowSelect = True
    .HideSelection = False
    .Checkboxes = False
    .ListItems.Clear
    .Sorted = False
  
    With .ColumnHeaders
      .Clear
      .Add , , "Código", 3000
      .Add , , "Valor", 5000
    End With
    
    With .ListItems
      With .Add(, , "Configuracion")
        .Bold = True
      End With
      With .Add(, , "  Cliente")
        .SubItems(1) = g_SetupCfg.IdCliente
      End With
      With .Add(, , "  Versión")
        .SubItems(1) = g_SetupCfg.Version
      End With
      With .Add(, , "  Descripción")
        .SubItems(1) = g_SetupCfg.Description
      End With
      With .Add(, , "  Bases Versión Minima")
        .SubItems(1) = g_SetupCfg.DB_MIN_Version
      End With
      With .Add(, , "  Exe Versión Minima")
        .SubItems(1) = g_SetupCfg.Version
      End With
      With .Add(, , "  Actualizador Versión Minima")
        .SubItems(1) = g_SetupCfg.APP_MIN_Version
      End With
      With .Add(, , "  Sistema Operativo Versión Minima")
        .SubItems(1) = g_SetupCfg.OS_Version
      End With
      With .Add(, , "  SQL Versión Minima")
        .SubItems(1) = g_SetupCfg.Version
      End With
      With .Add(, , "  Bases a actualizar")
        .SubItems(1) = g_SetupCfg.DataBases
      End With
      With .Add(, , "  Bases a incluir en el Backup")
        .SubItems(1) = g_SetupCfg.DB_BackUp
      End With
      With .Add(, , "  Detener Cairo")
        .SubItems(1) = g_SetupCfg.StopCairo
      End With
      
      .Add
      
      Dim i As Integer
      
      With .Add(, , "Scripts")
        .Bold = True
      End With
      
      For i = 1 To UBound(g_SetupCfg.Scripts)
        With .Add(, , "  " & g_SetupCfg.Scripts(i).name)
          .SubItems(1) = g_SetupCfg.Scripts(i).Description
          .Tag = "S" & i
        End With
      Next
      
      .Add
      
      With .Add(, , "Archivos")
        .Bold = True
      End With
      
      For i = 1 To UBound(g_SetupCfg.Files)
        With .Add(, , "  " & g_SetupCfg.Files(i).name)
          .SubItems(1) = g_SetupCfg.Files(i).Description
          .Tag = "F" & i
        End With
      Next
      
      .Add
      
      With .Add(, , "Reportes")
        .Bold = True
      End With
    
      For i = 1 To UBound(g_SetupCfg.Reports)
        With .Add(, , "  " & g_SetupCfg.Reports(i).name)
          .SubItems(1) = g_SetupCfg.Reports(i).Description
          .Tag = "R" & i
        End With
      Next
    
    End With
  
  End With
End Sub

Private Function pReadSetupIni() As Boolean
  On Error GoTo ControlError
  
  fMain.lbProcess.Caption = "Leyendo el paquete de actualización"
  UpdateStatus fMain.picStatus, 0
  
  With g_SetupCfg
  
    .IdCliente = ""
    .Version = ""
    .Description = ""
    .DB_MIN_Version = ""
    .EXE_MIN_Version = ""
    .APP_MIN_Version = ""
    .OS_Version = ""
    .SQL_Version = ""
    .DataBases = ""
    .DB_BackUp = False
    .StopCairo = False
    
    ReDim .Scripts(0)
    ReDim .Files(0)
    ReDim .Reports(0)
  
  End With
  
  Dim IniFile As String
  
  IniFile = ValidPath(Environ$("Temp")) & c_setup_ini
  With g_SetupCfg
  
    .IdCliente = IniGet2(c_ini_sec_config, c_ini_key_IdCliente, "", IniFile)
    .Version = IniGet2(c_ini_sec_config, c_ini_key_Version, "", IniFile)
    .Description = Replace(IniGet2(c_ini_sec_config, c_ini_key_Description, "", IniFile), "|", vbCrLf)
    .DB_MIN_Version = IniGet2(c_ini_sec_config, c_ini_key_DB_MIN_Version, "", IniFile)
    .EXE_MIN_Version = IniGet2(c_ini_sec_config, c_ini_key_EXE_MIN_Version, "", IniFile)
    .APP_MIN_Version = IniGet2(c_ini_sec_config, c_ini_key_APP_MIN_Version, "", IniFile)
    .OS_Version = IniGet2(c_ini_sec_config, c_ini_key_OS_Version, "", IniFile)
    .SQL_Version = IniGet2(c_ini_sec_config, c_ini_key_SQL_Version, "", IniFile)
    .DataBases = IniGet2(c_ini_sec_config, c_ini_key_DataBases, "", IniFile)
    .DB_BackUp = Val(IniGet2(c_ini_sec_config, c_ini_key_DB_BackUp, "", IniFile))
    .StopCairo = Val(IniGet2(c_ini_sec_config, c_ini_key_StopCairo, 0, IniFile))
    
    
    Dim strScripts As String
    Dim strFiles   As String
    Dim strReports As String
    Dim vFiles     As Variant
    Dim vScripts   As Variant
    Dim vReports   As Variant
    
    strFiles = IniGet2(c_ini_sec_files, c_ini_key_Files, "", IniFile)
    strScripts = IniGet2(c_ini_sec_scripts, c_ini_key_Files, "", IniFile)
    strReports = IniGet2(c_ini_sec_reports, c_ini_key_Files, "", IniFile)
    
    vFiles = Split(strFiles, "|")
    vScripts = Split(strScripts, "|")
    vReports = Split(strReports, "|")
    
    Dim FilesToRead As Long
    
    FilesToRead = UBound(vFiles) + UBound(vScripts) + UBound(vReports)
    
    If FilesToRead < 0 Then FilesToRead = 1
    
    Dim i       As Long
    Dim k       As Long
    
    If UBound(vFiles) >= 0 Then
      ReDim .Files(UBound(vFiles) + 1)
      For i = 1 To UBound(vFiles) + 1
        .Files(i).name = vFiles(i - 1)
        pReadSetupFile .Files(i)
        k = k + 1
        UpdateStatus fMain.picStatus, DivideByCero(k, FilesToRead)
        DoEvents
      Next
    End If
    
    If UBound(vScripts) >= 0 Then
      ReDim .Scripts(UBound(vScripts) + 1)
      For i = 1 To UBound(vScripts) + 1
        .Scripts(i).name = vScripts(i - 1)
        pReadSetupScript .Scripts(i)
        k = k + 1
        UpdateStatus fMain.picStatus, DivideByCero(k, FilesToRead)
        DoEvents
      Next
    End If
    
    If UBound(vReports) >= 0 Then
      ReDim .Reports(UBound(vReports) + 1)
      For i = 1 To UBound(vReports) + 1
        .Reports(i).name = vReports(i - 1)
        pReadSetupReport .Reports(i)
        k = k + 1
        UpdateStatus fMain.picStatus, DivideByCero(k, FilesToRead)
        DoEvents
      Next
    End If
  
  End With
  
  UpdateStatus fMain.picStatus, 1, True
  
  pReadSetupIni = True
  
  GoTo ExitProc
ControlError:
  MngError Err, "pReadSetupIni", C_Module
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Private Sub pReadSetupScript(ByRef Script As T_ScriptFile)
  Dim IniFile As String
  
  IniFile = ValidPath(Environ$("Temp")) & c_setup_ini
  
  With Script
    .DataBases = IniGet2(Script.name, c_ini_key_DataBases, "", IniFile)
    .Description = Replace(IniGet2(Script.name, c_ini_key_Description, "", IniFile), "|", vbCrLf)
    .Filename = IniGet2(Script.name, c_ini_key_FileName, "", IniFile)
    
    Dim vAux    As Variant
    Dim i       As Integer
    
    vAux = Split(.DataBases, "|")
    
    If UBound(vAux) >= 0 Then
      ReDim .vDataBases(UBound(vAux) + 1)
      For i = 1 To UBound(vAux) + 1
        .vDataBases(i) = vAux(i - 1)
      Next
    End If
  End With
End Sub

Private Sub pReadSetupFile(ByRef File As T_File)
  Dim IniFile As String
  
  IniFile = ValidPath(Environ$("Temp")) & c_setup_ini
  
  With File
    .Filename = IniGet2(File.name, c_ini_key_FileName, "", IniFile)
    .Description = Replace(IniGet2(File.name, c_ini_key_Description, "", IniFile), "|", vbCrLf)
    .FolderTarget = IniGet2(File.name, c_ini_key_FolderTarget, "", IniFile)
    .FileVersion = IniGet2(File.name, c_ini_key_FileVersion, "", IniFile)
    .CreateShortCut = Val(IniGet2(File.name, c_ini_key_CreateShortCut, "", IniFile))
    .FolderShortCut = IniGet2(File.name, c_ini_key_FolderShortCut, "", IniFile)
    .Run = Val(IniGet2(File.name, c_ini_key_Run, "", IniFile))
    .DeleteAfterRun = Val(IniGet2(File.name, c_ini_key_DeleteAfterRun, "", IniFile))
    .Register = Val(IniGet2(File.name, c_ini_key_Register, "", IniFile))
  End With
End Sub

Private Sub pReadSetupReport(ByRef report As T_Report)
  Dim IniFile As String
  
  IniFile = ValidPath(Environ$("Temp")) & c_setup_ini
  
  With report
    .Filename = IniGet2(report.name, c_ini_key_FileName, "", IniFile)
    .Description = Replace(IniGet2(report.name, c_ini_key_Description, "", IniFile), "|", vbCrLf)
    .AsocToDoc = Val(IniGet2(report.name, c_ini_key_AsocToDoc, "", IniFile))
    .AsocToTbl = Val(IniGet2(report.name, c_ini_key_AsocToTbl, "", IniFile))
    .doct_id = Val(IniGet2(report.name, c_ini_key_Doct_id, "", IniFile))
    .tbl_id = Val(IniGet2(report.name, c_ini_key_tbl_id, "", IniFile))
  End With
End Sub

Public Function ValidPath(ByVal Path As String) As String
  If Right$(Path, 1) <> "\" Then
    Path = Path & "\"
  End If
  ValidPath = Path
End Function

Public Sub ShowInfo(ByRef Item As ListItem)
  Dim i   As Integer
  Dim msg As String
  
  If Left$(Item.Tag, 1) = "S" Then
    i = Val(Mid$(Item.Tag, 2))
    If i <= UBound(g_SetupCfg.Scripts) And i > 0 Then
      With g_SetupCfg.Scripts(i)
        msg = "Descripción" & vbCrLf & _
              .Description & vbCrLf & vbCrLf & _
              "Archivo" & vbCrLf & _
              .Filename & vbCrLf & vbCrLf & _
              "Bases" & vbCrLf & _
              .DataBases
      End With
    End If
  
  ElseIf Left$(Item.Tag, 1) = "F" Then
    
    i = Val(Mid$(Item.Tag, 2))
    If i <= UBound(g_SetupCfg.Files) And i > 0 Then
      With g_SetupCfg.Files(i)
        msg = "Descripción" & vbCrLf & _
              .Description & vbCrLf & vbCrLf & _
              "Filename" & vbCrLf & _
              .Filename & vbCrLf & vbCrLf & _
              "FolderTarget" & vbCrLf & _
              .FolderTarget & vbCrLf & vbCrLf & _
              "FileVersion" & vbCrLf & _
              .FileVersion & vbCrLf & vbCrLf & _
              "CreateShortCut" & vbCrLf & _
              .CreateShortCut & vbCrLf & vbCrLf & _
              "FolderShortCut" & vbCrLf & _
              .FolderShortCut & vbCrLf & vbCrLf & _
              "Run" & vbCrLf & _
              .Run & vbCrLf & vbCrLf & _
              "DeleteAfterRun" & vbCrLf & _
              .DeleteAfterRun & vbCrLf & vbCrLf & _
              "Register" & vbCrLf & _
              .Register

      End With
    End If
  
  ElseIf Left$(Item.Tag, 1) = "R" Then
    
    i = Val(Mid$(Item.Tag, 2))
    If i <= UBound(g_SetupCfg.Reports) And i > 0 Then
      With g_SetupCfg.Reports(i)
        msg = "Descripción" & vbCrLf & _
              .Description & vbCrLf & vbCrLf & _
              "Filename" & vbCrLf & _
              .Filename & vbCrLf & vbCrLf & _
              "Asociar a Documentos" & vbCrLf & _
              .AsocToDoc & vbCrLf & vbCrLf & _
              "Documento" & vbCrLf & _
              .doct_id & vbCrLf & vbCrLf & _
              "Asociar a Tablas" & vbCrLf & _
              .AsocToTbl & vbCrLf & vbCrLf & _
              "Tabla" & vbCrLf & _
              .tbl_id

      End With
    End If
  Else
    If Trim(Item.Text) = "Descripción" Then
      msg = Item.SubItems(1)
    End If
  End If
  
  fMain.rtxInfo.Text = msg
End Sub

Public Sub CloseApp()
  On Error Resume Next
  
  m_Client.TerminateSession
  Set m_Client = Nothing
  
  Dim F As Form
  
  For Each F In Forms
    Unload F
  Next

End Sub

Private Function GetComputer() As String
    Dim lpBuffer    As String
    Dim nResult     As Integer
    Dim nSize       As Long
    
    lpBuffer = String(255, " ")
    nSize = Len(lpBuffer)
    nResult = GetComputerName(lpBuffer, nSize)
    If nResult = 0 Then Exit Function
    GetComputer = Mid(lpBuffer, 1, nSize)
End Function

Private Function pLogin() As Boolean
  On Error GoTo ControlError

  fLogin.Show vbModal
  pLogin = fLogin.Ok
  Unload fLogin

  GoTo ExitProc
ControlError:
  MngError Err, "pLogin", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Private Function pValidateActiveCode() As Boolean
  On Error Resume Next
  Dim strCode As String
  
  If Not GetActiveCode(strCode) Then
    MsgWarning "No se pudo obtener el código de activación"
    Exit Function
  Else
    If IsValidCode(strCode) <> c_ACTIVE_CODE_OK And LCase$(GetComputer()) = LCase$(IniGet(c_K_Server, "")) Then
      MsgWarning "El código de activación no es valido"
      Exit Function
    End If
  End If
  pValidateActiveCode = True
End Function

Private Sub pSplash()
  fSplash.Show
  fSplash.ZOrder
  fSplash.Refresh
  Sleep 1500
End Sub

Private Sub pSetMainMenuEnabled(ByVal bEnabled As Boolean)
  On Error Resume Next
  
  Dim ctl As Object
  
  For Each ctl In fMain.Controls
    If TypeOf ctl Is Menu Then
      ctl.Enabled = bEnabled
    End If
  Next
End Sub

Private Function pConnectToServer() As Boolean
  Dim ErrTrayingConnect As Boolean
  
  fMain.Operation = "Conectando con el servidor"
  
  Do
    If pConnectToServerAux(ErrTrayingConnect) Then Exit Do
    If ErrTrayingConnect Then
      If Ask("Desea editar los parametros de conexión", vbYes) Then
        If Not EditConfig() Then Exit Function
      Else
        Exit Function
      End If
    End If
  Loop
  pConnectToServer = True
  
  Set fMain.Client = m_Client
  
  fMain.Operation = ""
End Function

Private Function pConnectToServerAux(ByRef ErrTrayingConnect As Boolean) As Boolean
  Dim Buffer    As String
  Dim server    As String
  Dim Port      As Integer
  
  server = IniGet(c_K_Server, "")
  Port = Val(IniGet(c_k_Port, ""))
  
  If server = "" Or Port = 0 Then
    If Not EditConfig() Then
      ErrTrayingConnect = True
      Exit Function
    End If
    server = IniGet(c_K_Server, "")
    Port = Val(IniGet(c_k_Port, ""))
  End If
  
  If Not m_Client.ConnectToServer(server, Port) Then
    MsgError m_Client.ErrDescription
    ErrTrayingConnect = True
    Exit Function
  End If
  
  Buffer = TCPCreateToken(c_ClientComputer, GetComputer())
  Buffer = Buffer & TCPCreateToken(c_ClientTCP_ID, m_Client.ClientId)
  Buffer = Buffer & TCPCreateToken(c_ClientUser, c_CairoSysUser)
  
  Buffer = TCPGetMessage(cTCPCommandAddClient, m_ClientProcessId, Buffer)
  
  If Not m_Client.SendAndReciveText(Buffer, SRV_ID_SERVER) Then Exit Function
  
  If TCPError(m_Client.DataReceived) Then
    MsgError GetErrorMessage(m_Client.DataReceived)
    ErrTrayingConnect = True
    Exit Function
  End If
    
  m_ClientProcessId = Val(TCPGetResponse(m_Client.DataReceived))
  
  fMain.ConnectedTo = "Conectado al server [" & server & "] Por [" & Port & "]"
  
  pConnectToServerAux = True
End Function

'  GoTo ExitProc
'ControlError:
'  MngError "", c_Module
'  If Err.Number Then Resume ExitProc
'ExitProc:
'  On Error Resume Next

