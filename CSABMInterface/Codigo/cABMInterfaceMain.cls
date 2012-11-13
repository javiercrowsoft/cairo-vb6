VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cABMInterfaceMain"
Attribute VB_GlobalNameSpace = True
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

'--------------------------------------------------------------------------------
' cABMInterfaceMain
' 06-06-2003

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cABMInterfaceMain"
' estructuras
' variables privadas
' eventos
' propiedades publicas
Public Property Let AppPath(ByVal rhs As String)
  gAppPath = rhs
End Property

Public Property Let EmpId(ByVal rhs As Long)
  gEmpId = rhs
End Property

Public Property Let EmpNombre(ByVal rhs As String)
  gEmpNombre = rhs
End Property

Public Property Let BackgroundColor(ByVal rhs As Long)
  gBackgroundColor = rhs
End Property


' propiedades friend
' propiedades privadas
' funciones publicas
Public Function CloseDll() As Boolean
  On Error Resume Next
  
  Dim f As Form
  
  DoEvents: DoEvents: DoEvents: DoEvents
  
  gUnloadCancel = False
  Set CSKernelClient2.OForms = Forms
  CSKernelClient2.FreeResource
  
  CloseDll = Not gUnloadCancel
End Function
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

