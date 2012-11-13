VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cABMDocProperties"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

'--------------------------------------------------------------------------------
' cABMDocProperties
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
Private Const C_Module = "cABMDocProperties"
' estructuras
' variables privadas
Private m_ImageList                     As Object
Private m_HaveDetail                   As Boolean
Private m_Columns                       As cABMDocPropertiesCols
Private m_StartRowText                  As Integer

' eventos
' propiedades publicas
Public Property Get ImageList() As Object
   Set ImageList = m_ImageList
End Property

Public Property Set ImageList(ByRef RHS As Object)
   Set m_ImageList = RHS
End Property

Public Property Get HaveDetail() As Boolean
   HaveDetail = m_HaveDetail
End Property

Public Property Let HaveDetail(ByVal RHS As Boolean)
   m_HaveDetail = RHS
End Property

Public Property Get Columns() As cABMDocPropertiesCols
   Set Columns = m_Columns
End Property

Public Property Set Columns(ByRef RHS As cABMDocPropertiesCols)
   Set m_Columns = RHS
End Property

Public Property Get StartRowText() As Integer
   StartRowText = m_StartRowText
End Property

Public Property Let StartRowText(ByVal RHS As Integer)
   m_StartRowText = RHS
End Property

' propiedades friend
' propiedades privadas
' funciones publicas
' funciones friend
' funciones privadas
' construccion - destruccion
Private Sub Class_Initialize()
  On Error GoTo ControlError
  
  Set m_Columns = New cABMDocPropertiesCols

  GoTo ExitProc
ControlError:
  MngError Err, "", C_Module, ""
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub Class_Terminate()
  On Error GoTo ControlError

  Set m_Columns = Nothing
  Set m_ImageList = Nothing
  
  GoTo ExitProc
ControlError:
  MngError Err, "Class_Terminate", C_Module, ""
  If Err.Number Then Resume ExitProc
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
'  If Err.Number Then Resume ExitProc
'ExitProc:
'  On Error Resume Next


