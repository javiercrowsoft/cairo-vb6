VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cEmpleado"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements CSInterfacesABM.cIEditGeneric
Implements CSInterfacesABM.cIABMClient
Implements CSMenu.cIMenuClient
Implements CSInterfacesABM.cIABMClientGrid

'--------------------------------------------------------------------------------
' cEmpleado
' 12-08-08

'--------------------------------------------------------------------------------
' notas:
'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cEmpleado"

Private Const c_CentroCosto = "CentroCosto"

Private Const K_APELLIDO                       As Integer = 100
Private Const K_NOMBRE                         As Integer = 1
Private Const K_CODIGO                         As Integer = 2
Private Const K_LEGAJO                         As Integer = 4
Private Const K_INGRESO                        As Integer = 5
Private Const K_EGRESO                         As Integer = 6
Private Const K_CUIL                           As Integer = 7
Private Const K_DNI                            As Integer = 8
Private Const K_FECHANACIMIENTO                As Integer = 9
Private Const K_CODPOSTAL                      As Integer = 10
Private Const K_LOCALIDAD                      As Integer = 11
Private Const K_CALLE                          As Integer = 12
Private Const K_CALLENUMERO                    As Integer = 13
Private Const K_PISO                           As Integer = 14
Private Const K_DEPTO                          As Integer = 15
Private Const K_TEL                            As Integer = 16
Private Const K_LIBRETA                        As Integer = 17
Private Const K_TIPOLIQUIDACION                As Integer = 18
Private Const K_CTABANCO                       As Integer = 19
Private Const K_FDODESEMPLEO                   As Integer = 20
Private Const K_OBRASOCIAL                     As Integer = 21
Private Const K_BANELCO                        As Integer = 22
Private Const K_PREOCUPACIONAL                 As Integer = 23
Private Const K_LUGARNACIMIENTO                As Integer = 24
Private Const K_DESCRIP                        As Integer = 25
Private Const K_ESTC_ID                        As Integer = 26
Private Const K_SIND_ID                        As Integer = 27
Private Const K_SINDCO_ID                      As Integer = 28
Private Const K_SINDCA_ID                      As Integer = 29
Private Const K_EMA_ID                         As Integer = 30
Private Const K_EME_ID                         As Integer = 31
Private Const K_ACTIVO                         As Integer = 32
Private Const K_PRO_ID                         As Integer = 33
Private Const K_EMAIL                          As Integer = 34
Private Const K_PA_ID                          As Integer = 35

Private Const K_ITEMS                          As Integer = 50
Private Const K_CENTRO_COSTO                   As Integer = 51

Private Const KI_EMF_ID        As Integer = 1
Private Const KI_APELLIDO      As Integer = 2
Private Const KI_NOMBRE        As Integer = 3
Private Const KI_DNI           As Integer = 4
Private Const KI_FECHA_NAC     As Integer = 5
Private Const KI_DESCRIP       As Integer = 6
Private Const KI_EMFT_ID       As Integer = 7

Private Const KI_EMCCOS_ID      As Integer = 1
Private Const KI_DESDE          As Integer = 2
Private Const KI_HASTA          As Integer = 4
Private Const KI_CCOS_ID        As Integer = 5

' estructuras
' Seudo - Variables
Private c_ErrorSave         As String

' variables privadas
Private m_Id                           As Long
Private m_Nombre                       As String
Private m_Apellido                     As String
Private m_Codigo                       As String
Private m_Legajo                       As String
Private m_Ingreso                      As Date
Private m_Egreso                       As Date
Private m_Cuil                         As String
Private m_Dni                          As String
Private m_Fechanacimiento              As Date
Private m_Codpostal                    As String
Private m_Localidad                    As String
Private m_Calle                        As String
Private m_Callenumero                  As String
Private m_Piso                         As String
Private m_Depto                        As String
Private m_Tel                          As String
Private m_Libreta                      As String
Private m_TipoLiquidacion              As Integer
Private m_CtaBanco                     As String
Private m_FdoDesempleo                 As String
Private m_ObraSocial                   As String
Private m_Banelco                      As Boolean
Private m_Preocupacional               As Boolean
Private m_LugarNacimiento              As String
Private m_descrip                      As String
Private m_Estc_id                      As Long
Private m_EstadoCivil                  As String
Private m_sind_id                      As Long
Private m_Sindicato                    As String
Private m_Sindco_id                    As Long
Private m_SindicatoConvenio            As String
Private m_Sindca_id                    As Long
Private m_SindicatoCategoria           As String
Private m_Ema_id                       As Long
Private m_ART                          As String
Private m_Eme_id                       As Long
Private m_Especialidad                 As String
Private m_Email                        As String
Private m_pro_id                       As Long
Private m_provincia                    As String
Private m_pa_id                        As Long
Private m_pais                         As String
Private m_Activo                       As Boolean

' HOJO HASTA ACA

Private m_Editing           As Boolean

Private m_ObjAbm            As cIABMGeneric
Private m_ObjTree           As Object

Private m_IsNew             As Boolean

Private m_BranchId          As Long
Private m_TreeId            As Long

Private m_Host              As CSMenu.cIMenuHost
Private m_Copy              As Boolean

Private m_ItemsDeletedItems            As String
Private m_ItemsDeletedCcos             As String
' Properties publicas

Public Property Get Id() As Long
  Id = m_Id
End Property

Public Property Get Nombre() As String
  Nombre = m_Apellido & ", " & m_Nombre
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
  
  With m_ObjAbm.Properties(cscEmCodigo)
    .Value = C_C & .Value
  End With
  
'  With m_ObjAbm.Properties(cscPaNombre)
'    .Value = C_CopiaDe & .Value
'  End With
  
  m_ObjAbm.ShowValue m_ObjAbm.Properties(cscEmCodigo)
  m_ObjAbm.ShowValue m_ObjAbm.Properties(cscEmNombre)
  
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

  Doc.ClientTable = csTEmpleado
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
                               csPrePNewEmpleado
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
  Dim LastId      As Long
  Dim register    As cRegister
  Dim fields      As cFields
  
  Set register = New cRegister
  Set fields = register.fields
  
  With register
    .fieldId = cscEmId
    .Table = csTEmpleado
  
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
        Case K_APELLIDO
          fields.Add2 cscEmApellido, .Value, csText
        Case K_NOMBRE
          fields.Add2 cscEmNombre, .Value, csText
        Case K_CODIGO
          fields.Add2 cscEmCodigo, .Value, csText
        Case K_DESCRIP
          fields.Add2 cscEmDescrip, .Value, csText
        Case K_ACTIVO
          fields.Add2 cscActivo, .Value, csBoolean
      
      
        Case K_LEGAJO
          fields.Add2 cscEmLegajo, .Value, csText
        Case K_INGRESO
          fields.Add2 cscEmIngreso, .Value, csDate
        Case K_EGRESO
          fields.Add2 cscEmEgreso, .Value, csDate
        Case K_CUIL
          fields.Add2 cscEmCuil, .Value, csText
        Case K_DNI
          fields.Add2 cscEmDni, .Value, csText
        Case K_FECHANACIMIENTO
          fields.Add2 cscEmFechanacimiento, .Value, csDate
        Case K_CODPOSTAL
          fields.Add2 cscEmCodpostal, .Value, csText
        Case K_LOCALIDAD
          fields.Add2 cscEmLocalidad, .Value, csText
        Case K_CALLE
          fields.Add2 cscEmCalle, .Value, csText
        Case K_CALLENUMERO
          fields.Add2 cscEmCallenumero, .Value, csText
        Case K_PISO
          fields.Add2 cscEmPiso, .Value, csText
        Case K_DEPTO
          fields.Add2 cscEmDepto, .Value, csText
        Case K_TEL
          fields.Add2 cscEmTel, .Value, csText
        Case K_LIBRETA
          fields.Add2 cscEmLibreta, .Value, csText
        Case K_TIPOLIQUIDACION
          fields.Add2 cscEmTipoLiquidacion, .ListItemData, csInteger
        Case K_CTABANCO
          fields.Add2 cscEmCtaBanco, .Value, csText
        Case K_FDODESEMPLEO
          fields.Add2 cscEmFdoDesempleo, .Value, csText
        Case K_OBRASOCIAL
          fields.Add2 cscEmObraSocial, .Value, csText
        Case K_BANELCO
          fields.Add2 cscEmBanelco, .Value, csBoolean
        Case K_PREOCUPACIONAL
          fields.Add2 cscEmPreocupacional, .Value, csBoolean
        Case K_LUGARNACIMIENTO
          fields.Add2 cscEmLugarNacimiento, .Value, csText
        Case K_DESCRIP
          fields.Add2 cscEmDescrip, .Value, csText
        Case K_EMAIL
          fields.Add2 cscEmEmail, .Value, csText
        Case K_PRO_ID
          fields.Add2 cscProId, .HelpId, csId
        Case K_PA_ID
          fields.Add2 cscPaId, .HelpId, csId
        Case K_ESTC_ID
          fields.Add2 cscEstcId, .HelpId, csId
        Case K_SIND_ID
          fields.Add2 cscSindId, .HelpId, csId
        Case K_SINDCO_ID
          fields.Add2 cscSindcoId, .HelpId, csId
        Case K_SINDCA_ID
          fields.Add2 cscSindcaId, .HelpId, csId
        Case K_EMA_ID
          fields.Add2 cscEmaId, .HelpId, csId
        Case K_EME_ID
          fields.Add2 cscEmeId, .HelpId, csId
      
      End Select
    End With
  Next
  
  fields.HaveLastUpdate = True
  fields.HaveWhoModify = True
  
  If Not register.BeginTrans(gDB) Then Exit Function
  
  If Not gDB.SaveEx(register, , _
                    cscEmCodigo, _
                    C_ABMClientSave, _
                    C_Module, _
                    c_ErrorSave) Then Exit Function
  
  LastId = m_Id
  m_Id = register.Id
  
  If Not pSaveItems() Then GoTo SaveError
  If Not pSaveCentroCosto() Then GoTo SaveError
  
  If Not register.CommitTrans() Then GoTo SaveError
  
  m_Copy = False
  cIABMClient_Save = Load(register.Id)
  
  Exit Function
SaveError:

  m_Id = LastId
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
                             'Empleados
  cIABMClient_Title = LNGGetText(4523, vbNullString)
End Property

Private Function cIABMClient_Validate() As Boolean

  Dim IProperty As cIABMProperty
  Dim bSinART   As Boolean
  
  For Each IProperty In m_ObjAbm.Properties
    With IProperty
      Select Case .Key
        Case K_APELLIDO
          If ValEmpty(.Value, csText) Then
            MsgInfo LNGGetText(4556, vbNullString) 'Debe indicar un apellido
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
        Case K_PRO_ID
          If ValEmpty(.HelpId, csId) Then
            MsgInfo LNGGetText(1077, vbNullString) 'Debe indicar una provincia
            Exit Function
          End If
        Case K_PA_ID
          If ValEmpty(.HelpId, csId) Then
            MsgInfo LNGGetText(4557, vbNullString) 'Debe indicar una nacionalidad
            Exit Function
          End If
        Case K_EME_ID
          If ValEmpty(.HelpId, csId) Then
            MsgInfo LNGGetText(4558, vbNullString) 'Debe indicar una especialidad
            Exit Function
          End If
        Case K_ESTC_ID
          If ValEmpty(.HelpId, csId) Then
            MsgInfo LNGGetText(4560, vbNullString) 'Debe indicar un estado civil
            Exit Function
          End If
        Case K_EMA_ID
          If ValEmpty(.HelpId, csId) Then
            bSinART = True
          End If

      End Select
    End With
  Next

  If bSinART Then
  
    If Not Ask(LNGGetText(4559, vbNullString), vbNo) Then
               'Confirma que desea grabar el empleado sin indicar la ART
      Exit Function
    End If
  
  End If

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
    cIEditGeneric_ShowList = SecurityCanAccess(csPrePListEmpleado)
End Function

Private Property Set cIEditGeneric_ObjAbm(rhs As CSInterfacesABM.cIABMGeneric)
    Set m_ObjAbm = rhs
End Property

Private Property Get cIEditGeneric_Editing() As Boolean
    cIEditGeneric_Editing = m_Editing
End Property

Private Function cIEditGeneric_Delete(Id As Long) As Boolean
    If Not SecurityCanAccess(csPrePDeleteEmpleado) Then Exit Function

    Dim sqlstmt As String
    
    sqlstmt = "delete EmpleadoFamilia where em_id = " & Id
    sqlstmt = sqlstmt & " delete Empleado where em_id = " & Id
    
    cIEditGeneric_Delete = gDB.Execute(sqlstmt, C_EditGenericDelete, C_Module)
End Function

Private Function cIEditGeneric_Search(Id As Long, Cancela As Boolean) As Boolean

End Function

Private Function cIEditGeneric_Edit(Id As Long, Optional ByVal InModalWindow As Boolean) As Boolean
  On Error GoTo ControlError
  
  If Id = csNO_ID Then
    m_IsNew = True
    If Not SecurityCanAccess(csPrePNewEmpleado) Then Exit Function
  Else
    m_IsNew = False
    If Not SecurityCanAccess(csPrePEditEmpleado) Then Exit Function
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
  
  m_Host.Server.AddMenu C_MenuManejoPersonal, csMenuConfigMPersonal, C_MenuConfig, 0, True, False, False, False, True, Nothing
                            '&Empleados
  m_Host.Server.AddMenu LNGGetText(4524, vbNullString), csPrePListEmpleado, C_MenuManejoPersonal, 0, True, False, False, False, False, Me
  
  cIMenuClient_Initialize = True
  
  GoTo ExitProc
ControlError:
  MngError Err, C_MenuClientInit, C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Private Function cIMenuClient_ProcessMenu(ByVal Id As Long) As Variant
                                                  'Empleados
  m_Host.MenuABMClick "CSPersonal.cEmpleado", Me, LNGGetText(4525, vbNullString), 0, csETablesPersonal.csEmpleado
  
End Function

' funciones privadas
Private Function LoadCollection() As Boolean
  Dim c As cIABMProperty
  Dim AbmObj  As cABMGeneric
  
  Set AbmObj = m_ObjAbm
  AbmObj.MinHeight = 7500
  
  Const c_tab_legajo = 1
  Const c_tab_sindicato = 2
  Const c_tab_direccion = 3
  Const c_tab_familiares = 4
  Const c_tab_construccion = 5
  Const c_tab_centrocosto = 6
  
  With m_ObjAbm.Tabs
  
    .Clear
      
    With .Add(Nothing)
      .Name = C_strGeneral
    End With
    
    With .Add(Nothing)
      .Index = c_tab_legajo
      .Name = LNGGetText(1575, vbNullString) 'Legajo
    End With
    
    With .Add(Nothing)
      .Index = c_tab_sindicato
      .Name = LNGGetText(4503, vbNullString) 'Sindicato
    End With
    
    With .Add(Nothing)
      .Index = c_tab_direccion
      .Name = LNGGetText(1037, vbNullString) 'Direccion
    End With
        
    With .Add(Nothing)
      .Index = c_tab_familiares
      .Name = LNGGetText(4526, vbNullString) 'Familiares
    End With
    
    With .Add(Nothing)
      .Index = c_tab_construccion
      .Name = LNGGetText(4547, vbNullString) 'Construccion
    End With
    
    With .Add(Nothing)
      .Index = c_tab_centrocosto
      .Name = LNGGetText(4602, vbNullString) 'Centos de Costo
    End With
    
  End With
  
  If LenB(m_Apellido & m_Nombre) Then
    m_ObjAbm.Title2 = m_Apellido & ", " & m_Nombre
  Else
    m_ObjAbm.Title2 = vbNullString
  End If

  With m_ObjAbm.Properties
    
    .Clear
    
    With .Add(Nothing, cscEmApellido)
      .PropertyType = cspText
      .Name = LNGGetText(1273, vbNullString) 'Apellido
      .Size = 100
      .Key = K_APELLIDO
      .Value = m_Apellido
      .Width = 6200
    End With
    
    With .Add(Nothing, cscEmNombre)
      .PropertyType = cspText
      .Name = C_strNombre
      .Size = 100
      .Key = K_NOMBRE
      .Value = m_Nombre
      .Width = 6200
    End With
      
    With .Add(Nothing, cscEmCodigo)
      .PropertyType = cspText
      .Name = C_strCodigo
      .Size = 15
      .Key = K_CODIGO
      .Value = m_Codigo
    End With
      
    With .Add(Nothing, cscActivo)
      .PropertyType = cspCheck
      .Name = C_strActivo
      .Key = K_ACTIVO
      .Value = CInt(m_Activo)
    End With
      
    With .Add(Nothing, cscEmDescrip)
      .PropertyType = cspText
      .Name = C_strDescrip
      .Size = 255
      .Key = K_DESCRIP
      .Value = m_descrip
      .SubType = cspMemo
      .Width = 6200
      .Height = 880
    End With
      
    '/////////////////////////////////////////////////////////////////////////////////////
    '
    ' Legajo
    '
    '
    With .Add(Nothing, cscEmLegajo)
      .PropertyType = cspText
      .Name = LNGGetText(1575, vbNullString) 'Legajo
      .Size = 50
      .Key = K_LEGAJO
      .Value = m_Legajo
      .TabIndex = c_tab_legajo
    End With
  
    With .Add(Nothing, cscEmIngreso)
      .PropertyType = cspDate
      .Name = LNGGetText(4531, vbNullString) 'Ingreso
      .Key = K_INGRESO
      .Value = m_Ingreso
      .TabIndex = c_tab_legajo
    End With
  
    With .Add(Nothing, cscEmEgreso)
      .PropertyType = cspDate
      .Name = LNGGetText(4532, vbNullString) 'Egreso
      .Key = K_EGRESO
      .Value = m_Egreso
      .TabIndex = c_tab_legajo
    End With
  
    With .Add(Nothing, cscEmCuil)
      .PropertyType = cspText
      .Name = LNGGetText(4533, vbNullString) 'CUIL
      .Size = 20
      .Key = K_CUIL
      .Value = m_Cuil
      .TabIndex = c_tab_legajo
    End With
  
    With .Add(Nothing, cscEmDni)
      .PropertyType = cspText
      .Name = LNGGetText(4534, vbNullString) 'DNI
      .Size = 20
      .Key = K_DNI
      .Value = m_Dni
      .TabIndex = c_tab_legajo
    End With
  
    With .Add(Nothing, cscEmFechanacimiento)
      .PropertyType = cspDate
      .Name = LNGGetText(3032, vbNullString) 'Nacimiento
      .Key = K_FECHANACIMIENTO
      .Value = m_Fechanacimiento
      .TabIndex = c_tab_legajo
    End With
    
    With .Add(Nothing, cscEmLugarNacimiento)
      .PropertyType = cspText
      .Name = LNGGetText(4543, vbNullString) 'Lugar de Nacimiento
      .Size = 255
      .Key = K_LUGARNACIMIENTO
      .Value = m_LugarNacimiento
      .TabIndex = c_tab_legajo
    End With
    
    With .Add(Nothing, cscEmaId)
      .PropertyType = cspHelp
      .Table = csEmpleadoART
      .Name = LNGGetText(4546, vbNullString) 'ART
      .Key = K_EMA_ID
      .Value = m_ART
      .HelpId = m_Ema_id
      .TabIndex = c_tab_legajo
      .Width = 5000
      .TopFromProperty = cscEmLegajo
      .Left = 5500
    End With
  
    With .Add(Nothing, cscEmeId)
      .PropertyType = cspHelp
      .Table = csEmpleadoEspecialidad
      .Name = LNGGetText(4519, vbNullString) 'Profesion / Especialidad
      .Key = K_EME_ID
      .Value = m_Especialidad
      .HelpId = m_Eme_id
      .TabIndex = c_tab_legajo
      .Width = 5000
    End With
    
    With .Add(Nothing, cscEmCtaBanco)
      .PropertyType = cspText
      .Name = LNGGetText(4538, vbNullString) 'Cta. Banco
      .Size = 20
      .Key = K_CTABANCO
      .Value = m_CtaBanco
      .TabIndex = c_tab_legajo
    End With
    
    With .Add(Nothing, cscEmObraSocial)
      .PropertyType = cspText
      .Name = LNGGetText(4540, vbNullString) 'Obra Social
      .Size = 20
      .Key = K_OBRASOCIAL
      .Value = m_ObraSocial
      .TabIndex = c_tab_legajo
      .Width = 5000
    End With
  
    With .Add(Nothing, cscEmBanelco)
      .PropertyType = cspCheck
      .Name = LNGGetText(4541, vbNullString) 'Banelco
      .Key = K_BANELCO
      .Value = CInt(m_Banelco)
      .TabIndex = c_tab_legajo
    End With
  
    With .Add(Nothing, cscEmPreocupacional)
      .PropertyType = cspCheck
      .Name = LNGGetText(4542, vbNullString) 'Preocupacional
      .Key = K_PREOCUPACIONAL
      .Value = CInt(m_Preocupacional)
      .TabIndex = c_tab_legajo
      .TopFromProperty = cscEmBanelco
      .Left = 7000
      .LeftNotChange = True
    End With
    
    With .Add(Nothing, cscEstcId)
      .PropertyType = cspHelp
      .Table = csEstadoCivil
      .Name = LNGGetText(4544, vbNullString) 'Estado Civil
      .Key = K_ESTC_ID
      .Value = m_EstadoCivil
      .HelpId = m_Estc_id
      .TabIndex = c_tab_legajo
      .Width = 2500
    End With
    
    With .Add(Nothing, cscPaId)
      .PropertyType = cspHelp
      .Table = csPais
      .Name = LNGGetText(4548, vbNullString) 'Nacionalidad
      .TabIndex = c_tab_legajo
      .Key = K_PA_ID
      .Value = m_pais
      .HelpId = m_pa_id
      .Width = 2500
    End With
    
    '/////////////////////////////////////////////////////////////////////////////////////
    '
    ' Sindicato
    '
    '
    With .Add(Nothing, cscSindId)
      .PropertyType = cspHelp
      .Table = csSindicato
      .Name = LNGGetText(4503, vbNullString) 'Sindicato
      .Key = K_SIND_ID
      .Value = m_Sindicato
      .HelpId = m_sind_id
      .TabIndex = c_tab_sindicato
      .Width = 4000
    End With
  
    With .Add(Nothing, cscSindcoId)
      .PropertyType = cspHelp
      .Table = csSindicatoConvenio
      .Name = LNGGetText(4545, vbNullString) 'Convenio
      .Key = K_SINDCO_ID
      .Value = m_SindicatoConvenio
      .HelpId = m_Sindco_id
      .TabIndex = c_tab_sindicato
      .Width = 4000
    End With
  
    With .Add(Nothing, cscSindcaId)
      .PropertyType = cspHelp
      .Table = csSindicatoCategoria
      .Name = LNGGetText(1120, vbNullString) 'Categoria
      .Key = K_SINDCA_ID
      .Value = m_SindicatoCategoria
      .HelpId = m_Sindca_id
      .TabIndex = c_tab_sindicato
      .Width = 4000
    End With
      
    '/////////////////////////////////////////////////////////////////////////////////////
    '
    ' Direccion
    '
    '
    With .Add(Nothing, cscEmCalle)
      .PropertyType = cspText
      .Name = LNGGetText(1194, vbNullString) 'Calle
      .TabIndex = c_tab_direccion
      .Key = K_CALLE
      .Value = m_Calle
      .Width = 9000
    End With
    
    With .Add(Nothing, cscEmCallenumero)
      .PropertyType = cspText
      .Name = LNGGetText(1065, vbNullString) 'Numero
      .TabIndex = c_tab_direccion
      .Size = 10
      .Key = K_CALLENUMERO
      .Value = m_Callenumero
      .Width = 1200
    End With
    
    With .Add(Nothing, cscEmPiso)
      .PropertyType = cspText
      .Name = LNGGetText(1196, vbNullString) 'Piso
      .TabIndex = c_tab_direccion
      .Size = 4
      .Key = K_PISO
      .Value = m_Piso
      .Width = 1200
    End With
    
    With .Add(Nothing, cscEmDepto)
      .PropertyType = cspText
      .Name = LNGGetText(1278, vbNullString) 'Departamento
      .TabIndex = c_tab_direccion
      .Size = 4
      .Key = K_DEPTO
      .Value = m_Depto
      .Width = 1200
    End With
    
    With .Add(Nothing, cscEmCodpostal)
      .PropertyType = cspText
      .Name = LNGGetText(1199, vbNullString) 'Codigo Postal
      .TabIndex = c_tab_direccion
      .Size = 20
      .Key = K_CODPOSTAL
      .Value = m_Codpostal
      .Width = 1200
    End With
    
    With .Add(Nothing, cscEmLocalidad)
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
          
    With .Add(Nothing, cscEmTel)
      .PropertyType = cspText
      .Name = LNGGetText(1036, vbNullString) 'Teléfono
      .TabIndex = c_tab_direccion
      .Size = 100
      .Key = K_TEL
      .Value = m_Tel
      .Width = 6000
      .TopFromProperty = cscEmCallenumero
      .Left = 4200
      .LeftLabel = -900
    End With
          
    With .Add(Nothing, cscEmEmail)
      .PropertyType = cspText
      .Name = LNGGetText(1034, vbNullString) 'E-Mail
      .TabIndex = c_tab_direccion
      .Size = 100
      .Key = K_EMAIL
      .Value = m_Email
    End With
    
    '/////////////////////////////////////////////////////////////////////////////////////
    '
    ' Familiares
    '
    '
  
    Set c = .Add(Nothing, c_Items)
    With c
      .PropertyType = cspGrid
      .LeftLabel = -1
      If Not pLoadItems(c) Then Exit Function
      .Name = c_Items
      .Key = K_ITEMS
      .TabIndex = c_tab_familiares
      .GridAdd = True
      .GridEdit = True
      .GridRemove = True
    End With
  
    m_ItemsDeletedItems = vbNullString
  
    '/////////////////////////////////////////////////////////////////////////////////////
    '
    ' Construccion
    '
    '
    With .Add(Nothing, cscEmLibreta)
      .PropertyType = cspText
      .Name = LNGGetText(4536, vbNullString) 'Libreta
      .Size = 20
      .Key = K_LIBRETA
      .Value = m_Libreta
      .TabIndex = c_tab_construccion
      .Left = 2100
      .LeftLabel = -1900
    End With
  
    With .Add(Nothing, cscEmTipoLiquidacion)
      .PropertyType = cspList
      .Name = LNGGetText(4537, vbNullString) 'Tipo de Liquidación
      .Key = K_TIPOLIQUIDACION
      .ListWhoSetItem = csListItemData
      With .List
        With .Add(Nothing)
          .Id = csETL_Jornalizado
          .Value = LNGGetText(4509, vbNullString) 'Jornalizado
        End With
        With .Add(Nothing)
          .Id = csETL_Mensualizado
          .Value = LNGGetText(4510, vbNullString) 'Mensualizado
        End With
      End With
      
      .ListItemData = m_TipoLiquidacion
      .TabIndex = c_tab_construccion
      .LeftLabel = -1900
    End With
    
    With .Add(Nothing, cscEmFdoDesempleo)
      .PropertyType = cspText
      .Name = LNGGetText(4539, vbNullString) 'Fdo. Desempleo
      .Size = 20
      .Key = K_FDODESEMPLEO
      .Value = m_FdoDesempleo
      .TabIndex = c_tab_construccion
    End With
  
    '/////////////////////////////////////////////////////////////////////////////////////
    '
    ' Familiares
    '
    '
  
    Set c = .Add(Nothing, c_CentroCosto)
    With c
      .PropertyType = cspGrid
      .LeftLabel = -1
      If Not pLoadCentroCosto(c) Then Exit Function
      .Name = c_CentroCosto
      .Key = K_CENTRO_COSTO
      .TabIndex = c_tab_centrocosto
      .GridAdd = True
      .GridEdit = True
      .GridRemove = True
    End With
  
    m_ItemsDeletedCcos = vbNullString
  
  End With
  
  If Not m_ObjAbm.Show(Me) Then Exit Function
  
  LoadCollection = True
End Function

Private Function Load(ByVal Id As Long) As Boolean

  Dim sqlstmt As String
  Dim rs      As Recordset
  
  sqlstmt = "sp_EmpleadoGet " & Id

  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, C_LoadFunction, C_Module) Then Exit Function

  If Not rs.EOF Then

    m_Id = gDB.ValField(rs.fields, cscEmId)
    m_Apellido = gDB.ValField(rs.fields, cscEmApellido)
    m_Nombre = gDB.ValField(rs.fields, cscEmNombre)
    m_Codigo = gDB.ValField(rs.fields, cscEmCodigo)
    m_descrip = gDB.ValField(rs.fields, cscEmDescrip)
    m_Activo = gDB.ValField(rs.fields, cscActivo)

    m_Legajo = gDB.ValField(rs.fields, cscEmLegajo)
    m_Ingreso = gDB.ValField(rs.fields, cscEmIngreso)
    m_Egreso = gDB.ValField(rs.fields, cscEmEgreso)
    m_Cuil = gDB.ValField(rs.fields, cscEmCuil)
    m_Dni = gDB.ValField(rs.fields, cscEmDni)
    m_Fechanacimiento = gDB.ValField(rs.fields, cscEmFechanacimiento)
    m_Codpostal = gDB.ValField(rs.fields, cscEmCodpostal)
    m_Localidad = gDB.ValField(rs.fields, cscEmLocalidad)
    m_Calle = gDB.ValField(rs.fields, cscEmCalle)
    m_Callenumero = gDB.ValField(rs.fields, cscEmCallenumero)
    m_Piso = gDB.ValField(rs.fields, cscEmPiso)
    m_Depto = gDB.ValField(rs.fields, cscEmDepto)
    m_Tel = gDB.ValField(rs.fields, cscEmTel)
    m_Libreta = gDB.ValField(rs.fields, cscEmLibreta)
    m_TipoLiquidacion = gDB.ValField(rs.fields, cscEmTipoLiquidacion)
    m_CtaBanco = gDB.ValField(rs.fields, cscEmCtaBanco)
    m_FdoDesempleo = gDB.ValField(rs.fields, cscEmFdoDesempleo)
    m_ObraSocial = gDB.ValField(rs.fields, cscEmObraSocial)
    m_Banelco = gDB.ValField(rs.fields, cscEmBanelco)
    m_Preocupacional = gDB.ValField(rs.fields, cscEmPreocupacional)
    m_LugarNacimiento = gDB.ValField(rs.fields, cscEmLugarNacimiento)
    m_descrip = gDB.ValField(rs.fields, cscEmDescrip)
    m_Email = gDB.ValField(rs.fields, cscEmEmail)
    
    m_Estc_id = gDB.ValField(rs.fields, cscEstcId)
    m_sind_id = gDB.ValField(rs.fields, cscSindId)
    m_Sindco_id = gDB.ValField(rs.fields, cscSindcoId)
    m_Sindca_id = gDB.ValField(rs.fields, cscSindcaId)
    m_Ema_id = gDB.ValField(rs.fields, cscEmaId)
    m_Eme_id = gDB.ValField(rs.fields, cscEmeId)
    m_pro_id = gDB.ValField(rs.fields, cscProId)
    m_pa_id = gDB.ValField(rs.fields, cscPaId)

    m_EstadoCivil = gDB.ValField(rs.fields, cscEstcNombre)
    m_Sindicato = gDB.ValField(rs.fields, cscSindNombre)
    m_SindicatoConvenio = gDB.ValField(rs.fields, cscSindcoNombre)
    m_SindicatoCategoria = gDB.ValField(rs.fields, cscSindcaNombre)
    m_ART = gDB.ValField(rs.fields, cscEmaNombre)
    m_Especialidad = gDB.ValField(rs.fields, cscEmeNombre)
    m_provincia = gDB.ValField(rs.fields, cscProNombre)
    m_pais = gDB.ValField(rs.fields, cscPaNombre)
    
  Else
    m_Id = csNO_ID
    m_Apellido = vbNullString
    m_Nombre = vbNullString
    m_Codigo = vbNullString
    m_descrip = vbNullString
    m_Activo = True

    m_Legajo = vbNullString
    m_Ingreso = csNoDate
    m_Egreso = csNoDate
    m_Cuil = vbNullString
    m_Dni = vbNullString
    m_Fechanacimiento = csNoDate
    m_Codpostal = vbNullString
    m_Localidad = vbNullString
    m_Calle = vbNullString
    m_Callenumero = vbNullString
    m_Piso = vbNullString
    m_Depto = vbNullString
    m_Tel = vbNullString
    m_Libreta = vbNullString
    m_TipoLiquidacion = False
    m_CtaBanco = vbNullString
    m_FdoDesempleo = vbNullString
    m_ObraSocial = vbNullString
    m_Banelco = False
    m_Preocupacional = False
    m_LugarNacimiento = vbNullString
    m_descrip = vbNullString
    m_Email = vbNullString
    
    m_Estc_id = csNO_ID
    m_sind_id = csNO_ID
    m_Sindco_id = csNO_ID
    m_Sindca_id = csNO_ID
    m_Ema_id = csNO_ID
    m_Eme_id = csNO_ID
    m_pro_id = csNO_ID
    m_pa_id = csNO_ID
    
    m_EstadoCivil = vbNullString
    m_Sindicato = vbNullString
    m_SindicatoConvenio = vbNullString
    m_SindicatoCategoria = vbNullString
    m_ART = vbNullString
    m_Especialidad = vbNullString
    m_provincia = vbNullString
    m_pais = vbNullString
  
  End If

  Load = True
End Function

Private Sub Class_Initialize()
  On Error GoTo ControlError
  
  c_ErrorSave = LNGGetText(4522, vbNullString) 'Error al grabar el empleado

  GoTo ExitProc
ControlError:
  MngError Err, "Class_Initialize", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

' construccion - destruccion
Private Sub Class_Terminate()
  On Error Resume Next
  Set m_ObjAbm = Nothing
  Set m_ObjTree = Nothing
End Sub


'------------------------------------------------------------------
'------------------------------------------------------------------
Private Function cIABMClientGrid_ColumnAfterEdit(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long, ByVal NewValue As Variant, ByVal NewValueID As Long) As Boolean
  cIABMClientGrid_ColumnAfterEdit = True
End Function

Private Function cIABMClientGrid_ColumnBeforeEdit(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long, ByVal iKeyAscii As Integer) As Boolean
  cIABMClientGrid_ColumnBeforeEdit = True
End Function

Private Function cIABMClientGrid_ColumnButtonClick(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long, ByVal iKeyAscii As Integer) As Boolean

End Function

Private Sub cIABMClientGrid_ColumnCancelEdit(ByVal Key As Integer)

End Sub

Private Function cIABMClientGrid_DeleteRow(ByVal Key As Integer, Row As CSInterfacesABM.cIABMGridRow, ByVal lRow As Long) As Boolean
  Dim Id As Long
  
  Select Case Key
    Case K_ITEMS
  
      Id = Val(pCell(Row, KI_EMF_ID).Value)
      
      If Id <> csNO_ID Then m_ItemsDeletedItems = m_ItemsDeletedItems & Id & C_StrColon
  
    Case K_CENTRO_COSTO
    
      Id = Val(pCell(Row, KI_EMCCOS_ID).Value)
      
      If Id <> csNO_ID Then m_ItemsDeletedCcos = m_ItemsDeletedCcos & Id & C_StrColon
    
  End Select
  
  cIABMClientGrid_DeleteRow = True
End Function

Private Function cIABMClientGrid_ListAdHock(ByVal Key As Integer, Row As CSInterfacesABM.cIABMGridRow, ByVal ColIndex As Long, List As CSInterfacesABM.cIABMList) As Boolean

End Function

Private Sub cIABMClientGrid_NewRow(ByVal Key As Integer, ByVal Rows As Integer)

End Sub

Private Sub cIABMClientGrid_ColumnClick(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long)

End Sub

Private Sub cIABMClientGrid_DblClick(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long)

End Sub

Private Function cIABMClientGrid_ValidateRow(ByVal Key As Integer, Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  On Error GoTo ControlError

  Select Case Key
    Case K_ITEMS
      cIABMClientGrid_ValidateRow = pValidateRowItems(Row, RowIndex)
    Case K_CENTRO_COSTO
      cIABMClientGrid_ValidateRow = pValidateRowCentroCosto(Row, RowIndex)
  End Select
  
  GoTo ExitProc
ControlError:
  MngError Err, C_ValidateRow, C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Private Function cIABMClientGrid_ColumnAfterUpdate(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long) As Boolean

End Function

Private Function cIABMClientGrid_IsEmptyRow(ByVal Key As Integer, Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  On Error GoTo ControlError

  Select Case Key
    Case K_ITEMS
      cIABMClientGrid_IsEmptyRow = pIsEmptyRowItems(Row, RowIndex)
    Case K_CENTRO_COSTO
      cIABMClientGrid_IsEmptyRow = pIsEmptyRowCentroCosto(Row, RowIndex)
      
  End Select
  
  GoTo ExitProc
ControlError:
  MngError Err, C_IsEmptyRow, C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Private Function pIsEmptyRowCentroCosto(ByRef Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  Dim Cell                  As cIABMGridCellValue
  Dim bRowIsEmpty           As Boolean
  
  bRowIsEmpty = True
  
  For Each Cell In Row
    Select Case Cell.Key
      Case KI_CCOS_ID
        If Not ValEmpty(Cell.Id, csId) Then
          bRowIsEmpty = False
          Exit For
        End If
    
      Case KI_DESDE
        If Not ValEmpty(Cell.Value, csDate) Then
          bRowIsEmpty = False
          Exit For
        End If
    
      Case KI_HASTA
        If Not ValEmpty(Cell.Value, csDate) Then
          bRowIsEmpty = False
          Exit For
        End If
    End Select
  Next
  
  pIsEmptyRowCentroCosto = bRowIsEmpty
End Function

Private Function pIsEmptyRowItems(ByRef Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  Dim Cell                  As cIABMGridCellValue
  Dim bRowIsEmpty           As Boolean
  
  bRowIsEmpty = True
  
  For Each Cell In Row
    Select Case Cell.Key
      Case KI_APELLIDO
        If Not ValEmpty(Cell.Value, csText) Then
          bRowIsEmpty = False
          Exit For
        End If
      Case KI_FECHA_NAC
        If Not ValEmpty(Cell.Value, csDate) Then
          bRowIsEmpty = False
          Exit For
        End If
      Case KI_DNI
        If Not ValEmpty(Cell.Value, csText) Then
          bRowIsEmpty = False
          Exit For
        End If
      Case KI_NOMBRE
        If Not ValEmpty(Cell.Value, csText) Then
          bRowIsEmpty = False
          Exit For
        End If
    End Select
  Next
  
  pIsEmptyRowItems = bRowIsEmpty
End Function

Private Function pValidateRowCentroCosto(Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  Dim Cell                  As cIABMGridCellValue
  Dim strRow                As String
  
  strRow = " (Fila " & RowIndex & ")"
  
  For Each Cell In Row
    Select Case Cell.Key
        Case KI_CCOS_ID
          If ValEmpty(Cell.Id, csId) Then
            MsgInfo LNGGetText(4603, vbNullString) 'Debe indicar un centro de costo
            Exit Function
          End If
    
        Case KI_DESDE
          If ValEmpty(Cell.Value, csDate) Then
            MsgInfo LNGGetText(2393, vbNullString) 'Debe indicar una fecha desde
            Exit Function
          End If
    
        Case KI_HASTA
          If ValEmpty(Cell.Value, csDate) Then
            MsgInfo LNGGetText(2394, vbNullString) 'Debe indicar una fecha hasta
            Exit Function
          End If
    End Select
  Next
  
  pValidateRowCentroCosto = True
  
End Function

Private Function pValidateRowItems(Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  Dim Cell                  As cIABMGridCellValue
  Dim strRow                As String
  
  strRow = " (Fila " & RowIndex & ")"
  
  For Each Cell In Row
    Select Case Cell.Key
        Case KI_NOMBRE
          If ValEmpty(Cell.Value, csText) Then
            MsgInfo LNGGetText(4643, vbNullString) ' Debe indicar un nombre para el familiar
            Exit Function
          End If
        Case KI_DNI
          If ValEmpty(Cell.Value, csText) Then
            MsgInfo LNGGetText(4642, vbNullString) ' Debe indicar un DNI para el familiar
            Exit Function
          End If
        Case KI_APELLIDO
          If ValEmpty(Cell.Value, csText) Then
            MsgInfo LNGGetText(4644, vbNullString, strRow) ' Debe indicar un apellido para el familiar
            Exit Function
          End If
        Case KI_FECHA_NAC
          If ValEmpty(Cell.Value, csText) Then
            MsgInfo LNGGetText(4645, vbNullString) ' Debe indicar la fecha de nacimiento para el familiar
            Exit Function
          End If
        Case KI_EMFT_ID
          If ValEmpty(Cell.Id, csId) Then
            MsgInfo LNGGetText(4646, vbNullString) ' Debe indicar el tipo de relacion con el familiar
            Exit Function
          End If
    End Select
  Next
  
  pValidateRowItems = True
  
End Function

Private Function pLoadItems(ByRef Propiedad As cIABMProperty) As Boolean
  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  
  sqlstmt = "select emf.*,emft_nombre from EmpleadoFamilia emf left join EmpleadoFamiliaTipo emft on emf.emft_id = emft.emft_id where emf.em_id = " & m_Id
  
  If Not gDB.OpenRs(sqlstmt, _
                    rs, _
                    csRsStatic, _
                    csLockReadOnly, _
                    csCmdText, _
                    "pLoadItems", _
                    C_Module) Then Exit Function
  
  With Propiedad.Grid
    
    With .Columns
      
      .Clear
      
      With .Add(Nothing)
        .Visible = False
        .Key = KI_EMF_ID
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(1273, vbNullString) ' Apellido
        .PropertyType = cspText
        .Width = 2500
        .Key = KI_APELLIDO
      End With
                  
      With .Add(Nothing)
        .Name = C_strNombre
        .PropertyType = cspText
        .Width = 2500
        .Key = KI_NOMBRE
      End With
                  
      With .Add(Nothing)
        .Name = LNGGetText(4534, vbNullString) ' DNI
        .PropertyType = cspText
        .Width = 2500
        .Key = KI_DNI
      End With
                  
      With .Add(Nothing)
        .Name = LNGGetText(4647, vbNullString) ' Fecha Nacimiento
        .PropertyType = cspDate
        .Width = 2500
        .Key = KI_FECHA_NAC
      End With
                  
      With .Add(Nothing)
        .Name = LNGGetText(4648, vbNullString) ' Relación Familiar
        .PropertyType = cspHelp
        .Table = csEmpleadoFamiliaTipo
        .Width = 2500
        .Key = KI_EMFT_ID
      End With
                  
      With .Add(Nothing)
        .Name = C_strDescrip
        .PropertyType = cspText
        .SubType = cspTextButtonEx
        .Width = 3000
        .Key = KI_DESCRIP
      End With
      
    End With
    
    With .Rows
      
      .Clear
      
      While Not rs.EOF
      
        With .Add(Nothing, rs(cscEmfId).Value)
        
          With .Add(Nothing)
            .Value = rs(cscEmfId).Value
            .Key = KI_EMF_ID
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscEmfApellido)
            .Key = KI_APELLIDO
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscEmfNombre)
            .Key = KI_NOMBRE
          End With
                                     
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscEmfDni)
            .Key = KI_DNI
          End With
                                     
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscEmfFechanacimiento)
            .Key = KI_FECHA_NAC
          End With
                                     
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscEmftNombre)
            .Id = gDB.ValField(rs.fields, cscEmftId)
            .Key = KI_EMFT_ID
          End With
                                     
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscEmfDescrip)
            .Key = KI_DESCRIP
          End With
                                     
         End With
         
        rs.MoveNext
      Wend
    
    End With
    
  End With
  
  pLoadItems = True

End Function

Private Function pLoadCentroCosto(ByRef Propiedad As cIABMProperty) As Boolean
  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  
  sqlstmt = "select e.*,ccos_nombre " & _
            "from EmpleadoCentroCosto e " & _
                "inner join CentroCosto ccos on e.ccos_id = ccos.ccos_id " & _
            "where e.em_id = " & m_Id
  
  If Not gDB.OpenRs(sqlstmt, _
                    rs, _
                    csRsStatic, _
                    csLockReadOnly, _
                    csCmdText, _
                    "pLoadCentroCosto", _
                    C_Module) Then Exit Function
  
  With Propiedad.Grid
    
    With .Columns
      
      .Clear
      
      With .Add(Nothing)
        .Visible = False
        .Key = KI_EMCCOS_ID
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(1057, vbNullString) 'Centro de Costo
        .PropertyType = cspHelp
        .Table = csCentroCosto
        .Width = 2500
        .Key = KI_CCOS_ID
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(2532, vbNullString) 'Desde
        .PropertyType = cspDate
        .Width = 1500
        .Key = KI_DESDE
      End With
            
      With .Add(Nothing)
        .Name = LNGGetText(2533, vbNullString) 'Hasta
        .PropertyType = cspDate
        .Width = 1500
        .Key = KI_HASTA
      End With
      
    End With
    
    With .Rows
      
      .Clear
      
      While Not rs.EOF
      
        With .Add(Nothing, rs(cscEmCcosId).Value)
        
          With .Add(Nothing)
            .Value = rs(cscEmCcosId).Value
            .Key = KI_EMCCOS_ID
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscCcosNombre)
            .Id = gDB.ValField(rs.fields, cscCcosId)
            .Key = KI_CCOS_ID
          End With
                   
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscEmCcosDesde)
            .Key = KI_DESDE
          End With
                  
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscEmCcosHasta)
            .Key = KI_HASTA
          End With
                  
         End With
         
        rs.MoveNext
      Wend
    
    End With
    
  End With
  
  pLoadCentroCosto = True

End Function

Private Function pSaveItems() As Boolean
  Dim register As cRegister
  Dim Row  As cIABMGridRow
  Dim Cell As cIABMGridCellValue
  
  With m_ObjAbm.Properties.Item(c_Items).Grid
          
    For Each Row In .Rows
    
      Set register = New cRegister
      With register
        .fieldId = cscEmfId
        .Table = csTEmpleadoFamilia
        .Id = csNew
        
        For Each Cell In Row
          Select Case Cell.Key
            
            Case KI_EMF_ID
              If Not m_Copy Then
                .Id = Val(Cell.Value)
              End If
  
            Case KI_APELLIDO
              .fields.Add2 cscEmfApellido, Cell.Value, csText
            Case KI_NOMBRE
              .fields.Add2 cscEmfNombre, Cell.Value, csText
            Case KI_DNI
              .fields.Add2 cscEmfDni, Cell.Value, csText
            Case KI_FECHA_NAC
              .fields.Add2 cscEmfFechanacimiento, Cell.Value, csDate
            Case KI_EMFT_ID
              .fields.Add2 cscEmftId, Cell.Id, csId
            Case KI_DESCRIP
              .fields.Add2 cscEmfDescrip, Cell.Value, csText
          End Select
        Next
        
        .fields.Add2 cscEmId, m_Id, csId
        
        .fields.HaveLastUpdate = False
        .fields.HaveWhoModify = False
      End With
      
      If Not gDB.Save(register, , C_pSaveItemsFunc, C_Module, c_ErrorSave) Then Exit Function
    Next
  End With
  
  Dim sqlstmt As String
  
  If LenB(m_ItemsDeletedItems) And Not m_Copy Then
    m_ItemsDeletedItems = RemoveLastColon(m_ItemsDeletedItems)
    sqlstmt = "delete EmpleadoFamilia where emf_id in (" & m_ItemsDeletedItems & ")"
  
    If Not gDB.Execute(sqlstmt, C_pSaveItemsFunc, C_Module) Then Exit Function
  End If
  
  pSaveItems = True
End Function

Private Function pSaveCentroCosto() As Boolean
  Dim register As cRegister
  Dim Row  As cIABMGridRow
  Dim Cell As cIABMGridCellValue
  
  With m_ObjAbm.Properties.Item(c_CentroCosto).Grid
          
    For Each Row In .Rows
    
      Set register = New cRegister
      With register
        .fieldId = cscEmCcosId
        .Table = csTEmpleadoCentroCosto
        .Id = csNew
        
        For Each Cell In Row
          Select Case Cell.Key
            
            Case KI_EMCCOS_ID
              If Not m_Copy Then
                .Id = Val(Cell.Value)
              End If
  
            Case KI_DESDE
              .fields.Add2 cscEmCcosDesde, Cell.Value, csDate
            Case KI_HASTA
              .fields.Add2 cscEmCcosHasta, Cell.Value, csDate
            Case KI_CCOS_ID
              .fields.Add2 cscCcosId, Cell.Id, csId
          End Select
        Next
        
        .fields.Add2 cscEmId, m_Id, csId
        
        .fields.HaveLastUpdate = False
        .fields.HaveWhoModify = False
      End With
      
      If Not gDB.Save(register, , "pSaveCentroCosto", C_Module, c_ErrorSave) Then Exit Function
    Next
  End With
  
  Dim sqlstmt As String
  
  If LenB(m_ItemsDeletedCcos) And Not m_Copy Then
    m_ItemsDeletedCcos = RemoveLastColon(m_ItemsDeletedCcos)
    sqlstmt = "delete EmpleadoCentroCosto where emccos_id in (" & m_ItemsDeletedCcos & ")"
  
    If Not gDB.Execute(sqlstmt, "pSaveCentroCosto", C_Module) Then Exit Function
  End If
  
  pSaveCentroCosto = True
End Function

