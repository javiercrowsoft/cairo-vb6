VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cColumnIcon"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

'--------------------------------------------------------------------------------
' cColumnIcon
' 25-08-2002

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cColumnIcon"
' estructuras
' variables privadas
Private m_IconIndex                     As Integer
Private m_Value1                        As Variant
Private m_Value2                        As Variant
Private m_FormulaType                   As csConditionType
' eventos
' propiedades publicas
Public Property Get IconIndex() As Integer
   IconIndex = m_IconIndex
End Property

Public Property Let IconIndex(ByVal RHS As Integer)
   m_IconIndex = RHS
End Property

Public Property Get Value1() As Variant
   Value1 = m_Value1
End Property

Public Property Let Value1(ByVal RHS As Variant)
   m_Value1 = RHS
End Property

Public Property Get Value2() As Variant
   Value2 = m_Value2
End Property

Public Property Let Value2(ByVal RHS As Variant)
   m_Value2 = RHS
End Property

Public Property Get FormulaType() As csConditionType
   FormulaType = m_FormulaType
End Property

Public Property Let FormulaType(ByVal RHS As csConditionType)
   m_FormulaType = RHS
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


