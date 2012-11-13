VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cWizardSteps"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

'--------------------------------------------------------------------------------
' cWizardSteps
' cWizardStep
' 00-11-2002

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

Implements CSInterfacesABM.cIWizardSteps
' constantes
Private Const C_Module = "cWizardSteps"
' estructuras
' variables privadas
Private m_Coll              As Collection
' Eventos
' propiedades publicas
' propiedades privadas
' funciones publicas
Private Function cIWizardSteps_Add(ByVal o As CSInterfacesABM.cIWizardStep, Optional Key As Variant) As CSInterfacesABM.cIWizardStep
    On Error GoTo ControlError

    If o Is Nothing Then Set o = New cWizardStep

    If IsMissing(Key) Then
        m_Coll.Add o
    Else
        m_Coll.Add o, GetKey(Key)
    End If
    
    o.Index = m_Coll.Count
    
    Dim oStep As cWizardStep
    Set oStep = o
    oStep.Key = Key

    Set cIWizardSteps_Add = o
    
    Exit Function
ControlError:
    Set cIWizardSteps_Add = Nothing
End Function

Private Sub cIWizardSteps_Clear()
  CollClear m_Coll
End Sub

Private Function cIWizardSteps_Count() As Long
  On Error GoTo ControlError
  cIWizardSteps_Count = m_Coll.Count
  Exit Function
ControlError:
  cIWizardSteps_Count = 0
End Function

Private Function cIWizardSteps_Item(ByVal kItem As Variant) As CSInterfacesABM.cIWizardStep
  On Error GoTo ControlError
  Set cIWizardSteps_Item = m_Coll(kItem)
  Exit Function
ControlError:
  Err.Clear
End Function

Private Function cIWizardSteps_NewEnum() As stdole.IUnknown
  Set cIWizardSteps_NewEnum = m_Coll.[_NewEnum]
End Function

Private Sub cIWizardSteps_Remove(ByVal kItem As Variant)
  On Error GoTo ControlError
  If VarType(kItem) = vbString Then
    m_Coll.Remove GetIndexFromKey(m_Coll, kItem)
  Else
    m_Coll.Remove kItem
  End If
  Exit Sub
ControlError:
End Sub

' funciones privadas

' construccion - destruccion
Private Sub Class_Initialize()
    Set m_Coll = New Collection
End Sub

Private Sub Class_Terminate()
    CollClear m_Coll
    Set m_Coll = Nothing
End Sub

