VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cIWizardGeneric"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

'--------------------------------------------------------------------------------
' cIWizardGeneric
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
' estructuras
' variables privadas
' eventos
' propiedades publicas
Public Property Get EditGeneric() As cIABMGeneric
End Property

Public Property Set EditGeneric(ByRef rhs As cIABMGeneric)
End Property

Public Property Get Steps() As cIWizardSteps
End Property

Public Property Set Steps(ByRef rhs As cIWizardSteps)
End Property

Public Property Get cmdBack() As Object
End Property
Public Property Get cmdNext() As Object
End Property
Public Property Get cmdCancel() As Object
End Property

' propiedades friend
' propiedades privadas
' funciones publicas
Public Function Show(ByVal ObjClientName As String) As Boolean
End Function
Public Sub CloseWizard()
End Sub
Public Function DoNextStep(ByVal CurrentStep As Integer) As Boolean
End Function
Public Function LoadControl(ByRef iProp As cIABMProperty) As Boolean
End Function
Public Sub ShowValue(ByRef iProp As cIABMProperty)
End Sub
Public Sub ResetTabLeftTop(ByVal StepKey As String)
End Sub
' funciones friend
' funciones privadas
' construccion - destruccion
