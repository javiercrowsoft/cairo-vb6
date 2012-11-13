VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cRubro"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements CSInterfacesABM.cIEditGeneric
Implements CSInterfacesABM.cIABMClient
Implements CSMenu.cIMenuClient
'--------------------------------------------------------------------------------
' cRubro
' 17-03-02

'--------------------------------------------------------------------------------
' notas:
'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cRubro"

Private Const K_NOMBRE      As Integer = 1
Private Const K_CODIGO      As Integer = 2
Private Const K_DESCRIP     As Integer = 3
Private Const K_ESCRITERIO  As Integer = 104

Private Const K_RUBT_ID1                       As Integer = 4
Private Const K_RUBT_ID2                       As Integer = 5
Private Const K_RUBT_ID3                       As Integer = 6
Private Const K_RUBT_ID4                       As Integer = 7
Private Const K_RUBT_ID5                       As Integer = 8
Private Const K_RUBT_ID6                       As Integer = 9
Private Const K_RUBT_ID7                       As Integer = 10
Private Const K_RUBT_ID8                       As Integer = 11
Private Const K_RUBT_ID9                       As Integer = 12
Private Const K_RUBT_ID10                      As Integer = 13
Private Const K_RUBTI_ID1                      As Integer = 14
Private Const K_RUBTI_ID2                      As Integer = 15
Private Const K_RUBTI_ID3                      As Integer = 16
Private Const K_RUBTI_ID4                      As Integer = 17
Private Const K_RUBTI_ID5                      As Integer = 18
Private Const K_RUBTI_ID6                      As Integer = 19
Private Const K_RUBTI_ID7                      As Integer = 20
Private Const K_RUBTI_ID8                      As Integer = 21
Private Const K_RUBTI_ID9                      As Integer = 22
Private Const K_RUBTI_ID10                     As Integer = 23

Private Const K_ACTIVO      As Integer = 24
' estructuras
' variables privadas
Private m_Id                As Long
Private m_Nombre            As String
Private m_Codigo            As String
Private m_Activo            As Boolean
Private m_EsCriterio        As Boolean
Private m_descrip           As String

Private m_Rubt_id1               As Long
Private m_Tabla1                 As String
Private m_Rubt_id2               As Long
Private m_Tabla2                 As String
Private m_Rubt_id3               As Long
Private m_Tabla3                 As String
Private m_Rubt_id4               As Long
Private m_Tabla4                 As String
Private m_Rubt_id5               As Long
Private m_Tabla5                 As String
Private m_Rubt_id6               As Long
Private m_Tabla6                 As String
Private m_Rubt_id7               As Long
Private m_Tabla7                 As String
Private m_Rubt_id8               As Long
Private m_Tabla8                 As String
Private m_Rubt_id9               As Long
Private m_Tabla9                 As String
Private m_Rubt_id10              As Long
Private m_Tabla10                As String
Private m_Rubti_id1              As Long
Private m_TablaItem1             As String
Private m_Rubti_id2              As Long
Private m_TablaItem2             As String
Private m_Rubti_id3              As Long
Private m_TablaItem3             As String
Private m_Rubti_id4              As Long
Private m_TablaItem4             As String
Private m_Rubti_id5              As Long
Private m_TablaItem5             As String
Private m_Rubti_id6              As Long
Private m_TablaItem6             As String
Private m_Rubti_id7              As Long
Private m_TablaItem7             As String
Private m_Rubti_id8              As Long
Private m_TablaItem8             As String
Private m_Rubti_id9              As Long
Private m_TablaItem9             As String
Private m_Rubti_id10             As Long
Private m_TablaItem10            As String

Private m_Editing           As Boolean

Private m_ObjAbm            As cIABMGeneric
Private m_ObjTree           As Object

Private m_IsNew             As Boolean

Private m_BranchId          As Long
Private m_TreeId            As Long

Private m_Host              As CSMenu.cIMenuHost
Private m_Copy              As Boolean

' propiedades publicas

Public Property Get Id() As Long
  Id = m_Id
End Property

Public Property Get Nombre() As String
  Nombre = m_Nombre
End Property

Public Property Get Codigo() As String
  Codigo = m_Codigo
End Property

Public Property Get Rubt_id1() As Long
  Rubt_id1 = m_Rubt_id1
End Property
Public Property Get Tabla1() As String
  Tabla1 = m_Tabla1
End Property
Public Property Get Rubt_id2() As Long
  Rubt_id2 = m_Rubt_id2
End Property
Public Property Get Tabla2() As String
  Tabla2 = m_Tabla2
End Property
Public Property Get Rubt_id3() As Long
  Rubt_id3 = m_Rubt_id3
End Property
Public Property Get Tabla3() As String
  Tabla3 = m_Tabla3
End Property
Public Property Get Rubt_id4() As Long
  Rubt_id4 = m_Rubt_id4
End Property
Public Property Get Tabla4() As String
  Tabla4 = m_Tabla4
End Property
Public Property Get Rubt_id5() As Long
  Rubt_id5 = m_Rubt_id5
End Property
Public Property Get Tabla5() As String
  Tabla5 = m_Tabla5
End Property
Public Property Get Rubt_id6() As Long
  Rubt_id6 = m_Rubt_id6
End Property
Public Property Get Tabla6() As String
  Tabla6 = m_Tabla6
End Property
Public Property Get Rubt_id7() As Long
  Rubt_id7 = m_Rubt_id7
End Property
Public Property Get Tabla7() As String
  Tabla7 = m_Tabla7
End Property
Public Property Get Rubt_id8() As Long
  Rubt_id8 = m_Rubt_id8
End Property
Public Property Get Tabla8() As String
  Tabla8 = m_Tabla8
End Property
Public Property Get Rubt_id9() As Long
  Rubt_id9 = m_Rubt_id9
End Property
Public Property Get Tabla9() As String
  Tabla9 = m_Tabla9
End Property
Public Property Get Rubt_id10() As Long
  Rubt_id10 = m_Rubt_id10
End Property
Public Property Get Tabla10() As String
  Tabla10 = m_Tabla10
End Property
Public Property Get Rubti_id1() As Long
  Rubti_id1 = m_Rubti_id1
End Property
Public Property Get TablaItem1() As String
  TablaItem1 = m_TablaItem1
End Property
Public Property Get Rubti_id2() As Long
  Rubti_id2 = m_Rubti_id2
End Property
Public Property Get TablaItem2() As String
  TablaItem2 = m_TablaItem2
End Property
Public Property Get Rubti_id3() As Long
  Rubti_id3 = m_Rubti_id3
End Property
Public Property Get TablaItem3() As String
  TablaItem3 = m_TablaItem3
End Property
Public Property Get Rubti_id4() As Long
  Rubti_id4 = m_Rubti_id4
End Property
Public Property Get TablaItem4() As String
  TablaItem4 = m_TablaItem4
End Property
Public Property Get Rubti_id5() As Long
  Rubti_id5 = m_Rubti_id5
End Property
Public Property Get TablaItem5() As String
  TablaItem5 = m_TablaItem5
End Property
Public Property Get Rubti_id6() As Long
  Rubti_id6 = m_Rubti_id6
End Property
Public Property Get TablaItem6() As String
  TablaItem6 = m_TablaItem6
End Property
Public Property Get Rubti_id7() As Long
  Rubti_id7 = m_Rubti_id7
End Property
Public Property Get TablaItem7() As String
  TablaItem7 = m_TablaItem7
End Property
Public Property Get Rubti_id8() As Long
  Rubti_id8 = m_Rubti_id8
End Property
Public Property Get TablaItem8() As String
  TablaItem8 = m_TablaItem8
End Property
Public Property Get Rubti_id9() As Long
  Rubti_id9 = m_Rubti_id9
End Property
Public Property Get TablaItem9() As String
  TablaItem9 = m_TablaItem9
End Property
Public Property Get Rubti_id10() As Long
  Rubti_id10 = m_Rubti_id10
End Property
Public Property Get TablaItem10() As String
  TablaItem10 = m_TablaItem10
End Property

' propiedades privadas
' funciones publicas

' Implementacion de cIABMClient
Private Function cIABMClient_Copy() As Boolean
  
  cIABMClient_Terminate
  m_IsNew = True
  
  With m_ObjAbm.Properties(cscRubCodigo)
    .Value = C_C & .Value
  End With
  
'  With m_ObjAbm.Properties(cscRubNombre)
'    .Value = C_CopiaDe & .Value
'  End With
  
  m_ObjAbm.ShowValue m_ObjAbm.Properties(cscRubCodigo)
  m_ObjAbm.ShowValue m_ObjAbm.Properties(cscRubNombre)
  
  m_Copy = True
End Function

Private Function cIABMClient_EditNew() As Boolean
  
  cIABMClient_Terminate
  m_IsNew = True
  
  cIEditGeneric_Edit csNO_ID
End Function

Private Property Get cIABMClient_Aplication() As String
  cIABMClient_Aplication = gAppName
End Property

Private Property Get cIABMClient_CanAddDocDigital() As Boolean
  cIABMClient_CanAddDocDigital = m_Id <> csNO_ID
End Property

Private Property Get cIABMClient_CanCopy() As Boolean
  cIABMClient_CanCopy = True
End Property

Private Property Get cIABMClient_CanNew() As Boolean
  cIABMClient_CanNew = True
End Property

Private Function cIABMClient_ShowDocDigital() As Boolean
  On Error GoTo ControlError
  
  If m_Id = csNO_ID Then Exit Function
  
  Dim Doc As cDocDigital
  Set Doc = New cDocDigital

  Doc.ClientTable = csTRubro
  Doc.ClientTableID = m_Id

  cIABMClient_ShowDocDigital = Doc.ShowDocs(gDB)

  GoTo ExitProc
ControlError:
  MngError Err, C_ShowDocDigital, C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Private Function cIABMClient_MessageEx(ByVal MessageID As Long, ByVal Info As Variant) As Variant
  Select Case MessageID
  
    Case MSG_DOC_INFO
    
      Dim AbmGen As cABMGeneric
      Set AbmGen = m_ObjAbm
      
      CSKernelClient2.ShowHelp AbmGen.hWnd, _
                               vbNullString, _
                               vbNullString, _
                               csPreGNewRubro
      cIABMClient_MessageEx = MSG_DOC_INFO_HANDLED
    Case Else
      cIABMClient_MessageEx = True
  End Select
End Function

Private Sub cIABMClient_DiscardChanges()
  LoadCollection
End Sub

Private Function cIABMClient_ListAdHock(Lista As CSInterfacesABM.cIABMList) As Boolean

End Function

Private Sub cIABMClient_Load()

End Sub

Private Function cIABMClient_PropertyChange(ByVal Clave As Integer) As Boolean

  With m_ObjAbm.Properties
    Select Case Clave
      Case K_RUBT_ID1
        .Item(cscRubtiid1).HelpFilter = cscRubtid & " = " & .Item(cscRubtid1).HelpId
        m_ObjAbm.ShowValue .Item(cscRubtiid1)
      Case K_RUBT_ID2
        .Item(cscRubtiid2).HelpFilter = cscRubtid & " = " & .Item(cscRubtid2).HelpId
        m_ObjAbm.ShowValue .Item(cscRubtiid2)
      Case K_RUBT_ID3
        .Item(cscRubtiid3).HelpFilter = cscRubtid & " = " & .Item(cscRubtid3).HelpId
        m_ObjAbm.ShowValue .Item(cscRubtiid3)
      Case K_RUBT_ID4
        .Item(cscRubtiid4).HelpFilter = cscRubtid & " = " & .Item(cscRubtid4).HelpId
        m_ObjAbm.ShowValue .Item(cscRubtiid4)
      Case K_RUBT_ID5
        .Item(cscRubtiid5).HelpFilter = cscRubtid & " = " & .Item(cscRubtid5).HelpId
        m_ObjAbm.ShowValue .Item(cscRubtiid5)
      Case K_RUBT_ID6
        .Item(cscRubtiid6).HelpFilter = cscRubtid & " = " & .Item(cscRubtid6).HelpId
        m_ObjAbm.ShowValue .Item(cscRubtiid6)
      Case K_RUBT_ID7
        .Item(cscRubtiid7).HelpFilter = cscRubtid & " = " & .Item(cscRubtid7).HelpId
        m_ObjAbm.ShowValue .Item(cscRubtiid7)
      Case K_RUBT_ID8
        .Item(cscRubtiid8).HelpFilter = cscRubtid & " = " & .Item(cscRubtid8).HelpId
        m_ObjAbm.ShowValue .Item(cscRubtiid8)
      Case K_RUBT_ID9
        .Item(cscRubtiid9).HelpFilter = cscRubtid & " = " & .Item(cscRubtid9).HelpId
        m_ObjAbm.ShowValue .Item(cscRubtiid9)
      Case K_RUBT_ID10
        .Item(cscRubtiid10).HelpFilter = cscRubtid & " = " & .Item(cscRubtid10).HelpId
        m_ObjAbm.ShowValue .Item(cscRubtiid10)
    End Select
  End With
  
End Function

Private Function cIABMClient_Save() As Boolean
  Dim register   As cRegister
  Dim fields     As cFields
  
  Set register = New cRegister
  Set fields = register.fields
  
  With register
    .fieldId = cscRubId
    .Table = csTRubro
  
    If m_Copy Then
      .Id = csNew
    Else
      .Id = m_Id
    End If
  End With
  
  Dim IProperty As cIABMProperty
  For Each IProperty In m_ObjAbm.Properties
    With IProperty
      Select Case .Key
        Case K_NOMBRE
          fields.Add2 cscRubNombre, .Value, csText
        Case K_CODIGO
          fields.Add2 cscRubCodigo, .Value, csText
        Case K_ACTIVO
          fields.Add2 cscActivo, Val(.Value), csBoolean
        Case K_DESCRIP
          fields.Add2 cscRubDescrip, .Value, csText
        Case K_ESCRITERIO
          fields.Add2 cscRubEsCriterio, Val(.Value), csBoolean
        Case K_RUBT_ID1
          fields.Add2 cscRubtid1, .HelpId, csId
        Case K_RUBT_ID2
          fields.Add2 cscRubtid2, .HelpId, csId
        Case K_RUBT_ID3
          fields.Add2 cscRubtid3, .HelpId, csId
        Case K_RUBT_ID4
          fields.Add2 cscRubtid4, .HelpId, csId
        Case K_RUBT_ID5
          fields.Add2 cscRubtid5, .HelpId, csId
        Case K_RUBT_ID6
          fields.Add2 cscRubtid6, .HelpId, csId
        Case K_RUBT_ID7
          fields.Add2 cscRubtid7, .HelpId, csId
        Case K_RUBT_ID8
          fields.Add2 cscRubtid8, .HelpId, csId
        Case K_RUBT_ID9
          fields.Add2 cscRubtid9, .HelpId, csId
        Case K_RUBT_ID10
          fields.Add2 cscRubtid10, .HelpId, csId
        Case K_RUBTI_ID1
          fields.Add2 cscRubtiid1, .HelpId, csId
        Case K_RUBTI_ID2
          fields.Add2 cscRubtiid2, .HelpId, csId
        Case K_RUBTI_ID3
          fields.Add2 cscRubtiid3, .HelpId, csId
        Case K_RUBTI_ID4
          fields.Add2 cscRubtiid4, .HelpId, csId
        Case K_RUBTI_ID5
          fields.Add2 cscRubtiid5, .HelpId, csId
        Case K_RUBTI_ID6
          fields.Add2 cscRubtiid6, .HelpId, csId
        Case K_RUBTI_ID7
          fields.Add2 cscRubtiid7, .HelpId, csId
        Case K_RUBTI_ID8
          fields.Add2 cscRubtiid8, .HelpId, csId
        Case K_RUBTI_ID9
          fields.Add2 cscRubtiid9, .HelpId, csId
        Case K_RUBTI_ID10
          fields.Add2 cscRubtiid10, .HelpId, csId
      End Select
    End With
  Next
  
  fields.HaveLastUpdate = True
  fields.HaveWhoModify = True
                                                         'Error al grabar Rubros
  If Not gDB.SaveEx(register, , _
                    cscRubCodigo, _
                    C_ABMClientSave, _
                    C_Module, _
                    LNGGetText(1451, vbNullString)) Then Exit Function
  
  m_Copy = False
  cIABMClient_Save = Load(register.Id)
End Function

Private Function cIABMClient_Terminate() As Boolean
  m_Editing = False
  
  cIABMClient_Terminate = True
  ' Este objeto puede no cumplir con la interfaz esperada, asi que si hay un error no
  ' le doy bola
  On Error GoTo ControlError
  If m_Id = csNO_ID Then Exit Function
  If m_ObjTree Is Nothing Then Exit Function
  
  If m_IsNew Then
    m_ObjTree.AddLeave m_Id, m_BranchId, m_TreeId
  Else
    m_ObjTree.AddEditedId m_Id
    m_ObjTree.RefreshActiveBranch
  End If
ControlError:
End Function

Private Property Get cIABMClient_Title() As String
  cIABMClient_Title = LNGGetText(1428, vbNullString)  'Rubros
End Property

Private Function cIABMClient_Validate() As Boolean

  Dim IProperty As cIABMProperty

  For Each IProperty In m_ObjAbm.Properties
    With IProperty
      Select Case .Key
        Case K_NOMBRE
          If ValEmpty(.Value, csText) Then
            MsgInfo C_DebeIndicarNombre
            Exit Function
          End If
        Case K_CODIGO
          If ValEmpty(.Value, csText) Then
            .Value = c_get_codigo_from_id
          End If

      End Select
    End With
  Next

  cIABMClient_Validate = True
End Function

' Implementacion de cIEditGeneric
Private Property Get cIEditGeneric_ObjAbm() As CSInterfacesABM.cIABMGeneric
  Set cIEditGeneric_ObjAbm = m_ObjAbm
End Property

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
  cIEditGeneric_ShowList = SecurityCanAccess(csPreGListRubro)
End Function

Private Property Set cIEditGeneric_ObjAbm(rhs As CSInterfacesABM.cIABMGeneric)
  Set m_ObjAbm = rhs
End Property

Private Property Get cIEditGeneric_Editing() As Boolean
  cIEditGeneric_Editing = m_Editing
End Property

Private Function cIEditGeneric_Delete(Id As Long) As Boolean
  If Not SecurityCanAccess(csPreGDeleteRubro) Then Exit Function

  Dim sqlstmt As String
  
  sqlstmt = "delete Rubro where rub_id = " & Id
  
  cIEditGeneric_Delete = gDB.Execute(sqlstmt, C_EditGenericDelete, C_Module)
End Function

Private Function cIEditGeneric_Search(Id As Long, Cancela As Boolean) As Boolean

End Function

Private Function cIEditGeneric_Edit(Id As Long, Optional ByVal InModalWindow As Boolean) As Boolean
  On Error GoTo ControlError
  
  If Id = csNO_ID Then
    m_IsNew = True
    If Not SecurityCanAccess(csPreGNewRubro) Then Exit Function
  Else
    m_IsNew = False
    If Not SecurityCanAccess(csPreGEditRubro) Then Exit Function
  End If

  m_ObjAbm.InModalWindow = InModalWindow

  If Not Load(Id) Then Exit Function
  
  If Not LoadCollection() Then Exit Function
  
  m_Editing = True
  m_Copy = False
 
  If InModalWindow Then
    cIEditGeneric_Edit = m_Id <> csNO_ID
  Else
    cIEditGeneric_Edit = True
  End If

  Exit Function
ControlError:
  MngError Err, C_EditGenericEdit, C_Module, vbNullString
End Function

Private Function cIEditGeneric_PrintObj(ByVal Id As Long) As Boolean

End Function

Private Property Set cIEditGeneric_ObjTree(rhs As Object)
  Set m_ObjTree = rhs
End Property

Private Function cIEditGeneric_PropertyChange(ByVal Clave As Integer) As Boolean

End Function

Private Property Let cIEditGeneric_BranchId(ByVal rhs As Long)
  m_BranchId = rhs
End Property

Private Property Get cIEditGeneric_BranchId() As Long
  cIEditGeneric_BranchId = m_BranchId
End Property

Private Function cIEditGeneric_TabClick(ByVal Index As Integer) As Boolean

End Function

Private Function cIEditGeneric_Preview(ByVal Id As Long) As Boolean

End Function

Private Function cIMenuClient_Initialize(F As Object, Host As CSMenu.cIMenuHost) As Boolean
  On Error GoTo ControlError

  Set m_Host = Host

  m_Host.Server.AddMenu C_MenuArticulos, csMenuConfigArticulos, C_MenuConfig, 0, True, False, False, False, True, Nothing
                           '&Rubros
  m_Host.Server.AddMenu LNGGetText(1429, vbNullString), csPreGListRubro, C_MenuArticulos, 0, True, False, False, False, False, Me

  cIMenuClient_Initialize = True

  GoTo ExitProc
ControlError:
  MngError Err, C_MenuClientInit, C_Module, vbNullString
  If Err.Number Then Resume ExitProc

ExitProc:
  On Error Resume Next
End Function

Private Function cIMenuClient_ProcessMenu(ByVal Id As Long) As Variant
                                                    'Rubros
  m_Host.MenuABMClick "CSGeneral2.cRubro", Me, LNGGetText(1429, vbNullString), 0, csETablasGeneral.csRubro
End Function

' funciones privadas
Private Function LoadCollection() As Boolean
  
  Dim c As cIABMProperty
      
  Dim AbmObj As cABMGeneric
  Set AbmObj = m_ObjAbm
  AbmObj.MinHeight = 7200
      
  With m_ObjAbm.Tabs
    
    .Clear
      
    With .Add(Nothing)
      .Name = C_strGeneral
    End With
  
    With .Add(Nothing)
      .Index = 1
      .Name = LNGGetText(1430, vbNullString)  'Tablas
    End With
  
  End With
  
  m_ObjAbm.Title2 = m_Nombre
  
  With m_ObjAbm.Properties
    
    .Clear
  
    With .Add(Nothing, cscRubNombre)
      .PropertyType = cspText
      .Name = C_strNombre
      .Size = 100
      .Key = K_NOMBRE
      .Value = m_Nombre
      .Width = 6200
    End With
    
    With .Add(Nothing, cscRubCodigo)
      .PropertyType = cspText
      .Name = C_strCodigo
      .Size = 15
      .Value = m_Codigo
      .Key = K_CODIGO
    End With
    
    With .Add(Nothing, cscActivo)
      .PropertyType = cspCheck
      .Name = C_strActivo
      .Key = K_ACTIVO
      .Value = CInt(m_Activo)
    End With
    
    With .Add(Nothing, cscRubEsCriterio)
      .PropertyType = cspCheck
      .Name = LNGGetText(4736, vbNullString) 'Es un criterio de busqueda
      .Key = K_ESCRITERIO
      .Value = CInt(m_EsCriterio)
      .TopNotChange = True
      .LeftNotChange = True
      .TopFromProperty = cscActivo
      .Left = 5000
      .LeftLabel = -2100
    End With
    
    With .Add(Nothing, cscRubDescrip)
      .PropertyType = cspText
      .LeftFromProperty = cscActivo
      .TopFromProperty = cscActivo
      .TopToPrevious = 440
      .Name = C_strDescrip
      .Size = 255
      .Key = K_DESCRIP
      .Value = m_descrip
      .SubType = cspMemo
      .Width = 6200
      .Height = 880
    End With
    
    '//////////////////////////
    '
    ' Tablas
    '
    '//////////////////////////
    
    With .Add(Nothing, cscRubtid1)
      .PropertyType = cspHelp
      .Table = csRubroTabla
      .Name = LNGGetText(1431, vbNullString)  'Tabla 1
      .Key = K_RUBT_ID1
      .Value = m_Tabla1
      .HelpId = m_Rubt_id1
      .TabIndex = 1
    End With
    
    With .Add(Nothing, cscRubtiid1)
      .PropertyType = cspHelp
      .Table = csRubroTablaItem
      .HelpFilter = cscRubtid & " = " & m_Rubt_id1
      .TopFromProperty = cscRubtid1
      .TopNotChange = True
      .Left = 5500
      .LeftNotChange = True
      .Name = LNGGetText(1432, vbNullString)  'Item 1
      .Key = K_RUBTI_ID1
      .Value = m_TablaItem1
      .HelpId = m_Rubti_id1
      .TabIndex = 1
    End With
    
    With .Add(Nothing, cscRubtid2)
      .PropertyType = cspHelp
      .Table = csRubroTabla
      .Name = LNGGetText(1433, vbNullString)  'Tabla 2
      .Key = K_RUBT_ID2
      .Value = m_Tabla2
      .HelpId = m_Rubt_id2
      .TabIndex = 1
    End With
    
    With .Add(Nothing, cscRubtiid2)
      .PropertyType = cspHelp
      .Table = csRubroTablaItem
      .HelpFilter = cscRubtid & " = " & m_Rubt_id2
      .TopFromProperty = cscRubtid2
      .TopNotChange = True
      .Left = 5500
      .LeftNotChange = True
      .Name = LNGGetText(1434, vbNullString)  'Item 2
      .Key = K_RUBTI_ID2
      .Value = m_TablaItem2
      .HelpId = m_Rubti_id2
      .TabIndex = 1
    End With
  
    With .Add(Nothing, cscRubtid3)
      .PropertyType = cspHelp
      .Table = csRubroTabla
      .Name = LNGGetText(1435, vbNullString)  'Tabla 3
      .Key = K_RUBT_ID3
      .Value = m_Tabla3
      .HelpId = m_Rubt_id3
      .TabIndex = 1
    End With
  
    With .Add(Nothing, cscRubtiid3)
      .PropertyType = cspHelp
      .Table = csRubroTablaItem
      .HelpFilter = cscRubtid & " = " & m_Rubt_id3
      .TopFromProperty = cscRubtid3
      .TopNotChange = True
      .Left = 5500
      .LeftNotChange = True
      .Name = LNGGetText(1436, vbNullString)  'Item 3
      .Key = K_RUBTI_ID3
      .Value = m_TablaItem3
      .HelpId = m_Rubti_id3
      .TabIndex = 1
    End With
  
    With .Add(Nothing, cscRubtid4)
      .PropertyType = cspHelp
      .Table = csRubroTabla
      .Name = LNGGetText(1437, vbNullString)  'Tabla 4
      .Key = K_RUBT_ID4
      .Value = m_Tabla4
      .HelpId = m_Rubt_id4
      .TabIndex = 1
    End With
  
    With .Add(Nothing, cscRubtiid4)
      .PropertyType = cspHelp
      .Table = csRubroTablaItem
      .HelpFilter = cscRubtid & " = " & m_Rubt_id4
      .TopFromProperty = cscRubtid4
      .TopNotChange = True
      .Left = 5500
      .LeftNotChange = True
      .Name = LNGGetText(1438, vbNullString)  'Item 4
      .Key = K_RUBTI_ID4
      .Value = m_TablaItem4
      .HelpId = m_Rubti_id4
      .TabIndex = 1
    End With
  
    With .Add(Nothing, cscRubtid5)
      .PropertyType = cspHelp
      .Table = csRubroTabla
      .Name = LNGGetText(1439, vbNullString)  'Tabla 5
      .Key = K_RUBT_ID5
      .Value = m_Tabla5
      .HelpId = m_Rubt_id5
      .TabIndex = 1
    End With
  
    With .Add(Nothing, cscRubtiid5)
      .PropertyType = cspHelp
      .Table = csRubroTablaItem
      .HelpFilter = cscRubtid & " = " & m_Rubt_id5
      .TopFromProperty = cscRubtid5
      .TopNotChange = True
      .Left = 5500
      .LeftNotChange = True
      .Name = LNGGetText(1440, vbNullString)  'Item 5
      .Key = K_RUBTI_ID5
      .Value = m_TablaItem5
      .HelpId = m_Rubti_id5
      .TabIndex = 1
    End With
  
    With .Add(Nothing, cscRubtid6)
      .PropertyType = cspHelp
      .Table = csRubroTabla
      .Name = LNGGetText(1441, vbNullString)  'Tabla 6
      .Key = K_RUBT_ID6
      .Value = m_Tabla6
      .HelpId = m_Rubt_id6
      .TabIndex = 1
    End With
  
    With .Add(Nothing, cscRubtiid6)
      .PropertyType = cspHelp
      .Table = csRubroTablaItem
      .HelpFilter = cscRubtid & " = " & m_Rubt_id6
      .TopFromProperty = cscRubtid6
      .TopNotChange = True
      .Left = 5500
      .LeftNotChange = True
      .Name = LNGGetText(1442, vbNullString)  'Item 6
      .Key = K_RUBTI_ID6
      .Value = m_TablaItem6
      .HelpId = m_Rubti_id6
      .TabIndex = 1
    End With
  
    With .Add(Nothing, cscRubtid7)
      .PropertyType = cspHelp
      .Table = csRubroTabla
      .Name = LNGGetText(1443, vbNullString)  'Tabla 7
      .Key = K_RUBT_ID7
      .Value = m_Tabla7
      .HelpId = m_Rubt_id7
      .TabIndex = 1
    End With
  
    With .Add(Nothing, cscRubtiid7)
      .PropertyType = cspHelp
      .Table = csRubroTablaItem
      .HelpFilter = cscRubtid & " = " & m_Rubt_id7
      .TopFromProperty = cscRubtid7
      .TopNotChange = True
      .Left = 5500
      .LeftNotChange = True
      .Name = LNGGetText(1444, vbNullString)  'Item 7
      .Key = K_RUBTI_ID7
      .Value = m_TablaItem7
      .HelpId = m_Rubti_id7
      .TabIndex = 1
    End With
  
    With .Add(Nothing, cscRubtid8)
      .PropertyType = cspHelp
      .Table = csRubroTabla
      .Name = LNGGetText(1445, vbNullString)  'Tabla 8
      .Key = K_RUBT_ID8
      .Value = m_Tabla8
      .HelpId = m_Rubt_id8
      .TabIndex = 1
    End With
  
    With .Add(Nothing, cscRubtiid8)
      .PropertyType = cspHelp
      .Table = csRubroTablaItem
      .HelpFilter = cscRubtid & " = " & m_Rubt_id8
      .TopFromProperty = cscRubtid8
      .TopNotChange = True
      .Left = 5500
      .LeftNotChange = True
      .Name = LNGGetText(1446, vbNullString)  'Item 8
      .Key = K_RUBTI_ID8
      .Value = m_TablaItem8
      .HelpId = m_Rubti_id8
      .TabIndex = 1
    End With
    
    With .Add(Nothing, cscRubtid9)
      .PropertyType = cspHelp
      .Table = csRubroTabla
      .Name = LNGGetText(1447, vbNullString)  'Tabla 9
      .Key = K_RUBT_ID9
      .Value = m_Tabla9
      .HelpId = m_Rubt_id9
      .TabIndex = 1
    End With
  
    With .Add(Nothing, cscRubtiid9)
      .PropertyType = cspHelp
      .Table = csRubroTablaItem
      .HelpFilter = cscRubtid & " = " & m_Rubt_id9
      .TopFromProperty = cscRubtid9
      .TopNotChange = True
      .Left = 5500
      .LeftNotChange = True
      .Name = LNGGetText(1448, vbNullString)  'Item 9
      .Key = K_RUBTI_ID9
      .Value = m_TablaItem9
      .HelpId = m_Rubti_id9
      .TabIndex = 1
    End With
    
    With .Add(Nothing, cscRubtid10)
      .PropertyType = cspHelp
      .Table = csRubroTabla
      .Name = LNGGetText(1449, vbNullString)  'Tabla 10
      .Key = K_RUBT_ID10
      .Value = m_Tabla10
      .HelpId = m_Rubt_id10
      .TabIndex = 1
    End With
  
    With .Add(Nothing, cscRubtiid10)
      .PropertyType = cspHelp
      .Table = csRubroTablaItem
      .HelpFilter = cscRubtid & " = " & m_Rubt_id10
      .TopFromProperty = cscRubtid10
      .TopNotChange = True
      .Left = 5500
      .LeftNotChange = True
      .Name = LNGGetText(1450, vbNullString)  'Item 10
      .Key = K_RUBTI_ID10
      .Value = m_TablaItem10
      .HelpId = m_Rubti_id10
      .TabIndex = 1
    End With
  
  End With
  
  If Not m_ObjAbm.Show(Me) Then Exit Function

  LoadCollection = True
End Function

Public Function Load(ByVal Id As Long) As Boolean
  
  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  
  sqlstmt = "sp_RubroGet " & Id
  
  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, C_LoadFunction, C_Module) Then Exit Function
  
  If rs.EOF Then
    m_Activo = True
    m_EsCriterio = False
    m_Nombre = vbNullString
    m_Codigo = vbNullString
    m_Id = csNO_ID
    m_descrip = vbNullString
  
    m_Rubt_id1 = csNO_ID
    m_Rubt_id2 = csNO_ID
    m_Rubt_id3 = csNO_ID
    m_Rubt_id4 = csNO_ID
    m_Rubt_id5 = csNO_ID
    m_Rubt_id6 = csNO_ID
    m_Rubt_id7 = csNO_ID
    m_Rubt_id8 = csNO_ID
    m_Rubt_id9 = csNO_ID
    m_Rubt_id10 = csNO_ID
    
    m_Tabla1 = vbNullString
    m_Tabla2 = vbNullString
    m_Tabla3 = vbNullString
    m_Tabla4 = vbNullString
    m_Tabla5 = vbNullString
    m_Tabla6 = vbNullString
    m_Tabla7 = vbNullString
    m_Tabla8 = vbNullString
    m_Tabla9 = vbNullString
    m_Tabla10 = vbNullString
    
    m_Rubti_id1 = csNO_ID
    m_Rubti_id2 = csNO_ID
    m_Rubti_id3 = csNO_ID
    m_Rubti_id4 = csNO_ID
    m_Rubti_id5 = csNO_ID
    m_Rubti_id6 = csNO_ID
    m_Rubti_id7 = csNO_ID
    m_Rubti_id8 = csNO_ID
    m_Rubti_id9 = csNO_ID
    m_Rubti_id10 = csNO_ID
  
    m_TablaItem1 = vbNullString
    m_TablaItem2 = vbNullString
    m_TablaItem3 = vbNullString
    m_TablaItem4 = vbNullString
    m_TablaItem5 = vbNullString
    m_TablaItem6 = vbNullString
    m_TablaItem7 = vbNullString
    m_TablaItem8 = vbNullString
    m_TablaItem9 = vbNullString
    m_TablaItem10 = vbNullString
  
  Else
    m_Activo = gDB.ValField(rs.fields, cscActivo)
    m_EsCriterio = gDB.ValField(rs.fields, cscRubEsCriterio)
    m_Nombre = gDB.ValField(rs.fields, cscRubNombre)
    m_Codigo = gDB.ValField(rs.fields, cscRubCodigo)
    m_Id = gDB.ValField(rs.fields, cscRubId)
    m_descrip = gDB.ValField(rs.fields, cscRubDescrip)
  
    m_Rubt_id1 = gDB.ValField(rs.fields, cscRubtid1)
    m_Rubt_id2 = gDB.ValField(rs.fields, cscRubtid2)
    m_Rubt_id3 = gDB.ValField(rs.fields, cscRubtid3)
    m_Rubt_id4 = gDB.ValField(rs.fields, cscRubtid4)
    m_Rubt_id5 = gDB.ValField(rs.fields, cscRubtid5)
    m_Rubt_id6 = gDB.ValField(rs.fields, cscRubtid6)
    m_Rubt_id7 = gDB.ValField(rs.fields, cscRubtid7)
    m_Rubt_id8 = gDB.ValField(rs.fields, cscRubtid8)
    m_Rubt_id9 = gDB.ValField(rs.fields, cscRubtid9)
    m_Rubt_id10 = gDB.ValField(rs.fields, cscRubtid10)
    
    m_Tabla1 = gDB.ValField(rs.fields, "rubro1")
    m_Tabla2 = gDB.ValField(rs.fields, "rubro2")
    m_Tabla3 = gDB.ValField(rs.fields, "rubro3")
    m_Tabla4 = gDB.ValField(rs.fields, "rubro4")
    m_Tabla5 = gDB.ValField(rs.fields, "rubro5")
    m_Tabla6 = gDB.ValField(rs.fields, "rubro6")
    m_Tabla7 = gDB.ValField(rs.fields, "rubro7")
    m_Tabla8 = gDB.ValField(rs.fields, "rubro8")
    m_Tabla9 = gDB.ValField(rs.fields, "rubro9")
    m_Tabla10 = gDB.ValField(rs.fields, "rubro10")
    
    m_Rubti_id1 = gDB.ValField(rs.fields, cscRubtiid1)
    m_Rubti_id2 = gDB.ValField(rs.fields, cscRubtiid2)
    m_Rubti_id3 = gDB.ValField(rs.fields, cscRubtiid3)
    m_Rubti_id4 = gDB.ValField(rs.fields, cscRubtiid4)
    m_Rubti_id5 = gDB.ValField(rs.fields, cscRubtiid5)
    m_Rubti_id6 = gDB.ValField(rs.fields, cscRubtiid6)
    m_Rubti_id7 = gDB.ValField(rs.fields, cscRubtiid7)
    m_Rubti_id8 = gDB.ValField(rs.fields, cscRubtiid8)
    m_Rubti_id9 = gDB.ValField(rs.fields, cscRubtiid9)
    m_Rubti_id10 = gDB.ValField(rs.fields, cscRubtiid10)
  
    m_TablaItem1 = gDB.ValField(rs.fields, "rubroi1")
    m_TablaItem2 = gDB.ValField(rs.fields, "rubroi2")
    m_TablaItem3 = gDB.ValField(rs.fields, "rubroi3")
    m_TablaItem4 = gDB.ValField(rs.fields, "rubroi4")
    m_TablaItem5 = gDB.ValField(rs.fields, "rubroi5")
    m_TablaItem6 = gDB.ValField(rs.fields, "rubroi6")
    m_TablaItem7 = gDB.ValField(rs.fields, "rubroi7")
    m_TablaItem8 = gDB.ValField(rs.fields, "rubroi8")
    m_TablaItem9 = gDB.ValField(rs.fields, "rubroi9")
    m_TablaItem10 = gDB.ValField(rs.fields, "rubroi10")
  End If
  
  Load = True
End Function

' construccion - destruccion
Private Sub Class_Terminate()
  On Error Resume Next
  Set m_ObjAbm = Nothing
  Set m_ObjTree = Nothing
End Sub
