VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cLock"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

'--------------------------------------------------------------------------------
' cLock
' 21-08-2002

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cLock"
' estructuras
' variables privadas
' eventos
' propiedadades publicas
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


Private m_DbName                        As String
Private m_IndexName                     As String
Private m_LockType                      As String
Private m_ReqSpid                       As Long
Private m_Status                        As Integer
Private m_TableName                     As String

Public Property Get DbName() As String
   DbName = m_DbName
End Property

Public Property Let DbName(ByVal rhs As String)
   m_DbName = rhs
End Property

Public Property Get IndexName() As String
   IndexName = m_IndexName
End Property

Public Property Let IndexName(ByVal rhs As String)
   m_IndexName = rhs
End Property

Public Property Get LockType() As String
   LockType = m_LockType
End Property

Public Property Let LockType(ByVal rhs As String)
   m_LockType = rhs
End Property

Public Property Get ReqSpid() As Long
   ReqSpid = m_ReqSpid
End Property

Public Property Let ReqSpid(ByVal rhs As Long)
   m_ReqSpid = rhs
End Property

Public Property Get Status() As Integer
   Status = m_Status
End Property

Public Property Let Status(ByVal rhs As Integer)
   m_Status = rhs
End Property

Public Property Get TableName() As String
   TableName = m_TableName
End Property

Public Property Let TableName(ByVal rhs As String)
   m_TableName = rhs
End Property


