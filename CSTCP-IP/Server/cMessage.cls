VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cMessage"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit

'--------------------------------------------------------------------------------
' cMessage
' 09-11-2002

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cMessage"
' estructuras
' variables privadas
Private m_ClientId                      As Long
Private m_ServiceId                     As Long
Private m_MessageId                     As Long
Private m_vMessage()                    As Variant
' eventos
' propiedadades publicas
Public Property Get ClientId() As Long
   ClientId = m_ClientId
End Property

Public Property Let ClientId(ByVal rhs As Long)
   m_ClientId = rhs
End Property

Public Property Get MessageId() As Long
   MessageId = m_MessageId
End Property

Public Property Let MessageId(ByVal rhs As Long)
   m_MessageId = rhs
End Property

Public Property Get ServiceId() As Long
   ServiceId = m_ServiceId
End Property

Public Property Let ServiceId(ByVal rhs As Long)
   m_ServiceId = rhs
End Property
' propiedadades friend
' propiedades privadas
' funciones publicas
Public Sub AddMessage(ByRef ByteArray() As Byte, ByVal IdTCPIP As Long)
  If IdTCPIP > UBound(m_vMessage()) Then ReDim Preserve m_vMessage(IdTCPIP)
  m_vMessage(IdTCPIP) = ByteArray
End Sub

Public Sub GetFullMessage(ByRef ByteArray() As Byte)
  Dim i     As Long
  Dim q     As Long
  Dim j     As Long
  Dim LenV  As Long
  Dim vRtn() As Byte
  
  For i = 1 To UBound(m_vMessage)
    LenV = LenV + UBound(m_vMessage(i)) + 1
  Next
  
  ReDim vRtn(LenV + UBound(ByteArray))
  
  For i = 1 To UBound(m_vMessage)
    For j = 0 To UBound(m_vMessage(i))
      vRtn(q) = m_vMessage(i)(j)
      q = q + 1
    Next
  Next

  For i = 0 To UBound(ByteArray)
    vRtn(q) = ByteArray(i)
    q = q + 1
  Next
  
  ByteArray = vRtn
End Sub
' funciones friend
' funciones privadas
' construccion - destruccion
Private Sub Class_Initialize()
  On Error GoTo ControlError

  ReDim m_vMessage(0)

  GoTo ExitProc
ControlError:
  MngError Err, "Class_Initialize", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
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


