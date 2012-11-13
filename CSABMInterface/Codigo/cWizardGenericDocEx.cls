VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cWizardGenericDocEx"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements CSInterfacesABM.cIWizardGeneric
Implements CSInterfacesABM.cIABMClient
Implements CSInterfacesABM.cIABMClientGrid
'--------------------------------------------------------------------------------
' cWizardGenericDocEx
' 18-05-2004

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cWizardGenericDocEx"

' estructuras
' variables privadas
Private m_EditGeneric         As cABMGenericDocEx
Private m_Steps               As cIWizardSteps
Private m_ObjClient           As cIWizardClient

Private m_CurrentStep     As Integer
Private m_WizardShowed    As Boolean
' eventos
' propiedades publicas
Public Property Get ObjAbm() As cIABMGeneric
  Set ObjAbm = m_EditGeneric
End Property

Public Property Get ObjClient() As cIWizardClient
  Set ObjClient = m_ObjClient
End Property

Public Property Set ObjClient(ByRef rhs As cIWizardClient)
  Set m_ObjClient = rhs
End Property

Public Sub ShowValue(iProp As CSInterfacesABM.cIABMProperty, Optional ByVal NoChangeColumns As Boolean, Optional ByVal strTag As String)
  m_EditGeneric.ShowValue iProp, NoChangeColumns, strTag
End Sub

' cIABMClient
Private Function cIABMClient_Copy() As Boolean
  
End Function

Private Function cIABMClient_EditNew() As Boolean

End Function

Private Property Get cIABMClient_Title() As String
  cIABMClient_Title = m_ObjClient.Title
End Property

Private Function cIABMClient_Validate() As Boolean
  cIABMClient_Validate = True
End Function

Private Property Get cIABMClient_Aplication() As String

End Property

Private Property Get cIABMClient_CanAddDocDigital() As Boolean
End Property

Private Property Get cIABMClient_CanCopy() As Boolean
End Property

Private Property Get cIABMClient_CanNew() As Boolean
End Property

Private Function cIABMClient_ShowDocDigital() As Boolean
End Function

Private Function cIABMClient_MessageEx(ByVal MessageID As Long, ByVal Info As Variant) As Variant
  cIABMClient_MessageEx = True
End Function

' Client Grid
Private Function pGetClientGrid() As cIABMClientGrid
  Set pGetClientGrid = m_ObjClient
End Function

Private Function cIABMClientGrid_ColumnAfterEdit(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long, ByVal NewValue As Variant, ByVal NewValueID As Long) As Boolean
  cIABMClientGrid_ColumnAfterEdit = pGetClientGrid.ColumnAfterEdit(Key, lRow, lCol, NewValue, NewValueID)
End Function

Private Function cIABMClientGrid_ColumnAfterUpdate(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long) As Boolean
  cIABMClientGrid_ColumnAfterUpdate = pGetClientGrid.ColumnAfterUpdate(Key, lRow, lCol)
End Function

Private Function cIABMClientGrid_ColumnBeforeEdit(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long, ByVal iKeyAscii As Integer) As Boolean
  cIABMClientGrid_ColumnBeforeEdit = pGetClientGrid.ColumnBeforeEdit(Key, lRow, lCol, iKeyAscii)
End Function

Private Function cIABMClientGrid_ColumnButtonClick(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long, ByVal iKeyAscii As Integer) As Boolean
  cIABMClientGrid_ColumnButtonClick = pGetClientGrid.ColumnButtonClick(Key, lRow, lCol, iKeyAscii)
End Function

Private Sub cIABMClientGrid_ColumnCancelEdit(ByVal Key As Integer)
  pGetClientGrid.ColumnCancelEdit Key
End Sub

Private Sub cIABMClientGrid_ColumnClick(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long)
  pGetClientGrid.ColumnClick Key, lRow, lCol
End Sub

Private Sub cIABMClientGrid_DblClick(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long)
  pGetClientGrid.DblClick Key, lRow, lCol
End Sub

Private Function cIABMClientGrid_DeleteRow(ByVal Key As Integer, Row As CSInterfacesABM.cIABMGridRow, ByVal lRow As Long) As Boolean
  cIABMClientGrid_DeleteRow = pGetClientGrid.DeleteRow(Key, Row, lRow)
End Function

Private Function cIABMClientGrid_IsEmptyRow(ByVal Key As Integer, Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  cIABMClientGrid_IsEmptyRow = pGetClientGrid.IsEmptyRow(Key, Row, RowIndex)
End Function

Private Function cIABMClientGrid_ListAdHock(ByVal Key As Integer, Row As CSInterfacesABM.cIABMGridRow, ByVal ColIndex As Long, List As CSInterfacesABM.cIABMList) As Boolean
  cIABMClientGrid_ListAdHock = pGetClientGrid.ListAdHock(Key, Row, ColIndex, List)
End Function

Private Sub cIABMClientGrid_NewRow(ByVal Key As Integer, ByVal Rows As Integer)
  pGetClientGrid.NewRow Key, Rows
End Sub

Private Function cIABMClientGrid_ValidateRow(ByVal Key As Integer, Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  cIABMClientGrid_ValidateRow = pGetClientGrid.ValidateRow(Key, Row, RowIndex)
End Function

' cIWizardGeneric
Private Property Get cIWizardGeneric_cmdBack() As Object
  Set cIWizardGeneric_cmdBack = m_EditGeneric.Frm.cmdBack
End Property

Private Property Get cIWizardGeneric_cmdCancel() As Object
  Set cIWizardGeneric_cmdCancel = m_EditGeneric.Frm.cmdCancel
End Property

Private Property Get cIWizardGeneric_cmdNext() As Object
  Set cIWizardGeneric_cmdNext = m_EditGeneric.Frm.cmdNext
End Property

Private Property Set cIWizardGeneric_EditGeneric(rhs As CSInterfacesABM.cIABMGeneric)
  Set m_EditGeneric = rhs
End Property

Private Property Get cIWizardGeneric_EditGeneric() As CSInterfacesABM.cIABMGeneric
  Set cIWizardGeneric_EditGeneric = m_EditGeneric
End Property

Private Function cIWizardGeneric_LoadControl(iProp As CSInterfacesABM.cIABMProperty) As Boolean
  cIWizardGeneric_LoadControl = m_EditGeneric.LoadControlEx(iProp)
End Function

Private Sub cIWizardGeneric_ResetTabLeftTop(ByVal StepKey As String)
  Dim oStep As cWizardStep
  Set oStep = m_Steps(StepKey)
  m_EditGeneric.ResetTabLeftTop oStep.TabIndex
End Sub

Private Sub cIWizardGeneric_ShowValue(iProp As CSInterfacesABM.cIABMProperty)
  m_EditGeneric.ShowValue iProp
End Sub

Private Property Set cIWizardGeneric_Steps(rhs As CSInterfacesABM.cIWizardSteps)
  Set m_Steps = rhs
End Property

Private Property Get cIWizardGeneric_Steps() As CSInterfacesABM.cIWizardSteps
  Set cIWizardGeneric_Steps = m_Steps
End Property
' propiedades friend
' propiedades privadas
' funciones publicas
Public Sub MoveNext()
  pNextStep m_CurrentStep
End Sub
Public Sub MoveBack()
  pPreviousStep m_CurrentStep
End Sub

Public Sub Clear(ByVal StepIndex As Integer)
  Dim iProp         As cIABMProperty
  Dim Index         As Integer
  ' Primero obtengo el paso y despues la propiedad
  If m_Steps(StepIndex) Is Nothing Then Exit Sub
    
  For Each iProp In m_Steps(StepIndex).Properties
    Index = Index + 1
    Remove Index, StepIndex
  Next
End Sub

Public Function Add(ByVal iProp As CSInterfacesABM.cIABMProperty, ByVal StepIndex As Integer) As CSInterfacesABM.cIABMProperty
  Dim o             As cIABMGeneric
  Dim oStep         As cWizardStep
  
  Set o = m_EditGeneric
  Set oStep = m_Steps(StepIndex)
  
  o.Properties.Add iProp
  iProp.TabIndex = oStep.TabIndex
End Function

Public Sub Remove(ByVal kItem As Variant, ByVal StepIndex As Integer)
  Dim iProp         As cIABMProperty
  Dim iPropRemoved  As cIABMProperty
  Dim o             As cIABMGeneric
  Dim oProperties   As cIABMProperties
  Dim Index         As Integer
  
  ' Primero obtengo el paso y despues la propiedad
  If m_Steps(StepIndex) Is Nothing Then Exit Sub
  If m_Steps(StepIndex).Properties(kItem) Is Nothing Then Exit Sub
  
  Set iPropRemoved = m_Steps(StepIndex).Properties(kItem)
  Set o = m_EditGeneric
  
  Set oProperties = o.Properties
  
  With m_EditGeneric
    For Each iProp In oProperties
      Index = Index + 1
      If iProp Is iPropRemoved Then
        .UnloadControl iProp
        .RemoveProperty Index
        oProperties.Remove Index
        Exit For
      End If
    Next
  End With
End Sub
' cIWizardGeneric
Private Function cIWizardGeneric_DoNextStep(ByVal CurrentStep As Integer) As Boolean
  cIWizardGeneric_DoNextStep = pNextStep(CurrentStep)
End Function

Private Function cIWizardGeneric_Show(ByVal ObjClientName As String) As Boolean
  Dim o                As cIABMGeneric
  
  Set o = m_EditGeneric
  
  If m_ObjClient Is Nothing Then
    Set m_ObjClient = CreateObject(ObjClientName)
  End If
  
  Set m_ObjClient.ObjWizard = Me
  
  If Not m_ObjClient.Load() Then Exit Function
  
  Dim iStep             As cIWizardStep
  Dim oStep             As cWizardStep
  Dim iProp             As cIABMProperty
  Dim oProp             As cABMProperty
  Dim iProperties       As cIABMProperties
  Dim iStepProperties   As cABMProperties
  Dim iTabs             As cIABMTabs
  
  Set iProperties = o.Properties
  Set iTabs = o.Tabs
  Set m_EditGeneric.Tabs = New cABMTabs
  
  Dim iTab        As cIABMTabItem
  Dim oTab        As cABMTabItem
  Dim Index       As Integer
  Dim StepIndex   As Integer
  
  For Each iStep In m_Steps
    
    StepIndex = StepIndex + 1
    Set oStep = iStep
    Set iTab = o.Tabs.Add(Nothing, GetKey(oStep.Key))
    
    With iTab
      .Index = Index
      .Name = "Paso" & iStep.Index
      
      oStep.TabIndex = .Index
      Set oTab = iTab
      oTab.KeyTab = oStep.Key
    End With
    
    Set iStepProperties = iStep.Properties
    With iStepProperties
      Set .WizardGeneric = Me
      .StepIndex = StepIndex
    End With
    
    For Each iProp In iStep.Properties
      Set oProp = iProp
      With oProp
        .TabIndex = iProp.TabIndex
        iProp.TabIndex = iTab.Index
        If .KeyCol = "" Then
          iProperties.Add iProp
        Else
          iProperties.Add iProp, .KeyCol
        End If
      End With
    Next
    
    Index = Index + 1
  Next
  
  For Each iTab In iTabs
    o.Tabs.Add iTab
    Set oTab = iTab
    oTab.CtlIndex = Index
    Index = Index + 1
  Next
  
  cIWizardGeneric_Show = pNextStep(-1)
End Function

Private Sub cIWizardGeneric_CloseWizard()
  m_EditGeneric.CloseWizard
End Sub

' cIABMClient
Private Sub cIABMClient_DiscardChanges()

End Sub

Private Function cIABMClient_ListAdHock(List As CSInterfacesABM.cIABMList) As Boolean

End Function

Private Sub cIABMClient_Load()

End Sub

Private Function cIABMClient_PropertyChange(ByVal Key As Integer) As Boolean
  cIABMClient_PropertyChange = m_ObjClient.PropertyChange(Key)
End Function

Private Function cIABMClient_Save() As Boolean

End Function

Private Function cIABMClient_Terminate() As Boolean
  Dim iStep       As cIWizardStep
  Dim oProperties As cABMProperties
  
  For Each iStep In m_Steps
    Set oProperties = iStep.Properties
    Set oProperties.WizardGeneric = Nothing
  Next
  
  Set m_EditGeneric = Nothing
  cIABMClient_Terminate = m_ObjClient.Terminate
  Set m_ObjClient = Nothing
End Function

' funciones friend
' funciones privadas
Private Function pNextStep(ByVal CurrentStep As Integer) As Boolean
  Dim NextStep As Integer
  With m_ObjClient
    If Not .NextStep(CurrentStep, NextStep) Then Exit Function
    If Not pShowStep(NextStep) Then Exit Function
    If Not .Work(m_CurrentStep, True) Then Exit Function
  End With
  pNextStep = True
End Function

Private Function pPreviousStep(ByVal CurrentStep As Integer) As Boolean
  Dim NextStep As Integer
  With m_ObjClient
    If Not .PreviousStep(CurrentStep, NextStep) Then Exit Function
    If Not pShowStep(NextStep) Then Exit Function
    If Not .Work(m_CurrentStep, False) Then Exit Function
  End With
  pPreviousStep = True
End Function

Private Function pShowStep(ByVal nStep As Integer) As Boolean
  Dim oStep As cWizardStep
  
  Set oStep = m_Steps(GetKey(nStep))
  
  With m_EditGeneric
    If m_WizardShowed Then
      .TabClick oStep.TabIndex
    Else
      If Not .Show(Me, oStep.TabIndex) Then Exit Function
      m_WizardShowed = True
    End If
  End With
  
  m_CurrentStep = nStep
  pShowStep = True
End Function

' construccion - destruccion
Private Sub Class_Initialize()
  On Error GoTo ControlError

  Set m_EditGeneric = New cABMGenericDocEx
  
  With m_EditGeneric
    .HideTabButtons = True
    Set m_Steps = New cWizardSteps
    .IsWizard = True
  End With
  
  GoTo ExitProc
ControlError:
  MngError Err, "Class_Initialize", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub Class_Terminate()
  On Error GoTo ControlError
  
  Set m_EditGeneric = Nothing
  Set m_Steps = Nothing
  Set m_ObjClient = Nothing

  GoTo ExitProc
ControlError:
  MngError Err, "Class_Terminate", C_Module, ""
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

