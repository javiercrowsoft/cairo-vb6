Attribute VB_Name = "mAux"
Option Explicit

#If Not PREPROC_SPSCRIPTOR Then
  ' Proposito: Rutinas auxiliares.
  Private Declare Function GetComputerName2 Lib "kernel32" Alias "GetComputerNameA" (ByVal lpBuffer As String, nSize As Long) As Long
  ' constantes
  Private Const C_Module = "mAux"
  
  Public Const C_PSqlFechaHora = "'/'yyyymmdd hh:nn:ss/'"
#End If

  Public Const csSchEndUndefined = #12/31/9999#

#If Not PREPROC_SPSCRIPTOR Then
    
  Public Const csNoDate = #1/1/1900#
  
  Public Const macro_databasename = "#macro(databasename)"
  Public Const macro_defaultpathdata = "#macro(defaultpathdata)"
  Public Const macro_defaultpathlog = "#macro(defaultpathlog)"
  Public Const macro_customercompanyname = "#macro(customercompanyname)"
  
  Public Const csStrNext = "&Siguiente"
  Public Const csStrBack = "&Atras"
  Public Const csStrFinish = "&Finalizar"
  Public Const csStrClose = "&Cerrar"
  Public Const csStrDefScriptBatchExt = "spr"
  Public Const csStrDefDataBaseExt = "srp"
  Public Const csStrScript = "&Script"
  Public Const csStrLog = "&Log"
  
  Public Const c_task = "Tarea"
  
  Public Const c_TCPSep1 = ""
  Public Const c_TCPSep2 = ""
  
  Public Enum csIconProgress
    csIconPrgWait = 3
    csIconPrgOk = 2
    csIconPrgFail = 1
    csIconPrgWarning = 4
  End Enum
  
  Public Enum csFindReplace
    csfrReplaceAll
    csfrFindNext
    csfrReplaceNext
  End Enum
  
  Public Enum csFindReplaceDirection
    csfrdAll
    csfrUp
    csfrDown
  End Enum
#End If

  ' Contiene el proximo caracter desde el cual busca una palabra la funcion
  ' GetWord
Private m_Start As Integer
Private Const ERROR_IN_GET_NOMBRE = 2222222

#If Not PREPROC_SPSCRIPTOR Then

  ' Es el path del exe que esta corriendo esta instancia del server
  Public gPathExe As String
  
  
  Public Sub Main()
    SetSepDecimal
  End Sub
#End If

Public Function CollObjectExists(ByRef coll As Object, ByVal Key As String) As Boolean
  On Error Resume Next
  
  ' Si la coleccion esta bacia obviamente que no esta.
  If coll Is Nothing Then Exit Function
  If coll.Count = 0 Then Exit Function
  
  Dim v As Variant
  
  Err.Clear
  Set v = coll(Key)
  
  CollObjectExists = Err.Number = 0
End Function

Public Sub DBCheckExists(ByRef Conn As cConnection, ByVal DataBaseName As String, ByVal sFunction As String)
  If Not CollObjectExists(Conn.Server.Databases, DataBaseName) Then
    Err.Raise csDataBaseNotExists, sFunction, "La base " & DataBaseName & " no se encuentra en el servidor " & Conn.ServerName & "."
  End If
End Sub

#If Not PREPROC_SPSCRIPTOR Then

  Public Function Ask(ByVal Message As String) As Boolean
  
    On Error GoTo ControlError
  
    Message = Replace(Message, ";", chr(13) + chr(10))
    Message = Replace(Message, "/n", chr(13) + chr(10))
  
    If InStr(1, Message, "?") = 0 Then
      Message = "¿ " + Message + " ?"
    End If
  
    Ask = MsgBox(Message, vbQuestion + vbYesNo) = vbYes
  
    Exit Function
ControlError:
    MngError Err, "Ask", "", ""
  End Function
  
  Public Function Ask2(ByVal Message As String, ByVal OkYesCancel As Boolean) As VbMsgBoxResult
  
    On Error GoTo ControlError
  
    Message = Replace(Message, ";", chr(13) + chr(10))
    Message = Replace(Message, "/n", chr(13) + chr(10))
  
    If InStr(1, Message, "?") = 0 Then
      Message = "¿ " + Message + " ?"
    End If
    
    Dim buttons As Long
    
    If OkYesCancel Then
      buttons = vbQuestion + vbYesNoCancel
    Else
      buttons = vbQuestion + vbYesNo
    End If
    
    Ask2 = MsgBox(Message, buttons)
  
    Exit Function
ControlError:
    MngError Err, "Ask2", "", ""
  End Function
  
  Public Sub info(ByVal s As String)
    MsgBox s, vbInformation
  End Sub
  
  Public Function GetComputerName() As String
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
  
  Public Sub FormCenter(ByRef f As Form)
    f.Move (Screen.Width - f.Width) * 0.5, (Screen.Height - f.Height) * 0.5
  End Sub
  
  Public Function FormatDate(ByVal varDate As Variant) As String
    FormatDate = Format(varDate, "dd/mm/yyyy")
  End Function
  
  Public Function FormatTime(ByVal varDate As Variant, Optional ByVal withSeconds As Boolean) As String
    If IsMissing(withSeconds) Then
      FormatTime = Format(varDate, "hh:nn")
    ElseIf withSeconds Then
      FormatTime = Format(varDate, "hh:nn:ss")
    Else
      FormatTime = Format(varDate, "hh:nn")
    End If
  End Function
  
  Public Function AddItemToList(ByRef cbList As Object, ByVal Text As String, Optional ByVal ItemData As Variant) As Integer
    cbList.AddItem Text
    If Not IsMissing(ItemData) Then cbList.ItemData(cbList.NewIndex) = ItemData
    AddItemToList = cbList.NewIndex
  End Function
  
  Public Function SelectItemByText(ByRef cbList As Object, ByVal Text As String) As Integer
    Dim i As Integer
    
    SelectItemByText = -1
    
    For i = 0 To cbList.ListCount - 1
      If cbList.List(i) = Text Then
        cbList.ListIndex = i
        SelectItemByText = i
        Exit For
      End If
    Next
  End Function
  
  Public Function SelectItemByItemData(ByRef cbList As Object, ByVal ItemData As Integer) As Integer
    Dim i As Integer
    
    SelectItemByItemData = -1
    
    For i = 0 To cbList.ListCount - 1
      If cbList.ItemData(i) = ItemData Then
        cbList.ListIndex = i
        SelectItemByItemData = i
        Exit For
      End If
    Next
  End Function
  
  Public Sub RemoveFromListByItemData(ByRef cbList As Object, ByVal ItemData As Integer)
    Dim i As Integer
    
    For i = 0 To cbList.ListCount - 1
      If cbList.ItemData(i) = ItemData Then
        cbList.RemoveItem i
        Exit For
      End If
    Next
  End Sub
  
  Public Function GetItemData(ByRef cbList As Object) As Long
    If cbList.ListIndex = -1 Then Exit Function
    GetItemData = cbList.ItemData(cbList.ListIndex)
  End Function
  
  Public Function SelectItemByText2(ByRef cbList As ImageCombo, ByVal Text As String) As Integer
    Dim i As Integer
    
    SelectItemByText2 = 0
    
    For i = 1 To cbList.ComboItems.Count
      If cbList.ComboItems(i).Text = Text Then
        cbList.ComboItems(i).Selected = True
        SelectItemByText2 = i
        Exit For
      End If
    Next
  End Function
  
  Public Function CharacterValidForDate(ByVal KeyAscii As Integer) As Integer
    Select Case KeyAscii
      Case vbKey0, vbKey1, vbKey2, vbKey3, vbKey4, vbKey5, vbKey6, vbKey7, vbKey8, vbKey9, vbKeyBack
        CharacterValidForDate = KeyAscii
      Case vbKeyDivide, vbKeyDecimal, vbKeySubtract, 47, 46, 45
        CharacterValidForDate = 47 ' 47 = /
      Case Else
        CharacterValidForDate = 0
    End Select
  End Function
  
  Public Function CharacterValidForDecimal(ByVal KeyAscii As Integer) As Integer
    Select Case KeyAscii
      Case vbKey0, vbKey1, vbKey2, vbKey3, vbKey4, vbKey5, vbKey6, vbKey7, vbKey8, vbKey9, vbKeyBack
        CharacterValidForDecimal = KeyAscii
      Case vbKeyDecimal
        CharacterValidForDecimal = KeyAscii
      Case Else
        CharacterValidForDecimal = 0
    End Select
  End Function
  
  Public Function CharacterValidForInteger(ByVal KeyAscii As Integer) As Integer
    Select Case KeyAscii
      Case vbKey0, vbKey1, vbKey2, vbKey3, vbKey4, vbKey5, vbKey6, vbKey7, vbKey8, vbKey9, vbKeyBack
        CharacterValidForInteger = KeyAscii
      Case Else
        CharacterValidForInteger = 0
    End Select
  End Function
  
  Public Function CharacterValidForTime(ByVal KeyAscii As Integer) As Integer
    Select Case KeyAscii
      Case vbKey0, vbKey1, vbKey2, vbKey3, vbKey4, vbKey5, vbKey6, vbKey7, vbKey8, vbKey9, vbKeyBack
        CharacterValidForTime = KeyAscii
      Case 46, 45, 58
        CharacterValidForTime = 58 ' 58 = :
      Case Else
        CharacterValidForTime = 0
    End Select
  End Function
  
  Public Sub SetFocusControl(ByRef ctl As Control)
    On Error Resume Next
    ctl.SetFocus
  End Sub
  
  Public Function CheckValueTime(ByVal Time As String) As String
    If Not IsNumeric(Time) And Not IsDate(Time) Then Exit Function
    If InStr(1, Time, ":") = 0 Then
      Time = Time & ":00"
    End If
    CheckValueTime = Time
  End Function
  
  Public Function GetLcaseKey(ByVal Key As String) As String
    GetLcaseKey = LCase$(Key)
  End Function

  Public Function GetKey(ByVal vVal As Variant) As String
    If IsNumeric(vVal) Then
      GetKey = "K" + vVal
    Else
      GetKey = vVal
    End If
  End Function
  
  Public Sub CollClear(ByRef coll As Collection)
    If coll Is Nothing Then Exit Sub
    Do While coll.Count > 0
      coll.Remove 1
    Loop
  End Sub
  
  Public Function GetDateFromSQLJobFormat(ByVal DateVal As Long) As Date
    Dim rtn As Date
    Dim Y As Long
    Dim m As Long
    Dim d As Long
    
    Y = DateVal / 10000
    m = Abs((DateVal - Y * 10000) / 100)
    d = Abs(DateVal - Y * 10000 - m * 100)
    rtn = DateSerial(Y, m, d)
    
    GetDateFromSQLJobFormat = rtn
  End Function
  
  Public Function GetTimeFromSQLJobFormat(ByVal TimeVal As Long) As Date
    Dim rtn As Date
    Dim h As Long
    Dim n As Long
    Dim s As Long
    
    h = TimeVal / 10000
    n = Abs((TimeVal - h * 10000) / 100)
    s = Abs(TimeVal - h * 10000 - n * 100)
    rtn = TimeSerial(h, n, s)
    
    GetTimeFromSQLJobFormat = rtn
  End Function
  
  Public Function GetDateFromCSJobFormat(ByVal DateVal As Date) As Long
    Dim rtn As Long
    Dim Y As Long
    Dim m As Long
    Dim d As Long
    
    Y = Year(DateVal) * 10000
    m = Month(DateVal) * 100
    d = Day(DateVal)
    
    rtn = Y + m + d
    
    GetDateFromCSJobFormat = rtn
  End Function
  
  Public Function GetTimeFromCSJobFormat(ByVal TimeVal As Date) As Long
    Dim rtn As Long
    Dim h As Long
    Dim n As Long
    Dim s As Long
    
    h = Hour(TimeVal) * 10000
    n = Minute(TimeVal) * 100
    s = Second(TimeVal)
    
    rtn = h + n + s
  
    GetTimeFromCSJobFormat = rtn
  End Function
#End If

'----------------------------------------------------------------------------------------------------
Public Function GetSQLObjectName(ByVal sqlstmt As String, ByVal sWordToSearch1 As String, ByVal sWordToSearch2 As String) As String
    On Error GoTo ControlError
    m_Start = 1
    GetSQLObjectName = FindCreate(sqlstmt, sWordToSearch1, sWordToSearch2)
    Exit Function
ControlError:
    GetSQLObjectName = ""
End Function

Private Function FindCreate(ByVal sqlstmt As String, ByVal sWordToSearch1 As String, ByVal sWordToSearch2 As String) As String
    Dim word As String
    Dim Nombre As String
    
    Do
        word = GetWord(sqlstmt)
        
        If UCase(word) = sWordToSearch1 Then
            Nombre = FindProcedure(sqlstmt, sWordToSearch2)
        End If
    Loop Until Nombre <> ""
    FindCreate = Nombre
End Function

Private Function FindProcedure(ByVal sqlstmt As String, ByVal sWordToSearch As String) As String
    Dim word As String
    Dim parentesis As Integer
    word = GetWord(sqlstmt)
    If UCase(word) = sWordToSearch Then
        FindProcedure = GetWord(sqlstmt)
        
        ' quito los parentesis si es que hay
        parentesis = InStr(1, FindProcedure, "(")
        If parentesis Then
            FindProcedure = Mid(FindProcedure, 1, parentesis - 1)
        End If
    Else
        FindProcedure = ""
    End If
End Function

Private Function GetWord(ByVal sqlstmt As String) As String
    Dim word        As String
    
    ' leo una palabra
    word = GetWord2(sqlstmt)
    

    ' mientras sea un principio de comentario
    While EsBeginComentario(word)
        
        ' busco un fin de comentario
        Do
            word = GetWord2(sqlstmt)
            
            If word = "!!@@##$$" Then
                GetWord = word
                Exit Function
            End If
            
        Loop Until EsEndComentario(word)
        
        ' leo la proxima palabra
        word = GetWord2(sqlstmt)
    Wend
    ' devuelvo la palabra que obviamente no es un comentario
    GetWord = word
    
End Function

Private Function EsBeginComentario(word As String) As Boolean
    If Not Mid(word, 1, 2) = "/*" Then Exit Function
    If Len(word) < 2 Then Exit Function
    If Mid(word, Len(word) - 1, 2) = "*/" Then Exit Function
    EsBeginComentario = True
End Function

Private Function EsEndComentario(word As String) As Boolean
    If Len(word) < 2 Then Exit Function
    If Not Mid(word, Len(word) - 1, 2) = "*/" Then Exit Function
    EsEndComentario = True
End Function

Private Function GetWord2(ByVal sqlstmt As String)
    Dim nespacio    As Integer
    Dim nreturn     As Integer
    Dim nfinWord    As Integer
    Dim nnextStart  As Integer
    Dim caracter    As String
    
    
    ' si ya no hay texto donde buscar disparo un error
    If m_Start = 0 Then
        Err.Raise vbObjectError + ERROR_IN_GET_NOMBRE
    End If
    
    ' una palabra comienza en donde estoy parado y termina en un espcio o char 13+ char 10
    nespacio = InStr(m_Start, sqlstmt, " ")
    nreturn = InStr(m_Start, sqlstmt, vbCrLf)
    
    ' cadena de ejemplo "hola"
    If nespacio = 0 And nreturn = 0 Then
        nfinWord = Len(sqlstmt)
        ' si no encuentro lo que busco en esta palabra, entonces
        ' la proxima vez que ejecute esta funcion se dispara un
        ' error por que ya no hay texto donde buscar
        nnextStart = 0
    
    ' cadena de ejemplo "hola<enter>"
    ElseIf nespacio = 0 Then
        nfinWord = nreturn
        ' es un fin de linea asi que avanzo dos caracteres
        nnextStart = nreturn + 2
        
    ' cadena de ejemplo "hola "
    ElseIf nreturn = 0 Then
        nfinWord = nespacio
        
        ' es un espacio asi que avanzo hasta el ultimo espacio
        ' ejemplo "hola   chau" nnextStart =7
        
        ' obtengo el proximo caracter
        caracter = Mid(sqlstmt, nfinWord + 1, 1)
        
        ' mientras sea un espacio, avanzo el limite
        Do While caracter = " "
            nfinWord = nfinWord + 1
            caracter = Mid(sqlstmt, nfinWord + 1, 1)
        Loop
        nnextStart = nfinWord + 1
        
    ' cadena de ejemplo "hola<enter> "
    ElseIf nreturn < nespacio Then
        nfinWord = nreturn
        ' es un fin de linea asi que avanzo dos caracteres
        nnextStart = nreturn + 2
        
    ' cadena de ejemplo "hola <enter>"
    Else
        nfinWord = nespacio
        
        ' es un espacio asi que avanzo hasta el ultimo espacio
        ' ejemplo "hola   chau" nnextStart =7
        
        ' obtengo el proximo caracter
        caracter = Mid(sqlstmt, nfinWord + 1, 1)
        
        ' mientras sea un espacio, avanzo el limite
        Do While caracter = " "
            nfinWord = nfinWord + 1
            caracter = Mid(sqlstmt, nfinWord + 1, 1)
        Loop
        nnextStart = nfinWord + 1
    End If
    
    ' obtengo la palabra sin espacios
    GetWord2 = Trim(Mid(sqlstmt, m_Start, nfinWord - m_Start))
    m_Start = nnextStart
End Function
  
#If Not PREPROC_SPSCRIPTOR Then
  
  Public Sub UpdateStatus(ByRef Pic As PictureBox, ByVal sngPercent As Single, Optional ByVal fBorderCase As Boolean = False)
    Dim strPercent  As String
    Dim intX        As Integer
    Dim intY        As Integer
    Dim intWidth    As Integer
    Dim intHeight   As Integer
    
    'For this to work well, we need a white background and any color foreground (blue)
    Const colBackground = vbButtonFace ' white
    Const colForeground = &HC00000    ' dark blue
    
    Pic.ForeColor = colForeground
    Pic.BackColor = colBackground
    
    '
    'Format percentage and get attributes of text
    '
    Dim intPercent
    intPercent = Int(100 * sngPercent + 0.5)
    
    'Never allow the percentage to be 0 or 100 unless it is exactly that value.  This
    'prevents, for instance, the status bar from reaching 100% until we are entirely done.
    If intPercent = 0 Then
      If Not fBorderCase Then
          intPercent = 1
      End If
    ElseIf intPercent >= 100 Then
      intPercent = 100
      If Not fBorderCase Then
          intPercent = 99
      End If
    End If
    
    strPercent = Format$(intPercent) & "%"
    intWidth = Pic.TextWidth(strPercent)
    intHeight = Pic.TextHeight(strPercent)
    
    '
    'Now set intX and intY to the starting location for printing the percentage
    '
    intX = Pic.Width / 2 - intWidth / 2
    intY = Pic.Height / 2 - intHeight / 2
    
    '
    'Need to draw a filled box with the pics background color to wipe out previous
    'percentage display (if any)
    '
    Pic.DrawMode = 13 ' Copy Pen
    Pic.Line (intX, intY)-Step(intWidth, intHeight), Pic.BackColor, BF
    
    '
    'Back to the center print position and print the text
    '
    Pic.CurrentX = intX
    Pic.CurrentY = intY
    Pic.Print strPercent
    
    '
    'Now fill in the box with the ribbon color to the desired percentage
    'If percentage is 0, fill the whole box with the background color to clear it
    'Use the "Not XOR" pen so that we change the color of the text to white
    'wherever we touch it, and change the color of the background to blue
    'wherever we touch it.
    '
    Pic.DrawMode = 10 ' Not XOR Pen
    If sngPercent > 0 Then
      Pic.Line (0, 0)-(Pic.Width * sngPercent, Pic.Height), Pic.ForeColor, BF
    Else
      Pic.Line (0, 0)-(Pic.Width, Pic.Height), Pic.BackColor, BF
    End If
    
    Pic.Refresh
  End Sub
  
  Public Function RemoveLastColon(ByVal s As String) As String
    RemoveLastColon = RemoveLastChr(s, ",")
  End Function
  
  Public Function RemoveLastChr(ByVal s As String, ByVal chr As String) As String
    s = RTrim$(s)
    If Right$(s, 1) = chr Then
      s = Left$(s, Len(s) - 1)
    End If
    RemoveLastChr = s
  End Function
  
  Public Function ShowFind(ByVal toFind As String) As String
    fFindText.cbToSearch.Text = toFind
    fFindText.cmdReplace.Caption = "Reemplazar..."
    fFindText.Show
  End Function
  
  Public Function SqlReplaceComments(ByVal Msg As String) As String
    SqlReplaceComments = Replace(Msg, "[Microsoft][ODBC SQL Server Driver][SQL Server]", "")
  End Function
  
  Public Function ShowFindFile(ByVal Database As String, ByVal File As String, ByVal Title As String, ByRef Server As SQLDMO.SQLServer) As String
    On Error GoTo ControlError
  
    Dim fFind As fFindFileBackup
    
    Set fFind = New fFindFileBackup
    
    If Not Trim(Title) = "" Then fFind.Caption = Title
    
    Set fFind.Server = Server
    
    If Not fFind.LoadDrives Then GoTo ExitProc
    
    If Not Trim(File) = "" Then
      fFind.lbSelectedPath.Caption = FileGetPath(File)
      fFind.txBackupFile = FileGetName(File)
    Else
      fFind.lbSelectedPath = "C:"
      fFind.txBackupFile = Database
    End If
    
    fFind.Show vbModal
    
    If Not fFind.Ok Then GoTo ExitProc
    
    ShowFindFile = fFind.PathAndFileName
  
    GoTo ExitProc
ControlError:
    MngError Err, "ShowFindFile", C_Module, ""
    If Err.Number <> 0 Then Resume ExitProc
ExitProc:
    On Error Resume Next
    Unload fFind
    Set fFind = Nothing
  End Function
  
  Public Sub SaveLog(ByVal Message As String)
  End Sub
  
  Public Function ExistsItemByText(ByRef cbList As Object, ByVal Text As String) As Boolean
    Dim i As Integer
    
    ExistsItemByText = False
    
    For i = 0 To cbList.ListCount - 1
      If cbList.List(i) = Text Then
        ExistsItemByText = True
        Exit For
      End If
    Next
  End Function
#End If
