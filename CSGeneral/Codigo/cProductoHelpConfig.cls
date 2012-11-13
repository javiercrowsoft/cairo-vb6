VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cProductoHelpConfig"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements CSInterfacesABM.cIEditGeneric
Implements CSInterfacesABM.cIABMClient
Implements CSMenu.cIMenuClient
'--------------------------------------------------------------------------------
' cProductoHelpConfig
' 25-01-01

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cProductoHelpConfig"

Private Const K_TECLA                          As Integer = 1
Private Const K_ATRIBUTO_INDICE                As Integer = 2
Private Const K_VALOR_CODIGO                   As Integer = 3
Private Const K_ACTIVO                         As Integer = 4
Private Const K_DESCRIP                        As Integer = 5
Private Const K_NOMBRE                         As Integer = 6
Private Const K_DEFAULT                        As Integer = 7
Private Const K_DEFAULT_SRV                    As Integer = 8
Private Const K_DEFAULT_PRP                    As Integer = 9
Private Const K_DEFAULT_PRNS                   As Integer = 10

' estructuras
' variables privadas
Private m_Id                           As Long
Private m_Nombre                       As String
Private m_Tecla                        As String
Private m_Atributo_indice              As Integer
Private m_Valor_codigo                 As String
Private m_Activo                       As Integer
Private m_descrip                      As String
Private m_Default                      As Integer
Private m_DefaultSrv                   As Integer
Private m_DefaultPrp                   As Integer
Private m_DefaultPrns                  As Integer

Private m_Editing           As Boolean

Private m_ObjAbm            As cIABMGeneric
Private m_ObjTree           As Object

Private m_IsNew             As Boolean

Private m_BranchId          As Long
Private m_TreeId            As Long

Private m_Host              As CSMenu.cIMenuHost
Private m_Copy              As Boolean

' propiedades publicas
' propiedades privadas
' funciones publicas

' Implementacion de cIABMClient
Private Function cIABMClient_Copy() As Boolean
  
  cIABMClient_Terminate
  m_IsNew = True
  
  With m_ObjAbm.Properties(cscPrhcTecla)
    .Value = C_C & .Value
  End With
    
  m_ObjAbm.ShowValue m_ObjAbm.Properties(cscPrhcTecla)
  
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

  Doc.ClientTable = csTProductoHelpConfig
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
                               csPreGNewProductoHelpConfig
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
'
End Function

Private Function cIABMClient_Save() As Boolean
    Dim register   As cRegister
    Dim fields     As cFields
    
    Set register = New cRegister
    Set fields = register.fields
    
    With register
      .fieldId = cscPrhcId
      .Table = csTProductoHelpConfig
      
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
                    fields.Add2 cscPrhcNombre, .Value, csText
                Case K_TECLA
                    fields.Add2 cscPrhcTecla, .Value, csText
                Case K_ATRIBUTO_INDICE
                    fields.Add2 cscPrhcAtributoIndice, .Value, csInteger
                Case K_VALOR_CODIGO
                    fields.Add2 cscPrhcValorCodigo, .Value, csText
                Case K_ACTIVO
                    fields.Add2 cscActivo, Val(.Value), csBoolean
                Case K_DESCRIP
                    fields.Add2 cscPrhcDescrip, .Value, csText
                Case K_DEFAULT
                    fields.Add2 cscPrhcDefault, Val(.Value), csBoolean
                Case K_DEFAULT_SRV
                    fields.Add2 cscPrhcDefaultSrv, Val(.Value), csBoolean
                Case K_DEFAULT_PRP
                    fields.Add2 cscPrhcDefaultPrp, Val(.Value), csBoolean
                Case K_DEFAULT_PRNS
                    fields.Add2 cscPrhcDefaultPrns, Val(.Value), csBoolean
            End Select
        End With
    Next
    
    fields.HaveLastUpdate = True
    fields.HaveWhoModify = True
                                                           'Error al grabar la configuracion del help de articulos
    If Not gDB.Save(register, , _
                    C_ABMClientSave, _
                    C_Module, _
                    LNGGetText(3911, vbNullString)) Then Exit Function
    
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
    cIABMClient_Title = LNGGetText(3912, vbNullString)  'Configuración del Help de Articulos
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
        Case K_TECLA
          If ValEmpty(.Value, csText) Then
            MsgInfo LNGGetText(3905, vbNullString) ' Debe indicar una tecla
            Exit Function
          End If
        Case K_VALOR_CODIGO
          If ValEmpty(.Value, csText) Then
            MsgInfo LNGGetText(3906, vbNullString) ' Debe indicar un valor para el código
            Exit Function
          End If
        Case K_ATRIBUTO_INDICE
          If Val(.Value) <= 0 Or Val(.Value) > 10 Then
            MsgInfo LNGGetText(3907, vbNullString) ' Debe indicar el indice del atributo
            Exit Function
          End If
      End Select
    End With
  Next
  
  cIABMClient_Validate = True
End Function

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
    cIEditGeneric_ShowList = SecurityCanAccess(csPreGListProductoHelpConfig)
End Function

' Implementacion de cIEditGeneric
Private Property Set cIEditGeneric_ObjAbm(rhs As CSInterfacesABM.cIABMGeneric)
    Set m_ObjAbm = rhs
End Property

Private Property Get cIEditGeneric_Editing() As Boolean
    cIEditGeneric_Editing = m_Editing
End Property

Private Function cIEditGeneric_Delete(Id As Long) As Boolean
    If Not SecurityCanAccess(csPreGDeleteProductoHelpConfig) Then Exit Function
    
    Dim sqlstmt As String
    
    sqlstmt = "delete ProductoHelpConfig where prhc_id = " & Id
    
    cIEditGeneric_Delete = gDB.Execute(sqlstmt, C_EditGenericDelete, C_Module)
End Function

Private Function cIEditGeneric_Search(Id As Long, Cancela As Boolean) As Boolean

End Function

Private Function cIEditGeneric_Edit(Id As Long, Optional ByVal InModalWindow As Boolean) As Boolean
  On Error GoTo ControlError
  
  If Id = csNO_ID Then
    m_IsNew = True
    If Not SecurityCanAccess(csPreGNewProductoHelpConfig) Then Exit Function
  Else
    m_IsNew = False
    If Not SecurityCanAccess(csPreGEditProductoHelpConfig) Then Exit Function
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
                            '&Configuración de Help de Articulos
  m_Host.Server.AddMenu LNGGetText(3910, vbNullString), csPreGListProductoHelpConfig, C_MenuArticulos, 0, True, False, False, False, False, Me

  cIMenuClient_Initialize = True

  GoTo ExitProc
ControlError:
  MngError Err, C_MenuClientInit, C_Module, vbNullString
  If Err.Number Then Resume ExitProc

ExitProc:
  On Error Resume Next
End Function

Private Function cIMenuClient_ProcessMenu(ByVal Id As Long) As Variant
                                                    'Configuración del Help de Articulos
  m_Host.MenuABMClick "CSGeneral2.cProductoHelpConfig", Me, LNGGetText(3912, vbNullString), 0, csETablasGeneral.csProductoHelpConfig
End Function


' funciones privadas
Private Function LoadCollection() As Boolean
  
  Dim AbmObj As cABMGeneric
  Set AbmObj = m_ObjAbm
  AbmObj.MinHeight = 6400
  
  With m_ObjAbm.Properties
    .Clear
    
    With .Add(Nothing, cscPrhcNombre)
      .PropertyType = cspText
      .Name = C_strNombre
      .Key = K_NOMBRE
      .Value = m_Nombre
      .Width = 7000
    End With
    
    With .Add(Nothing, cscPrhcTecla)
      .PropertyType = cspText
      .Name = LNGGetText(3904, vbNullString) ' Tecla
      .Key = K_TECLA
      .Value = m_Tecla
    End With
      
    With .Add(Nothing, cscPrhcValorCodigo)
      .PropertyType = cspText
      .Name = LNGGetText(3909, vbNullString) ' Valor Código
      .Key = K_VALOR_CODIGO
      .Value = m_Valor_codigo
    End With
      
    With .Add(Nothing, cscPrhcAtributoIndice)
      .PropertyType = cspNumeric
      .SubType = cspInteger
      .Name = LNGGetText(3908, vbNullString) ' Indice del Atributo
      .Value = m_Atributo_indice
      .Key = K_ATRIBUTO_INDICE
      .Width = 800
    End With
    
    With .Add(Nothing, cscActivo)
      .PropertyType = cspCheck
      .Name = C_strActivo
      .Key = K_ACTIVO
      .Value = m_Activo
    End With
    
    With .Add(Nothing, cscPrhcDefault)
      .PropertyType = cspCheck
      .Name = LNGGetText(3919, vbNullString) ' Default Ventas
      .Key = K_DEFAULT
      .Value = m_Default
      .LeftNotChange = True
      .Left = 2150
      .LeftLabel = -1800
    End With
    
    With .Add(Nothing, cscPrhcDefaultSrv)
      .PropertyType = cspCheck
      .Name = LNGGetText(3920, vbNullString) ' Default Servicios
      .Key = K_DEFAULT_SRV
      .Value = m_DefaultSrv
      .LeftNotChange = True
      .Left = 4700
      .LeftLabel = -1880
      .TopFromProperty = cscPrhcDefault
    End With
    
    With .Add(Nothing, cscPrhcDefaultPrp)
      .PropertyType = cspCheck
      .Name = LNGGetText(3964, vbNullString) ' Default Parte de Reparación
      .Key = K_DEFAULT_PRP
      .Value = m_DefaultPrp
      .LeftNotChange = True
      .Left = 8000
      .LeftLabel = -2180
      .TopFromProperty = cscPrhcDefault
    End With
    
    With .Add(Nothing, cscPrhcDefaultPrns)
      .PropertyType = cspCheck
      .Name = LNGGetText(3965, vbNullString) ' Default en Equipos
      .Key = K_DEFAULT_PRNS
      .Value = m_DefaultPrns
      .LeftNotChange = True
      .Left = 2150
      .LeftLabel = -1800
    End With
    
    With .Add(Nothing, cscPrhcDescrip)
      .PropertyType = cspText
      .SubType = cspMemo
      .Width = 7000
      .Height = 880
      .Name = C_strDescrip
      .Key = K_DESCRIP
      .Value = m_descrip
    End With
    
  End With
      
    If Not m_ObjAbm.Show(Me) Then Exit Function

    LoadCollection = True
End Function

Private Function Load(ByVal Id As Long) As Boolean
    
    Dim sqlstmt As String
    Dim rs      As ADODB.Recordset

    sqlstmt = "select * from ProductoHelpConfig where prhc_id = " & Id
    
    If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, C_LoadFunction, C_Module) Then Exit Function
    
    If rs.EOF Then
        m_Nombre = vbNullString
        m_Tecla = vbNullString
        m_Atributo_indice = 0
        m_Valor_codigo = vbNullString
        m_Id = csNO_ID
        m_Activo = True
        m_Default = False
        m_DefaultSrv = False
        m_DefaultPrp = False
        m_DefaultPrns = False
        m_descrip = vbNullString
    Else
        m_Tecla = gDB.ValField(rs.fields, cscPrhcTecla)
        m_Nombre = gDB.ValField(rs.fields, cscPrhcNombre)
        m_Atributo_indice = gDB.ValField(rs.fields, cscPrhcAtributoIndice)
        m_Valor_codigo = gDB.ValField(rs.fields, cscPrhcValorCodigo)
        m_Id = gDB.ValField(rs.fields, cscPrhcId)
        m_Activo = gDB.ValField(rs.fields, cscActivo)
        m_Default = gDB.ValField(rs.fields, cscPrhcDefault)
        m_DefaultSrv = gDB.ValField(rs.fields, cscPrhcDefaultSrv)
        m_DefaultPrp = gDB.ValField(rs.fields, cscPrhcDefaultPrp)
        m_DefaultPrns = gDB.ValField(rs.fields, cscPrhcDefaultPrns)
        m_descrip = gDB.ValField(rs.fields, cscPrhcDescrip)
    End If
    Load = True
End Function

' construccion - destruccion
Private Sub Class_Terminate()
  On Error Resume Next
  Set m_ObjAbm = Nothing
  Set m_ObjTree = Nothing
End Sub


