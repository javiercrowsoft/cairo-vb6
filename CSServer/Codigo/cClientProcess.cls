VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cClientProcess"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

'--------------------------------------------------------------------------------
' cClientProcess
' 14-04-2003

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cClientProcess"
' estructuras
' variables privadas
Private m_ClientProcessId               As Long
Private m_ClientUser                    As String
Private m_ClientComputer                As String
Private m_ClientConnected               As Date
Private m_ClientState                   As csClientProcessState
Private m_TCP_ID                        As Long
Private m_IsMonitor                     As Boolean
Private m_IsChat                        As Boolean
Private m_Key                           As String
Private m_ConnectString                 As String
Private m_UsID                          As Long
Private m_IsInternal                    As Boolean

' eventos
' propiedadades publicas

Public Property Get ClientProcessId() As Long
   ClientProcessId = m_ClientProcessId
End Property

Public Property Let ClientProcessId(ByVal rhs As Long)
   m_ClientProcessId = rhs
End Property

Public Property Get ClientUser() As String
   ClientUser = m_ClientUser
End Property

Public Property Let ClientUser(ByVal rhs As String)
   m_ClientUser = rhs
End Property

Public Property Get ClientComputer() As String
   ClientComputer = m_ClientComputer
End Property

Public Property Let ClientComputer(ByVal rhs As String)
   m_ClientComputer = rhs
End Property

Public Property Get ClientConnected() As Date
   ClientConnected = m_ClientConnected
End Property

Public Property Let ClientConnected(ByVal rhs As Date)
   m_ClientConnected = rhs
End Property

Public Property Get ClientState() As csClientProcessState
   ClientState = m_ClientState
End Property

Public Property Let ClientState(ByVal rhs As csClientProcessState)
   m_ClientState = rhs
End Property

Public Property Get TCP_ID() As Long
   TCP_ID = m_TCP_ID
End Property

Public Property Let TCP_ID(ByVal rhs As Long)
   m_TCP_ID = rhs
End Property

Public Property Get IsMonitor() As Boolean
   IsMonitor = m_IsMonitor
End Property

Public Property Let IsMonitor(ByVal rhs As Boolean)
   m_IsMonitor = rhs
End Property

Public Property Get IsChat() As Boolean
   IsChat = m_IsChat
End Property

Public Property Let IsChat(ByVal rhs As Boolean)
   m_IsChat = rhs
End Property

Public Property Get IsInternal() As Boolean
   IsInternal = m_IsInternal
End Property

Public Property Let IsInternal(ByVal rhs As Boolean)
   m_IsInternal = rhs
End Property

Public Property Get Key() As String
   Key = m_Key
End Property

Public Property Get ConnectString() As String
   ConnectString = m_ConnectString
End Property

Public Property Let ConnectString(ByVal rhs As String)
   m_ConnectString = rhs
End Property

Public Property Get UsID() As Long
   UsID = m_UsID
End Property

Public Property Let UsID(ByVal rhs As Long)
   m_UsID = rhs
End Property

' propiedadades friend
' propiedades privadas
' funciones publicas
Public Sub SetKey(ByVal rhs As String)
   m_Key = rhs
End Sub

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

