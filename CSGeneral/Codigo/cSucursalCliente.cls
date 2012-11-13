VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cClienteSucursal"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements CSInterfacesABM.cIEditGeneric
Implements CSInterfacesABM.cIABMClient
'--------------------------------------------------------------------------------
' cClienteSucursal
' 31-01-01

'--------------------------------------------------------------------------------
' notas:

' Sucursales de Clientes    reemplazar por el nombre logico del abm (ej Provincias)
'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cClienteSucursal"

Private Const K_NOMBRE                         As Integer = 1
Private Const K_CODIGO                         As Integer = 2
Private Const K_CLI_ID                         As Integer = 3
Private Const K_ACTIVO                         As Integer = 4

' estructuras
' variables privadas
Private m_Id                           As Long
Private m_Nombre                       As String
Private m_Codigo                       As String
Private m_Cli_id                       As Long
Private m_Cliente                      As String
Private m_Activo
'Private m_Creado                       As Date
'Private m_Modificado                   As Date
'Private m_Modifico                     As Long

Private m_Editing          As Boolean

Private m_ObjAbm           As cIABMGeneric
Private m_ObjTree          As Object

Private m_IsNew            As Boolean

Private m_BranchId         As Long
Private m_TreeId           As Long
Private m_Copy             As Boolean

' propiedades publicas

' JMA I
Public Property Get Id() As Long
  Id = m_Id
End Property

Public Property Get Nombre() As String
  Nombre = m_Nombre
End Property

Public Property Get Codigo() As String
  Codigo = m_Codigo
End Property
' JMA F

'Public Property Get Id() As Long
'  Id = m_Id
'End Property
'
'Public Property Let Id(ByVal rhs As Long)
'  m_Id = rhs
'End Property
'
'Public Property Get Nombre() As String
'  Nombre = m_Nombre
'End Property
'
'Public Property Let Nombre(ByVal rhs As String)
'  m_Nombre = rhs
'End Property
'
'Public Property Get Codigo() As String
'  Codigo = m_Codigo
'End Property
'
'Public Property Let Codigo(ByVal rhs As String)
'  m_Codigo = rhs
'End Property
'
'Public Property Get Cli_id() As Long
'  Cli_id = m_Cli_id
'End Property
'
'Public Property Let Cli_id(ByVal rhs As Long)
'  m_Cli_id = rhs
'End Property
'
'Public Property Get Cliente() As String
'  Cliente = m_Cliente
'End Property
'
'Public Property Let Cliente(ByVal rhs As String)
'  m_Cliente = rhs
'End Property
'
'Public Property Get Activo() As Boolean
'  Activo = m_Activo
'End Property
'
'Public Property Let Activo(ByVal rhs As Boolean)
'  m_Activo = rhs
'End Property
'
'Public Property Get Creado() As Date
'  Creado = m_Creado
'End Property
'
'Public Property Let Creado(ByVal rhs As Date)
'  m_Creado = rhs
'End Property
'
'Public Property Get Modificado() As Date
'  Modificado = m_Modificado
'End Property
'
'Public Property Let Modificado(ByVal rhs As Date)
'  m_Modificado = rhs
'End Property
'
'Public Property Get Modifico() As Long
'  Modifico = m_Modifico
'End Property
'
'Public Property Let Modifico(ByVal rhs As Long)
'  m_Modifico = rhs
'End Property

' propiedades privadas
' funciones publicas


' Implementacion de cIABMClient
Private Function cIABMClient_Copy() As Boolean
  
  cIABMClient_Terminate
  m_IsNew = True
    
  With m_ObjAbm.Properties(cscclisCodigo)
    .Value = C_C & .Value
  End With
  
  With m_ObjAbm.Properties(cscclisNombre)
    .Value = C_CopiaDe & .Value
  End With
  
  m_ObjAbm.ShowValue m_ObjAbm.Properties(cscclisCodigo)
  m_ObjAbm.ShowValue m_ObjAbm.Properties(cscclisNombre)
  
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

  Doc.ClientTable = csTClienteSucursal
  Doc.ClientTableID = m_Id

  cIABMClient_ShowDocDigital = Doc.ShowDocs(gDB)

  GoTo ExitProc
ControlError:
  MngError Err, C_ShowDocDigital, C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Private Function cIABMClient_MessageEx(ByVal MessageID As Long, ByVal Info As Variant) As Variant
  cIABMClient_MessageEx = True
End Function

Private Sub cIABMClient_DiscardChanges()
    LoadCollection
End Sub

Private Function cIABMClient_ListAdHock(Lista As CSInterfacesABM.cIABMList) As Boolean

End Function

Private Sub cIABMClient_Load()

End Sub

Private Function cIABMClient_PropertyChange(ByVal Clave As Integer) As Boolean

End Function

Private Function cIABMClient_Save() As Boolean
  Dim register As cRegister
  Dim fields     As cFields
  
  Set register = New cRegister
  Set fields = register.fields
  
  With register
    .fieldId = cscclisId
    .Table = csTClienteSucursal
  
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
          fields.Add2 cscclisNombre, .Value, csText
        Case K_CODIGO
          fields.Add2 cscclisCodigo, .Value, csText
        Case K_CLI_ID
          fields.Add2 cscCliId, .HelpId, csId
        Case K_ACTIVO
          fields.Add2 cscActivo, .Value, csBoolean
      End Select
    End With
  Next
  
  fields.HaveLastUpdate = True
  fields.HaveWhoModify = True
  
  If Not gDB.Save(register, , C_ABMClientSave, C_Module, "Error al grabar ClienteSucursal") Then Exit Function
  
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
    cIABMClient_Title = "Sucursales de Clientes"
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
            MsgInfo "Debe indicar un código"
            Exit Function
          End If
        Case K_CLI_ID
          If ValEmpty(.HelpId, csId) Then
            MsgInfo "Debe indicar un cliente"
            Exit Function
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
    cIEditGeneric_ShowList = SecurityCanAccess(csPreGListSucursalCliente)
End Function

Private Property Set cIEditGeneric_ObjAbm(rhs As CSInterfacesABM.cIABMGeneric)
    Set m_ObjAbm = rhs
End Property

Private Property Get cIEditGeneric_Editing() As Boolean
    cIEditGeneric_Editing = m_Editing
End Property

Private Function cIEditGeneric_Delete(Id As Long) As Boolean
    If Not SecurityCanAccess(csPreGDeleteSucursalCliente) Then Exit Function

    Dim sqlstmt As String
    
    sqlstmt = "Delete " & csTClienteSucursal & " where " & cscclisId & " = " & Id
    
    cIEditGeneric_Delete = gDB.Execute(sqlstmt, C_EditGenericDelete, C_Module)
End Function

Private Function cIEditGeneric_Search(Id As Long, Cancela As Boolean) As Boolean

End Function

Private Function cIEditGeneric_Edit(Id As Long, Optional ByVal InModalWindow As Boolean) As Boolean
  On Error GoTo ControlError
  
  If Id = csNO_ID Then
    m_IsNew = True
    If Not SecurityCanAccess(csPreGNewSucursalCliente) Then Exit Function
  Else
    m_IsNew = False
    If Not SecurityCanAccess(csPreGEditSucursalCliente) Then Exit Function
  End If

' JMA I
  m_ObjAbm.InModalWindow = InModalWindow
' JMA F

  If Not Load(Id) Then Exit Function
  
  If Not LoadCollection() Then Exit Function
  
  m_Editing = True
  m_Copy = False

' JMA I
  If InModalWindow Then
    cIEditGeneric_Edit = m_Id <> csNO_ID
  Else
    cIEditGeneric_Edit = True
  End If
' JMA I

  Exit Function
ControlError:
  MngError Err, C_EditGenericEdit, C_Module, ""
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
  m_ObjAbm.Properties.Clear
  
  Dim c As cIABMProperty
  
  m_ObjAbm.Title2 = m_Nombre

  Set c = m_ObjAbm.Properties.Add(Nothing, cscclisNombre)
  c.PropertyType = cspText
  c.Name = C_strNombre
  c.Size = 100
  c.Key = K_NOMBRE
  c.Value = m_Nombre
  
  Set c = m_ObjAbm.Properties.Add(Nothing, cscclisCodigo)
  c.PropertyType = cspText
  c.Name = C_strCodigo
  c.Size = 15
  c.Key = K_CODIGO
  c.Value = m_Codigo
  
  Set c = m_ObjAbm.Properties.Add(Nothing, cscCliId)
  c.PropertyType = cspHelp
  c.Table = csCliente
  c.Name = "Cliente"
  c.Key = K_CLI_ID
  c.Value = m_Cliente
  c.HelpId = m_Cli_id
  
  Set c = m_ObjAbm.Properties.Add(Nothing, cscActivo)
  c.PropertyType = cspCheck
  c.Name = C_strActivo
  c.Key = K_ACTIVO
  c.Value = CInt(m_Activo)
  
  If Not m_ObjAbm.Show(Me) Then Exit Function
  
  LoadCollection = True
End Function

Private Function Load(ByVal Id As Long) As Boolean

  Dim sqlstmt As String

  sqlstmt = sqlstmt & "select ClienteSucursal.*,cli_nombre" & vbCrLf
  sqlstmt = sqlstmt & "from ClienteSucursal, Cliente" & vbCrLf
  sqlstmt = sqlstmt & "where clis_id = " & Id & vbCrLf
  sqlstmt = sqlstmt & "and ClienteSucursal.cli_id = cliente.cli_id"

  Dim rs As Recordset

  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, C_LoadFunction, C_Module) Then Exit Function

  If Not rs.EOF Then

    m_Id = gDB.ValField(rs.fields, cscclisId)
    m_Nombre = gDB.ValField(rs.fields, cscclisNombre)
    m_Codigo = gDB.ValField(rs.fields, cscclisCodigo)
    m_Cli_id = gDB.ValField(rs.fields, cscCliId)
    m_Cliente = gDB.ValField(rs.fields, cscCliNombre)
    m_Activo = gDB.ValField(rs.fields, cscActivo)
    'm_Creado = gDB.ValField(rs.Fields, cscCreado)
    'm_Modificado = gDB.ValField(rs.Fields, cscModificado)
    'm_Modifico = gDB.ValField(rs.Fields, cscModifico)

  Else
    m_Id = csNO_ID
    m_Nombre = ""
    m_Codigo = ""
    m_Cli_id = csNO_ID
    m_Cliente = ""
    m_Activo = True
    'm_Creado = csNoDate
    'm_Modificado = csNoDate
    'm_Modifico = 0

  End If

  Load = True
End Function
' construccion - destruccion
Private Sub Class_Terminate()
  On Error Resume Next
  Set m_ObjAbm = Nothing
  Set m_ObjTree = Nothing
End Sub


