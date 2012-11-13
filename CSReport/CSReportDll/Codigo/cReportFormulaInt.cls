VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cReportFormulaInt"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit
'--------------------------------------------------------------------------------
' cReportFormulaInt
' 18-09-2001

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
' constantes
' estructuras
' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module As String = "cReportFormulaInt"
' estructuras
' variables privadas
Private m_Variables As cReportVariables
Private m_Parameters As cReportFormulaParameters
Private m_FormulaType As Integer
' eventos
' propiedades publicas
' propiedades friend
Friend Property Get Variables() As cReportVariables
  Set Variables = m_Variables
End Property

Friend Property Get Parameters() As cReportFormulaParameters
  Set Parameters = m_Parameters
End Property
' propiedades privadas
' funciones publicas
Public Property Get FormulaType() As Integer
  FormulaType = m_FormulaType
End Property

Public Property Let FormulaType(ByVal rhs As Integer)
  m_FormulaType = rhs
End Property
' funciones friend
' funciones privadas
' construccion - destruccion
Private Sub Class_Initialize()
  Set m_Variables = New cReportVariables
  Set m_Parameters = New cReportFormulaParameters
End Sub

Private Sub Class_Terminate()
  Set m_Variables = Nothing
  Set m_Parameters = Nothing
End Sub

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

