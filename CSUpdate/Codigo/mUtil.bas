Attribute VB_Name = "mUtil"
Option Explicit

'--------------------------------------------------------------------------------
' mUtil
' 01-05-2006

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    Private Const HWND_TOPMOST = -1
    Private Const HWND_NOTOPMOST = -2
    Private Const SWP_NOACTIVATE = &H10
    Private Const SWP_SHOWWINDOW = &H40
    
    Private Const SW_SHOWNORMAL = 1
    Private Const INFINITE = &HFFFF
    
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
    
    Public Const NOERROR = 0
    
    Private Const OF_EXIST = &H4000
    
    'OFSTRUCT structure used by the OpenFile API function
    Private Type OFSTRUCT            '136 bytes in length
      cBytes As String * 1
      fFixedDisk As String * 1
      nErrCode As Integer
      reserved As String * 4
      szPathName As String * 128
    End Type
    
    
    ' estructuras
    ' Funciones
    Private Declare Function OpenFile Lib "kernel32" (ByVal lpFileName As String, lpReOpenBuff As OFSTRUCT, ByVal wStyle As Long) As Long
    
    Private Declare Function SetWindowPos Lib "user32" _
                                                  (ByVal hwnd As Long, _
                                                  ByVal hWndInsertAfter As Long, _
                                                  ByVal x As Long, _
                                                  ByVal y As Long, _
                                                  ByVal cx As Long, _
                                                  ByVal cy As Long, _
                                                  ByVal wFlags As Long) As Long

    Private Declare Function ShellExecute2 Lib "shell32.dll" Alias "ShellExecuteA" (ByVal hwnd As Long, ByVal lpOperation As String, ByVal lpFile As String, ByVal lpParameters As String, ByVal lpDirectory As String, ByVal nShowCmd As Long) As Long
'--------------------------------------------------------------------------------

Public Const gstrSEP_DIR$ = "\"                         ' Directory separator character
Public Const gstrSEP_DIRALT$ = "/"                      ' Alternate directory separator character

Public Enum csErrores
    csErrorUserInvalido = vbObjectError + 1
    csErrorSepDecimal = vbObjectError + 2
    csErrorSepDecimalConfig = vbObjectError + 3
    csErrorFieldnTypeInvalido = vbObjectError + 4
    csErrorVal = vbObjectError + 5
    csErrorSetInfoString = vbObjectError + 6
    csErrorABMLoadControl = vbObjectError + 7
    csErrorUsoPropIdEnPermission = vbObjectError + 8
    csErrorUsoSubClearEnPermissions = vbObjectError + 9
    csErrorUsoSubRemoveEnPermissions = vbObjectError + 10
    csErrorUsoPropIdEnRol = vbObjectError + 11
    csErrorUsoSubClearEnUsuarioRol = vbObjectError + 12
    csErrorUsoSubRemoveEnUsuarioRol = vbObjectError + 13
    csErrorABMLoadControlSubTypeNotDefined = vbObjectError + 14
    csErrorInvalidPropertyValue = vbObjectError + 15
End Enum

Public Enum csSeccionSetting
  CSConfig
  csInterface
  csLogin
End Enum

Private Const c_CRLF = "@;"
Private Const c_CRLF2 = ";"

Public Const csNO_ID                            As Long = 0
Public Const csNoDate                           As Date = #1/1/1900#
Public Const C_PSqlFechaHora                    As String = "\'yyyymmdd HH:nn:ss\'"   'MS SQLServer

Public Const c_Title = "CSUpdate"

Public gAppName           As String

Public Sub MsgError(ByVal msg As String, Optional ByVal Title As String = "@@@@@")
  If Title = "@@@@@" Then Title = c_Title
  MsgError_ msg, Title
End Sub
Public Sub MsgWarning(ByVal msg As String, Optional ByVal Title As String = "@@@@@")
  If Title = "@@@@@" Then Title = c_Title
  MsgWarning_ msg, Title
End Sub
Public Function Ask(ByVal msg As String, ByVal default As VbMsgBoxResult, Optional ByVal Title As String = "@@@@@") As Boolean
  If Title = "@@@@@" Then Title = c_Title
  Ask = Ask_(msg, default, Title)
End Function
Public Function MsgInfo(ByVal msg As String, Optional ByVal Title As String = "@@@@@")
  If Title = "@@@@@" Then Title = c_Title
  MsgInfo_ msg, Title
End Function

Public Sub MsgWarning_(ByVal msg As String, _
                       Optional ByVal Title As String = "@@@@@")
  pMsgAux msg, vbExclamation, Title
End Sub

Public Sub MsgError_(ByVal msg As String, _
                     Optional ByVal Title As String = "@@@@@")
  pMsgAux msg, vbCritical, Title
End Sub

Public Function Ask_(ByVal msg As String, ByVal default As VbMsgBoxResult, Optional ByVal Title As String) As Boolean
  Dim n As Integer
  msg = pGetMessage(msg)
  If InStr(1, msg, "?") = 0 Then msg = "¿" & msg & "?"
  If default = vbNo Then n = vbDefaultButton2
  pGetTitle Title
  Ask_ = vbYes = MsgBox(msg, vbYesNo + n + vbQuestion, Title)
End Function

Public Function MsgInfo_(ByVal msg As String, Optional ByVal Title As String = "@@@@@")
  pMsgAux msg, vbInformation, Title
End Function

Public Sub AlwaysOnTop(myfrm As Object, SetOnTop As Boolean)
  On Error Resume Next
    Dim lFlag As Integer
    
    If SetOnTop Then
        lFlag = HWND_TOPMOST
    Else
        lFlag = HWND_NOTOPMOST
    End If

    SetWindowPos myfrm.hwnd, lFlag, _
    myfrm.Left / Screen.TwipsPerPixelX, _
    myfrm.Top / Screen.TwipsPerPixelY, _
    myfrm.Width / Screen.TwipsPerPixelX, _
    myfrm.Height / Screen.TwipsPerPixelY, _
    SWP_NOACTIVATE Or SWP_SHOWWINDOW
End Sub

#If Not PREPROC_CSUPDATEEX Then
  
  Public Function GetDataBase() As cDataBase
    Dim db        As cDataBase
    Dim Connstr   As String
    Dim ErrorMsg  As String
    
    If Not GetConnstrToDomain(Connstr, ErrorMsg) Then
      MsgWarning ErrorMsg, "Empresas"
    End If
  
    Set db = New cDataBase
    If Not db.InitDB(, , , , Connstr) Then Exit Function
  
    Set GetDataBase = db
  End Function
  
  Public Function GetActiveCode(ByRef strCode As String) As Boolean
    Dim sqlstmt   As String
    Dim db        As cDataBase
    Dim Connstr   As String
    Dim ErrorMsg  As String
    Dim rs        As ADODB.Recordset
  
    If Not GetConnstrToDomain(Connstr, ErrorMsg) Then
      MsgWarning ErrorMsg, "Código de Activación"
      Exit Function
    Else
      Set db = New cDataBase
      
      If Not db.InitDB(, , , , Connstr) Then Exit Function
      sqlstmt = "select si_valor from sistema where si_clave = " & db.sqlString(c_CodigoActivacion)
      
      If Not db.OpenRs(sqlstmt, rs) Then Exit Function
      
      If rs.EOF Then Exit Function
        
      strCode = rs.fields.Item(0).Value
    End If
    
    GetActiveCode = True
  End Function
  
  Public Function GetConnstrToDomain(ByRef strConnect As String, ByRef ErrorMsg As String) As Boolean
    Dim Buffer        As String
    Dim Message       As String
    Dim DataReceived  As String
    
    Buffer = TCPGetMessage(cTCPCommandGetConnectStrDom2, ClientProcessId, Message)
    If Not fMain.Client.SendAndReciveText(Buffer, SRV_ID_SERVER) Then Exit Function
    
    DataReceived = fMain.Client.DataReceived
    
    If TCPError(DataReceived) Then
      MsgError GetErrorMessage(DataReceived)
      Exit Function
    End If
    
    Buffer = TCPGetResponse(DataReceived)
    If TCPGetFail(DataReceived) Then
      ErrorMsg = Buffer
      Exit Function
    End If
    
    strConnect = Decrypt(Buffer, c_LoginSignature)
    
    GetConnstrToDomain = True
  End Function

#End If

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

Public Function GetErrorMessage(ByVal DataReceived As String) As String
  GetErrorMessage = "Ha ocurrido un error al intentar conectarse con el servidor.;;Descripción técnica: " & TCPGetResponse(DataReceived)
End Function

Public Function RemoveLastColon(ByVal List As String) As String
  List = Trim(List)
  If Right(List, 1) = "," Then
    RemoveLastColon = Mid(List, 1, Len(List) - 1)
  Else
    RemoveLastColon = List
  End If
End Function

Public Sub LoadForm(ByRef F As Object, ByVal name As String)
    Load F
    GetConfigForm F, name
End Sub

Public Sub UnloadForm(ByRef F As Object, ByVal name As String, Optional YesUnload As Boolean = False)
    SaveConfigForm F, name
    If YesUnload Then Unload F
End Sub

Public Sub CenterForm(ByRef frm As Object, Optional ByVal fMain As Object)
  frm.Left = (Screen.Width - frm.Width) * 0.5
  frm.Top = (Screen.Height - frm.Height) * 0.5
End Sub

'---------------
' Propiedades de los forms
Public Sub GetConfigForm(ByRef F As Object, ByVal name As String)
  On Error Resume Next
  Dim bExistsInRegistry As Boolean
  
  bExistsInRegistry = Val(GetRegistry_(csInterface, name + "_EXISTS", 0))

  If Not bExistsInRegistry Then
    F.Left = (Screen.Width - F.Width) / 2
    F.Top = (Screen.Height - F.Height) / 2
    Exit Sub
  End If
  
  F.WindowState = GetRegistry_(csInterface, name + "_WINDOW_STATE", vbNormal)
  
  If F.WindowState = vbNormal Then
  
    If pIsSizable(F) Then
      Dim Width     As Long
      Dim Height    As Long
      
      Width = GetRegistry_(csInterface, name + "_WIDTH", F.Width)
      Height = GetRegistry_(csInterface, name + "_HEIGHT", F.Height)
      If Width > 1000 Then F.Width = Width
      If Height > 1000 Then F.Height = Height
    End If
    
    If UCase(F.name) <> "FHELP" And UCase(F.name) <> "FHELPTREE" Then
      
      F.Left = GetRegistry_(csInterface, name + "_LEFT", F.Left)
      F.Top = GetRegistry_(csInterface, name + "_TOP", F.Top)
      
      If F.Left < 0 Then F.Left = 0
      If F.Top < 0 Then F.Top = 0
    
    Else
      If F.Left + F.Width > Screen.Width Then F.Left = Screen.Width - F.Width - 50
                                          ' Estimativo para el alto de la barra inicio
                                          ' esperando claro esta que el usuario la ponga
                                          ' en la parte inferior de la pantalla
      If F.Top + F.Height > Screen.Height - 500 Then F.Top = F.Top - F.Height - 285
      If F.Top < 0 Then F.Top = 0
      If F.Left < 0 Then F.Left = 0
    End If
  End If
End Sub

Public Sub SaveConfigForm(ByRef F As Object, ByVal name As String)
  If F.WindowState = vbMinimized Then Exit Sub
  SetRegistry_ csInterface, name + "_EXISTS", -1
  SetRegistry_ csInterface, name + "_WINDOW_STATE", F.WindowState
  If F.WindowState = vbNormal Then
    SetRegistry_ csInterface, name + "_LEFT", F.Left
    SetRegistry_ csInterface, name + "_TOP", F.Top
    If F.Width > 1000 Then SetRegistry_ csInterface, name + "_WIDTH", F.Width
    If F.Height > 1000 Then SetRegistry_ csInterface, name + "_HEIGHT", F.Height
  End If
  If LCase(F.name) = LCase("flistdoc") Then
    SetRegistry_ csInterface, name + "_HIDEPARAMETERS", CInt(Not F.cListDoc1.ParamVisible)
  End If
End Sub

'-- configuraciones en el registry
Public Function GetRegistry_(ByVal Seccion As csSeccionSetting, ByVal key As String, ByVal default As String) As String
    Dim sSeccion As String
    Select Case Seccion
        Case CSConfig
            sSeccion = "CONFIG"
        Case csInterface
            sSeccion = "INTERFACE"
        Case csLogin
            sSeccion = "LOGIN"
    End Select
    GetRegistry_ = GetSetting(gAppName, sSeccion, key, default)
End Function

Public Sub SetRegistry_(ByVal Seccion As csSeccionSetting, ByVal key As String, ByVal Value As String)
    Dim sSeccion As String
    Select Case Seccion
        Case CSConfig
            sSeccion = "CONFIG"
        Case csInterface
            sSeccion = "INTERFACE"
        Case csLogin
            sSeccion = "LOGIN"
    End Select
    On Error Resume Next
    SaveSetting gAppName, sSeccion, key, Value
End Sub

'
'-- InfoString
'
Public Function SetInfoString(ByVal source As String, ByVal key As String, ByVal Value As String) As String
    SetInfoString = SetInfoString_(source, key, Value)
End Function
Public Function GetInfoString(ByVal source As String, ByVal key As String, Optional ByVal default As String = "") As String
    GetInfoString = GetInfoString_(source, key, default)
End Function
    
    Public Function SetInfoString_(ByVal source As String, ByVal key As String, ByVal Value As String) As String
        Dim i As Integer
        Dim j As Integer
        Dim k As Integer

        key = "#" & key
        i = InStr(1, source, key, vbTextCompare)
        ' la Key no puede estar repetida
        If InStr(i + 1, source, key, vbTextCompare) <> 0 Then Err.Raise csErrorSetInfoString, "CSOAPI", "SetInfoString_: Se intento Save un Value de Password en una cadena invalida, la Password esta repetida."

        ' si aun no existe la agrego al final
        If i = 0 Then
            SetInfoString_ = source + key + "=" + Value + ";"
        Else

            j = InStr(i, source, ";", vbTextCompare)
            If j = 0 Then Err.Raise csErrorSetInfoString, "CSOAPI", "SetInfoString_: Se intento Save un Value de Password en una cadena invalida, la cadena esta corrupta, falta el signo ;."

            k = InStr(1, Mid(source, i, j), "=", vbTextCompare)
            If k = 0 Then Err.Raise csErrorSetInfoString, "CSOAPI", "SetInfoString_: Se intento Save un Value de Password en una cadena invalida, la cadena esta corrupta, falta el signo =."
            k = k + i - 1
            SetInfoString_ = Mid(source, 1, k) + Value + Mid(source, j)
        End If
    End Function

    Public Function GetInfoString_(ByVal source As String, ByVal key As String, Optional ByVal default As String = vbNullString) As String
        Dim i As Integer
        Dim j As Integer
        Dim k As Integer

        key = "#" & key

        i = InStr(1, source, key, vbTextCompare)
        ' la Key no puede estar repetida
        If InStr(i + 1, source, key, vbTextCompare) <> 0 Then Err.Raise csErrorSetInfoString, "CSOAPI", "GetInfoString_: Se intento obtener un Value de una cadena invalida, la Password esta repetida."

        ' si la Key no existe devuelvo el default
        If i = 0 Then
            GetInfoString_ = default
        Else

            Const c_errorstr = "GetInfoString_: Se intento obtener un valor de una cadena invalida, la cadena esta corrupta, falta el signo "

            j = InStr(i, source, ";", vbTextCompare)
            If j = 0 Then Err.Raise csErrorSetInfoString, "CSOAPI", c_errorstr & ";."

            k = InStr(1, Mid(source, i, j), "=", vbTextCompare)
            If k = 0 Then Err.Raise csErrorSetInfoString, "CSOAPI", c_errorstr & "=."
            k = k + i - 1
            GetInfoString_ = Mid(source, k + 1, j - k - 1)
        End If
    End Function

'------------
Public Function FileExists(ByVal TestFile As String) As Boolean
  On Error GoTo ControlError
  
  Dim wStyle As Integer
  Dim Buffer As OFSTRUCT
  
  If OpenFile(TestFile, Buffer, OF_EXIST) < 0 Then Exit Function
  
  FileExists = True
  
  Exit Function
ControlError:
End Function

Public Function GetPath(ByVal FullPath As String) As String
  GetPath = GetPath_(FullPath)
End Function

Public Function GetFileName(ByVal FullPath As String) As String
  GetFileName = GetFileName_(FullPath)
End Function

Public Function GetPath_(ByVal FullPath As String) As String
    Dim Path As String
    Dim Filename As String

    SeparatePathAndFileName_ FullPath, Path, Filename
    
    GetPath_ = Path
End Function

Public Function GetFileName_(ByVal FullPath As String) As String
  GetFileName_ = GetFileNameSinExt_(FullPath) + "." + GetFileExt_(FullPath)
End Function

Public Function GetFileNameSinExt_(ByVal FullPath As String) As String
    Dim Path As String
    Dim Filename As String
    Dim nSepPos As Long
    Dim sSEP As String

    SeparatePathAndFileName_ FullPath, Path, Filename
    
    nSepPos = Len(Filename)
    
    If nSepPos = 0 Then
        GetFileNameSinExt_ = FullPath
        Exit Function
    End If
    
    sSEP = Mid$(Filename, nSepPos, 1)
    Do Until sSEP = "."
        nSepPos = nSepPos - 1
        If nSepPos = 0 Then Exit Do
        sSEP = Mid$(Filename, nSepPos, 1)
    Loop

    Select Case nSepPos
        Case 0
            'Si el separador no es encontrado entonces es un archivo sin extencion
            GetFileNameSinExt_ = Filename
        Case Else
            GetFileNameSinExt_ = Left$(Filename, nSepPos - 1)
    End Select
End Function

Public Function GetFileExt_(ByVal FullPath As String) As String
    Dim Path As String
    Dim Filename As String
    Dim nSepPos As Long
    Dim sSEP As String

    SeparatePathAndFileName_ FullPath, Path, Filename
    
    nSepPos = Len(Filename)
    
    If nSepPos = 0 Then
        GetFileExt_ = ""
        Exit Function
    End If
    
    sSEP = Mid$(Filename, nSepPos, 1)
    Do Until sSEP = "."
        nSepPos = nSepPos - 1
        If nSepPos = 0 Then Exit Do
        sSEP = Mid$(Filename, nSepPos, 1)
    Loop

    Select Case nSepPos
        Case 0
            'Si el separador no es encontrado entonces es un archivo sin extencion
            GetFileExt_ = ""
        Case Else
            ' Devuelvo la extension
            GetFileExt_ = Mid$(Filename, nSepPos + 1)
    End Select
End Function

Public Sub SeparatePathAndFileName_(FullPath As String, _
                                    Optional ByRef Path As String, _
                                    Optional ByRef Filename As String)
    Dim nSepPos As Long
    Dim sSEP As String

    nSepPos = Len(FullPath)
    
    If nSepPos = 0 Then
        Path = FullPath
        Filename = FullPath
        Exit Sub
    End If
    sSEP = Mid$(FullPath, nSepPos, 1)
    Do Until IsSeparator(sSEP)
        nSepPos = nSepPos - 1
        If nSepPos = 0 Then Exit Do
        sSEP = Mid$(FullPath, nSepPos, 1)
    Loop

    Select Case nSepPos
        Case Len(FullPath)
            'Si el separador es encontrado al final entonces, se trata de un directorio raiz ej. c:\, d:\, etc.
            Path = Left$(FullPath, nSepPos - 1)
            Filename = FullPath
        Case 0
            'Si el separador no es encontrado entonces, se trata de un directorio raiz ej. c:, d:, etc.
            Path = FullPath
            Filename = FullPath
        Case Else
            Path = Left$(FullPath, nSepPos - 1)
            Filename = Mid$(FullPath, nSepPos + 1)
    End Select
End Sub

Private Function IsSeparator(Character As String) As Boolean
    Select Case Character
        Case gstrSEP_DIR
            IsSeparator = True
        Case gstrSEP_DIRALT
            IsSeparator = True
    End Select
End Function
'------------

Private Function pIsSizable(ByRef F As Object) As Boolean
  On Error Resume Next
  pIsSizable = F.BorderStyle = vbSizable Or F.BorderStyle = vbSizableToolWindow
End Function

Private Sub pMsgAux(ByVal msg As String, ByVal Style As VbMsgBoxStyle, ByVal Title As String)
  msg = pGetMessage(msg)
  Title = pGetTitle(Title)
  MsgBox msg, Style, Title
End Sub

Private Function pGetMessage(ByVal msg As String) As String
  msg = Replace(msg, c_CRLF, vbCrLf)
  msg = Replace(msg, c_CRLF2, vbCrLf)

  pGetMessage = msg
End Function

Private Function pGetTitle(ByVal Title As String) As String
  If Title = vbNullString Then Title = "CrowSoft"
  If Title = "@@@@@" Then Title = "CrowSoft"
  pGetTitle = Title
End Function
