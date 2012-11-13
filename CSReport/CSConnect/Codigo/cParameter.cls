VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cParameter"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

'--------------------------------------------------------------------------------
' cParameter
' 30-10-2001

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
' constantes
' estructuras
' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module As String = "cParameter"
' estructuras
' variables privadas
Private m_Name            As String
Private m_TypeColumn      As CSDataBaseClient2.csDataType
Private m_Value           As String
Private m_Position        As Integer
Private m_Key             As String
Private m_HasDefault      As Boolean
Private m_Default         As String
Private m_IsNullable      As Boolean
Private m_MaxLength       As Long

' eventos
' propiedades publicas
Public Property Get key() As String
  key = m_Key
End Property

Public Property Let key(ByVal rhs As String)
  m_Key = rhs
End Property

Public Property Get Name() As String
  Name = m_Name
End Property

Public Property Let Name(ByVal rhs As String)
  m_Name = rhs
End Property

Public Property Get TypeColumn() As CSDataBaseClient2.csDataType
  TypeColumn = m_TypeColumn
End Property

Public Property Let TypeColumn(ByVal rhs As CSDataBaseClient2.csDataType)
  m_TypeColumn = rhs
End Property

Public Property Get Value() As String
  Value = m_Value
End Property

Public Property Let Value(ByVal rhs As String)
  m_Value = rhs
End Property

Public Property Get Position() As Integer
  Position = m_Position
End Property

Public Property Let Position(ByVal rhs As Integer)
  m_Position = rhs
End Property

Public Property Get HasDefault() As Boolean
  HasDefault = m_HasDefault
End Property

Public Property Let HasDefault(ByVal rhs As Boolean)
  m_HasDefault = rhs
End Property


Public Property Get DefaultValue() As String
  DefaultValue = m_Default
End Property

Public Property Let DefaultValue(ByVal rhs As String)
  m_Default = rhs
End Property

Public Property Get IsNullable() As Boolean
  IsNullable = m_IsNullable
End Property

Public Property Let IsNullable(ByVal rhs As Boolean)
  m_IsNullable = rhs
End Property

Public Property Get MaxLength() As Long
  MaxLength = m_MaxLength
End Property

Public Property Let MaxLength(ByVal rhs As Long)
  m_MaxLength = rhs
End Property


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
'ExitProc:

