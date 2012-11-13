VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cReportCompilerGlobals"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

'--------------------------------------------------------------------------------
' cReportCompilerGlobals
' 13-03-2009

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
' constantes
' estructuras
' funciones

'--------------------------------------------------------------------------------

' Clase base
' constantes
Private Const C_Module As String = "cReportCompilerGlobals"

' estructuras
' variables privadas
Private m_Coll As Collection
Private m_Mode As Long
' propiedades publicas
Public Property Get Mode() As Long
  Mode = m_Mode
End Property
' propiedades friend
Friend Property Let Mode(ByVal rhs As Long)
  m_Mode = rhs
End Property
' propiedades privadas
' funciones publicas
Public Function AddVar(ByVal varName As String) As cReportCompilerVar
  On Error GoTo ControlError
  
  m_Coll.Add New cReportCompilerVar, varName
    
  Set AddVar = GetVar(varName)
  
  Exit Function
ControlError:
  Set AddVar = Nothing
End Function

Public Sub Clear()
  On Error GoTo ControlError
  Dim i As Long
  
  For i = 1 To m_Coll.Count
    Remove 1
  Next
  
  Exit Sub
ControlError:
End Sub

Public Sub Remove(ByVal varIdx As Variant)
  On Error GoTo ControlError
  m_Coll.Remove varIdx
  Exit Sub
ControlError:
End Sub

Public Function Count() As Long
  On Error GoTo ControlError
  Count = m_Coll.Count()
  Exit Function
ControlError:
  Count = 0
End Function

Public Function GetVar(ByVal varName As String) As cReportCompilerVar
Attribute GetVar.VB_UserMemId = 0
  On Error GoTo ControlError
  Set GetVar = m_Coll.Item(varName)
  Exit Function
ControlError:
End Function

' funciones privadas
Public Function NewEnum() As IUnknown
Attribute NewEnum.VB_UserMemId = -4
  Set NewEnum = m_Coll.[_NewEnum]
End Function

' construccion - destruccion
Private Sub Class_Initialize()
#If PREPROC_DEBUG Then
  gdbInitInstance C_Module
#End If
  
  Set m_Coll = New Collection
End Sub

Private Sub Class_Terminate()
  CollClear m_Coll
  Set m_Coll = Nothing

#If PREPROC_DEBUG Then
  gdbTerminateInstance C_Module
#End If
End Sub


