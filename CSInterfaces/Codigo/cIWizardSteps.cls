VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cIWizardSteps"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit
'--------------------------------------------------------------------------------
' cIWizardSteps
' 03-01-01

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
' Properties publicas
' Properties privadas
' funciones publicas
Public Function Add(ByVal o As cIWizardStep, Optional Key As Variant) As cIWizardStep
End Function
Public Sub Remove(ByVal kItem As Variant)
End Sub
Public Function Count() As Long
End Function
Public Function Item(ByVal kItem As Variant) As cIWizardStep
Attribute Item.VB_UserMemId = 0
End Function
Public Function NewEnum() As IUnknown
Attribute NewEnum.VB_UserMemId = -4
End Function
Public Sub Clear()
End Sub
' funciones privadas
' construccion - destruccion



