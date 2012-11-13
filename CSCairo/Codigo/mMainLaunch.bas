Attribute VB_Name = "mMain"
Option Explicit

Private Declare Function GetComputerName2 Lib "kernel32" Alias "GetComputerNameA" (ByVal lpBuffer As String, nSize As Long) As Long

Public Sub Main()
  On Error Resume Next
  
  If pRegistryActivex() Then

    ShellExecute GetValidPath(pGetAppPath) & "CSCairoSrv.exe " & Command$, vbNormalFocus, False
    'ShellExecute GetValidPath(pGetAppPath) & "CSCairoSmall.exe", vbNormalFocus, False
    'ShellExecute GetValidPath(pGetAppPath) & "CSCairoSmall2.exe", vbNormalFocus, False
  
  End If
  
  Unload fProgress

  Err.Clear
  
  End
  
End Sub

Public Sub MngError(ByRef Err As Object, ByVal FunctionName As String, ByVal Module As String, ByVal dummy As String)
  MsgBox Err.Description
End Sub

Private Function pRegistryActivex() As Boolean
  Const c_startIni = "CairoStart.ini"
  Const c_configSection = "CONFIG"
  Const c_serverPath = "serverPath"
  
  Dim iniFile As String
  Dim serverPath As String
  
  ' Leo cual es el server
  '
  iniFile = GetValidPath(pGetAppPath) & c_startIni
  serverPath = GetIniValue(c_configSection, c_serverPath, "", iniFile)
  
  If serverPath = "" Then
    MsgBox "Debe indicar la ruta al server en el archivo CairoStart.ini", vbCritical, "CrowSoft Cairo"
    Exit Function
  End If
  
  Const c_clientesini = "Cliente.ini"
  Const c_clientessection = "CLIENTES"
  Const c_InstalApp = "CSInstall.exe"
  
  Dim ComputerName As String
  
  ComputerName = GetComputerName()

  If LCase$(serverPath) <> "{remoto}" Then
    iniFile = GetValidPath(serverPath) & c_clientesini
  Else
    iniFile = GetValidPath(pGetAppPath()) & c_clientesini
  End If
  
  'MsgBox "iniFile = " & iniFile
  'MsgBox "serverPath = " & serverPath
  'MsgBox "pGetAppPath = " & pGetAppPath()

  ' Si no estoy en server
  '
  If Val(GetIniValue(c_clientessection, ComputerName, 0, iniFile)) = 0 Then
  
    fProgress.Show
  
    ' Copio los archivos desde el server
    '
    If Not pCopyFiles(serverPath) Then Exit Function
    
    fProgress.lbFile.Visible = False
    fProgress.lbTask.Caption = "Registrando componentes ..."
    fProgress.lbTask.Left = 0
    fProgress.lbTask.Width = fProgress.ScaleWidth
    fProgress.lbTask.Alignment = 2
    
    
    ' Registro los componentes
    '
    If Not ShellExecute(GetValidPath(pGetAppPath) & c_InstalApp, vbNormalFocus, True) Then Exit Function
    
    ' Registro en el ini que estoy actualizado
    '
    SaveIniValue c_clientessection, ComputerName, 1, iniFile
  End If
  
  pRegistryActivex = True
End Function

Private Function GetComputerName() As String
  Dim s As String
  s = String(255, " ")
  Dim l As Long
  l = Len(s)

  If GetComputerName2(s, l) <> 0 Then
    GetComputerName = Mid(s, 1, l)
  Else
    GetComputerName = ""
  End If
End Function

Private Function GetValidPath(ByVal path As String) As String
  If Right$(path, 1) <> "\" Then path = path & "\"
  GetValidPath = path
End Function

Public Function GetFileName(ByVal path As String) As String
  Dim i As Long
  For i = Len(path) To 1 Step -1
    If Mid$(path, i, 1) = "\" Then
      GetFileName = Mid$(path, i + 1)
      Exit Function
    End If
  Next
End Function

Private Function pCopyFiles(ByVal serverPath As String) As Boolean
  Dim File As String
  Dim appPath As String
    
  If LCase$(serverPath) <> "{remoto}" Then
  
    fProgress.lbTask.Visible = True
    fProgress.lbFile.Visible = True
  
    appPath = GetValidPath(pGetAppPath)
    serverPath = GetValidPath(serverPath)
    
    File = Dir(serverPath & "*.exe")
    While File <> ""
    
      If LCase$(File) <> "cairo.exe" Then
    
        fProgress.lbFile.Caption = serverPath & File
        DoEvents
        pFileCopy serverPath & File, appPath & File
        
      End If
      
      File = Dir()
    Wend
    
    File = Dir(serverPath & "*.dll")
    While File <> ""
      fProgress.lbFile.Caption = serverPath & File
      DoEvents
      If Not pFileCopy(serverPath & File, appPath & File) Then
        If Mid$(File, 1, 2) = "CS" Then
          MsgBox "No se puede copiar el archivo " & File, vbCritical, "CrowSoft Cairo"
          Exit Function
        End If
      End If
      File = Dir()
    Wend
    
    File = Dir(serverPath & "*.ocx")
    While File <> ""
      fProgress.lbFile.Caption = serverPath & File
      DoEvents
      If Not pFileCopy(serverPath & File, appPath & File) Then
        If Mid$(File, 1, 2) = "CS" Then
          MsgBox "No se puede copiar el archivo " & File, vbCritical, "CrowSoft Cairo"
          Exit Function
        End If
      End If
      File = Dir()
    Wend
    
    File = Dir(serverPath & "*.ini")
    While File <> ""
    
      If LCase$(File) <> "cairostart.ini" Then
      
        fProgress.lbFile.Caption = serverPath & File
        DoEvents
        pFileCopy serverPath & File, appPath & File
        
      End If
      
      File = Dir()
    Wend
    
    File = Dir(serverPath & "*.csd")
    While File <> ""
          
      fProgress.lbFile.Caption = serverPath & File
      DoEvents
      pFileCopy serverPath & File, appPath & File
      
      File = Dir()
    Wend
    
    File = Dir(serverPath & "*.csr")
    While File <> ""
          
      fProgress.lbFile.Caption = serverPath & File
      DoEvents
      pFileCopy serverPath & File, appPath & File
      
      File = Dir()
    Wend
    
    ' Reportes
    '
    
    serverPath = serverPath & "reportes\"
    appPath = appPath & "reportes\"
    
    pCreateFolder appPath
    
    File = Dir(serverPath & "*.csr")
    While File <> ""
      
      fProgress.lbFile.Caption = serverPath & File
      DoEvents
      pFileCopy serverPath & File, appPath & File
      File = Dir()
    
    Wend
  
  End If
  
  pCopyFiles = True
End Function

Private Sub pCreateFolder(ByVal path As String)
  On Error Resume Next
  MkDir path
  Err.Clear
End Sub

Private Function pFileCopy(ByVal source As String, ByVal destination As String) As Boolean
  On Error Resume Next
  Err.Clear
  FileCopy source, destination
  pFileCopy = Err.Number = 0
End Function

Private Function pGetAppPath() As String
  If inIDE() Then
    pGetAppPath = GetValidPath(App.path) & "test-launch"
  Else
    pGetAppPath = App.path
  End If
End Function
