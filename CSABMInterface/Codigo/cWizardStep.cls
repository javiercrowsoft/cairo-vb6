VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cWizardStep"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements CSInterfacesABM.cIWizardStep
'--------------------------------------------------------------------------------
' cWizardStep
' 17-07-2003

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cWizardStep"

' estructuras
' variables privadas
Private m_Index              As Integer
Private m_Properties         As cIABMProperties
Private m_TabIndex           As Integer
Private m_Key                As String
' eventos
' propiedades publicas
Private Property Let cIWizardStep_Index(ByVal RHS As Integer)
  m_Index = RHS
End Property

Private Property Get cIWizardStep_Index() As Integer
  cIWizardStep_Index = m_Index
End Property

Private Property Set cIWizardStep_Properties(ByVal RHS As CSInterfacesABM.cIABMProperties)
  Set m_Properties = RHS
End Property

Private Property Get cIWizardStep_Properties() As CSInterfacesABM.cIABMProperties
  Set cIWizardStep_Properties = m_Properties
End Property

Public Property Get TabIndex() As Integer
  TabIndex = m_TabIndex
End Property

Public Property Let TabIndex(ByVal RHS As Integer)
  m_TabIndex = RHS
End Property

Public Property Get Key() As String
  Key = m_Key
End Property

Public Property Let Key(ByVal RHS As String)
  m_Key = RHS
End Property
' propiedades friend
' propiedades privadas
' funciones publicas
' funciones friend
' funciones privadas
' construccion - destruccion
Private Sub Class_Initialize()
  On Error GoTo ControlError

  Set m_Properties = New cABMProperties
  
  GoTo ExitProc
ControlError:
  MngError Err, "Class_Initialize", C_Module, ""
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub Class_Terminate()
  On Error GoTo ControlError

  Set m_Properties = Nothing
  
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


