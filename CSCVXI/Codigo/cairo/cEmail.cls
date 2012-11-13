VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cEmail"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements CSInterfacesABM.cIEditGeneric
Implements CSInterfacesABM.cIABMClient
Implements csMenu.cIMenuClient
'--------------------------------------------------------------------------------
' cEmail
' 24-11-2009

'--------------------------------------------------------------------------------
' notas:
'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cEmail"

' estructuras

' variables privadas

'OJO HASTA ACA

Private m_Editing           As Boolean

Private m_ObjAbm            As cIABMGeneric
Private m_ObjTree           As Object

Private m_IsNew             As Boolean

Private m_BranchId          As Long
Private m_TreeId            As Long

Private m_Host              As csMenu.cIMenuHost
Private m_Copy              As Boolean

' Properties publicas
' Properties privadas
' funciones publicas

' Implementacion de cIABMClient
Private Function cIABMClient_Copy() As Boolean
End Function

Private Function cIABMClient_EditNew() As Boolean
End Function

Private Property Get cIABMClient_Aplication() As String
    cIABMClient_Aplication = gAppName
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

Private Sub cIABMClient_DiscardChanges()
End Sub

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
    cIABMClient_Title = LNGGetText(5023, vbNullString) 'E-Mails
End Property

Private Function cIABMClient_Validate() As Boolean
End Function

' Implementacion de cIEditGeneric
Private Property Get cIEditGeneric_ObjAbm() As CSInterfacesABM.cIABMGeneric
  Set cIEditGeneric_ObjAbm = m_ObjAbm
End Property

Private Function cIEditGeneric_TabClick(ByVal Index As Integer) As Boolean

End Function

Private Property Let cIEditGeneric_TreeId(ByVal rhs As Long)
    m_TreeId = rhs
End Property

Private Property Get cIEditGeneric_TreeId() As Long
    cIEditGeneric_TreeId = m_TreeId
End Property

Private Function cIEditGeneric_GridAdd(ByVal ClavePropiedad As Integer) As Boolean

End Function

Private Function cIEditGeneric_GridEdit(ByVal ClavePropiedad As Integer) As Boolean

End Function

Private Function cIEditGeneric_GridRemove(ByVal ClavePropiedad As Integer) As Boolean

End Function

Private Function cIEditGeneric_ShowList() As Boolean
    cIEditGeneric_ShowList = SecurityCanAccess(csPreCVXIListEmail)
End Function

Private Property Set cIEditGeneric_ObjAbm(rhs As CSInterfacesABM.cIABMGeneric)
    Set m_ObjAbm = rhs
End Property

Private Property Get cIEditGeneric_Editing() As Boolean
    cIEditGeneric_Editing = m_Editing
End Property

Private Function cIEditGeneric_Delete(id As Long) As Boolean
End Function

Private Function cIEditGeneric_Search(id As Long, Cancela As Boolean) As Boolean
End Function

Private Function cIEditGeneric_Edit(id As Long, Optional ByVal InModalWindow As Boolean) As Boolean
End Function

Private Function cIEditGeneric_PrintObj(ByVal id As Long) As Boolean
End Function

Private Property Set cIEditGeneric_ObjTree(rhs As Object)
  Set m_ObjTree = rhs
End Property

Private Property Let cIEditGeneric_BranchId(ByVal rhs As Long)
  m_BranchId = rhs
End Property

Private Property Get cIEditGeneric_BranchId() As Long
  cIEditGeneric_BranchId = m_BranchId
End Property

Private Function cIEditGeneric_Preview(ByVal id As Long) As Boolean
End Function

Private Function cIEditGeneric_PropertyChange(ByVal Key As Integer) As Boolean
End Function

' Menu Client
Private Function cIMenuClient_Initialize(f As Object, Host As csMenu.cIMenuHost) As Boolean
  On Error GoTo ControlError
  
  Dim str_5025 As String

  str_5025 = LNGGetText(5025, vbNullString)
  
  Set m_Host = Host
  m_Host.Server.AddMenu str_5025, csMenuEnum.csMenuComunidad, vbNullString, 1, False, False, False, True, False, Nothing
  m_Host.Server.AddMenu LNGGetText(5024, vbNullString), csPreCVXIListEmail, str_5025, 0, True, False, False, False, False, Me
                        '&E-Mails
  cIMenuClient_Initialize = True

  GoTo ExitProc
ControlError:
  MngError Err, "cIMenuClient_Initialize", C_Module, vbNullString
  If Err.Number Then Resume ExitProc

ExitProc:
  On Error Resume Next
End Function

Private Function cIMenuClient_ProcessMenu(ByVal id As Long) As Variant
  m_Host.MenuListDocClick "CSABMInterface2.CABMGeneric", _
                          "CSCVXI.cEmail", _
                          "CSABMInterface2.CABMGenericListDoc", _
                          "CSCVXI.cEmailListDoc", _
                          Me, _
                          LNGGetText(5023, vbNullString), _
                          0
                          'E-Mails
End Function

' construccion - destruccion

Private Sub Class_Terminate()
  On Error GoTo ControlError
  
  Set m_ObjAbm = Nothing
  Set m_ObjTree = Nothing
  
  GoTo ExitProc
ControlError:
  MngError Err, "Class_Terminate", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub
