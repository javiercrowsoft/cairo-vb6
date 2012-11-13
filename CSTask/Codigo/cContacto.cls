VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cContacto"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements CSInterfacesABM.cIEditGeneric
Implements CSInterfacesABM.cIABMClient
Implements CSMenu.cIMenuClient
'--------------------------------------------------------------------------------
' cContacto
' 29-04-02

'--------------------------------------------------------------------------------
' notas:
'--------------------------------------------------------------------------------
' api win32
  ' constantes
  ' estructuras
  ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cContacto"

Private Const K_NOMBRE             As Integer = 1
Private Const K_CODIGO             As Integer = 2
Private Const K_DESCRIP            As Integer = 3
Private Const K_TEL                As Integer = 4
Private Const K_CELULAR            As Integer = 5
Private Const K_EMAIL              As Integer = 6
Private Const K_CARGO              As Integer = 7
Private Const K_DIRECCION          As Integer = 8
Private Const K_CLI_ID             As Integer = 9
Private Const K_PROV_ID            As Integer = 10
Private Const K_ACTIVO             As Integer = 11
Private Const K_AGN_ID             As Integer = 12

Private Const K_APELLIDO           As Integer = 13
Private Const K_DOCUMENTO          As Integer = 14
Private Const K_TRATAMIENTO        As Integer = 15
Private Const K_FAX                As Integer = 16
Private Const K_TIPO               As Integer = 17
Private Const K_FECHANAC           As Integer = 18
Private Const K_CATEGORIA          As Integer = 19
Private Const K_CLIENTE            As Integer = 20
Private Const K_PROVEEDOR          As Integer = 21
Private Const K_CODPOSTAL          As Integer = 22
Private Const K_CIUDAD             As Integer = 23
Private Const K_US_ID              As Integer = 24
Private Const K_CIU_ID             As Integer = 25
Private Const K_PRO_ID             As Integer = 26
Private Const K_PA_ID              As Integer = 27
Private Const K_PROVINCIA          As Integer = 28

' Seudo - Variables
Private c_ErrorSave          As String

' estructuras
' variables privadas
Private m_Id                 As Long
Private m_Nombre             As String
Private m_Codigo             As String
Private m_Descrip            As String
Private m_Tel                As String
Private m_Celular            As String
Private m_Email              As String
Private m_Cargo              As String
Private m_Direccion          As String
Private m_Cli_id             As Long
Private m_Cliente            As String
Private m_Prov_id            As Long
Private m_Proveedor          As String

Private m_Agn_id             As Long
Private m_Agenda             As String


Private m_Apellido                     As String
Private m_Documento                    As String
Private m_Tratamiento                  As String
Private m_Fax                          As String
Private m_Tipo                         As Boolean
Private m_Fechanac                     As Date
Private m_Categoria                    As String
Private m_Cliente2                     As String
Private m_Proveedor2                   As String
Private m_Codpostal                    As String
Private m_Ciudad2                      As String
Private m_Provincia2                   As String
Private m_Us_id                        As Long
Private m_Usuario                      As String
Private m_Ciu_id                       As Long
Private m_Ciudad                       As String
Private m_Pro_id                       As Long
Private m_Provincia                    As String
Private m_Pa_id                        As Long
Private m_Pais                         As String
Private m_Activo                       As Boolean

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

' propiedades privadas
' funciones publicas
Public Function SetTree(ByRef Tree As Object) As Boolean
  On Error Resume Next
  
  Dim agn_id As Long
  Dim ContactoAux As cContactoAux
  Set ContactoAux = New cContactoAux
  
  agn_id = ContactoAux.GetAgenda()
  
  If agn_id <> csNO_ID Then
    Tree.SpGetHojas = "Sp_ArbGetHojasContacto " & agn_id & ","
    Tree.SpGetArboles = "Sp_ArbGetArbolesContacto " & User.Id & ","
    SetTree = True
  Else
    MsgWarning LNGGetText(2635, vbNullString)   'Debe seleccionar una Agenda
  End If
End Function

' Implementacion de cIABMClient
Private Function cIABMClient_Copy() As Boolean
  
  cIABMClient_Terminate
  m_IsNew = True
  
  With m_ObjAbm.Properties(cscContCodigo)
    .Value = "C-" & .Value
  End With
  
  With m_ObjAbm.Properties(cscContNombre)
    .Value = C_CopiaDe & .Value
  End With
  
  m_ObjAbm.ShowValue m_ObjAbm.Properties(cscContCodigo)
  m_ObjAbm.ShowValue m_ObjAbm.Properties(cscContNombre)
  
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

  Doc.ClientTable = csTContacto
  Doc.ClientTableID = m_Id

  cIABMClient_ShowDocDigital = Doc.ShowDocs(gDB)

  GoTo ExitProc
ControlError:
  MngError Err, "cIABMClient_ShowDocDigital", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Private Function cIABMClient_MessageEx(ByVal MessageID As Long, ByVal Info As Variant) As Variant
  cIABMClient_MessageEx = True
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
  Dim register   As cRegister
  Dim fields     As cFields
  
  Set register = New cRegister
  Set fields = register.fields
  
  With register
    .fieldId = cscContId
    .Table = csTContacto
    
    If m_Copy Then
      .Id = csNew
    Else
      .Id = m_Id
      If Not pIsOwner(m_Id) Then Exit Function
    End If
  End With
  
  Dim IProperty As cIABMProperty
  For Each IProperty In m_ObjAbm.Properties
    With IProperty
      Select Case .Key
        Case K_NOMBRE
          fields.Add2 cscContNombre, .Value, csText
        Case K_CODIGO
          fields.Add2 cscContCodigo, .Value, csText
        Case K_DESCRIP
          fields.Add2 cscContDescrip, .Value, csText
        Case K_TEL
          fields.Add2 cscContTel, .Value, csText
        Case K_CELULAR
          fields.Add2 cscContCelular, .Value, csText
        Case K_EMAIL
          fields.Add2 cscContEmail, .Value, csText
        Case K_CARGO
          fields.Add2 cscContCargo, .Value, csText
        Case K_DIRECCION
          fields.Add2 cscContDireccion, .Value, csText
        Case K_CLI_ID
          fields.Add2 cscCliId, .HelpId, csId
        Case K_AGN_ID
          fields.Add2 cscAgnId, .HelpId, csId
        Case K_PROV_ID
          fields.Add2 cscProvId, .HelpId, csId
        Case K_ACTIVO
          fields.Add2 cscActivo, .Value, csBoolean
        Case K_APELLIDO
          fields.Add2 cscContApellido, .Value, csText
        Case K_DOCUMENTO
          fields.Add2 cscContDocumento, .Value, csText
        Case K_TRATAMIENTO
          fields.Add2 cscContTratamiento, .Value, csText
        Case K_FAX
          fields.Add2 cscContFax, .Value, csText
        Case K_TIPO
          fields.Add2 cscContTipo, .Value, csBoolean
        Case K_FECHANAC
          fields.Add2 cscContFechanac, .Value, csDate
        Case K_CATEGORIA
          fields.Add2 cscContCategoria, .Value, csText
        Case K_CLIENTE
          fields.Add2 cscContCliente, .Value, csText
        Case K_PROVEEDOR
          fields.Add2 cscContProveedor, .Value, csText
        Case K_PROVINCIA
          fields.Add2 cscContProvincia, .Value, csText
        Case K_CODPOSTAL
          fields.Add2 cscContCodpostal, .Value, csText
        Case K_CIUDAD
          fields.Add2 cscContCiudad, .Value, csText
        Case K_US_ID
          fields.Add2 cscUsId, .HelpId, csId
        Case K_CIU_ID
          fields.Add2 cscCiuId, .HelpId, csId
        Case K_PRO_ID
          fields.Add2 cscProId, .HelpId, csId
        Case K_PA_ID
          fields.Add2 cscPaId, .HelpId, csId
      End Select
    End With
  Next
  fields.HaveLastUpdate = True
  fields.HaveWhoModify = True
  If Not gDB.Save(register, , "cIABMClient_Save", C_Module, c_ErrorSave) Then Exit Function
  
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
  cIABMClient_Title = LNGGetText(2636, vbNullString)  'Contactos
End Property

Private Function cIABMClient_Validate() As Boolean

  Dim IProperty As cIABMProperty

  For Each IProperty In m_ObjAbm.Properties
    With IProperty
      Select Case .Key
        Case K_NOMBRE
          If ValEmpty(.Value, csText) Then
            MsgInfo LNGGetText(1007, vbNullString)  'Debe indicar un nombre
            Exit Function
          End If
        Case K_CODIGO
          If ValEmpty(.Value, csText) Then
            MsgInfo LNGGetText(1008, vbNullString)  'Debe indicar un Codigo
            Exit Function
          End If
        Case K_AGN_ID
          If ValEmpty(.HelpId, csId) Then
            MsgInfo LNGGetText(2637, vbNullString)  'Debe indicar una Agenda
            Exit Function
          End If
'        Case K_TEL
'          If ValEmpty(.Value, csText) Then
'            MsgInfo "Debe indicar un tel"
'            Exit Function
'          End If
'        Case K_CELULAR
'          If ValEmpty(.Value, csText) Then
'            MsgInfo "Debe indicar un celular"
'            Exit Function
'          End If
'        Case K_EMAIL
'          If ValEmpty(.Value, csText) Then
'            MsgInfo "Debe indicar un email"
'            Exit Function
'          End If
'        Case K_CARGO
'          If ValEmpty(.Value, csText) Then
'            MsgInfo "Debe indicar un cargo"
'            Exit Function
'          End If
'        Case K_DIRECCION
'          If ValEmpty(.Value, csText) Then
'            MsgInfo "Debe indicar un direccion"
'            Exit Function
'          End If
'        Case K_CLI_ID
'          If ValEmpty(.Value, csId) Then
'            MsgInfo "Debe indicar un cli_id"
'            Exit Function
'          End If
'        Case K_PROV_ID
'          If ValEmpty(.Value, csId) Then
'            MsgInfo "Debe indicar un prov_id"
'            Exit Function
'          End If

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
  cIEditGeneric_ShowList = SecurityCanAccess(csPreTareaListContacto)
End Function

Private Property Set cIEditGeneric_ObjAbm(rhs As CSInterfacesABM.cIABMGeneric)
  Set m_ObjAbm = rhs
End Property

Private Property Get cIEditGeneric_Editing() As Boolean
  cIEditGeneric_Editing = m_Editing
End Property

Private Function cIEditGeneric_Delete(Id As Long) As Boolean
  If Not SecurityCanAccess(csPreTareaDeleteContacto) Then Exit Function

  Dim sqlstmt As String
  
  sqlstmt = "Delete Contacto where cont_id  = " & Id
  
  cIEditGeneric_Delete = gDB.Execute(sqlstmt, "cIEditGeneric_Delete", C_Module)
End Function

Private Function cIEditGeneric_Search(Id As Long, Cancela As Boolean) As Boolean

End Function

Private Function cIEditGeneric_Edit(Id As Long, Optional ByVal InModalWindow As Boolean) As Boolean
  On Error GoTo ControlError
  
  If Id = csNO_ID Then
    m_IsNew = True
    If Not SecurityCanAccess(csPreTareaNewContacto) Then Exit Function
  Else
    m_IsNew = False
    If Not SecurityCanAccess(csPreTareaEditContacto) Then Exit Function
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
  MngError Err, "cIEditGeneric_Edit", C_Module, vbNullString
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
  Dim AbmObj As cABMGeneric
  
  Set AbmObj = m_ObjAbm
  AbmObj.MinHeight = 6000
  AbmObj.MinWidth = 12000
  
  With m_ObjAbm.Properties
      
    .Clear

    With .Add(Nothing, cscContApellido)
      .PropertyType = cspText
      .Name = LNGGetText(1273, vbNullString) 'Apellido
      .Size = 100
      .Width = 6500
      .Key = K_APELLIDO
      .Value = m_Apellido
    End With
    
    With .Add(Nothing, cscContNombre)
      .PropertyType = cspText
      .Name = C_strNombre
      .Size = 100
      .Width = 6500
      .Key = K_NOMBRE
      .Value = m_Nombre
    End With
    
    With .Add(Nothing, cscActivo)
      .PropertyType = cspCheck
      .TopFromProperty = cscContApellido
      .Left = 9000
      .Name = C_strActivo
      .Key = K_ACTIVO
      .Value = m_Activo
      .LeftLabel = -800
    End With
    
    With .Add(Nothing, cscContTipo)
      .PropertyType = cspCheck
      .Name = LNGGetText(1223, vbNullString) 'tipo
      .Key = K_TIPO
      .Value = CInt(m_Tipo)
      .LeftLabel = -800
    End With
    
    With .Add(Nothing, cscContCodigo)
      .PropertyType = cspText
      .Name = C_strCodigo
      .LeftFromProperty = cscContApellido
      .Size = 15
      .Key = K_CODIGO
      .Value = m_Codigo
    End With
    
    With .Add(Nothing, cscContDocumento)
      .PropertyType = cspText
      .Name = LNGGetText(1067, vbNullString) 'D.N.I.
      .Size = 50
      .Key = K_DOCUMENTO
      .Value = m_Documento
    End With
    
    With .Add(Nothing, cscContTel)
      .PropertyType = cspText
      .Name = LNGGetText(1036, vbNullString) 'Teléfono
      .Size = 50
      .Key = K_TEL
      .Value = m_Tel
    End With
    
    With .Add(Nothing, cscContCelular)
      .PropertyType = cspText
      .Name = LNGGetText(1276, vbNullString) 'Celular
      .Size = 50
      .Key = K_CELULAR
      .Value = m_Celular
    End With
    
    With .Add(Nothing, cscContFax)
      .PropertyType = cspText
      .Name = LNGGetText(1200, vbNullString) 'fax
      .Size = 100
      .Key = K_FAX
      .Value = m_Fax
    End With
    
    With .Add(Nothing, cscContEmail)
      .PropertyType = cspText
      .Name = LNGGetText(1034, vbNullString) 'Email (TODO VER CON JAVIER YA QUE 1034 = MAIL)
      .Size = 50
      .Key = K_EMAIL
      .Value = m_Email
    End With
        
    With .Add(Nothing, cscContDireccion)
      .PropertyType = cspText
      .Name = LNGGetText(1037, vbNullString) 'Dirección
      .Width = 6500
      .Size = 255
      .Key = K_DIRECCION
      .Value = m_Direccion
    End With
      
    With .Add(Nothing, cscContCodpostal)
      .PropertyType = cspText
      .Name = LNGGetText(1199, vbNullString) 'codpostal
      .Size = 50
      .Key = K_CODPOSTAL
      .TopFromProperty = cscContCodigo
      .Left = 5500
      .Value = m_Codpostal
    End With
  
    With .Add(Nothing, cscContCiudad)
      .PropertyType = cspText
      .Name = LNGGetText(1079, vbNullString) 'ciudad
      .Size = 255
      .Key = K_CIUDAD
      .Value = m_Ciudad2
    End With
  
    With .Add(Nothing, cscContProvincia)
      .PropertyType = cspText
      .Name = LNGGetText(1080, vbNullString) 'provincia
      .Size = 255
      .Key = K_PROVINCIA
      .Value = m_Provincia2
    End With
      
    With .Add(Nothing, cscCiuId)
      .PropertyType = cspHelp
      .Table = csCiudad
      .Name = LNGGetText(1079, vbNullString) 'Ciudad
      .Key = K_CIU_ID
      .Value = m_Ciudad
      .HelpId = m_Ciu_id
    End With
  
    With .Add(Nothing, cscProId)
      .PropertyType = cspHelp
      .Table = csProvincia
      .Name = LNGGetText(1080, vbNullString) 'Provincia
      .Key = K_PRO_ID
      .Value = m_Provincia
      .HelpId = m_Pro_id
    End With
  
    With .Add(Nothing, cscPaId)
      .PropertyType = cspHelp
      .Table = csPais
      .Name = LNGGetText(1212, vbNullString) 'Pais
      .Key = K_PA_ID
      .Value = m_Pais
      .HelpId = m_Pa_id
    End With
    
    With .Add(Nothing, cscContFechanac)
      .PropertyType = cspDate
      .Name = LNGGetText(1064, vbNullString) 'fechanac
      .Key = K_FECHANAC
      .TopFromProperty = cscContCodigo
      .Left = 9500
      .Value = m_Fechanac
    End With
  
    With .Add(Nothing, cscContCategoria)
      .PropertyType = cspText
      .Name = LNGGetText(1120, vbNullString) 'categoria
      .Size = 150
      .Key = K_CATEGORIA
      .Value = m_Categoria
    End With
  
    With .Add(Nothing, cscContCargo)
      .PropertyType = cspText
      .Name = LNGGetText(1279, vbNullString) 'Cargo
      .Size = 15
      .Key = K_CARGO
      .Value = m_Cargo
    End With
    
    With .Add(Nothing, cscCliId)
      .PropertyType = cspHelp
      .Table = csETablasGeneral.csCliente
      .Name = LNGGetText(1150, vbNullString) 'Cliente
      .Key = K_CLI_ID
      .Value = m_Cliente
      .HelpId = m_Cli_id
    End With
    
    With .Add(Nothing, cscProvId)
      .PropertyType = cspHelp
      .Table = csETablasGeneral.csProveedor
      .Name = LNGGetText(1151, vbNullString) 'Proveedor
      .Key = K_PROV_ID
      .Value = m_Proveedor
      .HelpId = m_Prov_id
    End With
    
    With .Add(Nothing, cscContCliente)
      .PropertyType = cspText
      .Name = LNGGetText(1150, vbNullString) 'cliente
      .Size = 255
      .Key = K_CLIENTE
      .Value = m_Cliente2
    End With
  
    With .Add(Nothing, cscContProveedor)
      .PropertyType = cspText
      .Name = LNGGetText(1151, vbNullString) 'proveedor
      .Size = 255
      .Key = K_PROVEEDOR
      .Value = m_Proveedor2
    End With
  
    With .Add(Nothing, cscUsId)
      .PropertyType = cspHelp
      .Table = csUsuario
      .Name = LNGGetText(1137, vbNullString) 'Usuario
      .Key = K_US_ID
      .Value = m_Usuario
      .HelpId = m_Us_id
    End With
  
    With .Add(Nothing, cscAgnId)
      .PropertyType = cspHelp
      .Table = csAgenda
      .Name = LNGGetText(2638, vbNullString) 'Agenda
      .Key = K_AGN_ID
      .Value = m_Agenda
      .HelpId = m_Agn_id
      .HelpFilter = "exists(select per_id from permiso " & _
                          "where pre_id = pre_id_listar " & _
                          "and (us_id = " & User.Id & _
                              " or exists(select rol_id " & _
                                         "from usuariorol " & _
                                         "where rol_id = permiso.rol_id" & _
                                         " and us_id = " & User.Id & _
                                         ")))"
    End With
    
    With .Add(Nothing, cscContDescrip)
      .PropertyType = cspText
      .Name = C_strDescrip
      .LeftFromProperty = cscContNombre
      .TopFromProperty = cscContDireccion
      .TopToPrevious = 440
      .Width = 6500
      .Height = 940
      .SubType = cspMemo
      .Size = 255
      .Key = K_DESCRIP
      .Value = m_Descrip
    End With
  End With
  
  If Not m_ObjAbm.Show(Me) Then Exit Function
  
  LoadCollection = True
End Function

Private Function Load(ByVal Id As Long) As Boolean

  Dim sqlstmt As String

  sqlstmt = "sp_contactoGet " & Id
  
  Dim rs As ADODB.Recordset

  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, C_LoadFunction, C_Module) Then Exit Function

  If Not rs.EOF Then

    m_Id = gDB.ValField(rs.fields, cscContId)
    m_Nombre = gDB.ValField(rs.fields, cscContNombre)
    m_Codigo = gDB.ValField(rs.fields, cscContCodigo)
    m_Descrip = gDB.ValField(rs.fields, cscContDescrip)
    m_Tel = gDB.ValField(rs.fields, cscContTel)
    m_Celular = gDB.ValField(rs.fields, cscContCelular)
    m_Email = gDB.ValField(rs.fields, cscContEmail)
    m_Cargo = gDB.ValField(rs.fields, cscContCargo)
    m_Direccion = gDB.ValField(rs.fields, cscContDireccion)
    m_Cli_id = gDB.ValField(rs.fields, cscCliId)
    m_Prov_id = gDB.ValField(rs.fields, cscProvId)
    
    m_Agenda = gDB.ValField(rs.fields, cscAgnNombre)
    m_Agn_id = gDB.ValField(rs.fields, cscAgnId)
    
    m_Cliente = gDB.ValField(rs.fields, cscCliNombre)
    m_Proveedor = gDB.ValField(rs.fields, cscProvNombre)
    
    m_Apellido = gDB.ValField(rs.fields, cscContApellido)
    m_Documento = gDB.ValField(rs.fields, cscContDocumento)
    m_Tratamiento = gDB.ValField(rs.fields, cscContTratamiento)
    m_Fax = gDB.ValField(rs.fields, cscContFax)
    m_Tipo = gDB.ValField(rs.fields, cscContTipo)
    m_Fechanac = gDB.ValField(rs.fields, cscContFechanac)
    m_Categoria = gDB.ValField(rs.fields, cscContCategoria)
    m_Cliente2 = gDB.ValField(rs.fields, cscContCliente)
    m_Proveedor2 = gDB.ValField(rs.fields, cscContProveedor)
    m_Codpostal = gDB.ValField(rs.fields, cscContCodpostal)
    m_Ciudad2 = gDB.ValField(rs.fields, cscContCiudad)
    m_Provincia2 = gDB.ValField(rs.fields, cscContProvincia)
    m_Us_id = gDB.ValField(rs.fields, cscUsId)
    m_Usuario = gDB.ValField(rs.fields, cscUsNombre)
    m_Ciu_id = gDB.ValField(rs.fields, cscCiuId)
    m_Ciudad = gDB.ValField(rs.fields, cscCiuNombre)
    m_Pro_id = gDB.ValField(rs.fields, cscProId)
    m_Provincia = gDB.ValField(rs.fields, cscProvNombre)
    m_Pa_id = gDB.ValField(rs.fields, cscPaId)
    m_Pais = gDB.ValField(rs.fields, cscPaNombre)
    
    m_Activo = gDB.ValField(rs.fields, cscActivo)

  Else
    m_Id = csNO_ID
    m_Nombre = vbNullString
    m_Codigo = pGetCodigo()
    m_Descrip = vbNullString
    m_Tel = vbNullString
    m_Celular = vbNullString
    m_Email = vbNullString
    m_Cargo = vbNullString
    m_Direccion = vbNullString
    m_Cli_id = csNO_ID
    m_Prov_id = csNO_ID
    m_Proveedor = vbNullString
    m_Cliente = vbNullString
    m_Activo = True

    m_Apellido = vbNullString
    m_Documento = vbNullString
    m_Tratamiento = vbNullString
    m_Fax = vbNullString
    m_Tipo = 0
    m_Fechanac = csNoDate
    m_Categoria = vbNullString
    m_Cliente2 = vbNullString
    m_Proveedor2 = vbNullString
    m_Codpostal = vbNullString
    m_Ciudad2 = vbNullString
    m_Provincia2 = vbNullString
    m_Us_id = csNO_ID
    m_Usuario = vbNullString
    m_Ciu_id = csNO_ID
    m_Ciudad = vbNullString
    m_Pro_id = csNO_ID
    m_Provincia = vbNullString
    m_Pa_id = csNO_ID
    m_Pais = vbNullString

    ' Si no hay agenda
    ' ponemos la agenda publica
    '
    If m_Agn_id = csNO_ID Then
      Dim agenda As String
      If Not gDB.GetData(csTAgenda, _
                         cscAgnId, _
                         1, _
                         cscAgnNombre, _
                         agenda) Then Exit Function
      m_Agenda = agenda
      m_Agn_id = 1
    End If
  End If

  Load = True
End Function

Private Function pIsOwner(ByVal Id As Long) As Boolean
  Dim sqlstmt As String
  Dim rs      As Recordset
  
  sqlstmt = "sp_contactoUserCanEdit " & Id & ", " & User.Id
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Function
  If rs.EOF Then Exit Function
  If rs.fields.Item(0).Value Then
    pIsOwner = True
  Else
    MsgWarning LNGGetText(2639, vbNullString) 'Ud. no tiene permiso para editar este Contacto
  End If
End Function

' construccion - destruccion
Private Function cIMenuClient_Initialize(F As Object, Host As CSMenu.cIMenuHost) As Boolean
  On Error GoTo ControlError
  Dim str_1851  As String
  
  str_1851 = LNGGetText(1851, vbNullString) '&Servicios
  Set m_Host = Host
                                                'Co&nfiguración
  m_Host.Server.AddMenu str_1851, csMenuConfig, LNGGetText(1028, vbNullString), 0, True, False, True, False, True, Nothing
  m_Host.Server.AddMenu LNGGetText(2640, vbNullString), csPreTareaListContacto, str_1851, 0, True, False, False, False, False, Me
                        '&Contacto
  cIMenuClient_Initialize = True
  
  GoTo ExitProc
ControlError:
  MngError Err, "cIMenuClient_Initialize", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Private Function cIMenuClient_ProcessMenu(ByVal Id As Long) As Variant
  m_Host.MenuABMClick "CSTarea2.cContacto", Me, LNGGetText(2636, vbNullString), 0, csETablesTask.csContacto
                                                 'Contactos
End Function

Private Function pGetCodigo() As String
  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  Dim rtn     As String
  
  sqlstmt = "sp_ContactoGetCodigo"
  
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Function
  
  rtn = Format(gDB.ValField(rs.fields, 0), "00000000")
  
  pGetCodigo = rtn
End Function

Private Sub Class_Initialize()
  On Error GoTo ControlError
  
  c_ErrorSave = LNGGetText(2641, vbNullString) 'Error al grabar Contacto
  
  GoTo ExitProc
ControlError:
  MngError Err, "Class_Initialize", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub Class_Terminate()
  Set m_ObjAbm = Nothing
  Set m_ObjTree = Nothing
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



