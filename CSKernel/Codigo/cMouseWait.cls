VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cMouseWait"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit
'--------------------------------------------------------------------------------
' cMouseWait
' 21-05-2000

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
Private m_cMouse As cMouse
' propiedades publicas
' propiedades privadas
' Funciones publicas
Public Sub Wait()
    ' Con esto se ejecuta el Initialize
End Sub
' Funciones privadas
' construccion - destruccion

Private Sub Class_Initialize()
  If Not gNoChangeMouseCursor Then
    Set m_cMouse = New cMouse
    m_cMouse.MouseWait
  End If
End Sub
