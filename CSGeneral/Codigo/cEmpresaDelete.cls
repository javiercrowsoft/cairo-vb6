VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cEmpresaDelete"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements CSInterfacesABM.cIEditGeneric
Implements CSInterfacesABM.cIABMClient
'--------------------------------------------------------------------------------
' cEmpresaDelete
' 23-07-04

'--------------------------------------------------------------------------------
' notas:
'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cEmpresaDelete"

Private Const c_fDesde = "Desde"
Private Const c_fHasta = "Hasta"
Private Const c_Todo = "Todo"
Private Const c_SoloDoc = "SoloDoc"

Private Const K_TODO                             As Integer = 1
Private Const K_FECHA_DESDE                      As Integer = 2
Private Const K_FECHA_HASTA                      As Integer = 3
Private Const K_SOLO_DOC                         As Integer = 4

' estructuras
' variables privadas
Private m_empresa           As String
Private m_fechaDesde        As Date
Private m_fechaHasta        As Date
Private m_todo              As Boolean
Private m_solodoc           As Boolean

Private m_ObjAbm            As cIABMGeneric

' Properties publicas
' Properties privadas
Public Property Let Empresa(ByVal rhs As String)
  m_empresa = rhs
End Property
Public Property Get FechaDesde() As Date
  FechaDesde = m_fechaDesde
End Property
Public Property Get FechaHasta() As Date
  FechaHasta = m_fechaHasta
End Property
Public Property Get Todo() As Boolean
  Todo = m_todo
End Property
Public Property Get SoloDoc() As Boolean
  SoloDoc = m_solodoc
End Property
' funciones publicas

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

Private Function cIABMClient_MessageEx(ByVal MessageID As Long, ByVal Info As Variant) As Variant
  cIABMClient_MessageEx = True
End Function

Private Function cIABMClient_ShowDocDigital() As Boolean

End Function

Private Function cIABMClient_EditNew() As Boolean
  cIEditGeneric_Edit csNO_ID
End Function

Private Sub cIABMClient_DiscardChanges()
  LoadCollection
End Sub

Private Function cIABMClient_Copy() As Boolean

End Function

Private Function cIABMClient_ListAdHock(List As CSInterfacesABM.cIABMList) As Boolean

End Function

Private Sub cIABMClient_Load()

End Sub

Private Function cIABMClient_PropertyChange(ByVal Key As Integer) As Boolean

End Function

Private Function cIABMClient_Save() As Boolean
  Dim IProperty As cIABMProperty
  
  For Each IProperty In m_ObjAbm.Properties
    With IProperty
      Select Case .Key
        Case K_TODO
          m_todo = Val(.Value)
        Case K_FECHA_DESDE
          m_fechaDesde = .Value
        Case K_FECHA_HASTA
          m_fechaHasta = .Value
        Case K_SOLO_DOC
          m_solodoc = Val(.Value)
      End Select
    End With
  Next
  
  cIABMClient_Save = True
End Function

Private Function cIABMClient_Terminate() As Boolean
  cIABMClient_Terminate = True
End Function

Private Property Get cIABMClient_Title() As String
                        'Empresas
  cIABMClient_Title = LNGGetText(1171, vbNullString)
End Property

Private Function cIABMClient_Validate() As Boolean
  cIABMClient_Validate = True
End Function

' Implementacion de cIEditGeneric
Private Function cIEditGeneric_TabClick(ByVal Index As Integer) As Boolean

End Function

Private Property Let cIEditGeneric_TreeId(ByVal rhs As Long)

End Property

Private Property Get cIEditGeneric_TreeId() As Long

End Property

Private Function cIEditGeneric_GridAdd(ByVal KeyProperty As Integer) As Boolean

End Function

Private Function cIEditGeneric_GridEdit(ByVal KeyProperty As Integer) As Boolean

End Function

Private Function cIEditGeneric_GridRemove(ByVal KeyProperty As Integer) As Boolean

End Function

Private Function cIEditGeneric_ShowList() As Boolean

End Function

Private Property Get cIEditGeneric_ObjAbm() As CSInterfacesABM.cIABMGeneric
  Set cIEditGeneric_ObjAbm = m_ObjAbm
End Property

Private Property Set cIEditGeneric_ObjAbm(rhs As CSInterfacesABM.cIABMGeneric)
  Set m_ObjAbm = rhs
End Property

Private Property Get cIEditGeneric_Editing() As Boolean
  
End Property

Private Function cIEditGeneric_Delete(Id As Long) As Boolean

End Function

Private Function cIEditGeneric_Search(Id As Long, Cancela As Boolean) As Boolean

End Function

Private Function cIEditGeneric_Edit(Id As Long, Optional ByVal InModalWindow As Boolean) As Boolean
  On Error GoTo ControlError
  
  If Not SecurityCanAccess(csPreGDeleteEmpresa) Then Exit Function

  m_ObjAbm.InModalWindow = True
  Dim AbmObj As cABMGeneric
  Set AbmObj = m_ObjAbm
  AbmObj.OkCancelDialog = True

  If Not LoadCollection() Then Exit Function
  
  cIEditGeneric_Edit = AbmObj.OkCancelDialogRslt

  Exit Function
ControlError:
  MngError Err, "cIEditGeneric_Edit", "cEmpresaDelete", vbNullString
End Function

Private Function cIEditGeneric_PrintObj(ByVal Id As Long) As Boolean

End Function

Private Property Set cIEditGeneric_ObjTree(rhs As Object)

End Property

Private Property Let cIEditGeneric_BranchId(ByVal rhs As Long)

End Property

Private Property Get cIEditGeneric_BranchId() As Long

End Property

Private Function cIEditGeneric_Preview(ByVal Id As Long) As Boolean

End Function

Private Function cIEditGeneric_PropertyChange(ByVal Key As Integer) As Boolean

End Function

' funciones privadas

Private Function LoadCollection() As Boolean
    
  m_ObjAbm.Title2 = m_empresa
  
  With m_ObjAbm.Properties
    
    .Clear
    
    With .Add(Nothing, c_Todo)
      .PropertyType = cspCheck
      .Name = LNGGetText(1202, vbNullString)   'Todo
      .Key = K_TODO
      .Value = CInt(m_todo)
    End With
    
    With .Add(Nothing, c_fDesde)
      .PropertyType = cspDate
      .Name = LNGGetText(1203, vbNullString)   'Fecha desde
      .Key = K_FECHA_DESDE
      .Value = m_fechaDesde
    End With
    
    With .Add(Nothing, c_fHasta)
      .PropertyType = cspDate
      .Name = LNGGetText(1204, vbNullString)   'Fecha hasta
      .Key = K_FECHA_HASTA
      .Value = m_fechaHasta
    End With
    
    With .Add(Nothing, c_SoloDoc)
      .PropertyType = cspCheck
      .Name = LNGGetText(1205, vbNullString)   'Solo Documentos
      .Key = K_SOLO_DOC
      .Value = CInt(m_solodoc)
    End With
  
  End With
  
  If Not m_ObjAbm.Show(Me) Then Exit Function
  
  LoadCollection = True
End Function

' construccion - destruccion
Private Sub Class_Initialize()
  m_solodoc = True
End Sub

Private Sub Class_Terminate()
  Set m_ObjAbm = Nothing
End Sub

'//////////////////////////////
'  Codigo estandar de errores
'  On Error GoTo ControlError
'
'  GoTo ExitProc
'ControlError:
'  MngError err,"", C_Module, ""
'  If Err.Number Then Resume ExitProc
'ExitProc:
'  On Error Resume Next
