VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cBanco"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements CSInterfacesABM.cIEditGeneric
Implements CSInterfacesABM.cIABMClient
Implements CSMenu.cIMenuClient
'--------------------------------------------------------------------------------
' cBanco
' 31-01-01

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module      As String = "cBanco"

Private Const K_NOMBRE      As Integer = 1
Private Const K_CODIGO      As Integer = 2
Private Const K_CONTACTO    As Integer = 3
Private Const K_TELEFONO    As Integer = 4
Private Const K_DIRECCION   As Integer = 5
Private Const K_WEB         As Integer = 6
Private Const K_MAIL        As Integer = 7
Private Const K_ACTIVO      As Integer = 8
' estructuras
' variables privadas
Private m_Id                As Long
Private m_Nombre            As String
Private m_Codigo            As String
Private m_Activo            As Boolean
Private m_Contacto          As String
Private m_telefono          As String
Private m_direccion         As String
Private m_Web               As String
Private m_Mail              As String

Private m_Editing          As Boolean

Private m_ObjAbm           As cIABMGeneric
Private m_ObjTree          As Object

Private m_IsNew            As Boolean

Private m_BranchId         As Long
Private m_TreeId           As Long

Private m_Host As CSMenu.cIMenuHost
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

' propiedades privadas
' funciones publicas

' Implementacion de cIABMClient
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

  Doc.ClientTable = csTBanco
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
                               csPreGNewBanco
      cIABMClient_MessageEx = MSG_DOC_INFO_HANDLED
    Case Else
      cIABMClient_MessageEx = True
  End Select
End Function

Private Function cIABMClient_Copy() As Boolean
  
  cIABMClient_Terminate
  m_IsNew = True
  
  With m_ObjAbm.Properties(cscBcoCodigo)
    .Value = C_C & .Value
  End With
  
'  With m_ObjAbm.Properties(cscBcoNombre)
'    .Value = C_CopiaDe & .Value
'  End With
  
  m_ObjAbm.ShowValue m_ObjAbm.Properties(cscBcoCodigo)
  m_ObjAbm.ShowValue m_ObjAbm.Properties(cscBcoNombre)
  
  m_Copy = True
End Function


Private Sub cIABMClient_DiscardChanges()
  LoadCollection
End Sub

Private Function cIABMClient_EditNew() As Boolean
  
  cIABMClient_Terminate
  m_IsNew = True
  
  cIEditGeneric_Edit csNO_ID
End Function

Private Function cIABMClient_ListAdHock(Lista As CSInterfacesABM.cIABMList) As Boolean

End Function

Private Sub cIABMClient_Load()

End Sub

Private Function cIABMClient_PropertyChange(ByVal Clave As Integer) As Boolean

End Function

Private Function cIABMClient_Save() As Boolean
    Dim register   As cRegister
    Dim fields     As cFields
    
    Set register = New cRegister
    Set fields = register.fields
    
    With register
      .fieldId = cscBcoId
      .Table = csTBanco
      
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
                  fields.Add2 cscBcoNombre, .Value, csText
                Case K_CODIGO
                  fields.Add2 cscBcoCodigo, .Value, csText
                Case K_ACTIVO
                  fields.Add2 cscActivo, Val(.Value), csBoolean
                Case K_CONTACTO
                  fields.Add2 cscBcoContacto, .Value, csText
                Case K_TELEFONO
                  fields.Add2 cscBcoTelefono, .Value, csText
                Case K_DIRECCION
                  fields.Add2 cscBcoDireccion, .Value, csText
                Case K_WEB
                  fields.Add2 cscBcoWeb, .Value, csText
                Case K_MAIL
                  fields.Add2 cscBcoMail, .Value, csText
            End Select
        End With
    Next
    
    fields.HaveLastUpdate = True
    fields.HaveWhoModify = True
    
    If Not gDB.SaveEx(register, , _
                      cscBcoCodigo, _
                      C_ABMClientSave, _
                      C_Module, _
                      LNGGetText(1039, vbNullString)) Then Exit Function
    
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
    cIABMClient_Title = LNGGetText(1040, vbNullString)
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
                Case K_ACTIVO
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
  cIEditGeneric_ShowList = SecurityCanAccess(csPreGListBanco)
End Function

Private Property Set cIEditGeneric_ObjAbm(rhs As CSInterfacesABM.cIABMGeneric)
  Set m_ObjAbm = rhs
End Property

Private Property Get cIEditGeneric_Editing() As Boolean
  cIEditGeneric_Editing = m_Editing
End Property

Private Function cIEditGeneric_Delete(Id As Long) As Boolean
  If Not SecurityCanAccess(csPreGDeleteBanco) Then Exit Function

  Dim sqlstmt As String
  
  sqlstmt = "delete banco where bco_id = " & Id
  
  cIEditGeneric_Delete = gDB.Execute(sqlstmt, C_EditGenericDelete, C_Module)
End Function

Private Function cIEditGeneric_Search(Id As Long, Cancela As Boolean) As Boolean

End Function

Private Function cIEditGeneric_Edit(Id As Long, Optional ByVal InModalWindow As Boolean) As Boolean
  On Error GoTo ControlError
  
  If Id = csNO_ID Then
    m_IsNew = True
    If Not SecurityCanAccess(csPreGNewBanco) Then Exit Function
  Else
    m_IsNew = False
    If Not SecurityCanAccess(csPreGEditBanco) Then Exit Function
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

' funciones privadas
Private Function LoadCollection() As Boolean
  
  m_ObjAbm.Title2 = m_Nombre
    
  With m_ObjAbm.Properties
  
    .Clear
  
    With .Add(Nothing, cscBcoNombre)
      .PropertyType = cspText
      .Name = C_strNombre
      .Size = 100
      .Width = 4500
      .Key = K_NOMBRE
      .Value = m_Nombre
    End With
    
    With .Add(Nothing, cscBcoCodigo)
      .PropertyType = cspText
      .Name = C_strCodigo
      .Size = 15
      .Value = m_Codigo
      .Key = K_CODIGO
    End With
    
    With .Add(Nothing, cscActivo)
      .PropertyType = cspCheck
      .LeftNotChange = True
      .Left = 7100
      .Width = 500
      .LeftLabel = -800
      .TopFromProperty = cscBcoNombre
      .TopNotChange = True
      .Name = C_strActivo
      .Key = K_ACTIVO
      .Value = CInt(m_Activo)
    End With
    
    With .Add(Nothing, cscBcoMail)
      .PropertyType = cspText
      .Name = LNGGetText(1034, vbNullString) ' mail
      .Size = 255
      .Key = K_MAIL
      .Value = m_Mail
      .TopFromProperty = cscBcoCodigo
      .LeftNotChange = True
      .TopNotChange = True
      .LeftLabel = -500
      .Left = 4500
      .Width = 3550
    End With
    
    With .Add(Nothing, cscBcoContacto)
      .PropertyType = cspText
      .Name = LNGGetText(1035, vbNullString) ' contacto
      .Height = 660
      .Width = 6500
      .SubType = cspMemo
      .Size = 500
      .Key = K_CONTACTO
      .Value = m_Contacto
    End With
    
    With .Add(Nothing, cscBcoTelefono)
      .PropertyType = cspText
      .Name = LNGGetText(1036, vbNullString) ' telefono
      .Size = 255
      .Key = K_TELEFONO
      .Width = 6500
      .Value = m_telefono
    End With
    
    With .Add(Nothing, cscBcoDireccion)
      .PropertyType = cspText
      .Name = LNGGetText(1037, vbNullString) ' Dirección
      .Size = 255
      .Key = K_DIRECCION
      .Width = 6500
      .Value = m_direccion
    End With
    
    With .Add(Nothing, cscBcoWeb)
      .PropertyType = cspText
      .Name = LNGGetText(1038, vbNullString) ' Web
      .Size = 255
      .Key = K_WEB
      .Width = 6500
      .Value = m_Web
    End With
    
  End With
  
  If Not m_ObjAbm.Show(Me) Then Exit Function

  LoadCollection = True
End Function

Private Function Load(ByVal Id As Long) As Boolean
  
  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  
  sqlstmt = "select * from banco where bco_id = " & Id
  
  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, C_LoadFunction, C_Module) Then Exit Function
  
  If rs.EOF Then
      m_Activo = True
      m_Nombre = vbNullString
      m_Codigo = vbNullString
      m_Id = csNO_ID
      m_Contacto = vbNullString
      m_telefono = vbNullString
      m_direccion = vbNullString
      m_Web = vbNullString
      m_Mail = vbNullString
  Else
      m_Activo = gDB.ValField(rs.fields, cscActivo)
      m_Nombre = gDB.ValField(rs.fields, cscBcoNombre)
      m_Codigo = gDB.ValField(rs.fields, cscBcoCodigo)
      m_Id = gDB.ValField(rs.fields, cscBcoId)
      m_Contacto = gDB.ValField(rs.fields, cscBcoContacto)
      m_telefono = gDB.ValField(rs.fields, cscBcoTelefono)
      m_direccion = gDB.ValField(rs.fields, cscBcoDireccion)
      m_Web = gDB.ValField(rs.fields, cscBcoWeb)
      m_Mail = gDB.ValField(rs.fields, cscBcoMail)
  End If
  
  Load = True

End Function

Private Function cIMenuClient_Initialize(F As Object, Host As CSMenu.cIMenuHost) As Boolean
  On Error GoTo ControlError

  Set m_Host = Host
  m_Host.Server.AddMenu C_MenuTesoreria, csMenuConfigTesoreria, C_MenuConfig, 0, True, False, False, False, True, Nothing
                        ' &Bancos
  m_Host.Server.AddMenu LNGGetText(1041, vbNullString), csPreGListBanco, C_MenuTesoreria, 0, True, False, False, False, False, Me

  cIMenuClient_Initialize = True

  GoTo ExitProc
ControlError:
  MngError Err, C_MenuClientInit, C_Module, vbNullString
  If Err.Number Then Resume ExitProc

ExitProc:
  On Error Resume Next
End Function

Private Function cIMenuClient_ProcessMenu(ByVal Id As Long) As Variant
                                               ' Bancos
  m_Host.MenuABMClick "CSGeneral2.cBanco", Me, LNGGetText(1040, vbNullString), 0, csETablasGeneral.csBanco
End Function

' construccion - destruccion
Private Sub Class_Terminate()
  On Error Resume Next
  Set m_ObjAbm = Nothing
  Set m_ObjTree = Nothing
End Sub
