VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cDummy"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements CSInterfacesABM.cIABMClient
Implements CSInterfacesABM.cIEditGeneric
Implements CSMenu.cIMenuClient

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
End Function

Private Function cIABMClient_Copy() As Boolean

End Function

Private Sub cIABMClient_DiscardChanges()

End Sub

Private Function cIABMClient_EditNew() As Boolean

End Function

Private Function cIABMClient_ListAdHock(List As CSInterfacesABM.cIABMList) As Boolean

End Function

Private Sub cIABMClient_Load()

End Sub

Private Function cIABMClient_PropertyChange(ByVal Key As Integer) As Boolean

End Function

Private Function cIABMClient_Save() As Boolean

End Function

Private Function cIABMClient_Terminate() As Boolean

End Function

Private Property Get cIABMClient_Title() As String

End Property

Private Function cIABMClient_Validate() As Boolean

End Function

Private Property Let cIEditGeneric_BranchId(ByVal RHS As Long)

End Property

Private Property Get cIEditGeneric_BranchId() As Long

End Property

Private Function cIEditGeneric_Delete(Id As Long) As Boolean

End Function

Private Function cIEditGeneric_Edit(Id As Long, Optional ByVal InModalWindow As Boolean) As Boolean

End Function

Private Property Get cIEditGeneric_Editing() As Boolean

End Property

Private Function cIEditGeneric_GridAdd(ByVal KeyProperty As Integer) As Boolean

End Function

Private Function cIEditGeneric_GridEdit(ByVal KeyProperty As Integer) As Boolean

End Function

Private Function cIEditGeneric_GridRemove(ByVal KeyProperty As Integer) As Boolean

End Function

Private Property Get cIEditGeneric_ObjABM() As CSInterfacesABM.cIABMGeneric

End Property

Private Property Set cIEditGeneric_ObjABM(RHS As CSInterfacesABM.cIABMGeneric)

End Property

Private Property Set cIEditGeneric_ObjTree(RHS As Object)

End Property

Private Function cIEditGeneric_Preview(ByVal Id As Long) As Boolean

End Function

Private Function cIEditGeneric_PrintObj(ByVal Id As Long) As Boolean

End Function

Private Function cIEditGeneric_PropertyChange(ByVal Key As Integer) As Boolean

End Function

Private Function cIEditGeneric_Search(Id As Long, Cancel As Boolean) As Boolean

End Function

Private Function cIEditGeneric_ShowList() As Boolean

End Function

Private Function cIEditGeneric_TabClick(ByVal Index As Integer) As Boolean

End Function

Private Property Let cIEditGeneric_TreeId(ByVal RHS As Long)

End Property

Private Property Get cIEditGeneric_TreeId() As Long

End Property

Private Function cIMenuClient_Initialize(F As Object, Host As CSMenu.cIMenuHost) As Boolean
  cIMenuClient_Initialize = True
End Function

Private Function cIMenuClient_ProcessMenu(ByVal Id As Long) As Variant

End Function
