VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cProfesor"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements CSInterfacesABM.cIEditGeneric
Implements CSInterfacesABM.cIABMClient
Implements CSMenu.cIMenuClient

'--------------------------------------------------------------------------------
' cProfesor
' 30-10-08

'--------------------------------------------------------------------------------
' notas:
'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cProfesor"

Private Const c_foto = "foto"
Private Const c_foto_file = "foto_file"

Private Const K_NOMBRE                         As Integer = 1
Private Const K_APELLIDO                       As Integer = 2
Private Const K_CODIGO                         As Integer = 3
Private Const K_DESCRIP                        As Integer = 4
Private Const K_INTERNO                        As Integer = 5
Private Const K_TELTRAB                        As Integer = 6
Private Const K_TELCASA                        As Integer = 7
Private Const K_CELULAR                        As Integer = 8
Private Const K_EMAIL                          As Integer = 9
Private Const K_CARGO                          As Integer = 10
Private Const K_FECHANAC                       As Integer = 12
Private Const K_PROV_ID                        As Integer = 14
Private Const K_ACTIVO                         As Integer = 15
Private Const K_SUC_ID                         As Integer = 16
Private Const K_DPTO_ID                        As Integer = 20
Private Const K_PRSDT_ID                       As Integer = 21
Private Const K_DOCUMENTO                      As Integer = 22
Private Const K_WEB                            As Integer = 23

Private Const K_FECHA_INGRESO                  As Integer = 24
Private Const K_LEGAJO                         As Integer = 25

Private Const K_CODPOSTAL                      As Integer = 110
Private Const K_LOCALIDAD                      As Integer = 111
Private Const K_CALLE                          As Integer = 112
Private Const K_CALLENUMERO                    As Integer = 113
Private Const K_PISO                           As Integer = 114
Private Const K_DEPTO                          As Integer = 115
Private Const K_PRO_ID                         As Integer = 120

Private Const K_FOTO                           As Integer = 121
Private Const K_FOTO_FILE                      As Integer = 122

' estructuras
' variables privadas
Private m_Id                           As Long
Private m_prs_id                       As Long
Private m_Nombre                       As String
Private m_Apellido                     As String
Private m_Codigo                       As String
Private m_descrip                      As String
Private m_Interno                      As String
Private m_TelTrab                      As String
Private m_TelCasa                      As String
Private m_Celular                      As String
Private m_Email                        As String
Private m_Cargo                        As String
Private m_FechaNac                     As Date
Private m_Dpto_id                      As Long
Private m_Departamento                 As String
Private m_Suc_id                       As Long
Private m_Sucursal                     As String
Private m_Prov_id                      As Long
Private m_Proveedor                    As String
Private m_Activo                       As Boolean
Private m_prsdt_id                     As Long
Private m_TipoDoc                      As String
Private m_Documento                    As String
Private m_Web                          As String
Private m_FechaIngreso                 As Date
Private m_Legajo                       As String

Private m_Codpostal        As String
Private m_Localidad        As String
Private m_Calle            As String
Private m_Callenumero      As String
Private m_Piso             As String
Private m_Depto            As String
Private m_pro_id           As Long
Private m_provincia        As String

' HOJO HASTA ACA

Private m_Editing           As Boolean

Private m_ObjAbm            As cIABMGeneric
Private m_ObjTree           As Object

Private m_IsNew             As Boolean

Private m_BranchId          As Long
Private m_TreeId            As Long

Private m_Host             As CSMenu.cIMenuHost
Private m_Copy              As Boolean

' Properties publicas

Public Property Get Id() As Long
  Id = m_Id
End Property

Public Property Get Nombre() As String
  Nombre = m_Nombre
End Property

Public Property Get Codigo() As String
  Codigo = m_Codigo
End Property
' Properties privadas
' funciones publicas

' Implementacion de cIABMClient
Private Function cIABMClient_Copy() As Boolean
  
  cIABMClient_Terminate
  m_IsNew = True
  
  With m_ObjAbm.Properties(cscPrsCodigo)
    .Value = C_C & .Value
  End With
  
'  With m_ObjAbm.Properties(cscPrsNombre)
'    .Value = C_CopiaDe & .Value
'  End With
  
  m_ObjAbm.ShowValue m_ObjAbm.Properties(cscPrsCodigo)
  m_ObjAbm.ShowValue m_ObjAbm.Properties(cscPrsNombre)
  
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

  Doc.ClientTable = csTProfesor
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
                               csPreENewProfesor
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

Private Function cIABMClient_PropertyChange(ByVal Key As Integer) As Boolean
  Dim IProp As cIABMProperty

  Select Case Key
    Case K_FOTO_FILE
      Set IProp = m_ObjAbm.Properties.Item(c_foto)
      Set IProp.Picture = pLoadPictureFromFile()
      m_ObjAbm.ShowValue IProp
  End Select
End Function

Private Function cIABMClient_Save() As Boolean
  
  Dim register    As cRegister
  Dim fields      As cFields
  Dim File        As String
  Dim prs_id      As Long
  
  Set register = New cRegister
  Set fields = register.fields
  
  With register
    .fieldId = cscProfId
    .Table = csTProfesor
    
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
        Case K_DESCRIP
          fields.Add2 cscProfDescrip, .Value, csText
        Case K_ACTIVO
          fields.Add2 cscActivo, .Value, csBoolean
        Case K_FECHA_INGRESO
          fields.Add2 cscProfFechaingreso, .Value, csDate
        Case K_LEGAJO
          fields.Add2 cscProfLegajo, .Value, csText
        Case K_FOTO_FILE
          File = .Value
      End Select
    End With
  Next
  
  fields.HaveLastUpdate = True
  fields.HaveWhoModify = True
                    
  If Not register.BeginTrans(gDB) Then Exit Function
                    
  If Not pSavePersona(prs_id) Then Exit Function
  
  fields.Add2 cscPrsId, prs_id, csId
  fields.Add2 cscProfCodigo, pGetCodigo(prs_id), csText

                    ' Error al grabar el profesor
  If Not gDB.SaveEx(register, , _
                    cscProfCodigo, _
                    C_ABMClientSave, _
                    C_Module, _
                    LNGGetText(4675, vbNullString)) Then Exit Function
  
  register.CommitTrans
  
  m_Copy = False
  cIABMClient_Save = Load(register.Id)
  
  ' Si da un error que vuelva a intentar
  '
  If LenB(File) Then
    pSaveFoto prs_id, File
  End If
  
End Function

Private Function pGetCodigo(ByVal prs_id As Long) As String
  Dim prs_codigo As String
  gDB.GetData csTPersona, cscPrsId, prs_id, cscPrsCodigo, prs_codigo
  pGetCodigo = prs_codigo
End Function

Private Function pSavePersona(ByRef prs_id As Long) As Boolean

  Dim register   As cRegister
  Dim fields     As cFields
  
  Set register = New cRegister
  Set fields = register.fields
  
  With register
    .fieldId = cscPrsId
    .Table = csTPersona
    
    If m_Copy Then
      .Id = csNew
    Else
      .Id = m_prs_id
    End If
  End With
  
  Dim IProperty As cIABMProperty
  
  For Each IProperty In m_ObjAbm.Properties
    With IProperty
      Select Case .Key
        Case K_NOMBRE
          fields.Add2 cscPrsNombre, .Value, csText
        Case K_APELLIDO
          fields.Add2 cscPrsApellido, .Value, csText
        Case K_CODIGO
          fields.Add2 cscPrsCodigo, .Value, csText
        Case K_INTERNO
          fields.Add2 cscPrsInterno, .Value, csText
        Case K_TELTRAB
          fields.Add2 cscPrsTelTrab, .Value, csText
        Case K_TELCASA
          fields.Add2 cscPrsTelCasa, .Value, csText
        Case K_CELULAR
          fields.Add2 cscPrsCelular, .Value, csText
        Case K_EMAIL
          fields.Add2 cscPrsEmail, .Value, csText
        Case K_CARGO
          fields.Add2 cscPrsCargo, .Value, csText
        Case K_FECHANAC
          fields.Add2 cscPrsFechaNac, .Value, csDate
        Case K_PROV_ID
          fields.Add2 cscProvId, .HelpId, csId
        Case K_ACTIVO
          fields.Add2 cscActivo, .Value, csBoolean
        Case K_SUC_ID
          fields.Add2 cscSucId, .HelpId, csId
        Case K_DPTO_ID
          fields.Add2 cscDptoId, .HelpId, csId
        Case K_PRSDT_ID
          fields.Add2 cscPrsdtId, .HelpId, csId
        Case K_DOCUMENTO
          fields.Add2 cscPrsDocumento, .Value, csText
        Case K_WEB
          fields.Add2 cscPrsWeb, .Value, csText
        Case K_CODPOSTAL
          fields.Add2 cscPrsCodpostal, .Value, csText
        Case K_LOCALIDAD
          fields.Add2 cscPrsLocalidad, .Value, csText
        Case K_CALLE
          fields.Add2 cscPrsCalle, .Value, csText
        Case K_CALLENUMERO
          fields.Add2 cscPrsCallenumero, .Value, csText
        Case K_PISO
          fields.Add2 cscPrsPiso, .Value, csText
        Case K_DEPTO
          fields.Add2 cscPrsDepto, .Value, csText
        Case K_PRO_ID
          fields.Add2 cscProId, .HelpId, csId
      End Select
    End With
  Next
  
  fields.HaveLastUpdate = True
  fields.HaveWhoModify = True
                    
                    ' Error al grabar el profesor
  If Not gDB.SaveEx(register, , _
                    cscPrsCodigo, _
                    C_ABMClientSave, _
                    C_Module, _
                    LNGGetText(4675, vbNullString)) Then Exit Function
  
  prs_id = register.Id
  
  pSavePersona = True

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
                        'Profesores
  cIABMClient_Title = LNGGetText(4676, vbNullString)
End Property

Private Function cIABMClient_Validate() As Boolean

  Dim IProperty As cIABMProperty

  For Each IProperty In m_ObjAbm.Properties
    With IProperty
      Select Case .Key
        Case K_APELLIDO
          If ValEmpty(.Value, csText) Then
            MsgInfo LNGGetText(1271, vbNullString)  'Debe indicar el apellido
            Exit Function
          End If
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

Private Function cIEditGeneric_TabClick(ByVal Index As Integer) As Boolean

End Function

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
    cIEditGeneric_ShowList = SecurityCanAccess(csPreEListProfesor)
End Function

Private Property Set cIEditGeneric_ObjAbm(rhs As CSInterfacesABM.cIABMGeneric)
    Set m_ObjAbm = rhs
End Property

Private Property Get cIEditGeneric_Editing() As Boolean
    cIEditGeneric_Editing = m_Editing
End Property

Private Function cIEditGeneric_Delete(Id As Long) As Boolean
    If Not SecurityCanAccess(csPreEDeleteProfesor) Then Exit Function

    Dim sqlstmt As String
    
    sqlstmt = "sp_ProfesorDelete " & Id
    
    cIEditGeneric_Delete = gDB.Execute(sqlstmt, C_EditGenericDelete, C_Module)
End Function

Private Function cIEditGeneric_Search(Id As Long, Cancela As Boolean) As Boolean

End Function

Private Function cIEditGeneric_Edit(Id As Long, Optional ByVal InModalWindow As Boolean) As Boolean
  On Error GoTo ControlError
  
  If Id = csNO_ID Then
    m_IsNew = True
    If Not SecurityCanAccess(csPreENewProfesor) Then Exit Function
  Else
    m_IsNew = False
    If Not SecurityCanAccess(csPreEEditProfesor) Then Exit Function
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

Private Function cIMenuClient_Initialize(F As Object, Host As CSMenu.cIMenuHost) As Boolean
  On Error GoTo ControlError

  Set m_Host = Host

  m_Host.Server.AddMenu C_MenuEdu, csMenuConfigEdu, C_MenuConfig, 0, True, False, False, False, True, Nothing
                         '&Profesores
  m_Host.Server.AddMenu LNGGetText(4677, vbNullString), csPreEListProfesor, C_MenuEdu, 0, True, False, False, False, False, Me
  
  cIMenuClient_Initialize = True
  
  GoTo ExitProc
ControlError:
  MngError Err, C_MenuClientInit, C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Private Function cIMenuClient_ProcessMenu(ByVal Id As Long) As Variant
                                                      'Profesores
  m_Host.MenuABMClick "CSEdu.cProfesor", Me, LNGGetText(4676, vbNullString), 0, csETablesEdu.csProfesor
End Function

' funciones privadas
Private Function LoadCollection() As Boolean
  
  Dim AbmObj As cABMGeneric
  Set AbmObj = m_ObjAbm
  
  AbmObj.MinHeight = 8000
  AbmObj.MinWidth = 11000
  
  Const c_tab_general = 0
  Const c_tab_direccion = 1
  Const c_tab_empresa = 2
  
  With m_ObjAbm.Tabs
    .Clear
    
      .Clear
    
      With .Add(Nothing)
        .Name = C_strGeneral
      End With
      
      With .Add(Nothing)
        .Index = c_tab_direccion
        .Name = LNGGetText(1037, vbNullString) 'Dirección
      End With
      
      With .Add(Nothing)
        .Index = c_tab_empresa
        .Name = LNGGetText(1114, vbNullString) 'Empresa
      End With

  End With
  
  m_ObjAbm.Title2 = m_Apellido & ", " & m_Nombre

  With m_ObjAbm.Properties
    
    .Clear
  
    With .Add(Nothing, cscPrsApellido)
      .PropertyType = cspText
      .Name = LNGGetText(1273, vbNullString)  'Apellido
      .Size = 100
      .Key = K_APELLIDO
      .Value = m_Apellido
      .Width = 4000
    End With
      
    With .Add(Nothing, cscPrsNombre)
      .PropertyType = cspText
      .Name = C_strNombre
      .Size = 100
      .Key = K_NOMBRE
      .Value = m_Nombre
      .Width = 4000
    End With
      
    With .Add(Nothing, cscPrsCodigo)
      .PropertyType = cspText
      .Name = C_strCodigo
      .Size = 15
      .Key = K_CODIGO
      .Value = m_Codigo
    End With
      
    With .Add(Nothing, cscProfLegajo)
      .PropertyType = cspText
      .Name = LNGGetText(1575, vbNullString)  'Legajo
      .Key = K_LEGAJO
      .Value = m_Legajo
    End With
      
    With .Add(Nothing, cscProfFechaingreso)
      .PropertyType = cspText
      .Name = LNGGetText(4678, vbNullString)  'Fecha de Ingreso
      .Key = K_FECHA_INGRESO
      .Value = m_FechaIngreso
    End With
      
    With .Add(Nothing, cscActivo)
      .PropertyType = cspCheck
      .Name = C_strActivo
      .Key = K_ACTIVO
      .Value = CInt(m_Activo)
    End With
      
    With .Add(Nothing, cscPrsdtId)
      .PropertyType = cspHelp
      .Table = csPersonaDocumentoTipo
      .Name = LNGGetText(1063, vbNullString)  'Tipo Doc.
      .Key = K_PRSDT_ID
      .Value = m_TipoDoc
      .HelpId = m_prsdt_id
    End With
    
    With .Add(Nothing, cscPrsDocumento)
      .PropertyType = cspText
      .Name = LNGGetText(1567, vbNullString)  'Documento
      .Key = K_DOCUMENTO
      .Value = m_Documento
    End With
      
    With .Add(Nothing, cscPrsFechaNac)
      .PropertyType = cspDate
      .Name = LNGGetText(1280, vbNullString)  'Fecha Na.
      .Key = K_FECHANAC
      .Value = m_FechaNac
    End With
      
    With .Add(Nothing, c_foto_file)
      .PropertyType = cspFile
      .Name = LNGGetText(2966, vbNullString) 'Archivo
      .Key = K_FOTO_FILE
      .HelpFilter = "Archivos de Imagenes|*.jpg;*.bmp;*.gif;*.jpeg|Todos los archivos|*.*"
      .Width = 3000
      .TopFromProperty = cscPrsApellido
      .Left = 6550
      .LeftLabel = -700
    End With
    
    With .Add(Nothing, c_foto)
      .PropertyType = cspImage
      .Name = LNGGetText(4674, vbNullString) 'Foto
      .Key = K_FOTO
      .TopFromProperty = cscPrsNombre
      .Left = 6550
      .LeftLabel = -700
      .LeftNotChange = True
      .TopNotChange = True
      Set .Picture = pGetFoto
    End With
        
    ' Direccion
      
    With .Add(Nothing, cscPrsCalle)
      .PropertyType = cspText
      .Name = LNGGetText(1194, vbNullString) 'Calle
      .TabIndex = c_tab_direccion
      .Key = K_CALLE
      .Value = m_Calle
      .Width = 9000
      .LeftFromProperty = cscPrsNombre
    End With
    
    With .Add(Nothing, cscPrsCallenumero)
      .PropertyType = cspText
      .Name = LNGGetText(1065, vbNullString) 'Numero
      .TabIndex = c_tab_direccion
      .Size = 10
      .Key = K_CALLENUMERO
      .Value = m_Callenumero
      .Width = 1200
    End With
    
    With .Add(Nothing, cscPrsPiso)
      .PropertyType = cspText
      .Name = LNGGetText(1196, vbNullString) 'Piso
      .TabIndex = c_tab_direccion
      .Size = 4
      .Key = K_PISO
      .Value = m_Piso
      .Width = 1200
    End With
    
    With .Add(Nothing, cscPrsDepto)
      .PropertyType = cspText
      .Name = LNGGetText(1278, vbNullString) 'Departamento
      .TabIndex = c_tab_direccion
      .Size = 4
      .Key = K_DEPTO
      .Value = m_Depto
      .Width = 1200
    End With
    
    With .Add(Nothing, cscPrsCodpostal)
      .PropertyType = cspText
      .Name = LNGGetText(1199, vbNullString) 'Codigo Postal
      .TabIndex = c_tab_direccion
      .Size = 20
      .Key = K_CODPOSTAL
      .Value = m_Codpostal
      .Width = 1200
    End With
    
    With .Add(Nothing, cscPrsLocalidad)
      .PropertyType = cspText
      .Name = LNGGetText(1198, vbNullString) 'Localidad
      .TabIndex = c_tab_direccion
      .Size = 100
      .Key = K_LOCALIDAD
      .Value = m_Localidad
      .Width = 5000
    End With
    
    With .Add(Nothing, cscProId)
      .PropertyType = cspHelp
      .Table = csProvincia
      .Name = LNGGetText(1080, vbNullString) 'Provincia
      .TabIndex = c_tab_direccion
      .Key = K_PRO_ID
      .Value = m_provincia
      .HelpId = m_pro_id
      .Width = 5000
    End With
      
    With .Add(Nothing, cscPrsTelTrab)
      .PropertyType = cspText
      .TopFromProperty = cscPrsApellido
      .Left = 5200
      .Name = LNGGetText(1274, vbNullString)  'Tel. Trabajo
      .Size = 50
      .Key = K_TELTRAB
      .Value = m_TelTrab
      .TabIndex = c_tab_direccion
    End With
          
    With .Add(Nothing, cscPrsCelular)
      .PropertyType = cspText
      .Name = LNGGetText(1276, vbNullString)  'Celular
      .Size = 50
      .Key = K_CELULAR
      .Value = m_Celular
      .TabIndex = c_tab_direccion
    End With
      
    With .Add(Nothing, cscPrsEmail)
      .PropertyType = cspText
      .Name = LNGGetText(1034, vbNullString)  'Mail
      .Size = 50
      .Key = K_EMAIL
      .Value = m_Email
      .TabIndex = c_tab_direccion
    End With
      
    With .Add(Nothing, cscPrsTelCasa)
      .PropertyType = cspText
      .Name = LNGGetText(1277, vbNullString)  'Tel. Casa
      .Size = 50
      .Key = K_TELCASA
      .Value = m_TelCasa
      .TabIndex = c_tab_direccion
    End With
      
    With .Add(Nothing, cscPrsWeb)
      .PropertyType = cspText
      .Name = LNGGetText(1038, vbNullString)  'Web
      .Key = K_WEB
      .Value = m_Web
      .TabIndex = c_tab_direccion
    End With
            
    ' Empresa
            
    With .Add(Nothing, cscDptoId)
      .PropertyType = cspHelp
      .Table = csDepartamento
      .Name = LNGGetText(1278, vbNullString)  'Departamento
      .Key = K_DPTO_ID
      .Value = m_Departamento
      .HelpId = m_Dpto_id
      .TabIndex = c_tab_empresa
    End With
      
    With .Add(Nothing, cscPrsCargo)
      .PropertyType = cspText
      .Name = LNGGetText(1279, vbNullString)  'Cargo
      .Size = 100
      .Key = K_CARGO
      .Value = m_Cargo
      .TabIndex = c_tab_empresa
    End With
    
    With .Add(Nothing, cscPrsInterno)
      .PropertyType = cspText
      .Name = LNGGetText(1275, vbNullString)  'Interno
      .Size = 50
      .Key = K_INTERNO
      .Value = m_Interno
      .TabIndex = c_tab_empresa
    End With
    
    With .Add(Nothing, cscSucId)
      .PropertyType = cspHelp
      .Table = csSucursal
      .Name = LNGGetText(1281, vbNullString)  'Sucursal
      .Key = K_SUC_ID
      .Value = m_Sucursal
      .HelpId = m_Suc_id
      .TabIndex = c_tab_empresa
    End With
        
    With .Add(Nothing, cscProvId)
      .PropertyType = cspHelp
      .Table = csProveedor
      .Name = LNGGetText(1151, vbNullString)  'Proveedor
      .Key = K_PROV_ID
      .Value = m_Proveedor
      .HelpId = m_Prov_id
      .TabIndex = c_tab_empresa
    End With
      
    With .Add(Nothing, cscProfDescrip)
      .PropertyType = cspText
      .LeftFromProperty = cscPrsApellido
      .Name = C_strDescrip
      .SubType = cspMemo
      .Height = 880
      .Width = 8100
      .Size = 255
      .Key = K_DESCRIP
      .Value = m_descrip
      .TopFromProperty = cscPrsFechaNac
      .TopToPrevious = 1200
    End With
  
  End With
  
  If Not m_ObjAbm.Show(Me) Then Exit Function
  
  LoadCollection = True
End Function

Private Function Load(ByVal Id As Long) As Boolean
  
  Dim sqlstmt As String
  Dim rs      As Recordset

  sqlstmt = "sp_ProfesorGet " & Id

  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, C_LoadFunction, C_Module) Then Exit Function

  If Not rs.EOF Then

    m_Id = gDB.ValField(rs.fields, cscProfId)
  
    m_Legajo = gDB.ValField(rs.fields, cscProfLegajo)
    m_FechaIngreso = gDB.ValField(rs.fields, cscProfFechaingreso)
    m_descrip = gDB.ValField(rs.fields, cscProfDescrip)
    
    m_prs_id = gDB.ValField(rs.fields, cscPrsId)
    m_Nombre = gDB.ValField(rs.fields, cscPrsNombre)
    m_Apellido = gDB.ValField(rs.fields, cscPrsApellido)
    m_Codigo = gDB.ValField(rs.fields, cscPrsCodigo)
    m_Interno = gDB.ValField(rs.fields, cscPrsInterno)
    m_TelTrab = gDB.ValField(rs.fields, cscPrsTelTrab)
    m_TelCasa = gDB.ValField(rs.fields, cscPrsTelCasa)
    m_Celular = gDB.ValField(rs.fields, cscPrsCelular)
    m_Email = gDB.ValField(rs.fields, cscPrsEmail)
    m_Cargo = gDB.ValField(rs.fields, cscPrsCargo)
    m_FechaNac = gDB.ValField(rs.fields, cscPrsFechaNac)
    m_Prov_id = gDB.ValField(rs.fields, cscProvId)
    m_Proveedor = gDB.ValField(rs.fields, cscProvNombre)
    
    m_Codpostal = gDB.ValField(rs.fields, cscPrsCodpostal)
    m_Localidad = gDB.ValField(rs.fields, cscPrsLocalidad)
    m_Calle = gDB.ValField(rs.fields, cscPrsCalle)
    m_Callenumero = gDB.ValField(rs.fields, cscPrsCallenumero)
    m_Piso = gDB.ValField(rs.fields, cscPrsPiso)
    m_Depto = gDB.ValField(rs.fields, cscPrsDepto)
    
    m_pro_id = gDB.ValField(rs.fields, cscProId)
    m_provincia = gDB.ValField(rs.fields, cscProNombre)
    
    m_prsdt_id = gDB.ValField(rs.fields, cscPrsdtId)
    m_TipoDoc = gDB.ValField(rs.fields, cscPrsdtNombre)
    m_Documento = gDB.ValField(rs.fields, cscPrsDocumento)
    m_Web = gDB.ValField(rs.fields, cscPrsWeb)
    
    m_Activo = gDB.ValField(rs.fields, cscActivo)
    m_Suc_id = gDB.ValField(rs.fields, cscSucId)
    m_Sucursal = gDB.ValField(rs.fields, cscSucNombre)
    m_Departamento = gDB.ValField(rs.fields, cscDptoNombre)
    m_Dpto_id = gDB.ValField(rs.fields, cscDptoId)

  Else
    
    m_Id = csNO_ID
    
    m_Legajo = vbNullString
    m_FechaIngreso = Date
    m_descrip = vbNullString
    
    m_prs_id = csNO_ID
    m_Nombre = vbNullString
    m_Apellido = vbNullString
    m_Codigo = vbNullString
    m_Interno = vbNullString
    m_TelTrab = vbNullString
    m_TelCasa = vbNullString
    m_Celular = vbNullString
    m_Email = vbNullString
    m_Cargo = vbNullString
    m_FechaNac = csNoDate
    m_Prov_id = csNO_ID
    m_Proveedor = vbNullString
    
    m_prsdt_id = csNO_ID
    m_TipoDoc = vbNullString
    m_Documento = vbNullString
    m_Web = vbNullString
    
    m_Codpostal = vbNullString
    m_Localidad = vbNullString
    m_Calle = vbNullString
    m_Callenumero = vbNullString
    m_Piso = vbNullString
    m_Depto = vbNullString
    
    m_pro_id = csNO_ID
    m_provincia = vbNullString
    
    m_Activo = True
    m_Suc_id = csNO_ID
    m_Sucursal = vbNullString
    m_Departamento = vbNullString
    m_Dpto_id = csNO_ID

  End If

  Load = True
End Function

Private Function pSaveFoto(ByVal Id As Long, _
                           ByVal File As String) As Boolean
  Dim dd As cDocDigital
  Dim objFile As Object
  
  Set objFile = CSKernelClient2.CreateObject("CSKernelFile.cFileEx")
  Set dd = New cDocDigital
  
  dd.Codigo = c_foto_persona_chica & Id
  dd.ClientTable = "LOGIC_TBL_PERSONA"
  dd.ClientTableID = Id
  dd.FileName = objFile.FileGetName(File)
  dd.Path = objFile.FileGetPath(File)
  dd.Id = pGetDDId(Id)
  
  If Not dd.Save(gDB) Then Exit Function
  If Not dd.AddFile(gDB) Then Exit Function

  pSaveFoto = True

End Function

Private Function pGetDDId(ByVal Id As Long) As Long
  Dim sqlstmt As String
  Dim rs As ADODB.Recordset
  
  sqlstmt = "select dd_id from DocumentoDigital where dd_codigo = '" & c_foto_persona_chica & m_prs_id & "'"

  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Function
  If rs.EOF Then Exit Function
  
  pGetDDId = rs.fields.Item(0).Value
End Function

Private Function pGetFoto() As IPictureDisp
  
  If m_prs_id = csNO_ID Then Exit Function
  
  Dim dd As cDocDigital
  Dim dd_id As Long
  Dim sqlstmt As String
  Dim rs As ADODB.Recordset
  
  sqlstmt = "select dd_id from DocumentoDigital " & _
            "where dd_codigo = '" & c_foto_persona_chica & m_prs_id & "'" & _
             " and dd_clientTable = 'LOGIC_TBL_PERSONA' " & _
             " and dd_clientTableId = " & m_prs_id
             
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Function
  If rs.EOF Then Exit Function
  
  dd_id = rs.fields.Item(0).Value
  
  Set dd = New cDocDigital
  
  If Not dd.Load(dd_id, gDB) Then Exit Function
  
  Dim File As String
  File = c_foto_persona_chica & m_prs_id
  If Not dd.ExtractDoc(gDB, File, True) Then Exit Function
  
  On Error Resume Next
  Set pGetFoto = LoadPicture(File)
End Function

Private Function pLoadPictureFromFile() As IPictureDisp
  On Error Resume Next
  Dim File As String
  File = m_ObjAbm.Properties.Item(c_foto_file).Value
  Set pLoadPictureFromFile = LoadPicture(File)
End Function

' construccion - destruccion
Private Sub Class_Terminate()
  On Error Resume Next
  Set m_ObjAbm = Nothing
  Set m_ObjTree = Nothing
End Sub
