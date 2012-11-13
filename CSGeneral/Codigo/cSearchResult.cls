VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cSearchResult"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

'--------------------------------------------------------------------------------
' cSearchResult
' 19-05-2005

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cSearchResult"
' estructuras
' variables privadas
Private m_Success                       As Boolean
Private m_DoctId                        As Long
Private m_Id                            As Long
Private m_Table                         As String
Private m_Info                          As Variant
' eventos
' propiedades publicas
Public Property Get Success() As Boolean
  Success = m_Success
End Property

Public Property Let Success(ByVal rhs As Boolean)
  m_Success = rhs
End Property

Public Property Get DoctId() As Long
  DoctId = m_DoctId
End Property

Public Property Let DoctId(ByVal rhs As Long)
  m_DoctId = rhs
End Property

Public Property Get Id() As Long
  Id = m_Id
End Property

Public Property Let Id(ByVal rhs As Long)
  m_Id = rhs
End Property

Public Property Get Table() As String
  Table = m_Table
End Property

Public Property Let Table(ByVal rhs As String)
  m_Table = rhs
End Property

Public Property Get Info() As Variant
  Info = m_Info
End Property

Public Property Let Info(ByVal rhs As Variant)
  m_Info = rhs
End Property

' propiedades friend
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
'  If Err.Number Then Resume ExitProc
'ExitProc:
'  On Error Resume Next


