VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cGridGroupRow"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

'--------------------------------------------------------------------------------
' cGridGroupRow
' 19-11-2003

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cGridGroupRow"
' estructuras
' variables privadas
Private m_Expanded                      As Boolean
Private m_lRow                          As Long
Private m_GroupValue                    As String
Private m_IsValid                       As Boolean
Private m_lLastRow                      As Long
' eventos
' propiedades publicas
Public Property Get Expanded() As Boolean
  Expanded = m_Expanded
End Property

Public Property Let Expanded(ByVal rhs As Boolean)
  m_Expanded = rhs
End Property

Public Property Get RowIndex() As Long
  RowIndex = m_lRow
End Property

Public Property Get GroupValue() As String
  GroupValue = m_GroupValue
End Property

' propiedades friend
Public Property Let RowIndex(ByVal rhs As Long)
  m_lRow = rhs
End Property

Public Property Let GroupValue(ByVal rhs As String)
  m_GroupValue = rhs
End Property

Public Property Get IsValid() As Boolean
  IsValid = m_IsValid
End Property

Public Property Let IsValid(ByVal rhs As Boolean)
  m_IsValid = rhs
End Property

Friend Property Get LastRow() As Long
  LastRow = m_lLastRow
End Property

Friend Property Let LastRow(ByVal rhs As Long)
  m_lLastRow = rhs
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
'  If Err.Number <> 0 Then Resume ExitProc
'ExitProc:
'  On Error Resume Next


