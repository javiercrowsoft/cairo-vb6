VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cMngMacro"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

'--------------------------------------------------------------------------------
' cMngMacro
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
Private Const C_Module = "cMngMacro"

Private Const c_section = "DEFINITION"
Private Const c_databasename = "DATABASE_NAME"
Private Const c_datapath = "DATA_PATH"
Private Const c_logpath = "LOG_PATH"
Private Const c_customercompanyname = "CUSTOMER_COMPANY_NAME"
' estructuras
' variables privadas
Private m_Databasename                  As String
Private m_Defaultpathdata               As String
Private m_Defaultpathlog                As String
Private m_Customercompanyname           As String

Private m_IniFile     As String

Private m_Connection                    As cConnection
' eventos
' propiedadades publicas
Public Property Get DataBaseName() As String
   DataBaseName = m_Databasename
End Property

Public Property Let DataBaseName(ByVal rhs As String)
   m_Databasename = rhs
End Property

Public Property Get Defaultpathdata() As String
   Defaultpathdata = m_Defaultpathdata
End Property

Public Property Let Defaultpathdata(ByVal rhs As String)
   m_Defaultpathdata = rhs
End Property

Public Property Get Defaultpathlog() As String
   Defaultpathlog = m_Defaultpathlog
End Property

Public Property Let Defaultpathlog(ByVal rhs As String)
   m_Defaultpathlog = rhs
End Property

Public Property Get Customercompanyname() As String
   Customercompanyname = m_Customercompanyname
End Property

Public Property Let Customercompanyname(ByVal rhs As String)
   m_Customercompanyname = rhs
End Property

' propiedadades friend
Friend Property Get Conn() As cConnection
   Set Conn = m_Connection
End Property

Friend Property Set Conn(ByRef rhs As cConnection)
  Set m_Connection = rhs
  
  If rhs Is Nothing Then Exit Property
  
  If m_Defaultpathdata = "" Then
    m_Defaultpathdata = FileGetValidPath(rhs.Server.Registry.SQLDataRoot) & "data\"
  End If
  
  If m_Defaultpathlog = "" Then
    m_Defaultpathlog = FileGetValidPath(rhs.Server.Registry.SQLDataRoot) & "data\"
  End If
End Property
' propiedades privadas
' funciones publicas
Public Function LoadMacroFromIni(ByVal IniFile As String) As Boolean
  On Error GoTo ControlError
  
  m_IniFile = IniFile
  
  m_Databasename = GetIni(c_databasename, "CairoDB")
  m_Defaultpathdata = Val(GetIni(c_datapath, "200"))
  m_Defaultpathlog = Val(GetIni(c_logpath, "100"))
  m_Customercompanyname = GetIni(c_customercompanyname, "")

  LoadMacroFromIni = True

  GoTo ExitProc
ControlError:
  MngError Err, "LoadMacroFromIni", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Public Function SaveMacroToIni(ByVal IniFile As String) As Boolean
  On Error GoTo ControlError
  
  m_IniFile = IniFile

  SaveIni c_databasename, m_Databasename
  SaveIni c_datapath, m_Defaultpathdata
  SaveIni c_logpath, m_Defaultpathlog
  SaveIni c_customercompanyname, m_Customercompanyname

  SaveMacroToIni = True

  GoTo ExitProc
ControlError:
  MngError Err, "SaveMacroToIni", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Public Function ResolveMacros(ByVal command As String) As String
  command = Replace(command, macro_databasename, m_Databasename)
  command = Replace(command, macro_customercompanyname, m_Customercompanyname)
  If m_Defaultpathdata <> "" Then
    command = Replace(command, macro_defaultpathdata, m_Defaultpathdata)
  End If
  If m_Defaultpathlog <> "" Then
    command = Replace(command, macro_defaultpathlog, m_Defaultpathlog)
  End If
  ResolveMacros = command
End Function
' funciones friend
' funciones privadas
Private Function GetIni(ByVal Item As String, ByVal Default As String) As String
  GetIni = GetIniValue(c_section, Item, Default, m_IniFile)
End Function

Private Sub SaveIni(ByVal Item As String, ByVal Value As Variant)
  SaveIniValue c_section, Item, Value, m_IniFile
End Sub
' construccion - destruccion
Private Sub Class_Terminate()
  On Error GoTo ControlError
  
  Set m_Connection = Nothing
  
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

