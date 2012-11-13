VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cPickingListEditAux"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements CSInterfacesABM.cIABMClient

'--------------------------------------------------------------------------------
' cPickingListEditAux
' 28-04-09

'--------------------------------------------------------------------------------
' notas:
'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cPickingListEditAux"

Private Const c_pr_id_to_find     As String = "pr_id_to_find"
Private Const c_pr_id_new         As String = "pr_id_new"
Private Const c_no_update_precios As String = "no_update_precios"

Private Const K_PR_ID_TO_FIND                  As Integer = 1
Private Const K_PR_ID_NEW                      As Integer = 2
Private Const K_NO_UPDATE_PRECIOS              As Integer = 3

' estructuras
' variables privadas
Private m_pr_id_to_find                As Long
Private m_pr_id_new                    As Long
Private m_no_update_precios            As Boolean

'OJO HASTA ACA

Private m_Editing           As Boolean

Private m_ObjAbm            As cIABMGeneric

' Propiedades publicas
Public Property Get pr_id_to_find() As String
  pr_id_to_find = m_pr_id_to_find
End Property

Public Property Get pr_id_new() As String
  pr_id_new = m_pr_id_new
End Property

Public Property Get no_update_precios() As Boolean
  no_update_precios = m_no_update_precios
End Property

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
  Select Case MessageID
  
    Case MSG_DOC_INFO
    
      Dim AbmGen As cABMGeneric
      Set AbmGen = m_ObjAbm
      
      CSKernelClient2.ShowHelp AbmGen.hWnd, _
                               vbNullString, _
                               vbNullString, _
                               csPreVtaModificarArticulo
      cIABMClient_MessageEx = MSG_DOC_INFO_HANDLED
    Case Else
      cIABMClient_MessageEx = True
  End Select
End Function

Private Sub cIABMClient_DiscardChanges()
    LoadCollection
End Sub

Private Function cIABMClient_ListAdHock(List As CSInterfacesABM.cIABMList) As Boolean

End Function

Private Sub cIABMClient_Load()

End Sub

Private Function cIABMClient_PropertyChange(ByVal Clave As Integer) As Boolean

End Function

Private Function cIABMClient_Save() As Boolean
  
  m_pr_id_new = m_ObjAbm.Properties.Item(c_pr_id_new).HelpId
  m_pr_id_to_find = m_ObjAbm.Properties.Item(c_pr_id_to_find).HelpId
  m_no_update_precios = Val(m_ObjAbm.Properties.Item(c_no_update_precios).Value)
  
  cIABMClient_Save = True
End Function

Private Function cIABMClient_Terminate() As Boolean
  cIABMClient_Terminate = True
End Function

Private Property Get cIABMClient_Title() As String
  cIABMClient_Title = LNGGetText(4874, vbNullString) ' Reemplazar Articulos en Pedidos
End Property

Private Function cIABMClient_Validate() As Boolean

  Dim IProperty As cIABMProperty

  For Each IProperty In m_ObjAbm.Properties
    With IProperty
      Select Case .Key
        Case K_PR_ID_TO_FIND
          If ValEmpty(.Value, csText) Then
            MsgInfo LNGGetText(4875, vbNullString) ' Debe indicar un articulo a reemplazar
            Exit Function
          End If
        Case K_PR_ID_NEW
          If ValEmpty(.Value, csText) Then
            MsgInfo LNGGetText(4876, vbNullString) ' Debe indicar el articulo a despachar
            Exit Function
          End If
      End Select
    End With
  Next

  cIABMClient_Validate = True
End Function

Public Function Edit() As Boolean

  If Not SecurityCanAccess(csPreVtaModificarArticulo) Then Exit Function
  
  If m_ObjAbm Is Nothing Then
    Set m_ObjAbm = New cABMGeneric
  End If
  
  m_ObjAbm.InModalWindow = True
  Dim AbmGen As cABMGeneric
  
  Set AbmGen = m_ObjAbm
  
  AbmGen.OkCancelDialog = True
  AbmGen.bDontAskForSave = True
    
  If Not LoadCollection() Then Exit Function

  Edit = AbmGen.OkCancelDialogRslt

  Exit Function
ControlError:
  MngError Err, C_EditGenericEdit, C_Module, vbNullString
End Function

' funciones privadas
Private Function LoadCollection() As Boolean
  
  With m_ObjAbm.Properties
    
    .Clear

    With .Add(Nothing, c_pr_id_to_find)
      .PropertyType = cspHelp
      .Table = csProductoVenta
      .Name = LNGGetText(4871, vbNullString) ' Producto a Buscar
      .Key = K_PR_ID_TO_FIND
      .Width = 6000
      .LeftLabel = -2500
      .Left = 3000
    End With
    
    With .Add(Nothing, c_pr_id_new)
      .PropertyType = cspHelp
      .Table = csProductoVenta
      .Name = LNGGetText(4872, vbNullString) ' Remplazar con
      .Key = K_PR_ID_NEW
      .Width = 6000
      .LeftLabel = -2500
    End With
    
    With .Add(Nothing, c_no_update_precios)
      .PropertyType = cspCheck
      .Name = LNGGetText(4873, vbNullString) ' Respetar el precio del pedido
      .Key = K_NO_UPDATE_PRECIOS
      .Value = 0
      .LeftLabel = -2500
    End With
                
  End With
  
  If Not m_ObjAbm.Show(Me) Then Exit Function
  
  LoadCollection = True
End Function

' construccion - destruccion
Private Sub Class_Terminate()
  On Error Resume Next
  Set m_ObjAbm = Nothing
End Sub
