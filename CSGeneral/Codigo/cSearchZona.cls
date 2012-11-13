VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cSearchZona"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements CSInterfacesABM.cIABMClient
'--------------------------------------------------------------------------------
' cSearchZona
' 20-08-08
'--------------------------------------------------------------------------------
' notas:
'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cSearchZona"

Private Const c_Search As String = "search"
Private Const c_Zonas  As String = "zonas"

Private Const K_SEARCH                         As Integer = 1
Private Const K_ZONAS                          As Integer = 2

' estructuras
' variables privadas
Private m_owner     As Object
Private m_bShowed   As Boolean

'OJO HASTA ACA
Private m_ObjAbm            As cIABMGeneric

' Properties publicas
Public Property Get bShowed() As Boolean
  bShowed = m_bShowed
End Property

' Properties privadas
' funciones publicas

Public Function Edit(ByVal owner As Object)
  Set m_ObjAbm = New cABMGeneric
  Set m_owner = owner
  LoadCollection
  m_bShowed = True
End Function

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
  cIABMClient_CanCopy = False
End Property

Private Property Get cIABMClient_CanNew() As Boolean
  cIABMClient_CanNew = False
End Property

Private Function cIABMClient_ShowDocDigital() As Boolean

End Function

Private Function cIABMClient_MessageEx(ByVal MessageID As Long, ByVal Info As Variant) As Variant

End Function

Private Sub cIABMClient_DiscardChanges()
  LoadCollection
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
    cIABMClient_Terminate = True
End Function

Private Property Get cIABMClient_Title() As String
  cIABMClient_Title = vbNullString
End Property

Private Function cIABMClient_Validate() As Boolean
  cIABMClient_Validate = True
End Function

' Implementacion de cIEditGeneric

' funciones privadas
Private Function LoadCollection() As Boolean
  
  Dim AbmObj As cABMGeneric
  Set AbmObj = m_ObjAbm
  
  Set AbmObj.owner = m_owner
  AbmObj.OkCancelDialog = True
  AbmObj.MinHeight = 3000
  AbmObj.MinWidth = 5000
    
  With m_ObjAbm.Properties
    
    .Clear
    
    With .Add(Nothing, c_Search)
      .PropertyType = cspText
      .name = LNGGetText(1037, vbNullString) 'Direccion
      .Width = 4000
      .Key = K_SEARCH
      .Top = 100
      .Left = 1500
      .LeftLabel = -800
    End With
    
    Dim c As cIABMProperty
    
    Set c = .Add(Nothing, c_Zonas)
    With c
      .PropertyType = cspGrid
      If Not pLoadZonas(c) Then Exit Function
      .name = LNGGetText(1505, vbNullString) 'Zonas
      .Width = 4000
      .Key = K_ZONAS
      .Top = 1000
      .Left = 200
      .LeftLabel = -1
    End With
    
  End With
  
  If Not m_ObjAbm.Show(Me) Then Exit Function
  
  LoadCollection = True
End Function

Private Function pLoadZonas(ByRef Propiedad As cIABMProperty) As Boolean
  With Propiedad.Grid.Columns
    
    With .Add(Nothing)
      .Visible = False
    End With
    
    With .Add(Nothing)
      .name = LNGGetText(2901, vbNullString)    'Zona
      .PropertyType = cspText
      .Width = 2500
    End With
    
    With .Add(Nothing)
      .name = LNGGetText(2901, vbNullString)    'Zona
      .PropertyType = cspText
      .Width = 2500
    End With
    
    
  End With
  
  pLoadZonas = True
End Function

' construccion - destruccion
Private Sub Class_Terminate()
  On Error Resume Next
  Set m_ObjAbm = Nothing
  Set m_owner = Nothing
End Sub

