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
    Private Declare Function GetComputerName Lib "kernel32" Alias "GetComputerNameA" (ByVal lpBuffer As String, nSize As Long) As Long
    Private Declare Sub Sleep Lib "kernel32" (ByVal dwMilliseconds As Long)
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "mMain"
Public Const APP_NAME = "CSUpdatePackageEditor"

Public Const c_step_show_info = 1

Private Const c_CairoSysUser = "Cairo System Administrator"

Public Enum csETablesInforme
  csTblInforme = 7001
End Enum

Public Const c_macro_apppath = "$apppath"
Public Const c_macro_reportpath = "$reportpath"
Public Const c_macro_windowspath = "$windowspath"
Public Const c_macro_programfilespath = "$programfilespath"
Public Const c_macro_system32path = "$system32path"
Public Const c_macro_desktoppath = "$desktoppath"
Public Const c_macro_qlaunchpath = "$qlaunchpath"
Public Const c_macro_startuppath = "$startuppath"

Public Const c_id_file_files = 10000
Public Const c_id_file_scripts = 100000
Public Const c_id_file_csrs = 1000000

Public Const c_id_file_files_new = 0
Public Const c_id_file_scripts_new = c_id_file_files
Public Const c_id_file_csrs_new = c_id_file_scripts

Public Const c_file_type_file = "Archivo"
Public Const c_file_type_csr = "Reporte"
Public Const c_file_type_scripts = "Scripts"

' estructuras
' variables privadas
Private m_Client                        As cTCPIPClient
Private m_ClientProcessId               As Long
Private m_InitCSOAPI                    As CSOAPI2.cInitCSOAPI
' eventos
' propiedadades publicas
Public g_SetupCfg   As T_SetupCfg
Public g_db         As t_Database
Public gDb          As cDataBase

Private m_NextIdFileFile    As Long
Private m_NextIdFileScript  As Long
Private m_NextIdFileCsr     As Long

' propiedadades friend
' propiedades privadas
' funciones publicas
Public Function ClientProcessId() As Long
  ClientProcessId = m_ClientProcessId
End Function

Public Sub Main()

  pInit

  pSplash
  
  CSKernelClient2.AppName = APP_NAME
  
  CSKernelClient2.Title = APP_NAME
  
  Set m_Client = New cTCPIPClient
  
  fMain.Show
  pSetMainMenuEnabled False
  
  Unload fSplash
  
  ' Me conecto al server
  If Not pConnectToServer Then
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
      fDataBases.Show vbModal
      If Not fDataBases.Ok Then
        Unload fMain
        CloseApp
      Else
        fMain.lbTopTitle.Caption = "Server: " & g_db.server & " - " & _
                                   "Database: " & g_db.DataBase & " - " & _
                                   "User: " & g_db.User
        Unload fDataBases
      
        Set m_InitCSOAPI = New CSOAPI2.cInitCSOAPI
        m_InitCSOAPI.AppName = APP_NAME
        CSOAPI2.EmpId = 1
        CSOAPI2.BdId = g_db.db_id
      
        If Not m_InitCSOAPI.Init(pGetConnetString(g_db.server, _
                                                  g_db.DataBase, _
                                                  g_db.User, _
                                                  g_db.Pwd, _
                                                  g_db.UseNT _
                                                 ), _
                                 "Administrador", _
                                 m_Client, _
                                 m_ClientProcessId) Then
          Unload fMain
          CloseApp
        Else
        
          Set gDb = m_InitCSOAPI.DataBase
        
          If Not User.GetUser(m_InitCSOAPI.DataBase.UserId) Then
            
            Unload fMain
            CloseApp
          
          Else
          
            CSOAPI2.SecurityShowMessages = False
            pSetMainMenuEnabled True

          End If
        End If
      End If
    End If
  End If
End Sub

Private Sub pInit()
  m_NextIdFileFile = 1                     ' to c_id_file_files
  m_NextIdFileScript = c_id_file_files + 1 ' to c_id_file_scripts
  m_NextIdFileCsr = c_id_file_scripts + 1  ' to c_id_file_csrs
End Sub

Private Function pValidateActiveCode() As Boolean
  On Error Resume Next
  Dim strCode As String
  
  If Not GetActiveCode(strCode) Then
    MsgWarning "No se pudo obtener el código de activación"
    Exit Function
  Else
    If IsValidCode(strCode) <> c_ACTIVE_CODE_OK Then
      MsgWarning "El código de activación no es valido"
      Exit Function
    End If
  End If
  pValidateActiveCode = True
End Function

Public Sub CloseApp()
  On Error Resume Next
  
  Set gDb = Nothing
  
  Set CSKernelClient2.OForms = Forms
  CSKernelClient2.FreeResource
  
  m_Client.TerminateSession
  Set m_Client = Nothing
  
  m_InitCSOAPI.Terminate
  Set m_InitCSOAPI = Nothing
  
End Sub

Public Function GetErrorMessage(ByVal DataReceived As String) As String
  GetErrorMessage = "Ha ocurrido un error al intentar conectarse con el servidor.;;Descripción técnica: " & TCPGetResponse(DataReceived)
End Function
' funciones friend
' funciones privadas
Private Sub pSplash()
  fSplash.Show
  fSplash.ZOrder
  fSplash.Refresh
  Sleep 1500
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

Private Function pRefresLoginOn()
  Dim Buffer    As String
  
  Buffer = TCPGetMessage(cTCPCommandSetClientActive, m_ClientProcessId)
  If Not fMain.Client.SendAndReciveText(Buffer, SRV_ID_SERVER) Then Exit Function
  
  If TCPError(fMain.Client.DataReceived) Then
    MsgError "Ha ocurrido un error al verificar sus credenciales de usuario.;;Descripción técnica: " & TCPGetResponse(fMain.Client.DataReceived)
    Exit Function
  End If
  
  Buffer = TCPGetResponse(fMain.Client.DataReceived)
  
  If TCPGetFail(fMain.Client.DataReceived) Then
    MsgError Buffer
    Exit Function
  End If
  
  pRefresLoginOn = True
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
  
  fMain.Caption = fMain.Caption & " Conectado al server [" & server & "] Por [" & Port & "]"
  
  pConnectToServerAux = True
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

Public Function ValidPath(ByVal Path As String) As String
  If Right$(Path, 1) <> "\" Then
    Path = Path & "\"
  End If
  ValidPath = Path
End Function

Public Function NewCSA() As Boolean
  On Error GoTo ControlError

  Set fCSA = Nothing
  Set fCSA = New fCSA

  fCSA.Show vbModal

  If fCSA.Ok Then

    ReDim g_SetupCfg.Files(0)
    ReDim g_SetupCfg.Scripts(0)
    ReDim g_SetupCfg.Reports(0)
    
    fMain.lvInfo.ListItems.Clear

    fCSAtotCSA
    
    fMain.cmdAddCsr.Enabled = True
    fMain.cmdAddScripts.Enabled = True
    fMain.cmdAddFiles.Enabled = True
    fMain.cmdEditCSA.Enabled = True
    
    fMain.bCSAIsOpen = True
    
    NewCSA = True
    
  End If

  GoTo ExitProc
ControlError:
  MngError Err, "NewCSAI", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
  Unload fTree
End Function

Public Sub fCSAtotCSA()
  
  g_SetupCfg.CSA_File = fMain.txPackageName.Text
  g_SetupCfg.IdCliente = fCSA.txIdCliente.Text
  g_SetupCfg.Version = fCSA.txVersion.Text
  g_SetupCfg.Description = fCSA.txDescrip.Text
  g_SetupCfg.DB_MIN_Version = fCSA.txDBMinVer.Text
  g_SetupCfg.EXE_MIN_Version = fCSA.txEXEMinVer.Text
  g_SetupCfg.APP_MIN_Version = fCSA.txAPPMinVer.Text
  g_SetupCfg.OS_Version = fCSA.txOSVer.Text
  g_SetupCfg.SQL_Version = fCSA.txSqlVer.Text
  g_SetupCfg.DataBases = fCSA.txDataBases.Text
  g_SetupCfg.DB_BackUp = fCSA.chkBackup.Value = vbChecked
  g_SetupCfg.StopCairo = fCSA.chkStopCairo.Value = vbChecked

End Sub

Public Sub tCSAtofCSA()
  
  fMain.txPackageName.Text = g_SetupCfg.CSA_File
  fCSA.txIdCliente.Text = g_SetupCfg.IdCliente
  fCSA.txVersion.Text = g_SetupCfg.Version
  fCSA.txDescrip.Text = g_SetupCfg.Description
  fCSA.txDBMinVer.Text = g_SetupCfg.DB_MIN_Version
  fCSA.txEXEMinVer.Text = g_SetupCfg.EXE_MIN_Version
  fCSA.txAPPMinVer.Text = g_SetupCfg.APP_MIN_Version
  fCSA.txOSVer.Text = g_SetupCfg.OS_Version
  fCSA.txSqlVer.Text = g_SetupCfg.SQL_Version
  fCSA.txDataBases.Text = g_SetupCfg.DataBases
  fCSA.chkBackup.Value = IIf(g_SetupCfg.DB_BackUp, vbChecked, vbUnchecked)
  fCSA.chkStopCairo.Value = IIf(g_SetupCfg.StopCairo, vbChecked, vbUnchecked)

End Sub

Public Function NewCSAI()
  On Error GoTo ControlError

  fTree.NameEdit = "Informes"
  Load fTree
  fTree.Init
  fTree.Show vbModal
  
  If Ask("¿Desea agregar este paquete de informes a un paquete de actualizacion?", vbYes) Then
  
    If fMain.bCSAIsOpen Then
      fMain.AddCsr
    Else
      
      If NewCSA() Then
      
        fMain.AddCsr
      End If
    
    End If
  
  End If

  GoTo ExitProc
ControlError:
  MngError Err, "NewCSAI", C_Module, ""
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
  Unload fTree
End Function

Private Function pGetConnetString(ByVal server As String, ByVal DataBase As String, _
                                  ByVal User As String, ByVal Password As String, _
                                  ByVal UseNTSecurity As Boolean) As String
  Dim Connect As String

  If Not UseNTSecurity Then
    Connect = "Provider=SQLOLEDB.1;" _
              & "Password=" & Password & ";" _
              & "Persist Security Info=True;" _
              & "User ID=" & User & ";" _
              & "Initial Catalog=" & DataBase & ";" _
              & "Data Source=" & server

  Else
    Connect = "Provider=SQLOLEDB.1;" _
              & "Initial Catalog=" & DataBase & ";" _
              & "Data Source=" & server & ";" _
              & "Persist Security Info=False;Integrated Security=SSPI;"
  End If

  pGetConnetString = Connect

End Function

Public Function UpdateLvInfoCsr(ByRef lv As ListView) As Boolean
  Dim Item  As ListItem
  Dim i     As Long
  Dim sIcon As String
  
  For i = 1 To UBound(g_SetupCfg.Reports)
    With g_SetupCfg.Reports(i)
      For Each Item In lv.ListItems
        If Val(Item.Tag) = .idFile Then
          Exit For
        End If
      Next
      
      If Item Is Nothing Then
        sIcon = AddIconToImageList(GetValidPath(.SourcePath) _
                                       & .Filename, _
                                   fMain.ilsIcons16, _
                                   "DEFAULT")

        Set Item = lv.ListItems.Add(, , , , sIcon)
        Item.Tag = .idFile
      End If
      Item.Text = .name
      Item.SubItems(1) = .Filename
      Item.SubItems(2) = .SourcePath
      Item.SubItems(4) = c_file_type_csr
    End With
  Next
End Function

Public Function UpdateLvInfoFiles(ByRef lv As ListView) As Boolean
  Dim Item  As ListItem
  Dim i     As Long
  Dim sIcon As String
  
  For i = 1 To UBound(g_SetupCfg.Files)
    With g_SetupCfg.Files(i)
      For Each Item In lv.ListItems
        If Val(Item.Tag) = .idFile Then
          Exit For
        End If
      Next
      
      If Item Is Nothing Then
        
        sIcon = AddIconToImageList(GetValidPath(.SourcePath) _
                                       & .Filename, _
                                   fMain.ilsIcons16, _
                                   "DEFAULT")

        Set Item = lv.ListItems.Add(, , , , sIcon)
        Item.Tag = .idFile
      End If
      Item.Text = .name
      Item.SubItems(1) = .Filename
      Item.SubItems(2) = .SourcePath
      Item.SubItems(3) = .FolderTarget
      Item.SubItems(4) = c_file_type_file
    End With
  Next
End Function

Public Function UpdateLvInfoScripts(ByRef lv As ListView) As Boolean
  Dim Item  As ListItem
  Dim i     As Long
  Dim sIcon As String
  
  For i = 1 To UBound(g_SetupCfg.Scripts)
    With g_SetupCfg.Scripts(i)
      For Each Item In lv.ListItems
        If Val(Item.Tag) = .idFile Then
          Exit For
        End If
      Next
      
      If Item Is Nothing Then
        
        sIcon = AddIconToImageList(GetValidPath(.SourcePath) _
                                       & .Filename, _
                                   fMain.ilsIcons16, _
                                   "DEFAULT")

        Set Item = lv.ListItems.Add(, , , , sIcon)
        Item.Tag = .idFile
      End If
      Item.Text = .name
      Item.SubItems(1) = .Filename
      Item.SubItems(2) = .SourcePath
      Item.SubItems(4) = c_file_type_scripts
    End With
  Next
End Function

Public Function CSAEditFile(ByVal strFile As String, _
                            ByRef idFile As Long) As Boolean
  
  Dim i       As Long
  Dim bFound  As Boolean
  Dim FileEx  As CSKernelFile.cFileEx
  
  Set FileEx = New cFileEx
  
  With fFile
    .lbFile.Caption = strFile
    .txName.Text = Replace(FileEx.FileGetName(strFile), ".", "_")
  End With
  
  With g_SetupCfg
    
    If idFile < c_id_file_files Then
      For i = 1 To UBound(.Files)
        If idFile = .Files(i).idFile Then
          bFound = True
          Exit For
        End If
      Next
    
      If bFound Then
        With .Files(i)
          fFile.txDescrip.Text = .Description
          fFile.txName.Text = .name
          
          fFile.txVersion.Text = .FileVersion
          fFile.chkCreateShortcut.Value = IIf(.CreateShortCut, vbChecked, vbUnchecked)
          fFile.chkDelAfterRun.Enabled = IIf(.DeleteAfterRun, vbChecked, vbUnchecked)
          fFile.cbTarget.Text = .FolderTarget
          fFile.cbTargetShortcut.Text = .FolderShortCut
          fFile.chkExecute.Value = IIf(.Run, vbChecked, vbUnchecked)
          fFile.chkRegister.Value = IIf(.Register, vbChecked, vbUnchecked)
          
        End With
      
      Else
        m_NextIdFileFile = m_NextIdFileFile + 1
        idFile = m_NextIdFileFile
        i = UBound(.Files) + 1
        ReDim Preserve .Files(i)
        With .Files(i)
          .idFile = idFile
          .name = fFile.txName.Text
          .SourcePath = FileEx.FileGetPath(strFile)
        End With
      End If
    
      fFile.txDataBases.Enabled = False
      fFile.txDataBases.BackColor = vbButtonFace
      fFile.txVersion.Enabled = True
      fFile.txVersion.BackColor = vbWindowBackground
      fFile.chkCreateShortcut.Enabled = True
      fFile.chkDelAfterRun.Enabled = True
      fFile.cbTarget.Enabled = True
      fFile.cbTargetShortcut.Enabled = True
      fFile.chkExecute.Enabled = True
      fFile.chkRegister.Enabled = True
      fFile.chkAsocToDoc.Enabled = False
      fFile.cbDoct_id.Enabled = False
      fFile.chkAsocToTbl.Enabled = False
      fFile.cbTbl_id.Enabled = False
    
    ElseIf idFile < c_id_file_scripts Then
      For i = 1 To UBound(.Scripts)
        If idFile = .Scripts(i).idFile Then
          bFound = True
          Exit For
        End If
      Next
    
      If bFound Then
        With .Scripts(i)
          fFile.txDescrip.Text = .Description
          fFile.txDataBases.Text = .DataBases
          fFile.txName.Text = .name
        End With
      Else
        m_NextIdFileScript = m_NextIdFileScript + 1
        idFile = m_NextIdFileScript
        i = UBound(.Scripts) + 1
        ReDim Preserve .Scripts(i)
        With .Scripts(i)
          .idFile = idFile
          .name = fFile.txName.Text
          .SourcePath = FileEx.FileGetPath(strFile)
        End With
      End If
    
      fFile.txDataBases.Enabled = True
      fFile.txDataBases.BackColor = vbWindowBackground
      fFile.txVersion.Enabled = False
      fFile.txVersion.BackColor = vbButtonFace
      fFile.chkCreateShortcut.Enabled = False
      fFile.chkDelAfterRun.Enabled = False
      fFile.cbTarget.Enabled = False
      fFile.cbTargetShortcut.Enabled = False
      fFile.chkExecute.Enabled = False
      fFile.chkRegister.Enabled = False
      fFile.chkAsocToDoc.Enabled = False
      fFile.cbDoct_id.Enabled = False
      fFile.chkAsocToTbl.Enabled = False
      fFile.cbTbl_id.Enabled = False
    
    ElseIf idFile < c_id_file_csrs Then
      For i = 1 To UBound(.Reports)
        If idFile = .Reports(i).idFile Then
          bFound = True
          Exit For
        End If
      Next
      
      If bFound Then
        With .Reports(i)
          fFile.txName.Text = .name
          fFile.txDescrip.Text = .Description
          CSKernelClient2.ListSetListIndexForId fFile.cbDoct_id, _
                                                .doct_id
          fFile.chkAsocToDoc.Value = IIf(.AsocToDoc, vbChecked, vbUnchecked)
          CSKernelClient2.ListSetListIndexForId fFile.cbTbl_id, _
                                                .tbl_id
          fFile.chkAsocToTbl.Value = IIf(.AsocToTbl, vbChecked, vbUnchecked)
        End With
      Else
        m_NextIdFileCsr = m_NextIdFileCsr + 1
        idFile = m_NextIdFileCsr
        i = UBound(.Reports) + 1
        ReDim Preserve .Reports(i)
        With .Reports(i)
          .idFile = idFile
          .name = fFile.txName.Text
          .SourcePath = FileEx.FileGetPath(strFile)
        End With
      End If

      fFile.txDataBases.Enabled = False
      fFile.txDataBases.BackColor = vbButtonFace
      fFile.txVersion.Enabled = False
      fFile.txVersion.BackColor = vbButtonFace
      fFile.chkCreateShortcut.Enabled = False
      fFile.chkDelAfterRun.Enabled = False
      fFile.cbTarget.Enabled = False
      fFile.cbTargetShortcut.Enabled = False
      fFile.chkExecute.Enabled = False
      fFile.chkRegister.Enabled = False
      fFile.chkAsocToDoc.Enabled = True
      fFile.cbDoct_id.Enabled = True
      fFile.chkAsocToTbl.Enabled = True
      fFile.cbTbl_id.Enabled = True

    End If
  End With
  
  fFile.Show vbModal
  
  If Not fFile.Ok Then Exit Function
  
  With g_SetupCfg
    
    If idFile < c_id_file_files Then
        
      With .Files(i)
        
        .Description = fFile.txDescrip.Text
        .name = fFile.txName.Text
        
        .FileVersion = fFile.txVersion.Text
        .CreateShortCut = fFile.chkCreateShortcut.Value = vbChecked
        .DeleteAfterRun = fFile.chkDelAfterRun.Enabled = vbChecked
        .FolderTarget = fFile.cbTarget.Text
        .FolderShortCut = fFile.cbTargetShortcut.Text
        .Run = fFile.chkExecute.Value = vbChecked
        .Register = fFile.chkRegister.Enabled = vbChecked
        
      End With
    
    ElseIf idFile < c_id_file_scripts Then
      
      With .Scripts(i)
        .Description = fFile.txDescrip.Text
        .name = fFile.txName.Text
        .DataBases = fFile.txDataBases.Text
      End With
    
    ElseIf idFile < c_id_file_csrs Then
      
      With .Reports(i)
        .name = fFile.txName.Text
        .Description = fFile.txDescrip.Text
        .AsocToDoc = fFile.chkAsocToDoc = vbChecked
        .AsocToTbl = fFile.chkAsocToTbl = vbChecked
        .doct_id = CSKernelClient2.ListID(fFile.cbDoct_id)
        .tbl_id = CSKernelClient2.ListID(fFile.cbTbl_id)
      End With

    End If
  End With
  
  CSAEditFile = True
  
End Function

Public Function UpdateSetupFiles() As Boolean
  Dim strFile As String
  Dim i       As Long
  Dim k       As Long
  Dim idFile  As Long
  Dim FileEx  As cFileEx
  
  Set FileEx = New cFileEx
  
  With fAddFiles.lsFiles
    For i = 0 To .ListCount - 1
      If .ItemData(i) = 0 Then
        strFile = .List(i)
        k = UBound(g_SetupCfg.Files) + 1
        ReDim Preserve g_SetupCfg.Files(k)
        m_NextIdFileFile = m_NextIdFileFile + 1
        idFile = m_NextIdFileFile
        With g_SetupCfg.Files(k)
          .idFile = idFile
          .Filename = FileEx.FileGetName(strFile)
          .name = Replace(.Filename, ".", "_")
          .FolderTarget = fAddFiles.cbTarget.Text
          .SourcePath = FileEx.FileGetPath(strFile)
        End With
      End If
    Next
  End With

End Function

Public Function UpdateSetupScripts() As Boolean
  Dim strFile As String
  Dim i       As Long
  Dim k       As Long
  Dim idFile  As Long
  Dim FileEx  As cFileEx
  
  Set FileEx = New cFileEx
  
  With fAddFiles.lsFiles
    For i = 0 To .ListCount - 1
      If .ItemData(i) = 0 Then
        strFile = .List(i)
        k = UBound(g_SetupCfg.Scripts) + 1
        ReDim Preserve g_SetupCfg.Scripts(k)
        m_NextIdFileScript = m_NextIdFileScript + 1
        idFile = m_NextIdFileScript
        With g_SetupCfg.Scripts(k)
          .idFile = idFile
          .Filename = FileEx.FileGetName(strFile)
          .name = Replace(.Filename, ".", "_")
          .SourcePath = FileEx.FileGetPath(strFile)
        End With
      End If
    Next
  End With

End Function

Public Function UpdateSetupReports() As Boolean
  Dim strFile As String
  Dim i       As Long
  Dim k       As Long
  Dim idFile  As Long
  Dim FileEx  As cFileEx
  
  Set FileEx = New cFileEx
  
  With fAddFiles.lsFiles
    For i = 0 To .ListCount - 1
      If .ItemData(i) = 0 Then
        strFile = .List(i)
        k = UBound(g_SetupCfg.Reports) + 1
        ReDim Preserve g_SetupCfg.Reports(k)
        m_NextIdFileCsr = m_NextIdFileCsr + 1
        idFile = m_NextIdFileCsr
        With g_SetupCfg.Reports(k)
          .idFile = idFile
          .Filename = FileEx.FileGetName(strFile)
          .name = Replace(.Filename, ".", "_")
          .SourcePath = FileEx.FileGetPath(strFile)
        End With
      End If
    Next
  End With

End Function

Public Sub InitCBTarget(ByRef cbTarget As Control)
  
  With cbTarget
    .Clear
    .AddItem c_macro_apppath
    .AddItem c_macro_reportpath
    .AddItem c_macro_windowspath
    .AddItem c_macro_programfilespath
    .AddItem c_macro_system32path
    .AddItem c_macro_desktoppath
    .AddItem c_macro_qlaunchpath
    .AddItem c_macro_startuppath
  End With

End Sub

Public Sub InitCBDoctId(ByRef cbDoctId As Control)
  Dim rs      As ADODB.Recordset
  Dim sqlstmt As String
  
  sqlstmt = "select doct_id, doct_nombre from DocumentoTipo order by doct_nombre"
  If Not gDb.OpenRs(sqlstmt, rs) Then Exit Sub
  
  With cbDoctId
    .Clear
  
    While Not rs.EOF
  
      .AddItem gDb.ValField(rs.Fields, "doct_nombre")
      .ItemData(.NewIndex) = gDb.ValField(rs.Fields, "doct_id")
      
      rs.MoveNext
    Wend
  End With
End Sub

Public Sub InitCBTblId(ByRef cbTblId As Control)
  Dim rs      As ADODB.Recordset
  Dim sqlstmt As String
  
  sqlstmt = "select tbl_id, tbl_nombre from Tabla order by tbl_nombre"
  If Not gDb.OpenRs(sqlstmt, rs) Then Exit Sub
  
  With cbTblId
    .Clear
  
    While Not rs.EOF
  
      .AddItem gDb.ValField(rs.Fields, "tbl_nombre")
      .ItemData(.NewIndex) = gDb.ValField(rs.Fields, "tbl_id")
      
      rs.MoveNext
    Wend
  End With
End Sub

Public Function CSASave() As Boolean
  On Error GoTo ControlError

  Dim CSA As cCSA

  fMain.picProgress.Visible = True
  fMain.picProgress.ZOrder
  
  Set CSA = New cCSA

  CSASave = CSA.Save()

  GoTo ExitProc
ControlError:
  MngError Err, "CSASave", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
  fMain.picProgress.Visible = False
End Function

Private Sub pSetMainMenuEnabled(ByVal bEnabled As Boolean)
  On Error Resume Next
  
  Dim ctl As Object
  
  For Each ctl In fMain.Controls
    If TypeOf ctl Is Menu Then
      ctl.Enabled = bEnabled
    End If
  Next
End Sub

'//////////////////////////////
'  Codigo estandar de errores
'  On Error GoTo ControlError
'
'  GoTo ExitProc
'ControlError:
'  MngError err,"", C_Module, ""
'  If Err.Number <> 0 Then Resume ExitProc
'ExitProc:
'  On Error Resume Next
