VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cCSA"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit

'--------------------------------------------------------------------------------
' cCSA
' 11-07-00

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module      As String = "cInformes"

' estructuras
' variables privadas
Private m_FileCount     As Long
Private m_IdxFile       As Long
Private m_TempFolder    As String

Private WithEvents m_cZ As cszip.cZip
Attribute m_cZ.VB_VarHelpID = -1

' Properties publicas
' Properties privadas
' funciones publicas

Public Function Save() As Boolean
  On Error GoTo ControlError

  Dim pkgFolder   As String
  Dim pkgFile     As String
  Dim strError    As String
  Dim bCopy       As Boolean
  Dim Answer      As VbMsgBoxResult
  Dim sMsg        As String
  
  
  m_FileCount = 0
  m_IdxFile = 0
  
  UpdateStatus fMain.picStatus, 0
  
  fMain.picProgress.Visible = True
  fMain.lbClose.Visible = False
  fMain.lsFiles.Clear
  DoEvents

  pSetFileCount
  
  m_TempFolder = Environ$("TEMP") & "\CSA"

  pkgFolder = fMain.txPackagePath.Text
  pkgFile = fMain.txPackageName.Text

  ' Copio todos los archivos al temp

  ' Creo la carpeta donde guardare el paquete
  '
  If Not CreateFolder(pkgFolder) Then Exit Function
  
  ' Borro el paquete
  '
  If Not DeleteFile(GetValidPath(pkgFolder) & _
                                 pkgFile, _
                    strError) Then
    MsgWarning LNGGetText(3463, vbNullString, pkgFile, pkgFile, strError)
              'No se pudo eliminar el archivo  & pkgFile & _
                en la carpeta  & pkgFile & ;; & strError
    Exit Function
  End If
  
  ' Creo la carpeta temporal
  '
  If Not CreateFolder(m_TempFolder) Then Exit Function

  ' Borro setup.ini
  '
  If Not DeleteFile(GetValidPath(m_TempFolder) & _
                                 "setup.inf", _
                    strError) Then
    MsgWarning LNGGetText(3463, vbNullString, m_TempFolder, strError)
              'No se pudo eliminar el archivo setup.inf & _
                en la carpeta  & m_TempFolder & ;; & strError
    Exit Function
  End If

  ' Vacio la carpeta
  '
  If Not ClearFolder(m_TempFolder) Then Exit Function

  ' Copio archivos
  '
  Dim i As Long

  For i = 1 To UBound(g_SetupCfg.Files)
    
    With g_SetupCfg.Files(i)

      ' Si el archivo ya existe -> warnning
      '
      If ExistsFile(GetValidPath(m_TempFolder) _
                          & .Filename) Then
        Answer = Ask3(LNGGetText(3465, vbNullString, .Filename), vbNo)
                    'El archivo  & .Filename & _
                      ya existe.;;¿Desea reemplazarlo? & _
                     ;;Si presiona cancelar se cancela el proceso.
        
        If Answer = vbCancel Then
          GoTo ExitProc
        End If
        
        bCopy = Answer = vbYes
      Else
        bCopy = True
      End If
      
      sMsg = LNGGetText(3466, vbNullString, .name) 'Copiando .name
      
      With fMain
        .lbProcess.Caption = sMsg
        With .lsFiles
          .AddItem sMsg
          .ListIndex = .NewIndex
        End With
      End With
      
      If bCopy Then
      
        If Not CopyFile(GetValidPath(.SourcePath) _
                          & .Filename, _
                        GetValidPath(m_TempFolder) _
                          & .Filename) Then Exit Function
      End If
      
      m_IdxFile = m_IdxFile + 1
      UpdateStatus fMain.picStatus, m_IdxFile / m_FileCount
      
    End With
  Next
  
  For i = 1 To UBound(g_SetupCfg.Scripts)
    
    With g_SetupCfg.Scripts(i)
    
      ' Si el archivo ya existe -> warnning
      '
      If ExistsFile(GetValidPath(m_TempFolder) _
                          & .Filename) Then
        Answer = Ask3(LNGGetText(3465, vbNullString, .Filename), vbNo)
                  'El archivo  & .Filename & _
                    ya existe.;;¿Desea reemplazarlo? & _
                   ;;Si presiona cancelar se termina el proceso.
        
        If Answer = vbCancel Then
          GoTo ExitProc
        End If
        
        bCopy = Answer = vbYes
      Else
        bCopy = True
      End If
          
      sMsg = LNGGetText(3466, vbNullString, .name) 'Copiando .name
      
      With fMain
        .lbProcess.Caption = sMsg
        With .lsFiles
          .AddItem sMsg
          .ListIndex = .NewIndex
        End With
      End With
      
      If bCopy Then
    
        If Not CopyFile(GetValidPath(.SourcePath) _
                          & .Filename, _
                        GetValidPath(m_TempFolder) _
                          & .Filename) Then Exit Function
      End If
      
      m_IdxFile = m_IdxFile + 1
      UpdateStatus fMain.picStatus, m_IdxFile / m_FileCount
    
    End With
  Next
  
  For i = 1 To UBound(g_SetupCfg.Reports)
    
    With g_SetupCfg.Reports(i)
    
      ' Si el archivo ya existe -> warnning
      '
      If ExistsFile(GetValidPath(m_TempFolder) _
                          & .Filename) Then
        Answer = Ask3(LNGGetText(3465, vbNullString, .Filename), vbNo)
                      'El archivo  & .Filename & _
                       ya existe.;;¿Desea reemplazarlo? & _
                       ;;Si presiona cancelar se cancela el proceso.
        
        If Answer = vbCancel Then
          GoTo ExitProc
        End If
        
        bCopy = Answer = vbYes
      Else
        bCopy = True
      End If
    
      
      sMsg = LNGGetText(3466, vbNullString, .name) 'Copiando .name
      
      With fMain
        .lbProcess.Caption = sMsg
        With .lsFiles
          .AddItem sMsg
          .ListIndex = .NewIndex
        End With
      End With
      
      If bCopy Then
        
        If Not CopyFile(GetValidPath(.SourcePath) _
                          & .Filename, _
                        GetValidPath(m_TempFolder) _
                          & .Filename) Then Exit Function
      End If
      
      m_IdxFile = m_IdxFile + 1
      UpdateStatus fMain.picStatus, m_IdxFile / m_FileCount
      
    End With
  Next
  
  ' Creo el setup.ini
  '
  pCreateSetupIni
  
  m_IdxFile = 0
  UpdateStatus fMain.picStatus, 0
  
  ' Creo el zip
  '
  Dim zip As cszip.cZip
  Set zip = New cszip.cZip
  
  Set m_cZ = zip
  
  With zip
  
     .Encrypt = False
     .AddComment = False
     .ZipFile = GetValidPath(pkgFolder) & _
                   pkgFile
     .StoreFolderNames = False
     .RecurseSubDirs = False
     .ClearFileSpecs
     
     m_FileCount = ZipFilesInFolder(zip, m_TempFolder) * 3
     
     .zip
  
     If (.Success) Then
        
        UpdateStatus fMain.picStatus, 1, True
        
        MsgInfo LNGGetText(3468, vbNullString, .ZipFile)
                'Archivo generado: _
                & vbCrLf & vbCrLf & _
                   -  & .ZipFile
     Else
        MsgWarning LNGGetText(3469, vbNullString) 'Falló la creación del zip.
        fMain.lbClose.Visible = True
        GoTo ExitProc
     End If
  
  End With
  
  fMain.picProgress.Visible = False

  Save = True

  GoTo ExitProc
ControlError:
  MngError Err, "CSASave", C_Module, vbNullString
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Private Sub pSetFileCount()
  With g_SetupCfg
    m_FileCount = UBound(.Files) _
               + UBound(.Scripts) _
               + UBound(.Reports) + 1 ' setup.ini
  End With
End Sub

Private Sub m_cZ_Progress(ByVal lCount As Long, ByVal sMsg As String)
  
  sMsg = Trim(sMsg)
  
  With fMain
    
    .lbProcess.Caption = sMsg
    With .lsFiles
      .AddItem sMsg
      .ListIndex = .NewIndex
    End With
  
    m_IdxFile = m_IdxFile + 1
    UpdateStatus .picStatus, m_IdxFile / m_FileCount
  
  End With
  
End Sub

Private Function pCreateSetupIni() As Boolean
  On Error GoTo ControlError
  
  Dim iniFile     As String
  Dim i           As Long
  Dim strFiles    As String
  Dim strScripts  As String
  Dim strReports  As String
  
  iniFile = GetValidPath(m_TempFolder) & "setup.ini"
  
  CSASaveValue c_ini_sec_config, _
               c_ini_key_IdCliente, _
               g_SetupCfg.IdCliente, _
               iniFile
               
  CSASaveValue c_ini_sec_config, _
               c_ini_key_Version, _
               g_SetupCfg.Version, _
               iniFile
               
  CSASaveValue c_ini_sec_config, _
               c_ini_key_Description, _
               Replace(g_SetupCfg.Description, _
                       vbCrLf, "|"), _
               iniFile
               
  CSASaveValue c_ini_sec_config, _
               c_ini_key_DB_MIN_Version, _
               g_SetupCfg.DB_MIN_Version, _
               iniFile
               
  CSASaveValue c_ini_sec_config, _
               c_ini_key_EXE_MIN_Version, _
               g_SetupCfg.EXE_MIN_Version, _
               iniFile
               
  CSASaveValue c_ini_sec_config, _
               c_ini_key_APP_MIN_Version, _
               g_SetupCfg.APP_MIN_Version, _
               iniFile
               
  CSASaveValue c_ini_sec_config, _
               c_ini_key_OS_Version, _
               g_SetupCfg.OS_Version, _
               iniFile
               
  CSASaveValue c_ini_sec_config, _
               c_ini_key_SQL_Version, _
               g_SetupCfg.SQL_Version, _
               iniFile
               
  CSASaveValue c_ini_sec_config, _
               c_ini_key_DataBases, _
               g_SetupCfg.DataBases, _
               iniFile
               
  CSASaveValue c_ini_sec_config, _
               c_ini_key_DB_BackUp, _
               Val(g_SetupCfg.DB_BackUp), _
               iniFile
  
  CSASaveValue c_ini_sec_config, _
               c_ini_key_StopCairo, _
               Val(g_SetupCfg.StopCairo), _
               iniFile
               
               
'/////////////////////////////////
' LISTAS
'

'////////////////////////////////
' FILES
'
  For i = 1 To UBound(g_SetupCfg.Files)
    With g_SetupCfg.Files(i)
      strFiles = strFiles & .name & "|"
    End With
  Next
  
  If Right$(strFiles, 1) = "|" Then
    strFiles = Left$(strFiles, Len(strFiles) - 1)
  End If
  
  CSASaveValue c_ini_sec_files, _
               c_ini_key_Files, _
               strFiles, _
               iniFile
  
'////////////////////////////////
' SCRIPTS
'
  For i = 1 To UBound(g_SetupCfg.Scripts)
    With g_SetupCfg.Scripts(i)
      strScripts = strScripts & .name & "|"
    End With
  Next
  
  If Right$(strScripts, 1) = "|" Then
    strScripts = Left$(strScripts, Len(strScripts) - 1)
  End If
  
  CSASaveValue c_ini_sec_scripts, _
               c_ini_key_Files, _
               strScripts, _
               iniFile
  
'////////////////////////////////
' REPORTS
'
  For i = 1 To UBound(g_SetupCfg.Reports)
    With g_SetupCfg.Reports(i)
      strReports = strReports & .name & "|"
    End With
  Next
  
  If Right$(strReports, 1) = "|" Then
    strReports = Left$(strReports, Len(strReports) - 1)
  End If
  
  CSASaveValue c_ini_sec_reports, _
               c_ini_key_Files, _
               strReports, _
               iniFile

               
               
'////////////////////////////////
' FILES
'
  For i = 1 To UBound(g_SetupCfg.Files)
    With g_SetupCfg.Files(i)
    
      CSASaveValue .name, _
                   c_ini_key_FileName, _
                   .Filename, _
                   iniFile

      CSASaveValue .name, _
                   c_ini_key_Description, _
                   Replace(.Description, _
                           vbCrLf, "|"), _
                   iniFile

      CSASaveValue .name, _
                   c_ini_key_FolderTarget, _
                   .FolderTarget, _
                   iniFile

      CSASaveValue .name, _
                   c_ini_key_FileVersion, _
                   .FileVersion, _
                   iniFile

      CSASaveValue .name, _
                   c_ini_key_CreateShortCut, _
                   Val(.CreateShortCut), _
                   iniFile

      CSASaveValue .name, _
                   c_ini_key_FolderShortCut, _
                   .FolderShortCut, _
                   iniFile

      CSASaveValue .name, _
                   c_ini_key_Run, _
                   Val(.Run), _
                   iniFile

      CSASaveValue .name, _
                   c_ini_key_DeleteAfterRun, _
                   Val(.DeleteAfterRun), _
                   iniFile
    End With
  Next
  
'////////////////////////////////
' SCRIPTS
'
  For i = 1 To UBound(g_SetupCfg.Scripts)
    With g_SetupCfg.Scripts(i)
          
      CSASaveValue .name, _
                   c_ini_key_FileName, _
                   .Filename, _
                   iniFile

      CSASaveValue .name, _
                   c_ini_key_Description, _
                   Replace(.Description, _
                           vbCrLf, "|"), _
                   iniFile

      CSASaveValue .name, _
                   c_ini_key_DataBases, _
                   .DataBases, _
                   iniFile
    End With
  Next
  
'////////////////////////////////
' REPORTS
'
  For i = 1 To UBound(g_SetupCfg.Reports)
    With g_SetupCfg.Reports(i)
    
      CSASaveValue .name, _
                   c_ini_key_FileName, _
                   .Filename, _
                   iniFile

      CSASaveValue .name, _
                   c_ini_key_Description, _
                   Replace(.Description, _
                           vbCrLf, "|"), _
                   iniFile
    
      CSASaveValue .name, _
                   c_ini_key_AsocToDoc, _
                   CInt(.AsocToDoc), _
                   iniFile
    
      CSASaveValue .name, _
                   c_ini_key_Doct_id, _
                   .doct_id, _
                   iniFile
    
      CSASaveValue .name, _
                   c_ini_key_AsocToTbl, _
                   CInt(.AsocToTbl), _
                   iniFile
    
      CSASaveValue .name, _
                   c_ini_key_tbl_id, _
                   .tbl_id, _
                   iniFile
    End With
  Next
  
  pCreateSetupIni = True
  
  GoTo ExitProc
ControlError:
  MngError Err, "pCreateSetupIni", C_Module, vbNullString
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

' construccion - destruccion
Private Sub Class_Terminate()
  Set m_cZ = Nothing
End Sub
