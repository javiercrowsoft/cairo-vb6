VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cInternalTimer"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit

'--------------------------------------------------------------------------------
' cWindow
' 00-08-2002

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cWindow"
' estructuras
' variables privadas
Private WithEvents m_Timer1 As cTimer
Attribute m_Timer1.VB_VarHelpID = -1
Private WithEvents m_Timer2 As cTimer
Attribute m_Timer2.VB_VarHelpID = -1
' eventos
' propiedadades publicas
Public Property Get Timer1() As cTimer
  Set Timer1 = m_Timer1
End Property

Public Property Get Timer2() As cTimer
  Set Timer2 = m_Timer2
End Property
' propiedadades friend
' propiedades privadas
' funciones publicas
' funciones friend
' funciones privadas
Private Sub m_Timer1_ThatTime()
  On Error GoTo ControlError

  doTimer1

  GoTo ExitProc
ControlError:
  MngError Err, "m_Timer1_ThatTime", C_Module, ""
  If Err.number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub m_Timer2_ThatTime()
  On Error GoTo ControlError

  doTimer2
  
  GoTo ExitProc
ControlError:
  MngError Err, "m_Timer2_ThatTime", C_Module, ""
  If Err.number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub
' construccion - destruccion
Private Sub Class_Initialize()
  On Error GoTo ControlError

  Set m_Timer1 = New cTimer
  Set m_Timer2 = New cTimer

  GoTo ExitProc
ControlError:
  MngError Err, "Class_Initialize", C_Module, ""
  If Err.number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub Class_Terminate()
  On Error GoTo ControlError

  Set m_Timer1 = Nothing
  Set m_Timer2 = Nothing

  GoTo ExitProc
ControlError:
  MngError Err, "Class_Terminate", C_Module, ""
  If Err.number <> 0 Then Resume ExitProc
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


