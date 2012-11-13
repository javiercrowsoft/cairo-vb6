VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cfCreateDataBase"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

'--------------------------------------------------------------------------------
' cToolsDeclaration
' 15-06-2002

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cToolsDeclaration"
Private Const c_step_0 = 0
Private Const c_step_1_definition = 1
Private Const c_step_2_descripProcess = 2
Private Const c_step_3_progress = 3
Private Const c_step_4_result = 4

Private Enum eDirection
  csMoveNext = 1
  csMoveBack = 2
End Enum
' estructuras
' variables privadas
Private WithEvents m_fCreateDB      As fCreateDataBase
Attribute m_fCreateDB.VB_VarHelpID = -1

Private m_Step                      As Integer

Private m_SQLServer                 As cSQLServer
Private m_DefDB                     As cDefDataBase
Private m_MngMacro                  As cMngMacro
Private m_MngScript                 As cMngScriptBatch
Private m_MngLog                    As cMngLog

Private m_MustDropDB                As Boolean
Private WithEvents m_CreateDataBase As cCreateDataBase
Attribute m_CreateDataBase.VB_VarHelpID = -1

Private m_DoScript    As Boolean

Private m_CollError   As Collection

Private m_idprgcreatedb       As Integer
Private m_idprgdropdb         As Integer
Private m_idprgcreatetask     As Integer
Private m_idprgscript         As Integer

Private m_DbName              As String

Private m_Warning         As Boolean
Private m_Runing          As Boolean
Private m_cancel          As Boolean
Private m_IsForInstall    As Boolean

' eventos
' propiedadades publicas
Public Property Get DbName() As String
   DbName = m_DbName
End Property

Public Property Let DbName(ByVal rhs As String)
   m_DbName = rhs
End Property
' propiedadades friend
Friend Property Set SQLServer(ByRef rhs As cSQLServer)
  Set m_SQLServer = rhs
End Property

Friend Property Set MngMacro(ByRef rhs As cMngMacro)
   Set m_MngMacro = rhs
End Property

Friend Property Set MngScript(ByRef rhs As cMngScriptBatch)
   Set m_MngScript = rhs
End Property

Friend Property Let IsForInstall(ByRef rhs As Boolean)
  m_IsForInstall = rhs
End Property

' propiedades privadas
' funciones publicas
Public Function CreateDataBase(Optional ByVal ScriptFile As String, Optional ByVal ScriptMacro As String, _
                               Optional ByVal ScriptBatch As String, Optional ByVal DoScript As Boolean, _
                               Optional ByVal Log As String = "CreateDataBaseLog") As Boolean
  On Error GoTo ControlError
  
  m_DbName = ""
  
  Set m_fCreateDB = New fCreateDataBase
  Set m_DefDB = New cDefDataBase
  
  If Trim(ScriptFile) <> "" Then
    If Not m_DefDB.LoadDefFromIni(ScriptFile) Then Exit Function
  End If
  
  If m_MngMacro Is Nothing Then Set m_MngMacro = New cMngMacro
  
  If m_MngMacro.Conn Is Nothing Then Set m_MngMacro.Conn = m_SQLServer.Conn
  
  If Trim(ScriptMacro) <> "" Then
    If Not m_MngMacro.LoadMacroFromIni(ScriptFile) Then Exit Function
  End If
  
  If m_MngScript Is Nothing Then Set m_MngScript = New cMngScriptBatch
  
  If Trim(ScriptBatch) <> "" Then
    If Not m_MngScript.LoadScriptFromIni(ScriptBatch) Then Exit Function
  End If
  
  Set m_MngLog = New cMngLog
  m_MngLog.Init FileGetValidPath(gPathExe) & Log
  
  CollClear m_CollError
  
  m_DoScript = DoScript
  
  ' Nota: m_fCreateDB dispara un evento MoveNext
  '       que avanza m_step a m_step + 1, por esta
  '       razon el codigo anterior pone m_step un paso
  '       antes de lo establecido en el objeto m_DefDB
  
  ' Si hay que permitir al usuario
  ' editar la definicion
  If m_DefDB.ShowDefinition Or NeedDefinition Then
    m_Step = c_step_0
  
  ' sino, si debo mostrar la descripcion
  ' de los pasos
  ElseIf m_DefDB.ShowDescrip Then
    m_Step = c_step_1_definition
  
  ' sino, directamente voy al progreso
  Else
    m_Step = c_step_2_descripProcess
  End If
  
  m_MngLog.Log "Se inicia la creación una base de datos"
  
  ' Nota Esto debe estar despues de establecer
  ' el valor de m_step
  Load m_fCreateDB
  
  With m_fCreateDB
    .Caption = "Creando base de datos en " & m_SQLServer.Conn.Server.Name
    .txName.Text = m_MngMacro.ResolveMacros(m_DefDB.Name)
    .txDataFile.Text = m_MngMacro.ResolveMacros(m_DefDB.DataPath)
    .txDataSize.Text = m_MngMacro.ResolveMacros(m_DefDB.DataSize)
    .txLogFile.Text = m_MngMacro.ResolveMacros(m_DefDB.LogPath)
    .txLogSize.Text = m_MngMacro.ResolveMacros(m_DefDB.LogSize)
  End With
  
  m_fCreateDB.Show vbModal

  If Not m_fCreateDB.Ok Then
    m_MngLog.Log "La creación de la base de datos fallo"
    Exit Function
  End If
  
  m_MngLog.Log "La creación de la base de datos termino con éxito"

  CreateDataBase = True

  GoTo ExitProc
ControlError:
  MngError Err, "CreateDataBase", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
  
  Unload m_fCreateDB
  Set m_fCreateDB = Nothing
End Function

Public Function CreateDataBaseEx(ByRef DbName As String, _
                                 ByVal DataFile As String, _
                                 ByVal DataSize As Long, _
                                 ByVal LogFile As String, _
                                 ByVal LogSize As Long, _
                                 Optional ByVal Log As String = "CreateDataBaseLog") As Boolean
  On Error GoTo ControlError
  
  m_DbName = ""
  
  Set m_fCreateDB = New fCreateDataBase
  Set m_DefDB = New cDefDataBase
  
  If m_MngMacro Is Nothing Then Set m_MngMacro = New cMngMacro
  
  If m_MngMacro.Conn Is Nothing Then Set m_MngMacro.Conn = m_SQLServer.Conn
  
  If m_MngScript Is Nothing Then Set m_MngScript = New cMngScriptBatch
  
  Set m_MngLog = New cMngLog
  m_MngLog.Init ""
  
  CollClear m_CollError
  
  m_DoScript = False
  
  ' Nota: m_fCreateDB dispara un evento MoveNext
  '       que avanza m_step a m_step + 1, por esta
  '       razon el codigo anterior pone m_step un paso
  '       antes de lo establecido en el objeto m_DefDB
  
  ' Si hay que permitir al usuario
  ' editar la definicion
  If m_DefDB.ShowDefinition Or NeedDefinition Then
    m_Step = c_step_0
  
  ' sino, si debo mostrar la descripcion
  ' de los pasos
  ElseIf m_DefDB.ShowDescrip Then
    m_Step = c_step_1_definition
  
  ' sino, directamente voy al progreso
  Else
    m_Step = c_step_2_descripProcess
  End If
  
  m_MngLog.Log "Se inicia la creación una base de datos"
  
  ' Nota Esto debe estar despues de establecer
  ' el valor de m_step
  Load m_fCreateDB
  
  With m_fCreateDB
    .Caption = "Creando base de datos en " & m_SQLServer.Conn.Server.Name
    .txName.Text = DbName
    .txDataFile.Text = DataFile
    .txDataSize.Text = DataSize
    .txLogFile.Text = LogFile
    .txLogSize.Text = LogSize
  End With
  
  If m_IsForInstall Then
    m_fCreateDB.IsForInstall = True
    m_fCreateDB.CreateDataBase
  Else
    m_fCreateDB.Show vbModal
  End If

  If Not m_fCreateDB.Ok Then
    m_MngLog.Log "La creación de la base de datos fallo"
    Exit Function
  End If
  
  m_MngLog.Log "La creación de la base de datos termino con éxito"

  CreateDataBaseEx = True

  GoTo ExitProc
ControlError:
  MngError Err, "CreateDataBaseEx", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
  
  Unload m_fCreateDB
  Set m_fCreateDB = Nothing
End Function
' funciones friend
' funciones privadas
Private Function NeedDefinition() As Boolean
  Dim rtn As Boolean
  
  rtn = m_MngMacro.DataBaseName = "" And m_DefDB.Name = macro_databasename
  rtn = rtn Or (m_MngMacro.Defaultpathdata = "" And m_DefDB.Name = macro_defaultpathdata)
  rtn = rtn Or (m_MngMacro.Defaultpathlog = "" And m_DefDB.Name = macro_defaultpathlog)
  
  NeedDefinition = True
End Function

Private Sub Move(ByVal Direction As eDirection)

  Dim NextStep As Integer
  
  NextStep = m_Step
  
  If Direction = csMoveNext Then
    NextStep = NextStep + 1
  Else
    NextStep = NextStep - 1
  End If
  
  ' Validacion tonta pero prudente
  If NextStep < c_step_1_definition Then NextStep = c_step_1_definition
  If NextStep > c_step_4_result Then NextStep = c_step_4_result
  
  Select Case NextStep
    Case c_step_1_definition
      m_fCreateDB.frDefinition.ZOrder
      m_fCreateDB.cmdBack.Enabled = False
      m_fCreateDB.cmdNext.Enabled = True
      m_fCreateDB.cmdNext.Caption = csStrNext
      m_fCreateDB.cmdDoScript.Caption = csStrScript
      m_fCreateDB.cmdDoScript.Visible = m_DoScript
    Case c_step_2_descripProcess
      
      ' Si vengo de 1 y voy a 2
      If Direction = csMoveNext Then
        If Not ValidateStep1() Then Exit Sub
        
        m_fCreateDB.frDescrip.ZOrder
        m_fCreateDB.cmdBack.Enabled = True
        m_fCreateDB.cmdNext.Enabled = True
        m_fCreateDB.cmdNext.Caption = csStrFinish
        m_fCreateDB.lbDescrip2.Caption = "Toda la información necesaria para generar la base de datos esta compleata. Presione el boton " & Replace(csStrFinish, "&", "") & " para comenzar con el proceso."
        m_fCreateDB.txDescrip.Text = GetDescripProcess
        
      ' Si vengo de 3 salto a 1
      Else
        Move csMoveBack
      End If
      
    Case c_step_3_progress
      ' Si vengo de 4 voy directamente a 2
      If Direction = csMoveBack Then
        Move csMoveBack
      Else
      
        CollectData m_DefDB
        
        If Not ValidScriptsPath() Then Exit Sub
        
        m_fCreateDB.frProgress.ZOrder
        m_fCreateDB.cmdBack.Enabled = False
        m_fCreateDB.cmdNext.Enabled = False
        m_fCreateDB.lbDescrip3.Caption = "Creando la base de datos " & m_DefDB.Name & " en el servidor " & m_SQLServer.Conn.Server.Name
        m_fCreateDB.cmdDoScript.Visible = False
        m_fCreateDB.Progress "", 0
        m_fCreateDB.ProgressFull True
        m_fCreateDB.lvProgress.ListItems.Clear
        
        m_Runing = True
        m_cancel = False
        
        ' Cantidad de pasos
        If m_MustDropDB Then
          m_fCreateDB.InitProgressFull m_MngScript.Scripts.Count + 2
        Else
          m_fCreateDB.InitProgressFull m_MngScript.Scripts.Count + 1
        End If
        
        Set m_CreateDataBase = m_SQLServer.CreateDataBase
        If Not m_CreateDataBase.CreateDataBase(m_DefDB, m_MngMacro, _
                              m_MngScript, m_MustDropDB) Then
                              
          ' Le dejo ir hacia atras para volver a intentar
          m_fCreateDB.cmdBack.Enabled = True
          m_Runing = False
          Exit Sub
        End If
        
        ' Ok todo bien asi que solo queda cerrar
        m_Runing = False
        m_fCreateDB.Progress "", 0
        m_fCreateDB.ProgressFull True
        m_fCreateDB.cmdNext.Caption = csStrClose
        m_fCreateDB.cmdNext.Enabled = True
        m_fCreateDB.cmdCancel.Enabled = False
        m_fCreateDB.cmdDoScript.Visible = True
        m_fCreateDB.cmdDoScript.Caption = csStrLog
        m_fCreateDB.ShowProgress 0, "La creación de la base termino con éxito", csIconPrgOk
      End If
    
    Case c_step_4_result
      If m_fCreateDB.Ok Then m_DbName = m_fCreateDB.txName.Text
      Unload m_fCreateDB ' Se termino
      
  End Select
  
  m_Step = NextStep

End Sub

Private Sub CollectData(ByRef DefDB As cDefDataBase)
  DefDB.Name = m_fCreateDB.txName.Text
  DefDB.DataPath = m_fCreateDB.txDataFile.Text
  DefDB.DataSize = Val(m_fCreateDB.txDataSize.Text)
  DefDB.LogPath = m_fCreateDB.txLogFile.Text
  DefDB.LogSize = Val(m_fCreateDB.txLogSize.Text)
End Sub

Private Function ValidScriptsPath() As Boolean
  Dim scr     As cDefScript
  Dim File    As String
  
  For Each scr In m_MngScript.Scripts
    File = FileGetValidPath(gPathExe) & scr.File
    If Not FileExists(scr.FileValid) Then
      If Not ValidScriptPath(File) Then Exit Function
      scr.FileValid = File
    End If
  Next
  
  ValidScriptsPath = True
End Function

Private Function ValidScriptPath(ByRef File As String) As Boolean
  Dim Filter As String
  
  If Not FileExists(File) Then
    Filter = FileGetType(File)
    If Filter = "" Then
      Filter = "Todos los archivos|*.*"
    Else
      Filter = "Archivos *." & Filter & "|*." & Filter
    End If
    Dim File2 As String
    File2 = FileGetName(File)
    If Not ShowOpenFileDLG(m_fCreateDB.cd, File2, Filter) Then Exit Function
    File = File2
  End If
  ValidScriptPath = True
End Function

Private Function GetDescripProcess() As String
  Dim rtn As String
  Dim scr As cDefScript
  
  rtn = rtn & "Estos son los pasos a seguir:" & vbCrLf & vbCrLf
  If m_MustDropDB Then
    rtn = rtn & vbCrLf
    rtn = rtn & "  - Se borrara la base de datos " & m_fCreateDB.txName.Text & vbCrLf
    rtn = rtn & vbCrLf
  End If
  rtn = rtn & "  - Se creara la base " & m_fCreateDB.txName.Text & " en el servidor " & m_SQLServer.Conn.Server.Name & vbCrLf
  rtn = rtn & "  - Se usaran los archivos:" & vbCrLf
  rtn = rtn & "        - " & m_fCreateDB.txDataFile.Text & "  (" & m_fCreateDB.txDataSize.Text & " MB)" & vbCrLf
  rtn = rtn & "        - " & m_fCreateDB.txLogFile.Text & "  (" & m_fCreateDB.txLogSize.Text & " MB)" & vbCrLf
  rtn = rtn & vbCrLf
  
  If m_MngScript.Scripts.Count > 0 Then
    
    rtn = rtn & "Se ejecutaran los siguientes scripts:" & vbCrLf & vbCrLf
    
    For Each scr In m_MngScript.Scripts
    
      rtn = rtn & scr.File & vbCrLf
      rtn = rtn & scr.Descrip & vbCrLf
      If scr.ScrType = csScrTypeScript Then
        rtn = rtn & "(Script)" & vbCrLf
      Else
        rtn = rtn & "(Tarea)" & vbCrLf
      End If
      rtn = rtn & vbCrLf
    Next
  End If

  GetDescripProcess = rtn
End Function

' Proposito: Validar la definicion de la base de datos
'            Resolver que hacer si la base existe
Private Function ValidateStep1() As Boolean
  If Trim(m_fCreateDB.txName.Text) = "" Then
    info "Debe indicar un nombre para la base de datos"
    SetFocusControl m_fCreateDB.txName
    Exit Function
  End If
  If Trim(m_fCreateDB.txDataFile.Text) = "" Then
    info "Debe indicar un archivo para los datos"
    SetFocusControl m_fCreateDB.txDataFile
    Exit Function
  End If
  
  If Val(m_fCreateDB.txDataSize.Text) < 0 Then
    info "Debe indicar un tamaño para el archivo de datos"
    SetFocusControl m_fCreateDB.txDataSize
    Exit Function
  End If
  
  If Trim(m_fCreateDB.txLogFile.Text) = "" Then
    info "Debe indicar un archivo para el log"
    SetFocusControl m_fCreateDB.txLogFile
    Exit Function
  End If

  If Val(m_fCreateDB.txLogSize.Text) < 0 Then
    info "Debe indicar un tamaño para el archivo de log"
    SetFocusControl m_fCreateDB.txLogSize
    Exit Function
  End If
  
  m_MustDropDB = False
  
  If m_SQLServer.DataBaseExists(m_fCreateDB.txName.Text) Then
    If Not m_DefDB.OverWriteIfExists Then
      
      ' Debe confirmar que desea borrar la base
      If Ask("La base de datos '" & m_fCreateDB.txName.Text & "' ya existe./n/n¿Desea sobre escribirla?") Then
      
        ' Le pido una doble confirmacion por que esto es muy importante
        If Not Ask("¿Confirma que desea sobre escribir la base de datos '" & m_fCreateDB.txName.Text & "'?./n/nTODA LA INFORMACION contenida en esta base se PERDERA!!!.") Then
          MustChangeDataBaseName
          Exit Function
        End If
      Else
        MustChangeDataBaseName
        Exit Function
      End If
    End If
    m_MustDropDB = True
  End If
  
  ValidateStep1 = True
End Function

Private Sub MustChangeDataBaseName()
  info "Debe cambiar el nombre de la base de datos"
  SetFocusControl m_fCreateDB.txName
End Sub

Private Sub m_CreateDataBase_AddTask(ByVal Message As String)
  On Error Resume Next
  m_idprgcreatetask = m_fCreateDB.ShowProgress(0, "Creando la tarea " & Message, csIconPrgWait)
End Sub

Private Sub m_CreateDataBase_AddTaskFail(ByVal Message As String)
  On Error Resume Next
  m_idprgcreatetask = m_fCreateDB.ShowProgress(m_idprgcreatetask, "Fallo creación de la tarea " & Message, csIconPrgFail)
  m_fCreateDB.ProgressFull
End Sub

Private Sub m_CreateDataBase_AddTaskSuccess(ByVal Message As String)
  On Error Resume Next
  m_idprgcreatetask = m_fCreateDB.ShowProgress(m_idprgcreatetask, "La tarea " & Message & " se creo con éxito", csIconPrgOk)
  m_fCreateDB.ProgressFull
End Sub

Private Sub m_CreateDataBase_CreatingDataBase(ByVal Message As String)
  On Error Resume Next
  m_idprgcreatedb = m_fCreateDB.ShowProgress(0, "Creando la base de datos " & Message, csIconPrgWait)
End Sub

Private Sub m_CreateDataBase_CreatingDataBaseFail(ByVal Message As String)
  On Error Resume Next
  m_idprgcreatedb = m_fCreateDB.ShowProgress(m_idprgcreatedb, "Fallo creación de la base de datos " & Message, csIconPrgFail)
  m_fCreateDB.ProgressFull
End Sub

Private Sub m_CreateDataBase_CreatingDataBaseSuccess(ByVal Message As String)
  On Error Resume Next
  m_idprgcreatedb = m_fCreateDB.ShowProgress(m_idprgcreatedb, "La base de datos " & Message & " se creo con éxito", csIconPrgOk)
  m_fCreateDB.ProgressFull
End Sub

Private Sub m_CreateDataBase_DropingDataBase(ByVal Message As String)
  On Error Resume Next
  m_idprgdropdb = m_fCreateDB.ShowProgress(0, "Borrando la base de datos " & Message, csIconPrgWait)
End Sub

Private Sub m_CreateDataBase_DropingDataBaseFail(ByVal Message As String)
  On Error Resume Next
  m_idprgdropdb = m_fCreateDB.ShowProgress(m_idprgdropdb, "Fallo eliminación de la base de datos " & Message, csIconPrgFail)
  m_fCreateDB.ProgressFull
End Sub

Private Sub m_CreateDataBase_DropingDataBaseSuccess(ByVal Message As String)
  On Error Resume Next
  m_idprgdropdb = m_fCreateDB.ShowProgress(m_idprgdropdb, "La base de datos " & Message & " se elimino con éxito", csIconPrgOk)
  m_fCreateDB.ProgressFull
End Sub

Private Sub m_CreateDataBase_ScriptBegin(ByVal Message As String)
  m_idprgscript = m_fCreateDB.ShowProgress(0, "Ejecutando script " & Message, csIconPrgWait)
End Sub

Private Sub m_CreateDataBase_ScriptFail(ByVal Message As String)
  m_idprgscript = m_fCreateDB.ShowProgress(m_idprgscript, "Fallo fallo la ejecución del script " & Message, csIconPrgFail)
  m_fCreateDB.ProgressFull
End Sub

Private Sub m_CreateDataBase_ScriptSuccess(ByVal Message As String)
  m_idprgscript = m_fCreateDB.ShowProgress(m_idprgscript, "El script " & Message & " se ejecuto con éxito", csIconPrgOk)
  m_fCreateDB.ProgressFull
End Sub

Private Sub m_CreateDataBase_ScriptProgress(ByVal Percent As Integer, ByVal Descrip As String, Cancel As Boolean)
  On Error Resume Next
  
  m_fCreateDB.Progress Descrip, Percent
  
  Cancel = m_cancel
End Sub

Private Sub m_CreateDataBase_ScriptError(ByVal Descrip As String, ByVal ErrNumber As Long, ByVal sqlstmt As String, Continue As Boolean)
  On Error Resume Next
  
  Select Case ErrNumber
    Case 1913
      ' Ya existe un indice con ese nombre en la tabla
      Continue = True
    
    Case 3701
      ' No puede borrar por que no existe
      Continue = True
  
    Case 1901
      ' No puede crear un indice en una columna de bit data type
      Continue = True
  
    Case 2729
      ' El sp ya existe
      Continue = True
  
    Case 2714
      ' Ya existe un Foreing Key con ese nombre
      Continue = True
  
    Case 208
      ' Nombre de Objeto invalido
      
      ' Esto se loguea como un warning
      Continue = True
      m_MngLog.Log Descrip, sqlstmt
      
      m_Warning = True
  
    Case 439
      ' Imposible encontrar un foreing key aunque la tabla dice que lo tiene
      
      ' Esto se loguea como un warning
      Continue = True
      m_MngLog.Log Descrip, sqlstmt
      
      m_Warning = True
    
    Case Else
      
      If AskUser(Descrip) Then Continue = True
      
      Dim Icon As csIconProgress
      If Continue Then
        Icon = csIconPrgWarning
      Else
        Icon = csIconPrgFail
      End If
      
      Dim Id As Integer
      Id = m_fCreateDB.ShowProgress(0, "Ejecutando script " & Descrip, Icon)
      m_CollError.Add Descrip, "M_" & Id
      m_CollError.Add sqlstmt, "A_" & Id
      
      m_MngLog.Log Descrip, sqlstmt
      
      m_Warning = True
  End Select
End Sub

Private Function AskUser(ByVal ErrDescrip As String) As Boolean
  Dim Msg As String
  
  Msg = "La ejecucion de un script fallo devolviendo el siguiente mensaje:" & vbCrLf & vbCrLf
  Msg = Msg & ErrDescrip & vbCrLf & vbCrLf
  Msg = Msg & "¿Continua con el proceso?"
  
  AskUser = (vbYes = MsgBox(Msg, vbYesNo + vbQuestion))
End Function

Private Sub m_fCreateDB_Cancel()
  On Error GoTo ControlError

  If m_Runing Then

    m_cancel = Ask("¿Confirma que desea cancelar el proceso?")
  
  Else
    
    m_fCreateDB.Hide
    
  End If

  GoTo ExitProc
ControlError:
  MngError Err, "m_fCreateDB_Cancel", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub m_fCreateDB_DoScript()
  On Error GoTo ControlError
  
  Dim File As String
  
  If m_Step = c_step_3_progress Then
    m_MngLog.Show
  Else
    If m_DefDB.IniFile = "" Then
      File = "script1." & csStrDefDataBaseExt
      If Not ShowSaveFileDLG(m_fCreateDB.cd, File, "Archivos script|*." & csStrDefDataBaseExt, "Guardar script") Then Exit Sub
    Else
      File = m_DefDB.IniFile
      FileDelete File
    End If
  End If
  
  CollectData m_DefDB
  
  m_DefDB.SaveDefToIni File
  
  GoTo ExitProc
ControlError:
  MngError Err, "m_fCreateDB_DoScript", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub m_fCreateDB_ErrorDetail(Managed As Boolean, ByVal Id As Integer)
  On Error Resume Next
  
  Dim Descrip As String
  
  Err.Clear
  
  ' m_CollError es una pequeña coleccion con la descripcion de los errores
  Descrip = m_CollError("M_" & Id)
  If Err.Number <> 0 Then Exit Sub
  Descrip = Descrip & vbCrLf & vbCrLf & m_CollError("A_" & Id)
  If Err.Number <> 0 Then Exit Sub
  
  Managed = True
  
  Dim f As fErrorDetail
  Set f = New fErrorDetail
  f.txDetail.Text = Descrip
  f.Icon = m_fCreateDB.liProgress.ListImages(m_fCreateDB.lvProgress.SelectedItem.SmallIcon).Picture
  f.Show vbModal
  Unload f
End Sub

Private Sub m_fCreateDB_FindFile(ByVal Database As String, File As String, ByVal Title As String, Cancel As Boolean)
  On Error GoTo ControlError
  Dim rtn As String
  
  rtn = ShowFindFile(Database, File, Title, m_SQLServer.Conn.Server)
  If rtn = "" Then
    Cancel = True
    Exit Sub
  End If
  
  File = rtn

  GoTo ExitProc
ControlError:
  MngError Err, "m_fCreateDB_FindFile", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub m_fCreateDB_MoveBack()
  On Error GoTo ControlError

  Move csMoveBack

  GoTo ExitProc
ControlError:
  MngError Err, "m_fCreateDB_MoveBack", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub m_fCreateDB_MoveNext()
  On Error GoTo ControlError

  Move csMoveNext

  GoTo ExitProc
ControlError:
  MngError Err, "m_fCreateDB_MoveNext", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub
' construccion - destruccion
Private Sub Class_Initialize()
  On Error GoTo ControlError

  Set m_CollError = New Collection

  GoTo ExitProc
ControlError:
  MngError Err, "Class_Initialize", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub Class_Terminate()
  On Error GoTo ControlError

  Set m_SQLServer = Nothing
  Set m_DefDB = Nothing
  Set m_MngMacro = Nothing
  Set m_MngScript = Nothing
  Set m_CreateDataBase = Nothing
  Set m_MngLog = Nothing
  Set m_CollError = Nothing
  
  GoTo ExitProc
ControlError:
  MngError Err, "Class_Terminate", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
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

