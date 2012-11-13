VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cAlumno"
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
' cAlumno
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
Private Const C_Module = "cAlumno"

Private Const c_cursos = "curso"
Private Const c_partes = "partes"
Private Const c_foto = "foto"
Private Const c_foto_file = "foto_file"

Private Const csTblProyecto = 2005
Private Const csEstadoCivil = 35007

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
Private Const K_CLI_ID                         As Integer = 13
Private Const K_ACTIVO                         As Integer = 15
Private Const K_SUC_ID                         As Integer = 16
Private Const K_DPTO_ID                        As Integer = 20
Private Const K_PRSDT_ID                       As Integer = 21
Private Const K_DOCUMENTO                      As Integer = 22
Private Const K_WEB                            As Integer = 23

Private Const K_FECHA_INGRESO                  As Integer = 24
Private Const K_LEGAJO                         As Integer = 25

Private Const K_PROF_ID                        As Integer = 26
Private Const K_TIPO_CONTACTO                  As Integer = 27
Private Const K_REFERIDO                       As Integer = 28
Private Const K_PROY_ID                        As Integer = 29
Private Const K_ESPROSPECTO                    As Integer = 30

Private Const K_CODPOSTAL                      As Integer = 110
Private Const K_LOCALIDAD                      As Integer = 111
Private Const K_CALLE                          As Integer = 112
Private Const K_CALLENUMERO                    As Integer = 113
Private Const K_PISO                           As Integer = 114
Private Const K_DEPTO                          As Integer = 115
Private Const K_PRO_ID                         As Integer = 120

Private Const K_FOTO                           As Integer = 121
Private Const K_FOTO_FILE                      As Integer = 122

Private Const K_APELLIDOCASADO                 As Integer = 123
Private Const K_TITULO                         As Integer = 124
Private Const K_ICQ                            As Integer = 125
Private Const K_IDNEXTEL                       As Integer = 126
Private Const K_MESSENGER                      As Integer = 127
Private Const K_ANIVERSARIO                    As Integer = 128

Private Const K_ESTC_ID                        As Integer = 129
Private Const K_PA_ID                          As Integer = 130
Private Const K_NIVE_ID                        As Integer = 131
Private Const K_PROFE_ID                       As Integer = 132
Private Const K_SEXO                           As Integer = 133
Private Const K_CURSOS                         As Integer = 134
Private Const K_PARTES                         As Integer = 135
Private Const K_ADD_PARTE                      As Integer = 136

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
Private m_cli_id                       As Long
Private m_Cliente                      As String
Private m_Activo                       As Boolean
Private m_prsdt_id                     As Long
Private m_TipoDoc                      As String
Private m_Documento                    As String
Private m_Web                          As String
Private m_FechaIngreso                 As Date
Private m_Legajo                       As String

Private m_prof_id          As Long
Private m_Profesor         As String
Private m_EsProspecto      As Boolean
Private m_clict_id         As Long
Private m_ContactoTipo     As String
Private m_alum_id_referido As Long
Private m_Referido         As String
Private m_proy_id          As Long
Private m_Proyecto         As String

Private m_Codpostal        As String
Private m_Localidad        As String
Private m_Calle            As String
Private m_Callenumero      As String
Private m_Piso             As String
Private m_Depto            As String
Private m_pro_id           As Long
Private m_provincia        As String
Private m_pais             As String
Private m_pa_id            As Long

Private m_sexo             As csE_Sexo
Private m_ApellidoCasado   As String
Private m_EstadoCivil      As String
Private m_estc_id          As Long
Private m_NivelEstudio     As String
Private m_nive_id          As Long
Private m_titulo           As String
Private m_profesion        As String
Private m_profe_id         As Long
Private m_icq              As String
Private m_idnextel         As String
Private m_messenger        As String
Private m_aniversario      As String

' HOJO HASTA ACA

Private m_Editing           As Boolean

Private m_ObjAbm            As cIABMGeneric
Private m_ObjTree           As Object

Private m_IsNew             As Boolean

Private m_BranchId          As Long
Private m_TreeId            As Long

Private m_Host              As CSMenu.cIMenuHost
Private m_Copy              As Boolean

Private m_GenericEdit       As cGenericEdit

Private m_PartesDeleted     As String

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

  Doc.ClientTable = csTAlumno
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
  
    Case MSG_DOC_SEARCH
      
      pSearch
  
      cIABMClient_MessageEx = True
    
    Case MSG_ABM_PRINT
      
      If m_Id = csNO_ID Then
                ' "Debe grabar el alumno para poder imprimirlo"
        MsgInfo LNGGetText(4745, vbNullString), LNGGetText(1853, vbNullString)
              
      Else
        Dim AbmObj As cABMGeneric
        Set AbmObj = m_ObjAbm
        AbmObj.PrintABM m_Id, -csAlumno ' El menos es para que pase Id y no NODO Id en PrintManager
      End If
      
      cIABMClient_MessageEx = True
    
    Case MSG_ABM_CAN_PRINT
      
      cIABMClient_MessageEx = MSG_ABM_CAN_PRINT
    
    Case MSG_DOC_INFO
    
      Dim AbmGen As cABMGeneric
      Set AbmGen = m_ObjAbm
      
      CSKernelClient2.ShowHelp AbmGen.hWnd, _
                               vbNullString, _
                               vbNullString, _
                               csPreENewAlumno
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
  Dim iProp As cIABMProperty

  Select Case Key
    Case K_FOTO_FILE
      Set iProp = m_ObjAbm.Properties.Item(c_foto)
      Set iProp.Picture = pLoadPictureFromFile()
      m_ObjAbm.ShowValue iProp
      
    Case K_ADD_PARTE
      pAddMensaje
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
    .fieldId = cscAlumId
    .Table = csTAlumno
    
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
          fields.Add2 cscAlumDescrip, .Value, csText
        Case K_ACTIVO
          fields.Add2 cscActivo, .Value, csBoolean
        Case K_FECHA_INGRESO
          fields.Add2 cscAlumFechaingreso, .Value, csDate
        Case K_LEGAJO
          fields.Add2 cscAlumLegajo, .Value, csText
        Case K_FOTO_FILE
          File = .Value
        Case K_TIPO_CONTACTO
          fields.Add2 cscClictId, .HelpId, csId
        Case K_ESPROSPECTO
          fields.Add2 cscAlumEsProspecto, .Value, csBoolean
        Case K_REFERIDO
          fields.Add2 cscAlumIdReferido, .HelpId, csId
        Case K_PROY_ID
          fields.Add2 cscProyId, .HelpId, csId
        Case K_PROF_ID
          fields.Add2 cscProfId, .HelpId, csId
      End Select
    End With
  Next
  
  If Not m_GenericEdit.Save(m_ObjAbm, register) Then Exit Function
  
  fields.HaveLastUpdate = True
  fields.HaveWhoModify = True
  
  If Not register.BeginTrans(gDB) Then Exit Function
                    
  If Not pSavePersona(prs_id) Then Exit Function
  
  fields.Add2 cscPrsId, prs_id, csId
  fields.Add2 cscAlumCodigo, pGetCodigo(prs_id), csText

                    ' Error al grabar el alumno
  If Not gDB.SaveEx(register, , _
                    cscAlumCodigo, _
                    C_ABMClientSave, _
                    C_Module, _
                    LNGGetText(4679, vbNullString)) Then Exit Function
  
  register.CommitTrans
  
  m_Copy = False
  cIABMClient_Save = Load(register.Id)
  
  pDeletePartes
  
  ' Si da un error que vuelva a intentar
  '
  If LenB(File) Then
    pSaveFoto prs_id, File
  End If
  
  Dim bSaveCliente As Boolean
  
  If m_cli_id Then
    bSaveCliente = True
  Else
                      '¿Desea crear un cliente para este alumno?
    bSaveCliente = Ask(LNGGetText(4827, vbNullString), vbYes)
  End If
  
  If bSaveCliente Then
    pSaveCliente register.Id
  End If
  
End Function

Private Function pSaveCliente(ByVal alum_id As Long) As Boolean

  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  
  sqlstmt = "sp_AlumnoSaveCliente " & alum_id & "," & EmpId

  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Function
  If rs.EOF Then Exit Function
  
  m_cli_id = gDB.ValField(rs.fields, cscCliId)
  m_Cliente = gDB.ValField(rs.fields, cscCliNombre)

  pSaveCliente = True
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
        Case K_CLI_ID
          fields.Add2 cscCliId, .HelpId, csId
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
        
        Case K_APELLIDOCASADO
          fields.Add2 cscPrsApellido, .Value, csText
        Case K_TITULO
          fields.Add2 cscPrsTitulo, .Value, csText
        Case K_ICQ
          fields.Add2 cscPrsIcq, .Value, csText
        Case K_IDNEXTEL
          fields.Add2 cscPrsIdNextel, .Value, csText
        Case K_MESSENGER
          fields.Add2 cscPrsMessenger, .Value, csText
        Case K_ANIVERSARIO
          fields.Add2 cscPrsAniversario, .Value, csDate
        Case K_SEXO
          fields.Add2 cscPrsSexo, .ListItemData, csInteger
        Case K_ESTC_ID
          fields.Add2 cscEstcId, .HelpId, csId
        Case K_PA_ID
          fields.Add2 cscPaId, .HelpId, csId
        Case K_NIVE_ID
          fields.Add2 cscNiveId, .HelpId, csId
        Case K_PROFE_ID
          fields.Add2 cscProfeId, .HelpId, csId
      End Select
    End With
  Next
  
  fields.HaveLastUpdate = True
  fields.HaveWhoModify = True
                    
                    ' Error al grabar el alumno
  If Not gDB.SaveEx(register, , _
                    cscPrsCodigo, _
                    C_ABMClientSave, _
                    C_Module, _
                    LNGGetText(4679, vbNullString)) Then Exit Function
  
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
  
  m_ObjTree.sqlstmt = "sp_lsdoc_alumno"
  
  If m_IsNew Then
    m_ObjTree.AddLine m_Id
  Else
    m_ObjTree.RefreshLine m_Id
  End If
ControlError:
End Function

Private Property Get cIABMClient_Title() As String
                        'Alumnos
  cIABMClient_Title = LNGGetText(4680, vbNullString)
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

  If Not m_GenericEdit.Validate(m_ObjAbm) Then Exit Function

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
    cIEditGeneric_ShowList = SecurityCanAccess(csPreEListAlumno)
End Function

Private Property Set cIEditGeneric_ObjAbm(rhs As CSInterfacesABM.cIABMGeneric)
    Set m_ObjAbm = rhs
End Property

Private Property Get cIEditGeneric_Editing() As Boolean
    cIEditGeneric_Editing = m_Editing
End Property

Private Function cIEditGeneric_Delete(Id As Long) As Boolean
    If Not SecurityCanAccess(csPreEDeleteAlumno) Then Exit Function

    Dim sqlstmt As String
    
    sqlstmt = "sp_AlumnoDelete " & Id
    
    cIEditGeneric_Delete = gDB.Execute(sqlstmt, C_EditGenericDelete, C_Module)
End Function

Private Function cIEditGeneric_Search(Id As Long, Cancela As Boolean) As Boolean

End Function

Private Function cIEditGeneric_Edit(Id As Long, Optional ByVal InModalWindow As Boolean) As Boolean
  On Error GoTo ControlError
  
  If Id = csNO_ID Then
    m_IsNew = True
    If Not SecurityCanAccess(csPreENewAlumno) Then Exit Function
  Else
    m_IsNew = False
    If Not SecurityCanAccess(csPreEEditAlumno) Then Exit Function
  End If

  m_ObjAbm.InModalWindow = InModalWindow
  
  Set m_GenericEdit = New cGenericEdit
  If Not m_GenericEdit.Init(csAlumno) Then Exit Function
  
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

  Dim str_4690  As String
  
  str_4690 = LNGGetText(4690, vbNullString)  'Institutos &Educativos
  
  Set m_Host = Host

  m_Host.Server.AddMenu str_4690, csMenuEduMain, vbNullString, 1, False, False, False, True, False, Nothing
                         '&Alumnos
  m_Host.Server.AddMenu LNGGetText(4681, vbNullString), csPreEListAlumno, str_4690, 0, True, False, False, False, False, Me
  
  cIMenuClient_Initialize = True
  
  GoTo ExitProc
ControlError:
  MngError Err, C_MenuClientInit, C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Private Function cIMenuClient_ProcessMenu(ByVal Id As Long) As Variant
  m_Host.MenuListDocClick "CSABMInterface2.CABMGeneric", "CSEdu.cAlumno", "CSABMInterface2.CABMGenericListDoc", "CSEdu.cAlumnoListDoc", Me, LNGGetText(4680, vbNullString), 0
                                                                                                                                                        'Alumnos
End Function

' funciones privadas
Private Function LoadCollection() As Boolean
  
  Dim c As cIABMProperty
  Dim AbmObj As cABMGeneric
  Set AbmObj = m_ObjAbm
  
  AbmObj.MinHeight = 8000
  AbmObj.MinWidth = 11000
  
  Const c_tab_general = 0
  Const c_tab_personales = 1
  Const c_tab_empresa = 2
  Const c_tab_crm = 3
  Const c_tab_cursos = 4
  Const c_tab_partes = 5
  
  With m_ObjAbm.Tabs
    .Clear
    
      .Clear
    
      With .Add(Nothing)
        .Name = C_strGeneral
      End With
      
      With .Add(Nothing)
        .Index = c_tab_personales
        .Name = LNGGetText(4797, vbNullString) 'Personal - Contacto
      End With
      
      'With .Add(Nothing)
      '  .Index = c_tab_direccion
      '  .Name = LNGGetText(1037, vbNullString) 'Dirección
      'End With
      
      With .Add(Nothing)
        .Index = c_tab_empresa
        .Name = LNGGetText(1114, vbNullString) 'Empresa
      End With

      With .Add(Nothing)
        .Index = c_tab_crm
        .Name = LNGGetText(4660, vbNullString) 'CRM
      End With

      With .Add(Nothing)
        .Index = c_tab_cursos
        .Name = LNGGetText(4694, vbNullString) 'Cursos
      End With

      With .Add(Nothing)
        .Index = c_tab_partes
        .Name = LNGGetText(2348, vbNullString) 'Partes Diarios
      End With

  End With
  
  m_ObjAbm.Title2 = m_Apellido & ", " & m_Nombre & IIf(m_EsProspecto, " " & LNGGetText(4691, vbNullString), vbNullString) ' (prospecto)

  With m_ObjAbm.Properties
    
    .Clear
  
    With .Add(Nothing, cscPrsApellido)
      .PropertyType = cspText
      .Name = LNGGetText(1273, vbNullString)  'Apellido
      .Size = 100
      .Key = K_APELLIDO
      .Value = m_Apellido
      .Width = 4300
      .Left = 1000
      .LeftLabel = -700
    End With
      
    With .Add(Nothing, cscPrsNombre)
      .PropertyType = cspText
      .Name = C_strNombre
      .Size = 100
      .Key = K_NOMBRE
      .Value = m_Nombre
      .Width = 4300
      .TopFromProperty = cscPrsApellido
      .LeftNotChange = True
      .Left = 6400
      .LeftLabel = -800
    End With
      
    With .Add(Nothing, cscPrsCodigo)
      .PropertyType = cspText
      .Name = C_strCodigo
      .Size = 15
      .Key = K_CODIGO
      .Value = m_Codigo
      .Width = 800
    End With
            
    With .Add(Nothing, cscActivo)
      .PropertyType = cspCheck
      .Name = C_strActivo
      .Key = K_ACTIVO
      .Value = CInt(m_Activo)
      .TopFromProperty = cscPrsCodigo
      .LeftNotChange = True
      .Left = 2500
      .LeftLabel = -600
    End With
            
    With .Add(Nothing, cscProfId)
      .PropertyType = cspHelp
      .Table = csProfesor
      .Name = LNGGetText(4795, vbNullString) 'Profesor
      .Key = K_PROF_ID
      .Value = m_Profesor
      .HelpId = m_prof_id
      .HelpFilter = "prof.prs_id <> " & m_prs_id
      .TopFromProperty = cscPrsCodigo
      .LeftNotChange = True
      .Left = 3800
      .LeftLabel = -800
    End With
            
    With .Add(Nothing, cscAlumFechaingreso)
      .PropertyType = cspDate
      .Name = LNGGetText(4531, vbNullString)  'Ingreso
      .Key = K_FECHA_INGRESO
      .Value = m_FechaIngreso
      .TopFromProperty = cscPrsCodigo
      .LeftNotChange = True
      .Left = 6900
      .LeftLabel = -600
    End With
            
    With .Add(Nothing, cscPrsFechaNac)
      .PropertyType = cspDate
      .Name = LNGGetText(1280, vbNullString)  'Fecha Nac.
      .Key = K_FECHANAC
      .Value = m_FechaNac
      .TopFromProperty = cscPrsCodigo
      .LeftNotChange = True
      .Left = 9300
      .LeftLabel = -900
    End With
                        
'------------------------------------------------------------------

    With .Add(Nothing)
      .PropertyType = cspLabel
      .Width = 10500
      .Height = 10
      .BackColor = &HCCCCCC
      .Left = 300
    End With

    With .Add(Nothing)
      .PropertyType = cspLabel
      .FontBold = True
      .Value = LNGGetText(1037, vbNullString) 'Dirección
      .Left = 300
      .Width = 1000
      .TopFromProperty = cscPrsCodigo
      .TopToPrevious = 540
      .Height = 285
    End With

    With .Add(Nothing, cscPrsCalle)
      .PropertyType = cspText
      .Name = LNGGetText(1194, vbNullString) 'Calle
      '.TabIndex = c_tab_direccion
      .Key = K_CALLE
      .Value = m_Calle
      .Width = 8100
      .Left = 2000
      .TopToPrevious = 300
    End With
    
    With .Add(Nothing, cscPrsCallenumero)
      .PropertyType = cspText
      .Name = LNGGetText(1065, vbNullString) 'Numero
      '.TabIndex = c_tab_direccion
      .Size = 10
      .Key = K_CALLENUMERO
      .Value = m_Callenumero
      .Width = 1200
    End With
    
    With .Add(Nothing, cscPrsPiso)
      .PropertyType = cspText
      .Name = LNGGetText(1196, vbNullString) 'Piso
      '.TabIndex = c_tab_direccion
      .Size = 4
      .Key = K_PISO
      .Value = m_Piso
      .Width = 1200
    End With
    
    With .Add(Nothing, cscPrsDepto)
      .PropertyType = cspText
      .Name = LNGGetText(1278, vbNullString) 'Departamento
      '.TabIndex = c_tab_direccion
      .Size = 4
      .Key = K_DEPTO
      .Value = m_Depto
      .Width = 1200
    End With
    
    With .Add(Nothing, cscPrsCodpostal)
      .PropertyType = cspText
      .Name = LNGGetText(1199, vbNullString) 'Codigo Postal
      '.TabIndex = c_tab_direccion
      .Size = 20
      .Key = K_CODPOSTAL
      .Value = m_Codpostal
      .Width = 1200
    End With
    
    With .Add(Nothing, cscPrsLocalidad)
      .PropertyType = cspText
      .Name = LNGGetText(1198, vbNullString) 'Localidad
      '.TabIndex = c_tab_direccion
      .Size = 100
      .Key = K_LOCALIDAD
      .Value = m_Localidad
      .Width = 5000
    End With
    
    With .Add(Nothing, cscProId)
      .PropertyType = cspHelp
      .Table = csProvincia
      .Name = LNGGetText(1080, vbNullString) 'Provincia
      '.TabIndex = c_tab_direccion
      .Key = K_PRO_ID
      .Value = m_provincia
      .HelpId = m_pro_id
      .Width = 5000
    End With
      
    With .Add(Nothing, cscPaId)
      .PropertyType = cspHelp
      .Table = csPais
      .Name = LNGGetText(1212, vbNullString) 'Pais
      '.TabIndex = c_tab_direccion
      .Key = K_PA_ID
      .Value = m_pais
      .HelpId = m_pa_id
      .Width = 5000
    End With
      
    With .Add(Nothing, cscPrsTelTrab)
      .PropertyType = cspText
      .TopFromProperty = cscPrsCalle
      .Left = 4800
      .Name = LNGGetText(1274, vbNullString)  'Tel. Trabajo
      .Size = 50
      .Key = K_TELTRAB
      .Value = m_TelTrab
      .TopToPrevious = 440
      '.TabIndex = c_tab_direccion
    End With
          
    With .Add(Nothing, cscPrsCelular)
      .PropertyType = cspText
      .Name = LNGGetText(1276, vbNullString)  'Celular
      .Size = 50
      .Key = K_CELULAR
      .Value = m_Celular
      '.TabIndex = c_tab_direccion
    End With
      
    With .Add(Nothing, cscPrsEmail)
      .PropertyType = cspText
      .Name = LNGGetText(1034, vbNullString)  'Mail
      .Size = 50
      .Key = K_EMAIL
      .Value = m_Email
      '.TabIndex = c_tab_direccion
    End With
      
    With .Add(Nothing, cscPrsTelCasa)
      .PropertyType = cspText
      .Name = LNGGetText(1277, vbNullString)  'Tel. Casa
      .Size = 50
      .Key = K_TELCASA
      .Value = m_TelCasa
      '.TabIndex = c_tab_direccion
    End With
          
    With .Add(Nothing, cscPrsWeb)
      .PropertyType = cspText
      .Name = LNGGetText(1038, vbNullString)  'Web
      .Key = K_WEB
      .Value = m_Web
      .TopFromProperty = cscPrsTelTrab
      .Left = 7830
      .LeftLabel = -500
      '.TabIndex = c_tab_direccion
    End With

    With .Add(Nothing, cscAlumDescrip)
      .PropertyType = cspText
      .LeftFromProperty = cscPrsCalle
      .Name = C_strDescrip
      .SubType = cspMemo
      .Height = 660
      .Width = 8100
      .Size = 255
      .Key = K_DESCRIP
      .Value = m_descrip
      .TopFromProperty = cscPaId
      .TopToPrevious = 440
    End With

'------------------------------------------------------------------
    
    ' Personales - Contacto
    
    With .Add(Nothing, cscPrsSexo)
      .PropertyType = cspList
      .ListWhoSetItem = csListItemData
      With .List
        With .Add(Nothing)
          .Id = csE_Sexo.csSexoFemenino
          .Value = LNGGetText(4799, vbNullString)
        End With
        With .Add(Nothing)
          .Id = csE_Sexo.csSexoMasculino
          .Value = LNGGetText(4800, vbNullString)
        End With
        With .Add(Nothing)
          .Id = csE_Sexo.csSexoSinDefinir
          .Value = LNGGetText(4801, vbNullString)
        End With
      End With
      .Name = LNGGetText(4798, vbNullString) 'Sexo
      .Key = K_SEXO
      .ListItemData = m_sexo
      .TabIndex = c_tab_personales
      .Left = 1600
    End With
  
    With .Add(Nothing, cscPrsApellidoCasado)
      .PropertyType = cspText
      .Name = LNGGetText(4802, vbNullString)
      .Size = 255
      .Key = K_APELLIDOCASADO
      .Value = m_ApellidoCasado
      .TabIndex = c_tab_personales
      .Width = 4000
    End With
    
    With .Add(Nothing, cscEstcId)
      .PropertyType = cspHelp
      .Table = csEstadoCivil
      .Name = LNGGetText(4544, vbNullString)
      .Key = K_ESTC_ID
      .Value = m_EstadoCivil
      .HelpId = m_estc_id
      .TabIndex = c_tab_personales
    End With
    
    With .Add(Nothing, cscNiveId)
      .PropertyType = cspHelp
      .Table = csNivelEstudio
      .Name = LNGGetText(4803, vbNullString)
      .Key = K_NIVE_ID
      .Value = m_NivelEstudio
      .HelpId = m_nive_id
      .TabIndex = c_tab_personales
      .Width = 4000
    End With
    
    With .Add(Nothing, cscPrsTitulo)
      .PropertyType = cspText
      .Name = LNGGetText(4804, vbNullString)
      .Size = 255
      .Key = K_TITULO
      .Value = m_titulo
      .TabIndex = c_tab_personales
      .Width = 4000
    End With
    
    With .Add(Nothing, cscProfeId)
      .PropertyType = cspHelp
      .Table = csProfesion
      .Name = LNGGetText(4805, vbNullString)
      .Key = K_PROFE_ID
      .Value = m_profesion
      .HelpId = m_profe_id
      .TabIndex = c_tab_personales
      .Width = 4000
    End With
    
    With .Add(Nothing, cscPrsIcq)
      .PropertyType = cspText
      .Name = LNGGetText(4806, vbNullString)
      .Size = 255
      .Key = K_ICQ
      .Value = m_icq
      .TabIndex = c_tab_personales
      .Width = 4000
    End With
    
    With .Add(Nothing, cscPrsIdNextel)
      .PropertyType = cspText
      .Name = LNGGetText(4807, vbNullString)
      .Key = K_IDNEXTEL
      .Value = m_idnextel
      .TabIndex = c_tab_personales
      .Width = 4000
    End With
    
    With .Add(Nothing, cscPrsMessenger)
      .PropertyType = cspText
      .Name = LNGGetText(4808, vbNullString)
      .Size = 255
      .Key = K_MESSENGER
      .Value = m_messenger
      .TabIndex = c_tab_personales
      .Width = 4000
    End With
    
    With .Add(Nothing, cscPrsAniversario)
      .PropertyType = cspDate
      .Name = LNGGetText(4809, vbNullString)
      .Key = K_ANIVERSARIO
      .Value = m_aniversario
      .TabIndex = c_tab_personales
    End With
        
    With .Add(Nothing, cscPrsdtId)
      .PropertyType = cspHelp
      .Table = csPersonaDocumentoTipo
      .Name = LNGGetText(1063, vbNullString)  'Tipo Doc.
      .Key = K_PRSDT_ID
      .Value = m_TipoDoc
      .HelpId = m_prsdt_id
      .TabIndex = c_tab_personales
    End With
    
    With .Add(Nothing, cscPrsDocumento)
      .PropertyType = cspText
      .Name = LNGGetText(1567, vbNullString)  'Documento
      .Key = K_DOCUMENTO
      .Value = m_Documento
      .TabIndex = c_tab_personales
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
      .TabIndex = c_tab_personales
    End With
    
    With .Add(Nothing, c_foto)
      .PropertyType = cspImage
      .Name = LNGGetText(4674, vbNullString) 'Foto
      .Key = K_FOTO
      .TopFromProperty = cscPrsCodigo
      .Left = 6550
      .LeftLabel = -700
      .LeftNotChange = True
      .TopNotChange = True
      Set .Picture = pGetFoto
      .TabIndex = c_tab_personales
    End With
        
    ' Direccion
            
    ' Empresa
            
    With .Add(Nothing, cscDptoId)
      .PropertyType = cspHelp
      .Table = csDepartamento
      .Name = LNGGetText(1278, vbNullString)  'Departamento
      .Key = K_DPTO_ID
      .Value = m_Departamento
      .HelpId = m_Dpto_id
      .TabIndex = c_tab_empresa
      .Left = 1500
    End With
      
    With .Add(Nothing, cscPrsCargo)
      .PropertyType = cspText
      .Name = LNGGetText(1279, vbNullString)  'Cargo
      .Size = 100
      .Key = K_CARGO
      .Value = m_Cargo
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
        
    With .Add(Nothing, cscCliId)
      .PropertyType = cspHelp
      .Table = csCliente
      .Name = LNGGetText(1150, vbNullString)  'Cliente
      .Key = K_CLI_ID
      .Value = m_Cliente
      .HelpId = m_cli_id
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
      
    With .Add(Nothing, cscAlumLegajo)
      .PropertyType = cspText
      .Name = LNGGetText(1575, vbNullString)  'Legajo
      .Key = K_LEGAJO
      .Value = m_Legajo
      .TabIndex = c_tab_empresa
    End With
  
    ' CRM
    
    With .Add(Nothing, cscClictId)
      .PropertyType = cspHelp
      .Table = csClienteContactoTipo
      .Name = LNGGetText(4661, vbNullString) 'Tipo de Contacto
      .Key = K_TIPO_CONTACTO
      .Value = m_ContactoTipo
      .HelpId = m_clict_id
      .TabIndex = c_tab_crm
      .Width = 3000
      .LeftLabel = -1500
      .Left = 1800
    End With
  
    With .Add(Nothing, cscAlumIdReferido)
      .PropertyType = cspHelp
      .Table = csAlumno
      .Name = LNGGetText(4662, vbNullString) 'Referido por
      .Key = K_REFERIDO
      .Value = m_Referido
      .HelpId = m_alum_id_referido
      .HelpFilter = "alum_id <> " & m_Id
      .TabIndex = c_tab_crm
      .Width = 3000
    End With
  
    With .Add(Nothing, cscProyId)
      .PropertyType = cspHelp
      .Table = csTblProyecto
      .Name = LNGGetText(4663, vbNullString) 'Campaña de Marketing
      .Key = K_PROY_ID
      .Value = m_Proyecto
      .HelpId = m_proy_id
      .TabIndex = c_tab_crm
      .Width = 3000
    End With
  
    With .Add(Nothing, cscAlumEsProspecto)
      .PropertyType = cspCheck
      .Name = LNGGetText(3952, vbNullString) ' Es un prospecto
      .Key = K_ESPROSPECTO
      .Value = CInt(m_EsProspecto)
      .TabIndex = c_tab_crm
    End With
  
    Set c = .Add(Nothing, c_cursos)
    With c
      .PropertyType = cspGrid
      .Name = "Cursos"
      .Key = K_CURSOS
      If Not pLoadCursos(c) Then Exit Function
      .TabIndex = c_tab_cursos
      .GridAdd = False
      .GridEdit = False
      .GridRemove = False
      .LeftLabel = -1
    End With
  
    With .Add(Nothing)
      .PropertyType = cspButton
      .Name = LNGGetText(1615, vbNullString) ' Agregar Nota
      .Key = K_ADD_PARTE
      .TabIndex = c_tab_partes
      .LeftLabel = -1
      .Left = 200
      .Enabled = m_Id <> csNO_ID
      .LeftNotChange = True
    End With
  
    Set c = .Add(Nothing, c_partes)
    With c
      .PropertyType = cspGrid
      .Name = "Partes"
      .Key = K_PARTES
      If Not pLoadPartes(c) Then Exit Function
      .TabIndex = c_tab_partes
      .GridAdd = False
      .GridEdit = True
      .GridRemove = True
      .LeftLabel = -1
      .Top = 1500
      .Left = 200
      .LeftNotChange = True
    End With
  
    m_PartesDeleted = vbNullString
  
  End With
  
  If Not m_GenericEdit.LoadCollection(m_ObjAbm) Then Exit Function
  
  If Not m_ObjAbm.Show(Me) Then Exit Function
  
  LoadCollection = True
End Function

Private Function Load(ByVal Id As Long) As Boolean
  
  Dim sqlstmt As String
  Dim rs      As Recordset

  sqlstmt = "sp_AlumnoGet " & Id

  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, C_LoadFunction, C_Module) Then Exit Function

  If Not rs.EOF Then

    m_Id = gDB.ValField(rs.fields, cscAlumId)
  
    m_Legajo = gDB.ValField(rs.fields, cscAlumLegajo)
    m_FechaIngreso = gDB.ValField(rs.fields, cscAlumFechaingreso)
    m_descrip = gDB.ValField(rs.fields, cscAlumDescrip)
    
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
    m_cli_id = gDB.ValField(rs.fields, cscCliId)
    m_Cliente = gDB.ValField(rs.fields, cscCliNombre)
    
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

    m_clict_id = gDB.ValField(rs.fields, cscClictId)
    m_ContactoTipo = gDB.ValField(rs.fields, cscClictNombre)
    
    m_alum_id_referido = gDB.ValField(rs.fields, cscAlumIdReferido)
    m_Referido = gDB.ValField(rs.fields, "Referido")
    m_proy_id = gDB.ValField(rs.fields, cscProyId)
    m_Proyecto = gDB.ValField(rs.fields, cscProyNombre)
    m_EsProspecto = gDB.ValField(rs.fields, cscAlumEsProspecto)
    
    m_prof_id = gDB.ValField(rs.fields, cscProfId)
    m_Profesor = gDB.ValField(rs.fields, cscProfNombre)
    
    m_sexo = gDB.ValField(rs.fields, cscPrsSexo)
    m_ApellidoCasado = gDB.ValField(rs.fields, cscPrsApellido)
    m_EstadoCivil = gDB.ValField(rs.fields, cscEstcNombre)
    m_estc_id = gDB.ValField(rs.fields, cscEstcId)
    m_NivelEstudio = gDB.ValField(rs.fields, cscNiveNombre)
    m_nive_id = gDB.ValField(rs.fields, cscNiveId)
    m_titulo = gDB.ValField(rs.fields, cscPrsTitulo)
    m_profesion = gDB.ValField(rs.fields, cscProfeNombre)
    m_profe_id = gDB.ValField(rs.fields, cscProfeId)
    m_icq = gDB.ValField(rs.fields, cscPrsIcq)
    m_idnextel = gDB.ValField(rs.fields, cscPrsIdNextel)
    m_messenger = gDB.ValField(rs.fields, cscPrsMessenger)
    m_aniversario = gDB.ValField(rs.fields, cscPrsAniversario)
    
    m_pa_id = gDB.ValField(rs.fields, cscPaId)
    m_pais = gDB.ValField(rs.fields, cscPaNombre)
    
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
    m_cli_id = csNO_ID
    m_Cliente = vbNullString
    
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

    m_alum_id_referido = csNO_ID
    m_Referido = vbNullString
    m_proy_id = csNO_ID
    m_Proyecto = vbNullString
    m_EsProspecto = False

    m_prof_id = csNO_ID
    m_Profesor = vbNullString

    m_sexo = csE_Sexo.csSexoSinDefinir
    m_ApellidoCasado = vbNullString
    m_EstadoCivil = vbNullString
    m_estc_id = csNO_ID
    m_NivelEstudio = vbNullString
    m_nive_id = csNO_ID
    m_titulo = vbNullString
    m_profesion = vbNullString
    m_profe_id = csNO_ID
    m_icq = vbNullString
    m_idnextel = vbNullString
    m_messenger = vbNullString
    m_aniversario = vbNullString
    
    m_pais = vbNullString
    m_pa_id = csNO_ID

  End If
  
  If Not m_GenericEdit.Load(m_Id) Then Exit Function

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

Private Function pSearch() As Long
  Dim Help As CSOAPI2.cHelp
  Dim hr As cHelpResult
  
  Set Help = New CSOAPI2.cHelp
  
  Help.IsSearch = True
  
  Set hr = Help.Show(Nothing, csAlumno, "", "", "", , , , , True)
  
  If hr.Cancel Then Exit Function
  
  pSearch = hr.Id
  
  If hr.Id Then
    cIEditGeneric_Edit hr.Id
  End If
End Function

'-------------------------------------------------------------------------------------
' Implementacion de cIABMClientGrid
Private Function cIABMClientGrid_ColumnAfterEdit(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long, ByVal NewValue As Variant, ByVal NewValueID As Long) As Boolean

End Function

Private Function cIABMClientGrid_ColumnAfterUpdate(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long) As Boolean

End Function

Private Function cIABMClientGrid_ColumnBeforeEdit(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long, ByVal iKeyAscii As Integer) As Boolean

End Function

Private Function cIABMClientGrid_ColumnButtonClick(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long, ByVal iKeyAscii As Integer) As Boolean

End Function

Private Sub cIABMClientGrid_ColumnCancelEdit(ByVal Key As Integer)

End Sub

Private Sub cIABMClientGrid_ColumnClick(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long)

End Sub

Private Sub cIABMClientGrid_DblClick(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long)

  Select Case Key
    
    Case K_PARTES
    
      Dim ptd_id As Long
      Dim Parte  As Object
      Dim iEdit  As cIEditGeneric
      
      With m_ObjAbm.Properties.Item(c_partes).Grid
        ptd_id = Val(.Rows(lRow).Item(2).Value)
      End With
      
      Set Parte = CSKernelClient2.CreateObject("CSEnvio2.cParteDiario")
      Set iEdit = Parte
      Set iEdit.ObjABM = CSKernelClient2.CreateObject("CSABMInterface2.cABMGeneric")
      
      iEdit.Edit ptd_id, True
      
  End Select
End Sub

Private Function cIABMClientGrid_DeleteRow(ByVal Key As Integer, Row As CSInterfacesABM.cIABMGridRow, ByVal lRow As Long) As Boolean
  Dim Id As Long
  
  Select Case Key
    Case K_PARTES
      Id = Val(Row.Item(2).Value)
      If Id <> csNO_ID Then m_PartesDeleted = m_PartesDeleted & Id & C_StrColon
      cIABMClientGrid_DeleteRow = True
  End Select
End Function

Private Function cIABMClientGrid_IsEmptyRow(ByVal Key As Integer, Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean

End Function

Private Function cIABMClientGrid_ListAdHock(ByVal Key As Integer, Row As CSInterfacesABM.cIABMGridRow, ByVal ColIndex As Long, List As CSInterfacesABM.cIABMList) As Boolean

End Function

Private Sub cIABMClientGrid_NewRow(ByVal Key As Integer, ByVal Rows As Integer)

End Sub

Private Function cIABMClientGrid_ValidateRow(ByVal Key As Integer, Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  cIABMClientGrid_ValidateRow = True
End Function

Private Function pLoadPartes(ByRef Propiedad As cIABMProperty) As Boolean

  Dim sqlstmt       As String
  Dim rs            As ADODB.Recordset
  Dim Field         As ADODB.Field
  
  Dim DoctId  As Long
  
  DoctId = 37004
  
  sqlstmt = "sp_PartesDiarioGetForDoc " & gDB.UserId & "," & EmpId & "," & DoctId & "," & m_Id
  
  If Not gDB.OpenRs(sqlstmt, _
                    rs, _
                    csRsStatic, _
                    csLockReadOnly, _
                    csCmdText, _
                    "pLoadCursos", _
                    C_Module) Then Exit Function
  
  With Propiedad.Grid
    
    With .Columns
      
      .Clear
      
      For Each Field In rs.fields
        With .Add(Nothing)
          .Name = Field.Name
          .Visible = InStr(1, Field.Name, "_id") = 0
          If .Visible Then
            .Visible = InStr(1, Field.Name, "TypeTask") = 0
          End If
        End With
      Next
      
    End With
    
    With .Rows
      
      .Clear
      
      While Not rs.EOF
        
        With .Add(Nothing)
        
          For Each Field In rs.fields
            
            With .Add(Nothing)
              If IsNull(Field.Value) Then
                .Value = vbNullString
              Else
                .Value = Field.Value
              End If
              
            End With
          Next
        
        End With
         
        rs.MoveNext
      Wend
    
    End With
    
  End With
  
  pLoadPartes = True

End Function

Private Function pLoadCursos(ByRef Propiedad As cIABMProperty) As Boolean

  Dim sqlstmt       As String
  Dim rs            As ADODB.Recordset
  Dim Field         As ADODB.Field
  
  sqlstmt = "sp_AlumnoGetCursos " & m_Id
  
  If Not gDB.OpenRs(sqlstmt, _
                    rs, _
                    csRsStatic, _
                    csLockReadOnly, _
                    csCmdText, _
                    "pLoadCursos", _
                    C_Module) Then Exit Function
  
  With Propiedad.Grid
    
    With .Columns
      
      .Clear
      
      For Each Field In rs.fields
        With .Add(Nothing)
          .Name = Field.Name
          .Visible = InStr(1, Field.Name, "_id") = 0
        End With
      Next
      
    End With
    
    With .Rows
      
      .Clear
      
      While Not rs.EOF
        
        With .Add(Nothing)
        
          For Each Field In rs.fields
            
            With .Add(Nothing)
              If IsNull(Field.Value) Then
                .Value = vbNullString
              Else
                .Value = Field.Value
              End If
              
            End With
          Next
        
        End With
         
        rs.MoveNext
      Wend
    
    End With
    
  End With
  
  pLoadCursos = True

End Function

Private Sub pAddMensaje()
  Dim Parte As Object
  Set Parte = CSKernelClient2.CreateObject("CSEnvio2.cParteDiario")
  
  Parte.AddParteToDoc csAlumno, m_Id, False
End Sub

Private Sub pDeletePartes()
  Dim sqlstmt As String
  
  If Len(m_PartesDeleted) > 0 Then
  
    m_PartesDeleted = RemoveLastColon(m_PartesDeleted)
  
    sqlstmt = "delete ParteDiario where ptd_id in (" & m_PartesDeleted & ") and modifico = " & gDB.UserId
    If Not gDB.Execute(sqlstmt) Then Exit Sub
    
  End If
End Sub
