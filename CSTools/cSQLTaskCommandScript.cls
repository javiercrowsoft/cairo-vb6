VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cSQLTaskCommandScript"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

'--------------------------------------------------------------------------------
' cToolsDeclaration
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
Private Const C_Module = "cToolsDeclaration"

' estructuras
' variables privadas
Private m_Command       As String
Private m_CmdType       As csSchCommandScriptType
Private m_DataBase      As String
Private m_Order         As Integer
Private m_Name          As String
Private m_JobStep       As SQLDMO.JobStep

Private m_Connection  As cConnection
' eventos
' propiedadades publicas
Public Property Get JobStep() As SQLDMO.JobStep
  Set JobStep = m_JobStep
End Property

Public Property Set JobStep(ByRef rhs As SQLDMO.JobStep)
  Set m_JobStep = rhs
  If m_JobStep Is Nothing Then
    m_Command = ""
    m_DataBase = ""
    m_Name = ""
  Else
    m_Command = m_JobStep.command
    m_DataBase = m_JobStep.DataBaseName
    m_Name = m_JobStep.Name
  End If
End Property

Public Property Get DataBase() As String
   DataBase = m_DataBase
End Property

Public Property Let DataBase(ByVal rhs As String)
   m_DataBase = rhs
End Property

Public Property Get command() As String
   command = m_Command
End Property

Public Property Let command(ByVal rhs As String)
   m_Command = rhs
End Property

Public Property Get CmdType() As csSchCommandScriptType
   CmdType = m_CmdType
End Property

Public Property Let CmdType(ByVal rhs As csSchCommandScriptType)
   m_CmdType = rhs
End Property

Private Property Get cISQLTaskStep_CmdType() As csScheduleTaskType
  cISQLTaskStep_CmdType = csSchTypeScript
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

' propiedadades friend
Friend Property Set Conn(ByRef rhs As cConnection)
  Set m_Connection = rhs
End Property
' propiedades privadas
' funciones publicas
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


