VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cProcess"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

'--------------------------------------------------------------------------------
' cProcess
' 19-08-2002

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cProcess"
' estructuras
' variables privadas
Private m_Blocked                       As Integer
Private m_Cmd                           As String
Private m_Cpu                           As Long
Private m_Dbname                        As String
Private m_Hostname                      As String
Private m_Loginname                     As String
Private m_Memusage                      As Long
Private m_ProgramName                   As String
Private m_Spid                          As Integer
Private m_Status                        As String
Private m_Ecid                          As Integer

' eventos
' propiedadades publicas
Public Property Get Blocked() As Integer
   Blocked = m_Blocked
End Property

Public Property Let Blocked(ByVal rhs As Integer)
   m_Blocked = rhs
End Property

Public Property Get Cmd() As String
   Cmd = m_Cmd
End Property

Public Property Let Cmd(ByVal rhs As String)
   m_Cmd = rhs
End Property

Public Property Get Cpu() As Long
   Cpu = m_Cpu
End Property

Public Property Let Cpu(ByVal rhs As Long)
   m_Cpu = rhs
End Property

Public Property Get Dbname() As String
   Dbname = m_Dbname
End Property

Public Property Let Dbname(ByVal rhs As String)
   m_Dbname = rhs
End Property

Public Property Get Hostname() As String
   Hostname = m_Hostname
End Property

Public Property Let Hostname(ByVal rhs As String)
   m_Hostname = rhs
End Property

Public Property Get Loginname() As String
   Loginname = m_Loginname
End Property

Public Property Let Loginname(ByVal rhs As String)
   m_Loginname = rhs
End Property

Public Property Get Memusage() As Long
   Memusage = m_Memusage
End Property

Public Property Let Memusage(ByVal rhs As Long)
   m_Memusage = rhs
End Property

Public Property Get ProgramName() As String
   ProgramName = m_ProgramName
End Property

Public Property Let ProgramName(ByVal rhs As String)
   m_ProgramName = rhs
End Property

Public Property Get Spid() As Integer
   Spid = m_Spid
End Property

Public Property Let Spid(ByVal rhs As Integer)
   m_Spid = rhs
End Property

Public Property Get Status() As String
   Status = m_Status
End Property

Public Property Let Status(ByVal rhs As String)
   m_Status = rhs
End Property

Public Property Get Ecid() As Integer
   Ecid = m_Ecid
End Property

Public Property Let Ecid(ByVal rhs As Integer)
   m_Ecid = rhs
End Property

' propiedadades friend
' propiedades privadas
' funciones publicas
' funciones friend
' funciones privadas
' construccion - destruccion

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


