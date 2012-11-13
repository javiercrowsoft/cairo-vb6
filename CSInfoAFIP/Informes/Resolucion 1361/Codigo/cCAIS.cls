VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cCAIS"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements CSInterfacesABM.cIEditGeneric
Implements CSInterfacesABM.cIABMClient
Implements CSMenu.cIMenuClient
'--------------------------------------------------------------------------------
' cCAIS
' 03-07-2003

'--------------------------------------------------------------------------------
' notas:

' CAIS          reemplazar por el prefijo de la tabla (ej pro)
' CAIS           reemplazar por el nombre de la tabla (ej Provincia)
' cCAIS           reemplazar por el nombre de la clase (ej cProvincia)
' CAISs         reemplazar por el nombre logico del abm (ej Provincias)
' csPreTarea     reemplazar por el prefijo de las prestaciones (ej PreG)
'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cCAIS"

' estructuras
' variables privadas
Private m_Host              As CSMenu.cIMenuHost

' Properties publicas
' Properties privadas
' funciones publicas


' Implementacion de cIABMClient
Private Function cIABMClient_Copy() As Boolean
End Function

Private Function cIABMClient_EditNew() As Boolean
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
End Function

Private Sub cIABMClient_DiscardChanges()
End Sub

Private Function cIABMClient_ListAdHock(List As CSInterfacesABM.cIABMList) As Boolean
End Function

Private Sub cIABMClient_Load()
End Sub

Private Function cIABMClient_PropertyChange(ByVal Key As Integer) As Boolean
End Function

Private Sub ValidateHelp(ByVal Key As String, ByVal Table As Long, ByVal Filter As String)
End Sub

Private Function cIABMClient_Save() As Boolean
End Function

Private Function cIABMClient_Terminate() As Boolean
End Function

Private Property Get cIABMClient_Title() As String
End Property

Private Function cIABMClient_Validate() As Boolean
End Function

' Implementacion de cIEditGeneric
Private Property Get cIEditGeneric_ObjABM() As CSInterfacesABM.cIABMGeneric
End Property

Private Function cIEditGeneric_TabClick(ByVal Index As Integer) As Boolean

End Function

Private Property Let cIEditGeneric_TreeId(ByVal rhs As Long)
End Property

Private Property Get cIEditGeneric_TreeId() As Long
End Property

Private Function cIEditGeneric_GridAdd(ByVal ClavePropiedad As Integer) As Boolean

End Function

Private Function cIEditGeneric_GridEdit(ByVal ClavePropiedad As Integer) As Boolean

End Function

Private Function cIEditGeneric_GridRemove(ByVal ClavePropiedad As Integer) As Boolean

End Function

Private Function cIEditGeneric_ShowList() As Boolean
    cIEditGeneric_ShowList = SecurityCanAccess(csPreR1361ListCais)
End Function

Private Property Set cIEditGeneric_ObjABM(rhs As CSInterfacesABM.cIABMGeneric)
End Property

Private Property Get cIEditGeneric_Editing() As Boolean
End Property

Private Function cIEditGeneric_Delete(ID As Long) As Boolean
End Function

Private Function cIEditGeneric_Search(ID As Long, Cancela As Boolean) As Boolean
End Function

Private Function cIEditGeneric_Edit(ID As Long, Optional ByVal InModalWindow As Boolean) As Boolean
End Function

Private Function cIEditGeneric_PrintObj(ByVal ID As Long) As Boolean

End Function

Private Property Set cIEditGeneric_ObjTree(rhs As Object)
End Property

Private Property Let cIEditGeneric_BranchId(ByVal rhs As Long)
End Property

Private Property Get cIEditGeneric_BranchId() As Long
End Property

Private Function cIEditGeneric_Preview(ByVal ID As Long) As Boolean

End Function

Private Function cIEditGeneric_PropertyChange(ByVal Key As Integer) As Boolean

End Function

' Menu Client
Private Function cIMenuClient_Initialize(F As Object, Host As CSMenu.cIMenuHost) As Boolean
  On Error GoTo ControlError

  Set m_Host = Host
  m_Host.Server.AddMenu "&Listado de CAIS Vencidos", csPreR1361ListCais, "I&nformes", 0, True, False, False, False, False, Me

  cIMenuClient_Initialize = True

  GoTo ExitProc
ControlError:
  MngError Err, "cIMenuClient_Initialize", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc

ExitProc:
  On Error Resume Next
End Function

Private Function cIMenuClient_ProcessMenu(ByVal ID As Long) As Variant
  'm_Host.MenuListDocClick "CSABMInterface2.CABMGeneric", "CSAFIPRes1361.cCAIS", "CSABMInterface2.CABMGenericListDoc", "CSAFIPRes1361.cCAISListDoc", Me, "CAISs", 0
  m_Host.MenuListDocClick "CSABMInterface2.CABMGeneric", "CSGeneral.cProveedor", "CSABMInterface2.CABMGenericListDoc", "CSAFIPRes1361.cCAISListDoc", Me, "CAISs", 0
End Function

' funciones privadas
Private Function LoadCollection() As Boolean
End Function

Private Function Load(ByVal ID As Long) As Boolean
End Function

' construccion - destruccion
Private Sub Class_Initialize()
'
End Sub

