VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cTransporte"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements CSInterfacesABM.cIEditGeneric
Implements CSInterfacesABM.cIABMClient
Implements CSMenu.cIMenuClient
'--------------------------------------------------------------------------------
' cTransporte
' 23-03-02

'--------------------------------------------------------------------------------
' notas:
'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cTransporte"

Private Const K_NOMBRE                         As Integer = 1
Private Const K_CODIGO                         As Integer = 2
Private Const K_DESCRIP                        As Integer = 3
Private Const K_TELEFONO                       As Integer = 4
Private Const K_DIRECCION                      As Integer = 5
Private Const K_MAIL                           As Integer = 6
Private Const K_WEB                            As Integer = 7
Private Const K_ACTIVO                         As Integer = 8
Private Const K_PROV_ID                        As Integer = 9
Private Const K_PRO_ID                         As Integer = 10

Private Const K_HORARIO_M_DESDE                As Integer = 52
Private Const K_HORARIO_M_HASTA                As Integer = 53
Private Const K_HORARIO_T_DESDE                As Integer = 54
Private Const K_HORARIO_T_HASTA                As Integer = 55


' estructuras
' variables privadas
Private m_Id                           As Long
Private m_Nombre                       As String
Private m_Codigo                       As String
Private m_descrip                      As String
Private m_telefono                     As String
Private m_direccion                    As String
Private m_Mail                         As String
Private m_Web                          As String
Private m_Activo                       As Boolean

Private m_pro_id                      As Long
Private m_provincia                   As String

Private m_Prov_id                     As Long
Private m_Proveedor                   As String

Private m_horario_m_desde  As Date
Private m_horario_m_hasta  As Date
Private m_horario_t_desde  As Date
Private m_horario_t_hasta  As Date


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

' Implementacion de cIABMClient
Private Function cIABMClient_Copy() As Boolean
  
  cIABMClient_Terminate
  m_IsNew = True
  
  With m_ObjAbm.Properties(cscTransCodigo)
    .Value = C_C & .Value
  End With
  
'  With m_ObjAbm.Properties(cscTransNombre)
'    .Value = C_CopiaDe & .Value
'  End With
  
  m_ObjAbm.ShowValue m_ObjAbm.Properties(cscTransCodigo)
  m_ObjAbm.ShowValue m_ObjAbm.Properties(cscTransNombre)
  
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

  Doc.ClientTable = csTTransporte
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
                               csPreGNewTransporte
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

End Function

Private Function cIABMClient_Save() As Boolean
  Dim register   As cRegister
  Dim fields     As cFields
  
  Set register = New cRegister
  Set fields = register.fields
  
  With register
    .fieldId = cscTransId
    .Table = csTTransporte
  
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
          fields.Add2 cscTransNombre, .Value, csText
        Case K_CODIGO
          fields.Add2 cscTransCodigo, .Value, csText
        Case K_TELEFONO
          fields.Add2 cscTransTelefono, .Value, csText
        Case K_DIRECCION
          fields.Add2 cscTransDireccion, .Value, csText
        Case K_ACTIVO
          fields.Add2 cscActivo, .Value, csBoolean
        Case K_MAIL
          fields.Add2 cscTransMail, .Value, csText
        Case K_WEB
          fields.Add2 cscTransWeb, .Value, csText
        Case K_DESCRIP
          fields.Add2 cscTransDescrip, .Value, csText
        Case K_PROV_ID
          fields.Add2 cscProvId, .HelpId, csId
        Case K_PRO_ID
          fields.Add2 cscProId, .HelpId, csId
      
        Case K_HORARIO_M_DESDE
          fields.Add2 cscTransHorarioMdesde, .Value, csDate
        Case K_HORARIO_M_HASTA
          fields.Add2 cscTransHorarioMhasta, .Value, csDate
        Case K_HORARIO_T_DESDE
          fields.Add2 cscTransHorarioTdesde, .Value, csDate
        Case K_HORARIO_T_HASTA
          fields.Add2 cscTransHorarioThasta, .Value, csDate
      
      End Select
    End With
  Next
  
  fields.HaveLastUpdate = True
  fields.HaveWhoModify = True
                                                         'Error al grabar Transporte
  If Not gDB.SaveEx(register, , _
                    cscTransCodigo, _
                    C_ABMClientSave, _
                    C_Module, _
                    LNGGetText(1495, vbNullString)) Then Exit Function
  
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
    cIABMClient_Title = LNGGetText(1496, vbNullString)    'Transportes
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
    cIEditGeneric_ShowList = SecurityCanAccess(csPreGListTransporte)
End Function

Private Property Set cIEditGeneric_ObjAbm(rhs As CSInterfacesABM.cIABMGeneric)
    Set m_ObjAbm = rhs
End Property

Private Property Get cIEditGeneric_Editing() As Boolean
    cIEditGeneric_Editing = m_Editing
End Property

Private Function cIEditGeneric_Delete(Id As Long) As Boolean
    If Not SecurityCanAccess(csPreGDeleteTransporte) Then Exit Function

    Dim sqlstmt As String
    
    sqlstmt = "delete Transporte where trans_id = " & Id
    
    cIEditGeneric_Delete = gDB.Execute(sqlstmt, C_EditGenericDelete, C_Module)
End Function

Private Function cIEditGeneric_Search(Id As Long, Cancela As Boolean) As Boolean

End Function

Private Function cIEditGeneric_Edit(Id As Long, Optional ByVal InModalWindow As Boolean) As Boolean
  On Error GoTo ControlError
  
  If Id = csNO_ID Then
    m_IsNew = True
    If Not SecurityCanAccess(csPreGNewTransporte) Then Exit Function
  Else
    m_IsNew = False
    If Not SecurityCanAccess(csPreGEditTransporte) Then Exit Function
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
  
  Dim str_1497  As String '&Transporte
  
  str_1497 = LNGGetText(1497, vbNullString)
  
  #If Not PREPROC_NO_MENU_ICON Then
    Dim lIconIndex As Long
    Set m_Host = Host
    
    lIconIndex = m_Host.AddIcon(LoadResPicture(101, LoadResConstants.vbResIcon))
                          
    m_Host.Server.AddMenu C_MenuStock, csMenuConfigStock, C_MenuConfig, 0, True, False, False, False, True, Nothing
    m_Host.Server.AddMenu str_1497, csPreGListTransporte, C_MenuStock, 0, True, False, False, False, False, Me, lIconIndex
  #Else
    Set m_Host = Host
    m_Host.Server.AddMenu C_MenuStock, csMenuConfigStock, C_MenuConfig, 0, True, False, False, False, True, Nothing
    m_Host.Server.AddMenu str_1497, csPreGListTransporte, C_MenuStock, 0, True, False, False, False, False, Me
  #End If
  
  cIMenuClient_Initialize = True

  GoTo ExitProc
ControlError:
  MngError Err, C_MenuClientInit, C_Module, vbNullString
  If Err.Number Then Resume ExitProc

ExitProc:
  On Error Resume Next
End Function

Private Function cIMenuClient_ProcessMenu(ByVal Id As Long) As Variant
                                                    'Transporte
  m_Host.MenuABMClick "CSGeneral2.cTransporte", Me, LNGGetText(1050, vbNullString), 0, csETablasGeneral.csTransporte
End Function

' funciones privadas
Private Function LoadCollection() As Boolean
  Dim AbmObj As cABMGeneric
  
  Set AbmObj = m_ObjAbm
  AbmObj.MinHeight = 7000
  
  m_ObjAbm.Title2 = m_Nombre
    
  With m_ObjAbm.Properties
    .Clear
    
    With .Add(Nothing, cscTransNombre)
      .PropertyType = cspText
      .Name = C_strNombre
      .Size = 100
      .Key = K_NOMBRE
      .Value = m_Nombre
      .Width = 5900
    End With
      
    With .Add(Nothing, cscTransCodigo)
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
      .TopFromProperty = cscTransCodigo
      .Left = 5500
      .LeftLabel = -800
      .LeftNotChange = True
    End With
    
    With .Add(Nothing, cscTransDireccion)
      .PropertyType = cspText
      .Name = LNGGetText(1037, vbNullString) 'Dirección
      .Size = 50
      .Key = K_DIRECCION
      .Value = m_direccion
      .Width = 5900
    End With
      
    With .Add(Nothing, cscTransTelefono)
      .PropertyType = cspText
      .Name = LNGGetText(1036, vbNullString) 'Teléfono
      .Size = 50
      .Key = K_TELEFONO
      .Value = m_telefono
    End With
      
    With .Add(Nothing, cscProId)
      .PropertyType = cspHelp
      .Table = csProvincia
      .Name = LNGGetText(1080, vbNullString) 'Provincia
      .Key = K_PRO_ID
      .Value = m_provincia
      .HelpId = m_pro_id
      .TopFromProperty = cscTransTelefono
      .Left = 5200
      .LeftNotChange = True
    End With
    
    With .Add(Nothing, cscTransMail)
      .PropertyType = cspText
      .Name = LNGGetText(1034, vbNullString) 'Mail
      .Size = 255
      .Key = K_MAIL
      .Value = m_Mail
      .Width = 5900
    End With
        
    With .Add(Nothing, cscTransWeb)
      .PropertyType = cspText
      .Name = LNGGetText(1038, vbNullString) 'Página Web
      .Size = 255
      .Key = K_WEB
      .Value = m_Web
      .Width = 5900
    End With
            
    With .Add(Nothing, cscProvId)
      .PropertyType = cspHelp
      .Table = csProveedor
      .Name = LNGGetText(1151, vbNullString) 'Proveedor
      .Key = K_PROV_ID
      .Value = m_Proveedor
      .HelpId = m_Prov_id
      .Width = 5900
    End With
    
    With .Add(Nothing, cscTransHorarioMdesde)
      .PropertyType = cspTime
      .Name = LNGGetText(4965, vbNullString) ' Horario desde
      .Value = m_horario_m_desde
      .Key = K_HORARIO_M_DESDE
      .LeftNotChange = True
    End With
    
    With .Add(Nothing, cscTransHorarioMhasta)
      .PropertyType = cspTime
      .Name = LNGGetText(4966, vbNullString) ' Hasta
      .Value = m_horario_m_hasta
      .Key = K_HORARIO_M_HASTA
      .TopFromProperty = cscTransHorarioMdesde
      .Left = 3100
      .LeftLabel = -500
      .LeftNotChange = True
      .TopNotChange = True
    End With
    
    With .Add(Nothing, cscTransHorarioTdesde)
      .PropertyType = cspTime
      .Name = LNGGetText(4967, vbNullString) ' Desde
      .Value = m_horario_t_desde
      .Key = K_HORARIO_T_DESDE
      .TopFromProperty = cscTransHorarioMdesde
      .Left = 4700
      .LeftLabel = -500
      .LeftNotChange = True
      .TopNotChange = True
    End With
    
    With .Add(Nothing, cscTransHorarioThasta)
      .PropertyType = cspTime
      .Name = LNGGetText(4966, vbNullString) ' Hasta
      .Value = m_horario_t_hasta
      .Key = K_HORARIO_T_HASTA
      .TopFromProperty = cscTransHorarioMdesde
      .Left = 6200
      .LeftLabel = -500
      .LeftNotChange = True
      .TopNotChange = True
    End With
    
    With .Add(Nothing, cscTransDescrip)
      .PropertyType = cspText
      .Name = C_strDescrip
      .Size = 255
      .SubType = cspMemo
      .LeftFromProperty = cscTransNombre
      .TopFromProperty = cscTransHorarioThasta
      .TopToPrevious = 440
      .Width = 5900
      .Height = 880
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
    
    sqlstmt = "select transporte.*, prov_nombre, pro_nombre" & _
              " from transporte " & _
              " left join proveedor on transporte.prov_id = proveedor.prov_id" & _
              " left join provincia on transporte.pro_id = provincia.pro_id" & _
              " where trans_id = " & Id

    If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, C_LoadFunction, C_Module) Then Exit Function

    If Not rs.EOF Then

      m_Id = gDB.ValField(rs.fields, cscTransId)
      m_Nombre = gDB.ValField(rs.fields, cscTransNombre)
      m_Codigo = gDB.ValField(rs.fields, cscTransCodigo)
      m_telefono = gDB.ValField(rs.fields, cscTransTelefono)
      m_direccion = gDB.ValField(rs.fields, cscTransDireccion)
      m_Mail = gDB.ValField(rs.fields, cscTransMail)
      m_Web = gDB.ValField(rs.fields, cscTransWeb)
      m_descrip = gDB.ValField(rs.fields, cscTransDescrip)
      m_Activo = gDB.ValField(rs.fields, cscActivo)
      m_Prov_id = gDB.ValField(rs.fields, cscProvId)
      m_Proveedor = gDB.ValField(rs.fields, cscProvNombre)
      
      m_pro_id = gDB.ValField(rs.fields, cscProId)
      m_provincia = gDB.ValField(rs.fields, cscProNombre)
      
      m_horario_m_desde = gDB.ValField(rs.fields, cscTransHorarioMdesde)
      m_horario_m_hasta = gDB.ValField(rs.fields, cscTransHorarioMhasta)
      m_horario_t_desde = gDB.ValField(rs.fields, cscTransHorarioTdesde)
      m_horario_t_hasta = gDB.ValField(rs.fields, cscTransHorarioThasta)
      
    Else
      m_Id = csNO_ID
      m_Nombre = vbNullString
      m_Codigo = vbNullString
      m_telefono = vbNullString
      m_direccion = vbNullString
      m_Mail = vbNullString
      m_Web = vbNullString
      m_descrip = vbNullString
      m_Activo = True
      m_Prov_id = csNO_ID
      m_Proveedor = vbNullString
    
      m_horario_m_desde = csNoDate
      m_horario_m_hasta = csNoDate
      m_horario_t_desde = csNoDate
      m_horario_t_hasta = csNoDate
    
      m_pro_id = csNO_ID
      m_provincia = vbNullString
    End If

    Load = True
End Function

' construccion - destruccion
Private Sub Class_Terminate()
  On Error Resume Next
  Set m_ObjAbm = Nothing
  Set m_ObjTree = Nothing
End Sub

