VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cMouse"
Attribute VB_GlobalNameSpace = True
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit

'--------------------------------------------------------------------------------
' cMouse
' 02-01-01

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' Funciones

'--------------------------------------------------------------------------------

' constantes
' estructuras
' variables privadas
Private m_OldMouse As MousePointerConstants
' propiedades publicas
' propiedades privadas
' Funciones publicas
Public Function MouseWait() As MousePointerConstants
  DoEvents: DoEvents
  m_OldMouse = Screen.MousePointer
  MouseWait = m_OldMouse
  Screen.MousePointer = vbHourglass
  DoEvents: DoEvents
End Function

Public Function MouseSet(ByVal TypePointer As MousePointerConstants) As MousePointerConstants
  DoEvents: DoEvents
  m_OldMouse = Screen.MousePointer
  MouseSet = m_OldMouse
  Screen.MousePointer = TypePointer
  DoEvents: DoEvents
End Function

Public Function MouseDefault() As MousePointerConstants
  DoEvents: DoEvents
  m_OldMouse = Screen.MousePointer
  MouseDefault = m_OldMouse
  Screen.MousePointer = vbDefault
  DoEvents: DoEvents
End Function

' Funciones privadas

' construccion - destruccion
Private Sub Class_Initialize()
  m_OldMouse = Screen.MousePointer
End Sub
Private Sub Class_Terminate()
  Screen.MousePointer = m_OldMouse
End Sub
