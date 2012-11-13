VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cSQLTaskCommandBackup"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

'--------------------------------------------------------------------------------
' cSQLTaskCommandBackup
' 17-05-2002

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' interfaces
Implements cISQLTaskStep

' constantes
Private Const C_Module = "cSQLTaskCommandBackup"

' estructuras
' variables privadas
Private m_DataBase      As String
Private m_IsFull        As Boolean    ' Hace un backup de data
Private m_IsLog         As Boolean    ' Hace un backup del log
Private m_InitLog       As Boolean    ' Inicializa el Log
Private m_FileDataBase                  As String
Private m_FileLog                       As String
Private m_OverWrite                     As Boolean
Private m_LogUseDefaultPath             As Boolean
Private m_DataBaseUseDefaultPath        As Boolean
Private m_Order                         As Integer
Private m_Name                          As String

Private m_Connection  As cConnection
' eventos
' propiedadades publicas
Public Property Get OverWrite() As Boolean
   OverWrite = m_OverWrite
End Property

Public Property Let OverWrite(ByVal rhs As Boolean)
   m_OverWrite = rhs
End Property

Public Property Get DataBase() As String
   DataBase = m_DataBase
End Property

Public Property Let DataBase(ByVal rhs As String)
   m_DataBase = rhs
End Property

Public Property Get IsFull() As Boolean
   IsFull = m_IsFull
End Property

Public Property Let IsFull(ByVal rhs As Boolean)
   m_IsFull = rhs
End Property

Public Property Get IsLog() As Boolean
   IsLog = m_IsLog
End Property

Public Property Let IsLog(ByVal rhs As Boolean)
   m_IsLog = rhs
End Property

Public Property Get InitLog() As Boolean
   InitLog = m_InitLog
End Property

Public Property Let InitLog(ByVal rhs As Boolean)
   m_InitLog = rhs
End Property

Public Property Get FileDataBase() As String
   FileDataBase = m_FileDataBase
End Property

Public Property Let FileDataBase(ByVal rhs As String)
   m_FileDataBase = rhs
End Property

Public Property Get FileLog() As String
   FileLog = m_FileLog
End Property

Public Property Let FileLog(ByVal rhs As String)
   m_FileLog = rhs
End Property

Public Property Get LogUseDefaultPath() As Boolean
   LogUseDefaultPath = m_LogUseDefaultPath
End Property

Public Property Let LogUseDefaultPath(ByVal rhs As Boolean)
   m_LogUseDefaultPath = rhs
End Property

Public Property Get DataBaseUseDefaultPath() As Boolean
   DataBaseUseDefaultPath = m_DataBaseUseDefaultPath
End Property

Public Property Let DataBaseUseDefaultPath(ByVal rhs As Boolean)
   m_DataBaseUseDefaultPath = rhs
End Property

Public Property Get command() As String
  Dim rtn As String
  
  If m_IsFull Then
    
    rtn = "BACKUP DATABASE " & m_DataBase & " TO DISK='"
    If m_DataBaseUseDefaultPath Then
      rtn = rtn & FileGetValidPath(m_Connection.Server.Registry.SQLRootPath) & "Backup\" & m_FileDataBase & "'"
    Else
      rtn = rtn & m_FileDataBase & "'"
    End If
    rtn = rtn & " WITH NOUNLOAD ,  NOSKIP"
    If m_OverWrite Then
      rtn = rtn & ",  INIT"
    End If
  End If
  
  If m_IsLog Then
    rtn = rtn & "BACKUP LOG " & m_DataBase & " TO DISK '"
    If m_LogUseDefaultPath Then
      rtn = rtn & FileGetValidPath(m_Connection.Server.Registry.SQLRootPath) & "Backup\" & m_FileLog & "'"
    Else
      rtn = rtn & m_FileLog & "'"
    End If
    rtn = rtn & "WITH NOINIT , NOUNLOAD"
    If m_InitLog Then
      rtn = rtn & "NOSKIP"
    End If
  End If
  
  command = rtn
End Property

' propiedadades friend
Friend Property Set Conn(ByRef rhs As cConnection)
  Set m_Connection = rhs
End Property
' propiedades privadas
' funciones publicas
Public Function ShowFindFileBackup(ByVal DataBase As String, ByVal File As String, ByVal Title As String) As String
  ShowFindFileBackup = ShowFindFile(DataBase, File, Title, m_Connection.Server)
End Function

Private Property Get cISQLTaskStep_CmdType() As csScheduleTaskType
  cISQLTaskStep_CmdType = csSchTypeBackup
End Property

Public Property Get Name() As String
   Name = m_Name
End Property

Public Property Let Name(ByVal rhs As String)
   m_Name = rhs
End Property

Private Property Get cISQLTaskStep_Name() As String
   cISQLTaskStep_Name = m_Name
End Property

Private Property Let cISQLTaskStep_Order(ByVal rhs As Integer)
  m_Order = rhs
End Property

Private Property Get cISQLTaskStep_Order() As Integer
  cISQLTaskStep_Order = m_Order
End Property

' funciones friend
' funciones privadas
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


