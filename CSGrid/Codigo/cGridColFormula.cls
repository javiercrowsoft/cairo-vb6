VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cGridColFormula"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

'--------------------------------------------------------------------------------
' cGridColFormula
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
Private Const C_Module = "cGridColFormula"

Public Enum csGridFormulaTypes
  csGrFTSum = 1
  csGrFTMin = 2
  csGrFTMax = 3
  csGrFTAverage = 4
  csGrFTCount = 5
End Enum

' estructuras
' variables privadas
Private m_Column                        As String
Private m_FormulaType                   As csGridFormulaTypes
Private m_ColumnKey                     As String
Private m_Index                         As Long

Private m_IsRowFormula                  As Boolean
Private m_IsRowGroupFormula             As Boolean
Private m_RowKey                        As String

' eventos
' propiedades publicas
Public Property Get IsRowFormula() As Boolean
  IsRowFormula = m_IsRowFormula
End Property

Public Property Let IsRowFormula(ByVal rhs As Boolean)
  m_IsRowFormula = rhs
End Property

Public Property Get IsRowGroupFormula() As Boolean
  IsRowGroupFormula = m_IsRowGroupFormula
End Property

Public Property Let IsRowGroupFormula(ByVal rhs As Boolean)
  m_IsRowGroupFormula = rhs
End Property

Public Property Get RowKey() As String
  RowKey = m_RowKey
End Property

Public Property Let RowKey(ByVal rhs As String)
  m_RowKey = rhs
End Property

Public Property Get Column() As String
   Column = m_Column
End Property

Public Property Let Column(ByVal rhs As String)
   m_Column = rhs
End Property

Public Property Get FormulaType() As csGridFormulaTypes
   FormulaType = m_FormulaType
End Property

Public Property Let FormulaType(ByVal rhs As csGridFormulaTypes)
   m_FormulaType = rhs
End Property

Public Property Get ColumnKey() As String
   ColumnKey = m_ColumnKey
End Property

Public Property Let ColumnKey(ByVal rhs As String)
   m_ColumnKey = rhs
End Property

' propiedades friend
Public Property Get Index() As Long
   Index = m_Index
End Property

Public Property Let Index(ByVal rhs As Long)
   m_Index = rhs
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



