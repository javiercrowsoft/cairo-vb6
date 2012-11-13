VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cRespuestaPlantilla"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements CSInterfacesABM.cIEditGeneric
Implements CSInterfacesABM.cIABMClient
Implements CSMenu.cIMenuClient
'--------------------------------------------------------------------------------
' cRespuestaPlantilla
' 16-11-09

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cRespuestaPlantilla"

Private Const K_NOMBRE                         As Integer = 1
Private Const K_CODIGO                         As Integer = 2
Private Const K_TEXTO                          As Integer = 3
Private Const K_DESCRIP                        As Integer = 4
Private Const K_FROM                           As Integer = 5
Private Const K_SUBJECT                        As Integer = 6
Private Const K_CMIA_ID                        As Integer = 7
Private Const K_CMI_ID                         As Integer = 8
Private Const K_IDM_ID                         As Integer = 9
Private Const K_PR_ID                          As Integer = 10
Private Const K_RUB_ID                         As Integer = 11
Private Const K_MARC_ID                        As Integer = 12
Private Const K_ACTIVO                         As Integer = 13

' estructuras
' Seudo - Variables
Private c_ErrorSave                    As String

' variables privadas
Private m_Id                           As Long
Private m_Nombre                       As String
Private m_Codigo                       As String
Private m_Texto                        As String
Private m_Descrip                      As String
Private m_From                         As String
Private m_Subject                      As String
Private m_Cmia_id                      As Long
Private m_Aplicacion                   As String
Private m_Cmi_id                       As Long
Private m_ComunidadInternet            As String
Private m_Idm_id                       As Long
Private m_Idioma                       As String
Private m_Pr_id                        As Long
Private m_Producto                     As String
Private m_Rub_id                       As Long
Private m_Rubro                        As String
Private m_Marc_id                      As Long
Private m_Marca                        As String
Private m_Creado                       As Date
Private m_Modificado                   As Date
Private m_Modifico                     As Long
Private m_Activo                       As Boolean



'OJO HASTA ACA

Private m_Editing           As Boolean

Private m_ObjAbm            As cIABMGeneric
Private m_ObjTree           As Object

Private m_IsNew             As Boolean

Private m_BranchId          As Long
Private m_TreeId            As Long
Private m_Copy              As Boolean

Private m_Host As CSMenu.cIMenuHost

Private m_WasChanged        As Boolean

' Properties publicas

Public Property Get id() As Long
  id = m_Id
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

  Doc.ClientTable = csTComunidadInternetRespuestaPlantilla
  Doc.ClientTableID = m_Id

  cIABMClient_ShowDocDigital = Doc.ShowDocs(gDB)

  GoTo ExitProc
ControlError:
  MngError Err, "cIABMClient_ShowDocDigital", C_Module, vbNullString
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Private Function cIABMClient_EditNew() As Boolean
  
  cIABMClient_Terminate
  m_IsNew = True
  
  cIEditGeneric_Edit csNO_ID
End Function

Private Function cIABMClient_MessageEx(ByVal MessageID As Long, ByVal Info As Variant) As Variant
  cIABMClient_MessageEx = True
End Function

Private Sub cIABMClient_DiscardChanges()
  LoadCollection
End Sub

Private Function cIABMClient_Copy() As Boolean
  
  cIABMClient_Terminate
  m_IsNew = True
  
  With m_ObjAbm.Properties(cscCmirpCodigo)
    .Value = C_C & .Value
  End With
  
  With m_ObjAbm.Properties(cscCmirpNombre)
    .Value = C_CopiaDe & .Value
  End With
  
  m_ObjAbm.ShowValue m_ObjAbm.Properties(cscCmirpCodigo)
  m_ObjAbm.ShowValue m_ObjAbm.Properties(cscCmirpNombre)
  
  m_Copy = True
End Function

Private Function cIABMClient_ListAdHock(List As CSInterfacesABM.cIABMList) As Boolean

End Function

Private Sub cIABMClient_Load()

End Sub

Private Function cIABMClient_PropertyChange(ByVal Key As Integer) As Boolean

End Function

Private Function cIABMClient_Save() As Boolean
  Dim register As cRegister
  Dim fields   As cFields
  Dim LastId   As Long
  
  Set register = New cRegister
  
  With register
    Set fields = .fields
    .fieldId = cscCmirpId
    .Table = csTComunidadInternetRespuestaPlantilla
  
    If m_Copy Then
      .id = csNew
    Else
      .id = m_Id
    End If
  End With
  
  Dim IProperty As cIABMProperty
  
  For Each IProperty In m_ObjAbm.Properties
    With IProperty
      Select Case .Key
        Case K_NOMBRE
          register.fields.Add2 cscCmirpNombre, .Value, csText
        Case K_CODIGO
          register.fields.Add2 cscCmirpCodigo, .Value, csText
        Case K_TEXTO
          register.fields.Add2 cscCmirpTexto, .Value, csText
        Case K_DESCRIP
          register.fields.Add2 cscCmirpDescrip, .Value, csText
        Case K_FROM
          register.fields.Add2 cscCmirpFrom, .Value, csText
        Case K_SUBJECT
          register.fields.Add2 cscCmirpSubject, .Value, csText
        Case K_CMIA_ID
          register.fields.Add2 cscCmiaId, .HelpId, csId
        Case K_CMI_ID
          register.fields.Add2 cscCmiId, .HelpId, csId
        Case K_IDM_ID
          register.fields.Add2 cscIdmId, .HelpId, csId
        Case K_PR_ID
          register.fields.Add2 cscPrId, .HelpId, csId
        Case K_RUB_ID
          register.fields.Add2 cscRubId, .HelpId, csId
        Case K_MARC_ID
          register.fields.Add2 cscMarcId, .HelpId, csId
        Case K_ACTIVO
          register.fields.Add2 cscActivo, .Value, csBoolean
      End Select
    End With
  Next
  
  fields.HaveLastUpdate = True
  fields.HaveWhoModify = True
    
  If Not gDB.SaveEx(register, , _
                    cscCmirpCodigo, _
                    C_ABMClientSave, _
                    C_Module, _
                    c_ErrorSave) Then Exit Function
  
  m_Copy = False
  
  cIABMClient_Save = Load(register.id)

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
    cIABMClient_Title = LNGGetText(5002, vbNullString)
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

Private Function cIEditGeneric_TabClick(ByVal Index As Integer) As Boolean

End Function

Private Property Let cIEditGeneric_TreeId(ByVal rhs As Long)
    m_TreeId = rhs
End Property

Private Property Get cIEditGeneric_TreeId() As Long
    cIEditGeneric_TreeId = m_TreeId
End Property

Private Function cIEditGeneric_GridAdd(ByVal KeyProperty As Integer) As Boolean

End Function

Private Function cIEditGeneric_GridEdit(ByVal KeyProperty As Integer) As Boolean

End Function

Private Function cIEditGeneric_GridRemove(ByVal KeyProperty As Integer) As Boolean

End Function

Private Function cIEditGeneric_ShowList() As Boolean
    cIEditGeneric_ShowList = SecurityCanAccess(csPreCVXIListRespuestaPlantilla)
End Function

Private Property Get cIEditGeneric_ObjAbm() As CSInterfacesABM.cIABMGeneric
  Set cIEditGeneric_ObjAbm = m_ObjAbm
End Property

Private Property Set cIEditGeneric_ObjAbm(rhs As CSInterfacesABM.cIABMGeneric)
    Set m_ObjAbm = rhs
End Property

Private Property Get cIEditGeneric_Editing() As Boolean
    cIEditGeneric_Editing = m_Editing
End Property

Private Function cIEditGeneric_Delete(id As Long) As Boolean
    If Not SecurityCanAccess(csPreCVXIDeleteRespuestaPlantilla) Then Exit Function

    Dim sqlstmt As String
    
    sqlstmt = "delete ComunidadInternetRespustaPlantilla where cmirp_id = " & id
    
    cIEditGeneric_Delete = gDB.Execute(sqlstmt, "cIEditGeneric_Delete", C_Module)
End Function

Private Function cIEditGeneric_Search(id As Long, Cancela As Boolean) As Boolean

End Function

Private Function cIEditGeneric_Edit(id As Long, Optional ByVal InModalWindow As Boolean) As Boolean
  On Error GoTo ControlError
  
  If id = csNO_ID Then
      m_IsNew = True
      If Not SecurityCanAccess(csPreCVXINewRespuestaPlantilla) Then Exit Function
  Else
      m_IsNew = False
      If Not SecurityCanAccess(csPreCVXIEditRespuestaPlantilla) Then Exit Function
  End If

  m_ObjAbm.InModalWindow = InModalWindow

  If Not Load(id) Then Exit Function
  
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

Private Function cIEditGeneric_PrintObj(ByVal id As Long) As Boolean

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

Private Function cIEditGeneric_Preview(ByVal id As Long) As Boolean

End Function

Private Function cIEditGeneric_PropertyChange(ByVal Key As Integer) As Boolean

End Function


Private Function cIMenuClient_Initialize(F As Object, Host As CSMenu.cIMenuHost) As Boolean
  On Error GoTo ControlError

  Dim str_4999 As String

  str_4999 = LNGGetText(4999, vbNullString)

  Set m_Host = Host
  m_Host.Server.AddMenu str_4999, csMenuConfig, C_MenuConfig, 0, True, False, True, False, True, Nothing
  m_Host.Server.AddMenu LNGGetText(5000, vbNullString), csPreCVXIListRespuestaPlantilla, str_4999, 0, True, False, False, False, False, Me

  cIMenuClient_Initialize = True

  GoTo ExitProc
ControlError:
  MngError Err, "cIMenuClient_Initialize", C_Module, vbNullString
  If Err.Number <> 0 Then Resume ExitProc

ExitProc:
  On Error Resume Next
End Function

Private Function cIMenuClient_ProcessMenu(ByVal id As Long) As Variant
  m_Host.MenuABMClick "CSCVXI.cRespuestaPlantilla", Me, LNGGetText(5002, vbNullString), 0, csETablesCVXI.csComunidadInternetRespuestaPlantilla
End Function

' funciones privadas

Private Function LoadCollection() As Boolean
        
  Dim abmgen As cABMGeneric
  Set abmgen = m_ObjAbm
  abmgen.MinHeight = 10700
        
  With m_ObjAbm.Properties
    
    .Clear

    With .Add(Nothing, cscCmirpNombre)
      .PropertyType = cspText
      .Name = C_strNombre
      .Size = 100
      .Key = K_NOMBRE
      .Value = m_Nombre
      .Width = 6500
    End With
  
    With .Add(Nothing, cscCmirpCodigo)
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
      .TopFromProperty = cscCmirpCodigo
      .Left = 5500
      .LeftNotChange = True
    End With
      
    With .Add(Nothing, cscCmiId)
      .PropertyType = cspHelp
      .Table = csComunidadInternet
      .Name = LNGGetText(5004, vbNullString) ' Comunidad Internet
      .Key = K_CMI_ID
      .Value = m_ComunidadInternet
      .HelpId = m_Cmi_id
    End With
      
    With .Add(Nothing, cscCmiaId)
      .PropertyType = cspHelp
      .Table = csComunidadInternetAplicacion
      .Name = LNGGetText(5005, vbNullString) ' Aplicación
      .Key = K_CMIA_ID
      .Value = m_Aplicacion
      .HelpId = m_Cmia_id
    End With
      
    With .Add(Nothing, cscIdmId)
      .PropertyType = cspHelp
      .Table = csIdioma
      .Name = LNGGetText(1239, vbNullString) ' Idioma
      .Key = K_IDM_ID
      .Value = m_Idioma
      .HelpId = m_Idm_id
    End With
      
    With .Add(Nothing, cscMarcId)
      .PropertyType = cspHelp
      .Table = csMarca
      .Name = LNGGetText(1310, vbNullString) ' Marca
      .Key = K_MARC_ID
      .Value = m_Marca
      .HelpId = m_Marc_id
      .TopFromProperty = cscCmiId
      .Left = 5500
    End With
      
    With .Add(Nothing, cscRubId)
      .PropertyType = cspHelp
      .Table = csRubro
      .Name = LNGGetText(1299, vbNullString) ' Rubro
      .Key = K_RUB_ID
      .Value = m_Rubro
      .HelpId = m_Rub_id
    End With
      
    With .Add(Nothing, cscPrId)
      .PropertyType = cspHelp
      .Table = csProductoVenta
      .Name = LNGGetText(1619, vbNullString) ' Producto
      .Key = K_PR_ID
      .Value = m_Producto
      .HelpId = m_Pr_id
    End With
            
    With .Add(Nothing, cscCmirpFrom)
      .PropertyType = cspText
      .Name = LNGGetText(5006, vbNullString) ' Cuenta de envio
      .Key = K_FROM
      .Value = m_From
      .Width = 6500
      .LeftFromProperty = cscCmirpNombre
    End With
            
    With .Add(Nothing, cscCmirpSubject)
      .PropertyType = cspText
      .Name = LNGGetText(5007, vbNullString) ' Asunto
      .Key = K_SUBJECT
      .Value = m_Subject
      .Width = 6500
      .LeftFromProperty = cscCmirpNombre
    End With
            
    With .Add(Nothing, cscCmirpDescrip)
      .PropertyType = cspText
      .SubType = cspMemo
      .Name = C_strDescrip
      .Size = 255
      .Width = 6500
      .Height = 880
      .Key = K_DESCRIP
      .Value = m_Descrip
      .LeftFromProperty = cscCmirpNombre
    End With
                  
    With .Add(Nothing, cscCmirpTexto)
      .PropertyType = cspText
      .SubType = cspMemo
      .Name = LNGGetText(5003, vbNullString) 'Texto
      .Size = 5000
      .Width = 11500
      .Height = 4000
      .Key = K_TEXTO
      .Value = m_Texto
      .FontSize = 14
      .FontName = "Verdana"
    End With
                  
  End With
    
  If Not m_ObjAbm.Show(Me) Then Exit Function
  
  LoadCollection = True
End Function

Private Function Load(ByVal id As Long) As Boolean
  Dim sqlstmt As String
  Dim rs As Recordset
  
  sqlstmt = "sp_ComunidadInternetRespuestaPlantillaGet " & id

  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, "Load", C_Module) Then Exit Function

  If Not rs.EOF Then

    m_Id = gDB.ValField(rs.fields, cscCmirpId)
    m_Nombre = gDB.ValField(rs.fields, cscCmirpNombre)
    m_Codigo = gDB.ValField(rs.fields, cscCmirpCodigo)
    m_Descrip = gDB.ValField(rs.fields, cscCmirpDescrip)
    m_Creado = gDB.ValField(rs.fields, cscCreado)
    m_Modificado = gDB.ValField(rs.fields, cscModificado)
    m_Modifico = gDB.ValField(rs.fields, cscModifico)
    m_Activo = gDB.ValField(rs.fields, cscActivo)
    m_From = gDB.ValField(rs.fields, cscCmirpFrom)
    m_Subject = gDB.ValField(rs.fields, cscCmirpSubject)
    
    m_Texto = gDB.ValField(rs.fields, cscCmirpTexto)
    m_Cmi_id = gDB.ValField(rs.fields, cscCmiId)
    m_ComunidadInternet = gDB.ValField(rs.fields, cscCmiNombre)
    m_Cmia_id = gDB.ValField(rs.fields, cscCmiaId)
    m_Aplicacion = gDB.ValField(rs.fields, cscCmiaNombre)
    m_Idm_id = gDB.ValField(rs.fields, cscIdmId)
    m_Idioma = gDB.ValField(rs.fields, cscIdmNombre)
    m_Pr_id = gDB.ValField(rs.fields, cscPrId)
    m_Producto = gDB.ValField(rs.fields, cscPrNombreVenta)
    m_Rub_id = gDB.ValField(rs.fields, cscRubId)
    m_Rubro = gDB.ValField(rs.fields, cscRubNombre)
    m_Marc_id = gDB.ValField(rs.fields, cscMarcId)
    m_Marca = gDB.ValField(rs.fields, cscMarcNombre)

  Else
  
    m_Id = csNO_ID
    m_Nombre = vbNullString
    m_Codigo = vbNullString
    m_Descrip = vbNullString
    m_From = vbNullString
    m_Subject = vbNullString
    m_Creado = csNoDate
    m_Modificado = csNoDate
    m_Modifico = 0
    m_Activo = True
  
    m_Texto = vbNullString
    m_Cmi_id = csNO_ID
    m_ComunidadInternet = vbNullString
    m_Cmia_id = csNO_ID
    m_Aplicacion = vbNullString
    m_Idm_id = csNO_ID
    m_Idioma = vbNullString
    m_Pr_id = csNO_ID
    m_Producto = vbNullString
    m_Rub_id = csNO_ID
    m_Rubro = vbNullString
    m_Marc_id = csNO_ID
    m_Marca = vbNullString
    
  End If

  Load = True
End Function

Private Sub Class_Initialize()
  On Error GoTo ControlError
  
  c_ErrorSave = LNGGetText(5001, vbNullString) 'Error al grabar la plantilla de respueta

  GoTo ExitProc
ControlError:
  MngError Err, "Class_Initialize", C_Module, vbNullString
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

' construccion - destruccion

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
'  If Err.Number <> 0 Then Resume ExitProc
'ExitProc:
'  On Error Resume Next

