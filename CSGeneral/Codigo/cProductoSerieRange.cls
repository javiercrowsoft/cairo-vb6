VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cProductoSerieRange"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements CSInterfacesABM.cIEditGeneric
Implements CSInterfacesABM.cIABMClient
'--------------------------------------------------------------------------------
' cProductoSerieRange
' 06-09-03
'--------------------------------------------------------------------------------
' notas:
'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones
'--------------------------------------------------------------------------------
' constantes
Private Const C_Module = "cProductoSerieRange"

Private Const c_first = "first"
Private Const c_last = "last"
Private Const c_bByChar = "bByChar"

Private Const K_FIRST          As Integer = 2
Private Const K_LAST           As Integer = 5

' estructuras
' variables privadas
Private m_last                 As String
Private m_first                As String
Private m_bByChar              As Integer

Private m_Editing                      As Boolean

Private m_ObjAbm                       As cIABMGeneric
Private m_ObjTree                      As Object

Private m_BranchId                     As Long
Private m_TreeId                       As Long

' Properties publicas

' JMA I
Public Property Get first() As String
  first = m_first
End Property

Public Property Get bByChar() As String
  bByChar = m_bByChar
End Property

Public Property Get last() As String
  last = m_last
End Property
' JMA F

' Properties privadas
' funciones publicas
Public Function Edit() As Boolean
  On Error GoTo ControlError
  
  Dim AbmObj As cABMGeneric
  
  Set m_ObjAbm = New cABMGeneric
  Set AbmObj = m_ObjAbm
  AbmObj.OkCancelDialog = True
  AbmObj.bDontAskForSave = True
  
  m_ObjAbm.InModalWindow = True
  
  LoadCollection

  Edit = AbmObj.OkCancelDialogRslt
  
  GoTo ExitProc
ControlError:
  MngError Err, "Edit", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function
' Implementacion de cIABMClient
Private Property Get cIABMClient_Aplication() As String
    cIABMClient_Aplication = gAppName
End Property

Private Property Get cIABMClient_CanAddDocDigital() As Boolean
  cIABMClient_CanAddDocDigital = False
End Property

Private Property Get cIABMClient_CanCopy() As Boolean
  cIABMClient_CanCopy = False
End Property

Private Property Get cIABMClient_CanNew() As Boolean
  cIABMClient_CanNew = False
End Property

Private Function cIABMClient_ShowDocDigital() As Boolean
End Function

Private Function cIABMClient_MessageEx(ByVal MessageID As Long, ByVal Info As Variant) As Variant
  cIABMClient_MessageEx = True
End Function

Private Function cIABMClient_Copy() As Boolean
  cIABMClient_Copy = False
End Function

Private Sub cIABMClient_DiscardChanges()
    LoadCollection
End Sub

Private Function cIABMClient_EditNew() As Boolean
  cIABMClient_EditNew = False
End Function

Private Function cIABMClient_ListAdHock(List As CSInterfacesABM.cIABMList) As Boolean

End Function

Private Sub cIABMClient_Load()

End Sub

Private Function cIABMClient_PropertyChange(ByVal Key As Integer) As Boolean

End Function

Private Function cIEditGeneric_Edit(Id As Long, Optional ByVal InModalWindow As Boolean) As Boolean
On Error GoTo ControlError
  

' JMA I
  m_ObjAbm.InModalWindow = InModalWindow
' JMA F
  
  If Not LoadCollection() Then Exit Function
  
  m_Editing = True

' JMA I
  If InModalWindow Then
    cIEditGeneric_Edit = True
  Else
    cIEditGeneric_Edit = True
  End If
' JMA I

  Exit Function
ControlError:
  MngError Err, C_EditGenericEdit, C_Module, vbNullString
End Function

Private Function cIABMClient_Save() As Boolean
  
  m_bByChar = m_ObjAbm.Properties(c_bByChar).Value
  m_first = m_ObjAbm.Properties(c_first).Value
  m_last = m_ObjAbm.Properties(c_last).Value
  
  cIABMClient_Save = True
End Function

Private Function cIABMClient_Terminate() As Boolean
    m_Editing = False
    cIABMClient_Terminate = True
End Function

Private Property Get cIABMClient_Title() As String
    cIABMClient_Title = LNGGetText(2905, vbNullString) 'Número de Serie Por Rango
End Property

Private Function cIABMClient_Validate() As Boolean

  Dim IProperty As cIABMProperty

  For Each IProperty In m_ObjAbm.Properties
    With IProperty
      Select Case .Key
        Case K_FIRST
          If ValEmpty(.Value, csText) Then
            MsgInfo LNGGetText(2906, vbNullString) 'Debe indicar un número inicial
            Exit Function
          End If
        Case K_LAST
          If ValEmpty(.Value, csText) Then
            MsgInfo LNGGetText(2907, vbNullString) 'Debe indicar un número final
            Exit Function
          End If
      End Select
    End With
  Next

  cIABMClient_Validate = True
End Function

' Implementacion de cIEditGeneric

Private Function cIEditGeneric_TabClick(ByVal Index As Integer) As Boolean

End Function

Private Property Let cIEditGeneric_TreeId(ByVal rhs As Long)
    m_TreeId = rhs
End Property

Private Property Get cIEditGeneric_TreeId() As Long
    cIEditGeneric_TreeId = m_TreeId
End Property

Private Function cIEditGeneric_GridAdd(ByVal KeyProperty As Integer) As Boolean

End Function

Private Function cIEditGeneric_GridEdit(ByVal KeyProperty As Integer) As Boolean

End Function

Private Function cIEditGeneric_GridRemove(ByVal KeyProperty As Integer) As Boolean

End Function

Private Function cIEditGeneric_ShowList() As Boolean
    cIEditGeneric_ShowList = False
End Function

Private Property Get cIEditGeneric_ObjAbm() As CSInterfacesABM.cIABMGeneric
  Set cIEditGeneric_ObjAbm = m_ObjAbm
End Property

Private Property Set cIEditGeneric_ObjAbm(rhs As CSInterfacesABM.cIABMGeneric)
    Set m_ObjAbm = rhs
End Property

Private Property Get cIEditGeneric_Editing() As Boolean
    cIEditGeneric_Editing = m_Editing
End Property

Private Function cIEditGeneric_Delete(Id As Long) As Boolean
    cIEditGeneric_Delete = False
End Function

Private Function cIEditGeneric_Search(Id As Long, Cancela As Boolean) As Boolean

End Function

Private Function cIEditGeneric_PrintObj(ByVal Id As Long) As Boolean

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

Private Function cIEditGeneric_Preview(ByVal Id As Long) As Boolean

End Function

Private Function cIEditGeneric_PropertyChange(ByVal Key As Integer) As Boolean

End Function

' funciones privadas
Private Function LoadCollection() As Boolean
  Dim c       As cIABMProperty
  Dim msg     As String
  Dim AbmObj  As cABMGeneric
  
  Set AbmObj = m_ObjAbm
  AbmObj.MinHeight = 6000
  
  AbmObj.OkCancelDialog = True
  
  m_ObjAbm.Properties.Clear
    
  Set c = m_ObjAbm.Properties.Add(Nothing)
  c.PropertyType = cspLabel
  msg = LNGGetText(2909, vbNullString)
        'El Número de Serie puede contener números y letras. & _
        El sistema puede generar los Números de Serie dentro del rango que Ud. indica & _
        de dos maneras 1- Numéricamente  2- Alfabéticamente& _
        Cuando se incrementa alfabéticamente, el sistema utiliza los números del 0 al 9 y & _
        las letras del alfabeto inglés de a-z en minúsculas. & _
        Ej. Desde: ab1 Hasta: ba1 Cairo genera: ab1,ab2,..ab9,aba,abb,..,abz,ac0,ac1,..b01,..ba1
  c.Value = msg
  c.Width = 8000
  c.Left = 360
  c.Height = 2000
  c.LeftNotChange = True
    
  Set c = m_ObjAbm.Properties.Add(Nothing, c_bByChar)
  c.PropertyType = cspCheck
  c.Value = m_bByChar
  c.Name = LNGGetText(2908, vbNullString) 'Incrementar alfabéticamente
  c.LeftLabel = -2100
  c.Left = 3000
    
  Set c = m_ObjAbm.Properties.Add(Nothing, c_first)
  c.PropertyType = cspText
  c.Name = LNGGetText(2532, vbNullString) 'Desde
  c.Key = K_FIRST
  c.Value = m_first
  c.LeftLabel = -550
  
  Set c = m_ObjAbm.Properties.Add(Nothing, c_last)
  c.PropertyType = cspText
  c.Name = LNGGetText(2533, vbNullString) 'Hasta
  c.Key = K_LAST
  c.Value = m_last
  c.LeftLabel = -550
  
  If Not m_ObjAbm.Show(Me) Then Exit Function
  
  LoadCollection = True
End Function

' construccion - destruccion
Private Sub Class_Terminate()
  On Error Resume Next
   Set m_ObjAbm = Nothing
   Set m_ObjTree = Nothing
End Sub
