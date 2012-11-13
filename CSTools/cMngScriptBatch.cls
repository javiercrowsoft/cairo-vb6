VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cMngScriptBatch"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

'--------------------------------------------------------------------------------
' cMngScriptBatch
' 09-06-2002

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cMngScriptBatch"

Private Const c_section = "DEFINITION"
Private Const c_filescount = "FILES_COUNT"
Private Const c_file = "FILE_"
Private Const c_descrip = "DESCRIP_"
Private Const c_type = "TYPE_"
' estructuras
' variables privadas

Private m_IniFile                       As String
Private m_FileCount                     As Integer
Private m_Scripts                       As cDefScripts

Private WithEvents m_fDefScripts As fDefScriptBatch
Attribute m_fDefScripts.VB_VarHelpID = -1
' eventos
' propiedadades publicas
Public Property Get Scripts() As cDefScripts
   Set Scripts = m_Scripts
End Property

Public Property Get IniFile() As String
   IniFile = m_IniFile
End Property

' propiedadades friend
' propiedades privadas
' funciones publicas
Public Function EditScriptIni(ByVal IniFile As String) As Boolean
  On Error GoTo ControlError
  
  If Trim(IniFile) <> "" Then
    If Not LoadScriptFromIni(IniFile) Then Exit Function
  End If
  
  Dim f As fDefScriptBatch
  Set f = New fDefScriptBatch
  Set m_fDefScripts = f
  
  Load f
  
  Dim def As cDefScript
  
  For Each def In m_Scripts
    f.AddScript def.File, def.Descrip, def.ScrType
  Next
  
  Set f.lvScripts.SelectedItem = Nothing
  
  f.Show vbModal
  
  If Not f.Ok Then GoTo ExitProc
  
  m_Scripts.Clear
  
  Dim i As Integer
  
  For i = 1 To f.lvScripts.ListItems.Count
    Set def = m_Scripts.Add(Nothing)
    def.File = f.lvScripts.ListItems(i).Text
    def.Descrip = f.lvScripts.ListItems(i).SubItems(2)
    If f.lvScripts.ListItems(i).SubItems(1) = c_task Then
      def.ScrType = csScrTypeTask
    Else
      def.ScrType = csScrTypeScript
    End If
  Next
  
  If Trim(IniFile) = "" Then
    IniFile = "def_script." & csStrDefScriptBatchExt
    If Not ShowSaveFileDLG(f.cd, IniFile, "Archivos script|*." & csStrDefScriptBatchExt) Then GoTo ExitProc
  Else
    FileDelete IniFile
  End If
  
  If Not SaveScriptToIni(IniFile) Then GoTo ExitProc
  
  EditScriptIni = True

  GoTo ExitProc
ControlError:
  MngError Err, "EditScriptIni", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
  Unload f
  Set f = Nothing
End Function

Public Function LoadScriptFromIni(ByVal IniFile As String) As Boolean
  On Error GoTo ControlError
  Dim i As Integer
  Dim def As cDefScript
  
  m_IniFile = IniFile
  
  m_FileCount = GetIni(c_filescount, "0")
  For i = 1 To m_FileCount
    Set def = m_Scripts.Add(Nothing)
    def.File = GetIni(c_file & i, "")
    def.Descrip = GetIni(c_descrip & i, "")
    def.ScrType = Val(GetIni(c_type & i, csScrTypeScript))
  Next

  LoadScriptFromIni = True

  GoTo ExitProc
ControlError:
  MngError Err, "LoadScriptFromIni", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Public Function SaveScriptToIni(ByVal IniFile As String) As Boolean
  On Error GoTo ControlError
  Dim def As cDefScript
  Dim i   As Integer
  
  m_IniFile = IniFile

  SaveIni c_filescount, m_Scripts.Count
  For Each def In m_Scripts
    i = i + 1
    SaveIni c_file & i, def.File
    SaveIni c_descrip & i, def.Descrip
    SaveIni c_type & i, def.ScrType
  Next
  
  SaveScriptToIni = True
  
  GoTo ExitProc
ControlError:
  MngError Err, "SaveScriptToIni", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

' funciones friend
' funciones privadas
Private Function GetIni(ByVal Item As String, ByVal Default As String) As String
  GetIni = GetIniValue(c_section, Item, Default, m_IniFile)
End Function

Private Sub SaveIni(ByVal Item As String, ByVal Value As Variant)
  SaveIniValue c_section, Item, Value, m_IniFile
End Sub

Private Sub m_fDefScripts_FindFile(File As String, Cancel As Boolean)
  On Error GoTo ControlError
  
  Cancel = Not ShowOpenFileDLG(m_fDefScripts.cd, File, "Archivos de Script|*.sql;*.task|Script|*.sql|Tareas|*.Task")
  
  GoTo ExitProc
ControlError:
  MngError Err, "m_fDefScripts_FindFile", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

' construccion - destruccion
Private Sub Class_Terminate()
  On Error GoTo ControlError
  
  Set m_Scripts = Nothing
  Set m_fDefScripts = Nothing
  
  GoTo ExitProc
ControlError:
  MngError Err, "Class_Terminate", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub Class_Initialize()
  On Error GoTo ControlError
  
  Set m_Scripts = New cDefScripts
    
  GoTo ExitProc
ControlError:
  MngError Err, "Class_Initialize", C_Module, ""
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


