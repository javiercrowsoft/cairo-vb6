VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cChofer"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements CSInterfacesABM.cIEditGeneric
Implements CSInterfacesABM.cIABMClient
Implements CSMenu.cIMenuClient

'--------------------------------------------------------------------------------
' cChofer
' 21-06-03

'--------------------------------------------------------------------------------
' notas:
'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cChofer"

Private Const K_NOMBRE                         As Integer = 1
Private Const K_CODIGO                         As Integer = 2
Private Const K_DESCRIP                        As Integer = 3
Private Const K_TIPODNI                        As Integer = 4
Private Const K_DNI                            As Integer = 5
Private Const K_FECHADENACIMIENTO              As Integer = 6
Private Const K_DIRECCION                      As Integer = 7
Private Const K_TELEFONO                       As Integer = 8
Private Const K_TRANS_ID                       As Integer = 9
Private Const K_ACTIVO                         As Integer = 10
Private Const K_CAM_ID                         As Integer = 11

Public Enum csChofTipoDoc
  csChofTdDni = 1
  csChofTdCi = 2
  csChofTdPass = 3
  csChofTdLE = 4
  csChofTdLC = 5
  csChofTdOtro = 6
End Enum
' estructuras
' variables privadas
Private m_Id                           As Long
Private m_Nombre                       As String
Private m_Codigo                       As String
Private m_descrip                      As String
Private m_Tipodni                      As csChofTipoDoc
Private m_Dni                          As Long
Private m_Fechadenacimiento            As Date
Private m_direccion                    As String
Private m_telefono                     As String
Private m_Activo                       As Boolean
Private m_trans_id                     As Long
Private m_Transporte                   As String
Private m_cam_id                       As Long
Private m_Camion                       As String
'OJO HASTA ACA

Private m_Editing           As Boolean

Private m_ObjAbm            As cIABMGeneric
Private m_ObjTree           As Object

Private m_IsNew             As Boolean

Private m_BranchId          As Long
Private m_TreeId            As Long
Private m_Host              As CSMenu.cIMenuHost
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
  
  With m_ObjAbm.Properties(cscChofCodigo)
    .Value = C_C & .Value
  End With
  
'  With m_ObjAbm.Properties(cscChofNombre)
'    .Value = C_CopiaDe & .Value
'  End With
  
  m_ObjAbm.ShowValue m_ObjAbm.Properties(cscChofCodigo)
  m_ObjAbm.ShowValue m_ObjAbm.Properties(cscChofNombre)
  
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

  Doc.ClientTable = csTChofer
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
                               csPreGNewChofer
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
  Dim register   As cRegister
  Dim fields     As cFields
  
  Set register = New cRegister
  Set fields = register.fields
  
  With register
    .fieldId = cscChofId
    .Table = csTChofer
  
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
          fields.Add2 cscChofNombre, .Value, csText
        Case K_CODIGO
          fields.Add2 cscChofCodigo, .Value, csText
        Case K_DESCRIP
          fields.Add2 cscChofDescrip, .Value, csText
        Case K_TIPODNI
          fields.Add2 cscChofTipodni, .ListItemData, csText
        Case K_DNI
          fields.Add2 cscChofDni, .Value, csLong
        Case K_FECHADENACIMIENTO
          fields.Add2 cscChofFechadenacimiento, .Value, csDate
        Case K_DIRECCION
          fields.Add2 cscChofDireccion, .Value, csText
        Case K_TELEFONO
          fields.Add2 cscChofTelefono, .Value, csText
        Case K_ACTIVO
          fields.Add2 cscActivo, .Value, csBoolean
        Case K_TRANS_ID
          fields.Add2 cscTransId, .HelpId, csId
        Case K_CAM_ID
          fields.Add2 cscCamId, .HelpId, csId
      End Select
    End With
  Next
  
  fields.HaveLastUpdate = True
  fields.HaveWhoModify = True
  
  If Not gDB.SaveEx(register, , _
                    cscChofCodigo, _
                    C_ABMClientSave, _
                    C_Module, _
                    LNGGetText(1060, vbNullString)) Then Exit Function
  
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
  cIABMClient_Title = LNGGetText(1061, vbNullString)  'Choferes
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
    cIEditGeneric_ShowList = SecurityCanAccess(csPreGListChofer)
End Function

Private Property Set cIEditGeneric_ObjAbm(rhs As CSInterfacesABM.cIABMGeneric)
    Set m_ObjAbm = rhs
End Property

Private Property Get cIEditGeneric_Editing() As Boolean
    cIEditGeneric_Editing = m_Editing
End Property

Private Function cIEditGeneric_Delete(Id As Long) As Boolean
    If Not SecurityCanAccess(csPreGDeleteChofer) Then Exit Function

    Dim sqlstmt As String
    
    sqlstmt = "delete chofer where chof_id = " & Id
    
    cIEditGeneric_Delete = gDB.Execute(sqlstmt, C_EditGenericDelete, C_Module)
End Function

Private Function cIEditGeneric_Search(Id As Long, Cancela As Boolean) As Boolean

End Function

Private Function cIEditGeneric_Edit(Id As Long, Optional ByVal InModalWindow As Boolean) As Boolean
  On Error GoTo ControlError
  
  If Id = csNO_ID Then
    m_IsNew = True
    If Not SecurityCanAccess(csPreGNewChofer) Then Exit Function
  Else
    m_IsNew = False
    If Not SecurityCanAccess(csPreGEditChofer) Then Exit Function
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
  
  m_Host.Server.AddMenu C_MenuStock, csMenuConfigStock, C_MenuConfig, 0, True, False, False, False, True, Nothing
  m_Host.Server.AddMenu LNGGetText(1062, vbNullString), csPreGListChofer, C_MenuStock, 0, True, False, False, False, False, Me
  cIMenuClient_Initialize = True

  GoTo ExitProc
ControlError:
  MngError Err, C_MenuClientInit, C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function
 
Private Function cIMenuClient_ProcessMenu(ByVal Id As Long) As Variant
  m_Host.MenuABMClick "CSGeneral2.cChofer", Me, LNGGetText(1061, vbNullString), 0, csETablasGeneral.csChofer
End Function

' funciones privadas
Private Function LoadCollection() As Boolean
  Dim c As cIABMProperty
  
  m_ObjAbm.Title2 = m_Nombre

  With m_ObjAbm.Properties
  
    .Clear
  
    With .Add(Nothing, cscChofNombre)
      .PropertyType = cspText
      .Name = C_strNombre
      .Size = 50
      .Key = K_NOMBRE
      .Value = m_Nombre
      .Width = 7500
    End With
      
    With .Add(Nothing, cscChofCodigo)
      .PropertyType = cspText
      .Name = C_strCodigo
      .Size = 50
      .Key = K_CODIGO
      .Value = m_Codigo
      .Width = 1400
    End With
      
    With .Add(Nothing, cscActivo)
      .PropertyType = cspCheck
      .Name = C_strActivo
      .Key = K_ACTIVO
      .Value = CInt(m_Activo)
      .TopFromProperty = cscChofCodigo
      .TopNotChange = True
      .Left = 3700
      .LeftLabel = -600
      .LeftNotChange = True
    End With
      
    With .Add(Nothing, cscTransId)
      .PropertyType = cspHelp
      .Table = csTransporte
      .Name = LNGGetText(1050, vbNullString) 'Transporte
      .Key = K_TRANS_ID
      .Value = m_Transporte
      .HelpId = m_trans_id
    End With
    
    With .Add(Nothing, cscCamId)
      .PropertyType = cspHelp
      .Table = csCamion
      .Name = LNGGetText(3489, vbNullString) 'Camion
      .Key = K_CAM_ID
      .Value = m_Camion
      .HelpId = m_cam_id
    End With
    
    With .Add(Nothing, cscChofDireccion)
      .PropertyType = cspText
      .Name = LNGGetText(1037, vbNullString)   'Dirección
      .Size = 255
      .Key = K_DIRECCION
      .Value = m_direccion
      .Width = 3700
    End With
    
    Set c = .Add(Nothing, cscChofTipodni)
    With c
      .PropertyType = cspList
      .Name = LNGGetText(1063, vbNullString) 'Tipo Doc.
      .Size = 10
      .Key = K_TIPODNI
      pLoadTipoDoc c
      .ListItemData = m_Tipodni
      .ListWhoSetItem = csListItemData
      .TopFromProperty = cscChofCodigo
      .Left = 6600
    End With
    
    With .Add(Nothing, cscChofDni)
      .PropertyType = cspNumeric
      .SubType = cspInteger
      .Name = LNGGetText(1065, vbNullString) 'Número
      .Width = 1200
      .Key = K_DNI
      .Value = m_Dni
    End With
    
    With .Add(Nothing, cscChofFechadenacimiento)
      .PropertyType = cspDate
      .Name = LNGGetText(1064, vbNullString) 'Fecha de Nacimiento
      .Key = K_FECHADENACIMIENTO
      .Value = m_Fechadenacimiento
    End With
          
    With .Add(Nothing, cscChofTelefono)
      .PropertyType = cspText
      .Name = LNGGetText(1036, vbNullString) 'Teléfono
      .Size = 50
      .Key = K_TELEFONO
      .Value = m_telefono
    End With
                  
    With .Add(Nothing, cscChofDescrip)
      .PropertyType = cspText
      .Name = C_strDescrip
      .SubType = cspMemo
      .LeftFromProperty = cscChofNombre
      .Width = 7500
      .Height = 600
      .Size = 255
      .Key = K_DESCRIP
      .Value = m_descrip
    End With
      
  End With
  
  If Not m_ObjAbm.Show(Me) Then Exit Function
  
  LoadCollection = True
End Function

Private Sub pLoadTipoDoc(ByRef c As cIABMProperty)
  With c.List.Add(Nothing)
    .Id = csChofTdCi
    .Value = LNGGetText(1066, vbNullString) 'C.I.
  End With
  With c.List.Add(Nothing)
    .Id = csChofTdDni
    .Value = LNGGetText(1067, vbNullString) 'D.N.I.
  End With
  With c.List.Add(Nothing)
    .Id = csChofTdLC
    .Value = LNGGetText(1068, vbNullString) 'L.C.
  End With
  With c.List.Add(Nothing)
    .Id = csChofTdLE
    .Value = LNGGetText(1069, vbNullString) 'L.E.
  End With
  With c.List.Add(Nothing)
    .Id = csChofTdOtro
    .Value = LNGGetText(1070, vbNullString) 'Otros
  End With
  With c.List.Add(Nothing)
    .Id = csChofTdPass
    .Value = LNGGetText(1071, vbNullString) 'Pasaporte
  End With
End Sub

Private Function Load(ByVal Id As Long) As Boolean

  Dim sqlstmt As String
  Dim rs      As Recordset
  
  sqlstmt = "select chof.*, trans_nombre, cam_patente" & _
            " from chofer chof left join transporte t on chof.trans_id = t.trans_id" & _
                             " left join camion c on chof.cam_id = c.cam_id " & _
            " where chof.chof_id = " & Id

  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, C_LoadFunction, C_Module) Then Exit Function

  If Not rs.EOF Then

    m_Id = gDB.ValField(rs.fields, cscChofId)
    m_Nombre = gDB.ValField(rs.fields, cscChofNombre)
    m_Codigo = gDB.ValField(rs.fields, cscChofCodigo)
    m_descrip = gDB.ValField(rs.fields, cscChofDescrip)
    m_Tipodni = gDB.ValField(rs.fields, cscChofTipodni)
    m_Dni = gDB.ValField(rs.fields, cscChofDni)
    m_Fechadenacimiento = gDB.ValField(rs.fields, cscChofFechadenacimiento)
    m_direccion = gDB.ValField(rs.fields, cscChofDireccion)
    m_telefono = gDB.ValField(rs.fields, cscChofTelefono)
    m_Activo = gDB.ValField(rs.fields, cscActivo)
    m_trans_id = gDB.ValField(rs.fields, cscTransId)
    m_Transporte = gDB.ValField(rs.fields, cscTransNombre)
    m_cam_id = gDB.ValField(rs.fields, cscCamId)
    m_Camion = gDB.ValField(rs.fields, cscCamPatente)

  Else
    m_Id = csNO_ID
    m_Nombre = vbNullString
    m_Codigo = vbNullString
    m_descrip = vbNullString
    m_Tipodni = csChofTipoDoc.csChofTdDni
    m_Dni = 0
    m_Fechadenacimiento = csNoDate
    m_direccion = vbNullString
    m_telefono = vbNullString
    m_Activo = True
    m_trans_id = csNO_ID
    m_Transporte = vbNullString
    m_cam_id = csNO_ID
    m_Camion = vbNullString
  End If

  Load = True
  
End Function

' construccion - destruccion
Private Sub Class_Terminate()
  On Error Resume Next
  Set m_ObjAbm = Nothing
  Set m_ObjTree = Nothing
End Sub
