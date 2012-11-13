VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cLockUpdateWindow"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit

'--------------------------------------------------------------------------------
' cLockUpdateWindow
' 28-05-00

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones
    Private Declare Function LockWindowUpdate Lib "user32" (ByVal hwndLock As Long) As Long
    
'--------------------------------------------------------------------------------

' constantes
' estructuras
' variables privadas
Private m_handle As Long
' propiedades publicas
' propiedades privadas
' funciones publicas
Public Sub LockW(ByVal Handle As Long)
    UnLockW

    m_handle = Handle
    
    If m_handle <> 0 Then
        LockWindowUpdate m_handle
    End If
End Sub
Public Sub UnLockW()
    If m_handle <> 0 Then
        LockWindowUpdate 0
        m_handle = 0
    End If
End Sub

' funciones privadas
' construccion - destruccion
Private Sub Class_Initialize()
    m_handle = 0
End Sub

Private Sub Class_Terminate()
    UnLockW
End Sub
