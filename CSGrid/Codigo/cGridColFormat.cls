VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cGridColFormat"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

'--------------------------------------------------------------------------------
' cGridColFormat
' 20-11-2003

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cGridColFormat"

Public Enum csGridFormatOperator
  csGrFOEqual = 1
  csGrFOMajor = 2
  csGrFOMinor = 3
  csGrFONotEqual = 4
  csGrFOLike = 5
  csGrFOEndLike = 6
  csGrFOStartLike = 7
End Enum

' estructuras
' variables privadas
Private m_Column                        As String
Private m_Column2                       As String
Private m_ColumnKey                     As String
Private m_Operator                      As csGridFormatOperator
Private m_ColumnKey2                    As String
Private m_CompareTo                     As String
Private m_Font                          As StdFont
Private m_BackColor                     As Long
Private m_ForeColor                     As Long

' eventos
' propiedades publicas
Public Property Get Column() As String
   Column = m_Column
End Property

Public Property Let Column(ByVal rhs As String)
   m_Column = rhs
End Property

Public Property Get Column2() As String
   Column2 = m_Column2
End Property

Public Property Let Column2(ByVal rhs As String)
   m_Column2 = rhs
End Property

Public Property Get ColumnKey() As String
   ColumnKey = m_ColumnKey
End Property

Public Property Let ColumnKey(ByVal rhs As String)
   m_ColumnKey = rhs
End Property

Public Property Get Operator() As csGridFormatOperator
   Operator = m_Operator
End Property

Public Property Let Operator(ByVal rhs As csGridFormatOperator)
   m_Operator = rhs
End Property

Public Property Get ColumnKey2() As String
   ColumnKey2 = m_ColumnKey2
End Property

Public Property Let ColumnKey2(ByVal rhs As String)
   m_ColumnKey2 = rhs
End Property

Public Property Get CompareTo() As String
   CompareTo = m_CompareTo
End Property

Public Property Let CompareTo(ByVal rhs As String)
   m_CompareTo = rhs
End Property

Public Property Get Font() As StdFont
   Set Font = m_Font
End Property

Public Property Set Font(ByRef rhs As StdFont)
   Set m_Font = rhs
End Property

Public Property Get BackColor() As Long
   BackColor = m_BackColor
End Property

Public Property Let BackColor(ByVal rhs As Long)
   m_BackColor = rhs
End Property

Public Property Get ForeColor() As Long
   ForeColor = m_ForeColor
End Property

Public Property Let ForeColor(ByVal rhs As Long)
   m_ForeColor = rhs
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
'  If Err.Number <> 0 Then Resume ExitProc
'ExitProc:
'  On Error Resume Next




Private Sub Class_Initialize()
  m_ForeColor = -1
  m_BackColor = -1
End Sub
