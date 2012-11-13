VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cUtil"
Attribute VB_GlobalNameSpace = True
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

'--------------------------------------------------------------------------------
' cUtil
' 28-07-2003

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32

    ' constantes
    Private Const ERROR_PATH_NOT_FOUND = 3&
    Private Const ERROR_BAD_FORMAT = 11&
    Private Const SE_ERR_ACCESSDENIED = 5            '  access denied
    Private Const SE_ERR_ASSOCINCOMPLETE = 27
    Private Const SE_ERR_DDEBUSY = 30
    Private Const SE_ERR_DDEFAIL = 29
    Private Const SE_ERR_DDETIMEOUT = 28
    Private Const SE_ERR_DLLNOTFOUND = 32
    Private Const SE_ERR_FNF = 2                     '  file not found
    Private Const SE_ERR_NOASSOC = 31
    Private Const SE_ERR_OOM = 8                     '  out of memory
    Private Const SE_ERR_PNF = 3                     '  path not found
    Private Const SE_ERR_SHARE = 26
    
    Private Const SYNCHRONIZE = 1048576
    Private Const NORMAL_PRIORITY_CLASS = &H20&
    
    Private Const VK_LWIN = &H5B
    Private Const VK_M = &H4D
    Private Const KEYEVENTF_EXTENDEDKEY = &H1
    Private Const KEYEVENTF_KEYUP = &H2

    ' estructuras
    ' funciones
    Private Declare Function ShellExecute2 Lib "shell32.dll" Alias "ShellExecuteA" (ByVal hwnd As Long, ByVal lpOperation As String, ByVal lpFile As String, ByVal lpParameters As String, ByVal lpDirectory As String, ByVal nShowCmd As Long) As Long
    Private Declare Sub SubSleep Lib "kernel32" Alias "Sleep" (ByVal dwMilliseconds As Long)
    Private Declare Sub keybd_event Lib "user32" (ByVal bVk As Byte, ByVal bScan As Byte, ByVal dwFlags As Long, ByVal dwExtraInfo As Long)

    ' Carpetas especiales
    Public Enum SpecialFolderIDs
        sfidDESKTOP = &H0
        sfidPROGRAMS = &H2
        sfidPERSONAL = &H5
        sfidFAVORITES = &H6
        sfidSTARTUP = &H7
        sfidRECENT = &H8
        sfidSENDTO = &H9
        sfidSTARTMENU = &HB
        sfidDESKTOPDIRECTORY = &H10
        sfidNETHOOD = &H13
        sfidFONTS = &H14
        sfidTEMPLATES = &H15
        sfidCOMMON_STARTMENU = &H16
        sfidCOMMON_PROGRAMS = &H17
        sfidCOMMON_STARTUP = &H18
        sfidCOMMON_DESKTOPDIRECTORY = &H19
        sfidAPPDATA = &H1A
        sfidPRINTHOOD = &H1B
        sfidPROGRAMS_FILES = &H26
        sfidProgramFiles = &H10000
        sfidCommonFiles = &H10001
    End Enum
    
    Private Const NOERROR = 0

    Private Declare Function SHGetSpecialFolderLocation Lib "shell32" (ByVal hwndOwner As Long, ByVal nFolder As SpecialFolderIDs, ByRef pIdl As Long) As Long
    Private Declare Function SHGetPathFromIDListA Lib "shell32" (ByVal pIdl As Long, ByVal pszPath As String) As Long

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cUtil"
' estructuras
' variables privadas
' eventos
' propiedadades publicas
Public Property Let EmailServer(ByVal rhs As String)
  gEmailServer = rhs
End Property
Public Property Let EmailAddress(ByVal rhs As String)
  gEmailAddress = rhs
End Property
Public Property Let EmailPort(ByVal rhs As Long)
  gEmailPort = rhs
End Property
Public Property Let EmailUser(ByVal rhs As String)
  gEmailUser = rhs
End Property
Public Property Let EmailPwd(ByVal rhs As String)
  gEmailPwd = rhs
End Property

Public Property Let EmailErrDescrip(ByVal rhs As String)
  gEmailErrDescrip = rhs
End Property

Public Property Get EmailServer() As String
  EmailServer = gEmailServer
End Property
Public Property Get EmailAddress() As String
  EmailAddress = gEmailAddress
End Property
Public Property Get EmailPort() As Long
  EmailPort = gEmailPort
End Property
Public Property Get EmailUser() As String
  EmailUser = gEmailUser
End Property
Public Property Get EmailPwd() As String
  EmailPwd = gEmailPwd
End Property

Public Property Get ErrorDB() As String
  ErrorDB = gErrorDB
End Property
Public Property Let ErrorDB(ByVal rhs As String)
  gErrorDB = rhs
End Property

' propiedadades friend
' propiedades privadas
' funciones publicas
Public Function ArrayToString(ByVal v As Variant) As String
  ArrayToString = ArrayToString_(v)
End Function
Public Function ExistsFile(ByVal PathYName As String) As Boolean
  ExistsFile = mUtil.ExistsFile_(PathYName)
End Function
Public Property Get GetToken(ByVal Token As String, ByVal Source As String) As String
  GetToken = mUtil.GetToken(Token, Source)
End Property
Public Function GetSepDecimal() As String
  GetSepDecimal = mConfigRegional.GetSepDecimal()
End Function
Public Function GetValidPath(ByVal Path As String) As String
  If Right$(Path, 1) <> "\" Then Path = Path & "\"
  GetValidPath = Path
End Function
Public Sub ShowToolBarButtonEx(ByVal Boton As csButtons, ByRef TBBarra As Object, ByVal Show As Boolean)
  ShowToolBarButtonEx_ Boton, TBBarra, Show
End Sub
Public Sub ShowToolBarButton(ByVal Boton As csButtons, ByRef TBBarra As Object, ByVal Show As Boolean)
  ShowToolBarButton_ Boton, TBBarra, Show
End Sub
Public Sub SetToolBar(ByRef TBBarra As Object, ByVal Botones1 As Long, Optional ByVal Botones2 As Long = 0, Optional ByVal Botones3 As Long = 0)
    SetToolBar_ TBBarra, Botones1, Botones2, Botones3
End Sub
Public Sub SetToolBar24(ByRef TBBarra As Object, ByVal Botones1 As Long, Optional ByVal Botones2 As Long = 0, Optional ByVal Botones3 As Long = 0, Optional ByVal bShowNames As Boolean, Optional ByVal bIsDoc As Boolean)
    SetToolBar24_ TBBarra, Botones1, Botones2, Botones3, bShowNames, bIsDoc
End Sub
Public Sub SetToolBar16(ByRef TBBarra As Object, ByVal Botones1 As Long, Optional ByVal Botones2 As Long = 0, Optional ByVal Botones3 As Long = 0, Optional ByVal bShowNames As Boolean, Optional ByVal bIsDoc As Boolean)
    SetToolBar16_ TBBarra, Botones1, Botones2, Botones3, bShowNames, bIsDoc
End Sub
Public Sub SetToolBarEx(ByRef TBBarra As Object, ByVal Botones1 As Long, Optional ByVal Botones2 As Long = 0, Optional ByVal Botones3 As Long = 0)
    SetToolBarEx_ TBBarra, Botones1, Botones2, Botones3
End Sub
Public Function PresButtonToolbarEx(ByVal sKeyButton As String, ByRef f As Object, Optional NameFunction As String = "TBBarra_ButtonClick") As Boolean
    PresButtonToolbarEx = PresButtonToolbarEx_(sKeyButton, f, NameFunction)
End Function
Public Function PresButtonToolbar(ByVal sKeyButton As String, ByRef f As Object, Optional NameFunction As String = "TBBarra_ButtonClick") As Boolean
    PresButtonToolbar = PresButtonToolbar_(sKeyButton, f, NameFunction)
End Function
'--------------------------------------------------------------------------------------------------------------------
Public Sub SetRegistry(ByVal Seccion As csSeccionSetting, ByVal Clave As String, ByVal Value As String)
    SetRegistry_ Seccion, Clave, Value
End Sub
Public Function GetRegistry(ByVal Seccion As csSeccionSetting, ByVal Clave As String, ByVal default As String) As String
    GetRegistry = GetRegistry_(Seccion, Clave, default)
End Function
'--------------------------------------------------------------------------------------------------------------------
Public Function ValEmpty(ByVal Value As Variant, ByVal VarType As csTypes) As Boolean
    On Error Resume Next

    ValEmpty = ValEmpty_(Value, VarType)
End Function
Public Function ShowAbout(ByVal APP_NAME As String, ByVal aApp As Object)
  Dim msg As String
  
  Dim CompanyName       As String
  Dim FileDescription   As String
  Dim LegalCopyright    As String
  Dim LegalTrademarks   As String
  
  If aApp.CompanyName = "" Then
    CompanyName = aApp.CompanyName
  Else
    CompanyName = App.CompanyName
  End If
  
  If aApp.FileDescription = "" Then
    FileDescription = aApp.FileDescription
  Else
    FileDescription = App.FileDescription
  End If
  
  If aApp.LegalCopyright = "" Then
    LegalCopyright = aApp.LegalCopyright
  Else
    LegalCopyright = App.LegalCopyright
  End If
  
  If aApp.LegalTrademarks = "" Then
    LegalTrademarks = aApp.LegalTrademarks
  Else
    LegalTrademarks = App.LegalTrademarks
  End If
  
  msg = CompanyName & vbCrLf
  msg = msg & APP_NAME & " " & App.Major & "." & App.Minor & "." & App.Revision & vbCrLf
  msg = msg & App.FileDescription & vbCrLf
  msg = msg & App.LegalCopyright & vbCrLf
  msg = msg & App.LegalTrademarks
  
  MsgBox msg, vbInformation
End Function
Public Sub ListAdd(ByRef List As Object, ByVal Value As String, Optional ByVal Id As Variant)
    If Not IsMissing(Id) Then
        ListAdd_ List, Value, Id
    Else
        ListAdd_ List, Value
    End If
End Sub
Public Function ListID(ByVal List As Object) As Long
    ListID = ListID_(List)
End Function
Public Function ListItemData(ByVal List As Object, Optional ByVal Index As Integer = -1)
    ListItemData = ListItemData_(List, Index)
End Function
Public Sub ListSetListIndex(ByRef List As Object, Optional ByVal idx As Integer = 0)
    ListSetListIndex_ List, idx
End Sub
Public Sub ListSetListIndexForId(ByRef List As Object, ByVal Id As Long)
    ListSetListIndexForId_ List, Id
End Sub
Public Sub ListSetListIndexForText(ByRef List As Object, ByVal Text As String)
    ListSetListIndexForText_ List, Text
End Sub
Public Sub ListChangeTextForSelected(ByRef List As Object, ByVal Value As String)
    ListChangeTextForSelected_ List, Value
End Sub
Public Sub ListChangeText(ByRef List As Object, ByVal idx As Long, ByVal Value As String)
    ListChangeText_ List, idx, Value
End Sub
Public Function ListGetIndexFromItemData(ByVal List As Object, ByVal ValueItemData As Long) As Integer
    ListGetIndexFromItemData = ListGetIndexFromItemData_(List, ValueItemData)
End Function
'--------------------------------------------------------------------------------------------------------------------
Public Sub SetNodeForId(ByRef Tree As Object, ByVal Id As Long)
    SetNodeForId_ Tree, Id
End Sub
'--------------------------------------------------------------------------------------------------------------------
Public Function GetPropertyFromParent(ByRef retValue As Variant, ByVal o As Object, ByVal propiedad As String) As Boolean
    GetPropertyFromParent = GetPropertyFromParent_(retValue, o, propiedad)
End Function
Public Function GetWindowState(ByRef retValue As Variant, ByVal o As Object) As Boolean
    GetWindowState = GetWindowState_(retValue, o)
End Function
'--------------------------------------------------------------------------------------------------------------------
Public Function SetInfoString(ByVal Fuente As String, ByVal Clave As String, ByVal Value As String) As String
    SetInfoString = SetInfoString_(Fuente, Clave, Value)
End Function
Public Function GetInfoString(ByVal Fuente As String, ByVal Clave As String, Optional ByVal default As String = "") As String
    GetInfoString = GetInfoString_(Fuente, Clave, default)
End Function
'--------------------------------------------------------------------------------------------------------------------
Public Function GetInput(ByRef Value As Variant, Optional ByVal Descrip As String = "") As Boolean
  GetInput = GetInput_(Value, Descrip)
End Function
Public Function GetInputEx(ByRef Value As String, Optional ByVal Descrip As String) As Boolean
  GetInputEx = GetInputEx_(Value, Descrip)
End Function
Public Function RemoveLastColon(ByVal List As String) As String
    RemoveLastColon = RemoveLastColon_(List)
End Function

Public Sub Sleep(ByVal dwMilliseconds As Long)
  SubSleep dwMilliseconds
End Sub

Public Sub EditFile(ByVal strFile As String, ByVal hwnd As Long)
  Dim Hresult As Long
  
  
  Hresult = ShellExecute2(hwnd, "open", strFile + Chr(0), 0, strFile + Chr(0), SW_SHOWNORMAL)
  
  Select Case Hresult
    Case ERROR_PATH_NOT_FOUND '= 3&
        MsgBox "La ruta de acceso no se encuentra"
    Case ERROR_BAD_FORMAT '= 11&
        MsgBox "Formato no reconocido"
    Case SE_ERR_ACCESSDENIED '= 5 '  access denied
        MsgBox "Error a intentar acceder al archivo. Acceso Denegado."
    Case SE_ERR_ASSOCINCOMPLETE '= 27
        MsgBox "Acceso Incompleto"
    Case SE_ERR_DDEBUSY '= 30
        
    Case SE_ERR_DDEFAIL '= 29
        MsgBox "Falla al intentar editar el archivo"
    Case SE_ERR_DDETIMEOUT '= 28
        
    Case SE_ERR_DLLNOTFOUND '= 32
        MsgBox "El archivo no se encuentra"
    Case SE_ERR_FNF '= 2                     '  file not found
        MsgBox "Archivo no encontrado"
    Case SE_ERR_NOASSOC '= 31
    Case SE_ERR_OOM '= 8                     '  out of memory
        MsgBox "Error de Memoria "
    Case SE_ERR_PNF '= 3                     '  path not found
        MsgBox "La ruta de acceso no se encuentra"
    Case SE_ERR_SHARE '= 26
        
  End Select
End Sub

Public Function CreateObject(ByVal Class As String) As Object
  On Error GoTo ControlError
  Set CreateObject = Interaction.CreateObject(Class)
  Exit Function
ControlError:
  Err.Raise Err.Number, Err.Source, "No se pudo crear el objeto " & Class & ".\nError Original: " & Err.Description, Err.HelpFile, Err.HelpContext
End Function

Public Sub ExecuteCalc()
  Dim pInfo As PROCESS_INFORMATION
  Dim sInfo As STARTUPINFO
  Dim sNull As String
  Dim lSuccess As Long
  Dim lRetValue As Long

  sInfo.cb = Len(sInfo)
  lSuccess = CreateProcess(sNull, _
                          "Calc.exe", _
                          ByVal 0&, _
                          ByVal 0&, _
                          1&, _
                          NORMAL_PRIORITY_CLASS, _
                          ByVal 0&, _
                          sNull, _
                          sInfo, _
                          pInfo)

  lRetValue = CloseHandle(pInfo.hThread)
  lRetValue = CloseHandle(pInfo.hProcess)
End Sub

Public Sub ExecuteExplorer()
  Dim pInfo As PROCESS_INFORMATION
  Dim sInfo As STARTUPINFO
  Dim sNull As String
  Dim lSuccess As Long
  Dim lRetValue As Long

  sInfo.cb = Len(sInfo)
  lSuccess = CreateProcess(sNull, _
                          "explorer.exe", _
                          ByVal 0&, _
                          ByVal 0&, _
                          1&, _
                          NORMAL_PRIORITY_CLASS, _
                          ByVal 0&, _
                          sNull, _
                          sInfo, _
                          pInfo)

  lRetValue = CloseHandle(pInfo.hThread)
  lRetValue = CloseHandle(pInfo.hProcess)
End Sub

Public Function ShellExecute(ByVal shelstmt As String, _
                             ByVal TypeFocus As VbAppWinStyle, _
                             Optional ByVal bWait As Boolean) As Boolean
  
  ShellExecute = mShell.ShellExecute(shelstmt, TypeFocus, bWait)
End Function

Public Function StartWord() As Boolean
   Dim wrdTmp As Object
   On Error Resume Next
   
   Set wrdTmp = GetObject(, "Word.Application")
   If Err.Number <> 0 Then
       'Using New here would work just the
       'same as using CreateObject, but I wanted
       'it to be parallel for the other function.
       Set wrdTmp = CreateObject("Word.Application")
   End If
   
  wrdTmp.Documents.Add
  wrdTmp.Visible = True
   
  StartWord = Err.Number = 0
End Function

Public Function StartExcel() As Boolean
   Dim excelTmp As Object
   On Error Resume Next
   
   Set excelTmp = GetObject(, "Excel.Application")
   If Err.Number <> 0 Then
       'Using New here would work just the
       'same as using CreateObject, but I wanted
       'it to be parallel for the other function.
       Set excelTmp = CreateObject("Excel.Application")
   End If
   
  excelTmp.Workbooks.Add
  excelTmp.Visible = True
   
  StartExcel = Err.Number = 0
End Function

Public Sub StartIExplorer()
  
  'Internet-Explorer starten und Homepage aufrufen
  Dim IeAppli As Object
  Dim DoM As Object
  Set IeAppli = CreateObject("InternetExplorer.Application")
  
  IeAppli.Visible = True
End Sub

Public Sub ShowDesktop()
  '// Simulate a key press // or 0x5B
  keybd_event VK_LWIN, _
  &H45, _
  KEYEVENTF_EXTENDEDKEY, _
  0
  
  '// or 0x5B
  keybd_event VK_M, _
  &H45, _
  KEYEVENTF_EXTENDEDKEY, _
  0
  
  keybd_event VK_M, _
  &H45, _
  KEYEVENTF_EXTENDEDKEY Or KEYEVENTF_KEYUP, _
  0
  
  '// Simulate a key release
  keybd_event VK_LWIN, _
  &H45, _
  KEYEVENTF_EXTENDEDKEY Or KEYEVENTF_KEYUP, _
  0
End Sub

Public Function DivideByCero(ByVal x1 As Double, ByVal x2 As Double) As Double
  If x2 <> 0 Then
    DivideByCero = x1 / x2
  Else
    DivideByCero = 0
  End If
End Function

Public Sub SetFocusControl(ByRef Ctl As Object)
  On Error Resume Next
  Ctl.SetFocus
  DoEvents: DoEvents: DoEvents
End Sub

Public Function GetComputerName() As String
  GetComputerName = mUtil.GetComputerName
End Function

Public Sub ShowHelp(ByVal hwnd As Long, _
                    ByVal HelpFileFullName As String, _
                    ByVal HelpFile As String, _
                    ByVal ContextId As Long)
  ShowHelp_ hwnd, HelpFileFullName, HelpFile, ContextId
End Sub

Public Sub SendEmailToCrowSoft(ByVal Subject As String, _
                               ByVal Body As String)
  Dim Text As String
  
  If Not GetInputEx(Text, "Ingrese su sugerencia") Then Exit Sub
                                 
  Body = Text & vbCrLf & vbCrLf & _
         Body & vbCrLf & vbCrLf & _
         "Enviado por " & gEmailErrDescrip

  SendEmailToCrowSoft_ Subject, Body
End Sub

Public Function GetEspecialFolders(ByVal nFolder As SpecialFolderIDs) As String
  Dim sPath   As String
  Dim strPath As String
  Dim lngPos  As Long
  Dim IDL     As Long
  
  ' Fill the item id list with the pointer of each folder item, rtns 0 on success
  If SHGetSpecialFolderLocation(0, nFolder, IDL) = NOERROR Then
      sPath = String$(255, 0)
      SHGetPathFromIDListA IDL, sPath

      lngPos = InStr(sPath, Chr(0))
      If lngPos > 0 Then
          strPath = Left$(sPath, lngPos - 1)
      End If
  End If
  
  GetEspecialFolders = strPath
End Function

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


