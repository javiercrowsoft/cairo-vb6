VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cABMProperties"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements CSInterfacesABM.cIABMProperties

'--------------------------------------------------------------------------------
' cABMProperties
' 07-01-01

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
Private m_Coll              As Collection
Private m_WizardGeneric     As Object
Private m_StepIndex         As Integer

' eventos
' propiedades publicas
Public Property Set WizardGeneric(ByVal rhs As Object)
  Set m_WizardGeneric = rhs
End Property

Public Property Let StepIndex(ByVal rhs As Integer)
   m_StepIndex = rhs
End Property

' propiedades privadas
' funciones publicas
' funciones privadas
Private Function cIABMProperties_Add(ByVal o As CSInterfacesABM.cIABMProperty, Optional Key As Variant) As CSInterfacesABM.cIABMProperty
    On Error GoTo ControlError

    If o Is Nothing Then Set o = New cABMProperty

    If IsMissing(Key) Then
        m_Coll.Add o
    Else
        m_Coll.Add o, GetKey(Key)
        Dim o2 As cABMProperty
        Set o2 = o
        o2.KeyCol = Key
    End If

    Set cIABMProperties_Add = o
    
    If Not m_WizardGeneric Is Nothing Then m_WizardGeneric.Add o, m_StepIndex
    
    Exit Function
ControlError:
    Set cIABMProperties_Add = Nothing

End Function

Private Sub cIABMProperties_Clear()
  If Not m_WizardGeneric Is Nothing Then m_WizardGeneric.Clear m_StepIndex
  CollClear m_Coll
End Sub

Private Function cIABMProperties_Count() As Long
    cIABMProperties_Count = m_Coll.Count
End Function

Private Function cIABMProperties_Item(ByVal kItem As Variant) As CSInterfacesABM.cIABMProperty
    On Error GoTo ControlError
    If VarType(kItem) <> vbInteger And VarType(kItem) <> vbLong Then
      If IsNumeric(kItem) Then kItem = GetKey(kItem)
    End If
    Set cIABMProperties_Item = m_Coll(kItem)
    Exit Function
ControlError:
    Err.Clear
End Function

Private Function cIABMProperties_NewEnum() As stdole.IUnknown
    Set cIABMProperties_NewEnum = m_Coll.[_NewEnum]
End Function

Private Sub cIABMProperties_Remove(ByVal kItem As Variant)
  If Not m_WizardGeneric Is Nothing Then m_WizardGeneric.Remove kItem, m_StepIndex
  m_Coll.Remove kItem
End Sub

' construccion - destruccion
Private Sub Class_Initialize()
    Set m_Coll = New Collection
End Sub

Private Sub Class_Terminate()
    CollClear m_Coll
    Set m_Coll = Nothing
End Sub
