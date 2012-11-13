VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cDefDataBase"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

'--------------------------------------------------------------------------------
' cDefDataBase
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
Private Const C_Module = "cDefDataBase"

Private Const c_section = "DEFINITION"
Private Const c_name = "NAME"
Private Const c_datasize = "DATA_SIZE"
Private Const c_logsize = "LOG_SIZE"
Private Const c_datapath = "DATA_PATH"
Private Const c_logpath = "LOG_PATH"
Private Const c_showdefinition = "SHOW_DEFINITION"
Private Const c_showdescript = "SHOW_DESCRIPT"
Private Const c_overwriteifexists = "OVERWRITE_IF_EXISTS"

' estructuras
' variables privadas
Private m_Name                          As String
Private m_DataSize                      As Integer
Private m_LogSize                       As Integer
Private m_LogPath                       As String
Private m_DataPath                      As String
Private m_OverWriteIfExists             As Boolean
Private m_ShowDefinition                As Boolean
Private m_ShowDescrip                   As Boolean

Private m_IniFile     As String
' eventos
' propiedadades publicas

Public Property Get ShowDescrip() As Boolean
   ShowDescrip = m_ShowDescrip
End Property

Public Property Let ShowDescrip(ByVal rhs As Boolean)
   m_ShowDescrip = rhs
End Property

Public Property Get ShowDefinition() As Boolean
   ShowDefinition = m_ShowDefinition
End Property

Public Property Let ShowDefinition(ByVal rhs As Boolean)
   m_ShowDefinition = rhs
End Property

Public Property Get OverWriteIfExists() As Boolean
   OverWriteIfExists = m_OverWriteIfExists
End Property

Public Property Let OverWriteIfExists(ByVal rhs As Boolean)
   m_OverWriteIfExists = rhs
End Property

Public Property Get Name() As String
   Name = m_Name
End Property

Public Property Let Name(ByVal rhs As String)
   m_Name = rhs
End Property

Public Property Get DataSize() As Integer
   DataSize = m_DataSize
End Property

Public Property Let DataSize(ByVal rhs As Integer)
   m_DataSize = rhs
End Property

Public Property Get LogSize() As Integer
   LogSize = m_LogSize
End Property

Public Property Let LogSize(ByVal rhs As Integer)
   m_LogSize = rhs
End Property

Public Property Get LogPath() As String
   LogPath = m_LogPath
End Property

Public Property Let LogPath(ByVal rhs As String)
   m_LogPath = rhs
End Property

Public Property Get DataPath() As String
   DataPath = m_DataPath
End Property

Public Property Let DataPath(ByVal rhs As String)
   m_DataPath = rhs
End Property

Public Property Get IniFile() As String
   IniFile = m_IniFile
End Property
' propiedadades friend
' propiedades privadas
' funciones publicas
Public Function LoadDefFromIni(ByVal IniFile As String) As Boolean
  On Error GoTo ControlError
  
  m_IniFile = IniFile
  
  m_Name = GetIni(c_name, "CairoDB")
  m_DataSize = Val(GetIni(c_datasize, "200"))
  m_LogSize = Val(GetIni(c_logsize, "100"))
  m_LogPath = GetIni(c_logpath, macro_defaultpathlog)
  m_DataPath = GetIni(c_datapath, macro_defaultpathdata)
  m_ShowDefinition = GetIni(c_showdefinition, 1)
  m_OverWriteIfExists = GetIni(c_overwriteifexists, 0)
  m_ShowDescrip = GetIni(c_showdescript, 1)

  LoadDefFromIni = True

  GoTo ExitProc
ControlError:
  MngError Err, "LoadDefFromIni", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Public Function SaveDefToIni(ByVal IniFile As String) As Boolean
  On Error GoTo ControlError
  
  m_IniFile = IniFile

  SaveIni c_name, m_Name
  SaveIni c_datasize, m_DataSize
  SaveIni c_logsize, m_LogSize
  SaveIni c_logpath, m_LogPath
  SaveIni c_datapath, m_DataPath
  SaveIni c_showdefinition, m_ShowDefinition
  SaveIni c_overwriteifexists, m_OverWriteIfExists
  SaveIni c_showdescript, m_ShowDescrip

  SaveDefToIni = True

  GoTo ExitProc
ControlError:
  MngError Err, "SaveDefToIni", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Private Function GetIni(ByVal Item As String, ByVal Default As String) As String
  GetIni = GetIniValue(c_section, Item, Default, m_IniFile)
End Function

Private Sub SaveIni(ByVal Item As String, ByVal Value As Variant)
  SaveIniValue c_section, Item, Value, m_IniFile
End Sub
' funciones friend
' funciones privadas

' construccion - destruccion
Private Sub Class_Initialize()
  On Error GoTo ControlError
  
  m_Name = macro_databasename & macro_customercompanyname
  m_DataSize = 1
  m_LogSize = 1
  m_DataPath = macro_defaultpathdata
  m_LogPath = macro_defaultpathlog
  
  m_ShowDefinition = True
  m_ShowDescrip = True

  GoTo ExitProc
ControlError:
  MngError Err, "Class_Initialize", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub Class_Terminate()
  On Error GoTo ControlError

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



