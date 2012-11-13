VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cReina"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements CSInterfacesABM.cIEditGeneric
Implements CSInterfacesABM.cIABMClient
Implements CSMenu.cIMenuClient
'--------------------------------------------------------------------------------
' cReina
' 9-9-03

'--------------------------------------------------------------------------------
' notas:
'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cReina"

Private Const K_CODIGO                         As Integer = 1
Private Const K_DESCRIP                        As Integer = 2
Private Const K_NACIMIENTO                     As Integer = 3
Private Const K_PROVEEDOR                      As Integer = 4
Private Const K_CALIDAD                        As Integer = 5
Private Const K_ACTIVO                         As Integer = 6
Private Const K_COLMENA                        As Integer = 7
' estructuras
' Seudo - Variables
Private c_ErrorSave                    As String

' variables privadas
Private m_Id                           As Long
Private m_Codigo                       As String
Private m_Descrip                      As String
Private m_Nacimiento                   As Date
Private m_Proveedor                    As String
Private m_Prov_id                      As Long

Private m_Colm_id                      As Long
Private m_Colmena                      As String

Private m_Calidad                      As Integer
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
Private m_Host As CSMenu.cIMenuHost

Private m_Copy              As Boolean
' Properties publicas
'Public Property Get ID() As Long
'  ID = m_Id
'End Property
'
'Public Property Let ID(ByVal rhs As Long)
'  m_Id = rhs
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
'Public Property Get Descrip() As String
'  Descrip = m_Descrip
'End Property
'
'Public Property Let Descrip(ByVal rhs As String)
'  m_Descrip = rhs
'End Property
'
'Public Property Get Nacimiento() As Date
'  Nacimiento = m_Nacimiento
'End Property
'
'Public Property Let Nacimiento(ByVal rhs As Date)
'  m_Nacimiento = rhs
'End Property
'
'Public Property Get Colmena() As String
'  Colmena = m_Colmena
'End Property
'
'Public Property Let Colmena(ByVal rhs As String)
'  m_Colmena = rhs
'End Property
'
'Public Property Get Colm_id() As Long
'  Colm_id = m_Colm_id
'End Property
'
'Public Property Let Colm_id(ByVal rhs As Long)
'  m_Colm_id = rhs
'End Property
'
'Public Property Get Prov_id() As Long
'  Prov_id = m_Prov_id
'End Property
'
'Public Property Let Prov_id(ByVal rhs As Long)
'  m_Prov_id = rhs
'End Property
'
'Public Property Get Proveedor() As String
'  Proveedor = m_Proveedor
'End Property
'
'Public Property Let Proveedor(ByVal rhs As String)
'  m_Proveedor = rhs
'End Property
'
'Public Property Get Calidad() As Integer
'  Calidad = m_Calidad
'End Property
'
'Public Property Let Calidad(ByVal rhs As Integer)
'  m_Calidad = rhs
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
'
'Public Property Get Activo() As Boolean
'  Activo = m_Activo
'End Property
'
'Public Property Let Activo(ByVal rhs As Boolean)
'  m_Activo = rhs
'End Property

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

Private Function cIABMClient_Copy() As Boolean
  
  cIABMClient_Terminate
  m_IsNew = True
  
  With m_ObjAbm.Properties(cscReinaCodigo)
    .Value = "C-" & .Value
  End With
  
  m_ObjAbm.ShowValue m_ObjAbm.Properties(cscReinaCodigo)
  
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

Private Function cIABMClient_ListAdHock(List As CSInterfacesABM.cIABMList) As Boolean

End Function

Private Sub cIABMClient_Load()

End Sub

Private Function cIABMClient_ShowDocDigital() As Boolean
  On Error GoTo ControlError
  
  If m_Id = csNO_ID Then Exit Function
  
  Dim Doc As cDocDigital
  Set Doc = New cDocDigital

  Doc.ClientTable = csTReina
  Doc.ClientTableID = m_Id

  cIABMClient_ShowDocDigital = Doc.ShowDocs(gDB)

  GoTo ExitProc
ControlError:
  MngError Err, "cIABMClient_ShowDocDigital", C_Module, vbNullString
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Private Function cIABMClient_MessageEx(ByVal MessageID As Long, ByVal Info As Variant) As Variant
  cIABMClient_MessageEx = True
End Function

Private Function cIABMClient_PropertyChange(ByVal Key As Integer) As Boolean

End Function

Private Function cIABMClient_Save() As Boolean
  Dim register   As cRegister
  Dim fields     As cFields
   
  Set register = New cRegister
  Set fields = register.fields
  
  With register
    .fieldId = cscReinaId
    .Table = csTReina
  
    If m_Copy Then
      .ID = csNew
    Else
      .ID = m_Id
    End If
  End With
  
  Dim IProperty As cIABMProperty
  For Each IProperty In m_ObjAbm.Properties
    With IProperty
      Select Case .Key
        Case K_CODIGO
          fields.Add2 cscReinaCodigo, .Value, csText
        Case K_DESCRIP
          fields.Add2 cscReinaDescrip, .Value, csText
        Case K_NACIMIENTO
          fields.Add2 cscReinaNacimiento, .Value, csDate
        Case K_CALIDAD
          fields.Add2 cscReinaCalidad, .ListItemData, csInteger
        Case K_PROVEEDOR
          fields.Add2 cscProvId, .HelpId, csId
        Case K_ACTIVO
          fields.Add2 cscActivo, .Value, csBoolean

      End Select
    End With
  Next
  
  fields.HaveLastUpdate = True
  fields.HaveWhoModify = True
  
  If Not gDB.Save(register, , "cIABMClient_Save", "cReina", c_ErrorSave) Then Exit Function
  
  m_Copy = False
  cIABMClient_Save = Load(register.ID)
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
    cIABMClient_Title = LNGGetText(3028, vbNullString) 'Reinas
End Property


Private Function cIABMClient_Validate() As Boolean

  Dim IProperty As cIABMProperty

  For Each IProperty In m_ObjAbm.Properties
    With IProperty
      Select Case .Key
        Case K_CODIGO
          If ValEmpty(.Value, csText) Then
            MsgInfo LNGGetText(1008, vbNullString) 'Debe indicar un código
            Exit Function
          End If
        Case K_NACIMIENTO
          If ValEmpty(.Value, csDate) Then
            MsgInfo LNGGetText(3029, vbNullString) 'Debe indicar un nacimiento
            Exit Function
          End If
        Case K_CALIDAD
          If ValEmpty(.ListItemData, csInteger) Then
            MsgInfo LNGGetText(3030, vbNullString) 'Debe indicar un calidad
            Exit Function
          End If

      End Select
    End With
  Next

  cIABMClient_Validate = True
End Function

Private Function cIEditGeneric_Edit(ID As Long, Optional ByVal InModalWindow As Boolean) As Boolean
  On Error GoTo ControlError
  
  If ID = csNO_ID Then
    m_IsNew = True
    If Not SecurityCanAccess(csPreANewReina) Then Exit Function
  Else
    m_IsNew = False
    If Not SecurityCanAccess(csPreAEditReina) Then Exit Function
  End If
  
  ' JMA I
  m_ObjAbm.InModalWindow = InModalWindow
' JMA F
  
  If Not Load(ID) Then Exit Function
  
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
  MngError Err, "cIEditGeneric_Edit", "cReina", vbNullString
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
    cIEditGeneric_ShowList = SecurityCanAccess(csPreAListReina)
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

Private Function cIEditGeneric_Delete(ID As Long) As Boolean
    If Not SecurityCanAccess(csPreADeleteReina) Then Exit Function

    Dim sqlstmt As String
    
    sqlstmt = "Delete Reina where reina_id = " & ID
    
    cIEditGeneric_Delete = gDB.Execute(sqlstmt, "cIEditGeneric_Delete", "cReina")
End Function

Private Function cIEditGeneric_Search(ID As Long, Cancela As Boolean) As Boolean

End Function

Private Function cIEditGeneric_PrintObj(ByVal ID As Long) As Boolean

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

Private Function cIEditGeneric_Preview(ByVal ID As Long) As Boolean

End Function

Private Function cIEditGeneric_PropertyChange(ByVal Key As Integer) As Boolean

End Function
Private Function cIMenuClient_Initialize(F As Object, Host As CSMenu.cIMenuHost) As Boolean
  On Error GoTo ControlError
  Dim str_1028 As String
  Dim str_3003 As String
  Dim str_3031 As String
  
  str_1028 = LNGGetText(1028, vbNullString) 'Co&nfiguración
  str_3003 = LNGGetText(3003, vbNullString) '&Apicultura
  str_3031 = LNGGetText(3031, vbNullString) '&Reina
  #If Not PREPROC_NO_MENU_ICON Then
    
    Dim lIconIndex  As Long
    Set m_Host = Host
    lIconIndex = m_Host.AddIcon(LoadResPicture(101, LoadResConstants.vbResIcon))
    m_Host.Server.AddMenu str_3003, csMenuConfig, str_1028, 0, True, False, True, False, True, Nothing
    m_Host.Server.AddMenu str_3031, csPreAListReina, str_3003, 0, True, False, False, False, False, Me, lIconIndex

  #Else
  
    Set m_Host = Host
    m_Host.Server.AddMenu str_3003, csMenuConfig, str_1028, 0, True, False, True, False, True, Nothing
    m_Host.Server.AddMenu str_3031, csPreAListReina, str_3003, 0, True, False, False, False, False, Me
  
  #End If

  cIMenuClient_Initialize = True

  GoTo ExitProc
ControlError:
  MngError Err, "cIMenuClient_Initialize", C_Module, vbNullString
  If Err.Number <> 0 Then Resume ExitProc

ExitProc:
  On Error Resume Next
End Function

Private Function cIMenuClient_ProcessMenu(ByVal ID As Long) As Variant
  m_Host.MenuABMClick "CSApicultura2.cReina", Me, LNGGetText(3028, vbNullString), 0, csETablesApicultura.csReina
                                                  'Reinas
End Function

' funciones privadas
Private Function LoadCollection() As Boolean
  
  With m_ObjAbm.Properties
  
    .Clear
    
    With .Add(Nothing, cscReinaCodigo)
      .PropertyType = cspText
      .Name = C_strCodigo
      .Size = 10
      .Key = K_CODIGO
      .Value = m_Codigo
    End With
    
    With .Add(Nothing, cscReinaNacimiento)
      .PropertyType = cspDate
      .Name = LNGGetText(3032, vbNullString) 'Nacimiento
      .Key = K_NACIMIENTO
      .Value = m_Nacimiento
    End With
    
    With .Add(Nothing, cscActivo)
      .PropertyType = cspCheck
      .Name = C_strActivo
      .Key = K_ACTIVO
      .Value = CInt(m_Activo)
    End With
    
    With .Add(Nothing, cscReinaCalidad)
      .PropertyType = cspList
    
      With .List.Add(Nothing)
        .ID = csRCBuena
        .Value = LNGGetText(3033, vbNullString) 'Buena
      End With
      
      With .List.Add(Nothing)
        .ID = csRCMala
        .Value = LNGGetText(3034, vbNullString) 'Mala
      End With
      
      With .List.Add(Nothing)
        .ID = csRCRegular
        .Value = LNGGetText(3035, vbNullString) 'Regular
      End With
    
      .Name = LNGGetText(3036, vbNullString) 'Calidad
      .Key = K_CALIDAD
      .ListItemData = m_Calidad
      .ListWhoSetItem = csListItemData
    End With
    
    With .Add(Nothing, cscReinaDescrip)
      .PropertyType = cspText
      .Name = C_strDescrip
      .Size = 255
      .Width = 6250
      .Height = 880
      .LeftFromProperty = cscReinaCodigo
      .Key = K_DESCRIP
      .Value = m_Descrip
    End With
    
    With .Add(Nothing, cscColmCodigo)
      .PropertyType = cspText
      .Name = LNGGetText(3006, vbNullString) 'Colmena
      .TopFromProperty = cscReinaCodigo
      .Left = 5500
      .Enabled = False
      .Key = K_COLMENA
      .Value = m_Colmena
    End With
    
    With .Add(Nothing, cscProvNombre)
      .PropertyType = cspHelp
      .Table = csProveedor
      .Name = LNGGetText(1151, vbNullString) 'Proveedor
      .HelpId = m_Prov_id
      .Key = K_PROVEEDOR
      .Value = m_Proveedor
    End With
  
  End With
  
  If Not m_ObjAbm.Show(Me) Then Exit Function
  
  LoadCollection = True
End Function
Private Function Load(ByVal ID As Long) As Boolean

  Dim sqlstmt As String

  sqlstmt = "select reina.*,prov_nombre,colm_codigo " & _
            " from Reina,Proveedor,Colmena" & _
              " Where reina_id     = " & ID & _
                " and reina.prov_id *= proveedor.prov_id" & _
                " and reina.colm_id *= colmena.colm_id"

  Dim rs As Recordset

  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, "Load", "cReina") Then Exit Function

  If Not rs.EOF Then

    m_Id = gDB.ValField(rs.fields, cscReinaId)
    m_Codigo = gDB.ValField(rs.fields, cscReinaCodigo)
    m_Descrip = gDB.ValField(rs.fields, cscReinaDescrip)
    m_Nacimiento = gDB.ValField(rs.fields, cscReinaNacimiento)
    m_Proveedor = gDB.ValField(rs.fields, cscProvNombre)
    m_Prov_id = gDB.ValField(rs.fields, cscProvId)
    
    m_Colm_id = gDB.ValField(rs.fields, cscColmId)
    m_Colmena = gDB.ValField(rs.fields, cscColmCodigo)
    
    m_Calidad = gDB.ValField(rs.fields, cscReinaCalidad)
    m_Creado = gDB.ValField(rs.fields, cscCreado)
    m_Modificado = gDB.ValField(rs.fields, cscModificado)
    m_Modifico = gDB.ValField(rs.fields, cscModifico)
    m_Activo = gDB.ValField(rs.fields, cscActivo)

  Else
    m_Id = csNO_ID
    m_Codigo = vbNullString
    m_Descrip = vbNullString
    m_Nacimiento = csNoDate
    m_Proveedor = vbNullString
    m_Calidad = 0
    m_Creado = csNoDate
    m_Modificado = csNoDate
    m_Modifico = 0
    m_Activo = False

  End If

  Load = True
End Function ' construccion - destruccion

Private Sub Class_Initialize()
  On Error GoTo ControlError

  c_ErrorSave = LNGGetText(3037, vbNullString) 'Error al grabar Reina

  GoTo ExitProc
ControlError:
  MngError Err, "Class_Initialize", C_Module, vbNullString
  If Err.Number <> 0 Then Resume ExitProc
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
'  If Err.Number <> 0 Then Resume ExitProc
'ExitProc:
'  On Error Resume Next


