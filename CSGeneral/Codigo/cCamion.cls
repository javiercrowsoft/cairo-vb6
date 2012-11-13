VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cCamion"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements CSInterfacesABM.cIEditGeneric
Implements CSInterfacesABM.cIABMClient
Implements CSMenu.cIMenuClient
'--------------------------------------------------------------------------------
' cCamion
' 12-06-03
'--------------------------------------------------------------------------------
' notas:
'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cCamion"

Private Const K_CODIGO                         As Integer = 1
Private Const K_DESCRIP                        As Integer = 2
Private Const K_PATENTE                        As Integer = 3
Private Const K_PATENTESEMI                    As Integer = 4
Private Const K_TARA                           As Integer = 5
Private Const K_TRANS_ID                       As Integer = 6
Private Const K_CHOF_ID                        As Integer = 7
Private Const K_ACTIVO                         As Integer = 8
Private Const K_ESSEMI                         As Integer = 9

' estructuras
' variables privadas
Private m_Id                           As Long
Private m_Codigo                       As String
Private m_Descrip                      As String
Private m_patente                      As String
Private m_Patentesemi                  As String
Private m_Tara                         As Long
Private m_Activo                       As Boolean
Private m_EsSemi                       As Boolean
Private m_trans_id                     As Long
Private m_Transporte                   As String
Private m_chof_id                      As Long
Private m_Chofer                       As String

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
  Nombre = m_Codigo
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
  
  With m_ObjAbm.Properties(cscCamCodigo)
    .Value = C_C & .Value
  End With
   
  m_ObjAbm.ShowValue m_ObjAbm.Properties(cscCamCodigo)
   
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

  Doc.ClientTable = csTCamion
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
                               csPreGNewCamion
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
    Case K_ESSEMI
      With m_ObjAbm.Properties
        Set iProp = .Item(cscCamPatentesemi)
        iProp.Enabled = Val(.Item(cscCamEsSemi).Value) = 0
        m_ObjAbm.ShowValue iProp
      End With
  End Select
End Function

Private Function cIABMClient_Save() As Boolean
  Dim register   As cRegister
  Dim fields     As cFields
  
  Set register = New cRegister
  Set fields = register.fields
  
  With register
    .fieldId = cscCamId
    .Table = csTCamion
  
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
        Case K_CODIGO
          fields.Add2 cscCamCodigo, .Value, csText
        Case K_DESCRIP
          fields.Add2 cscCamDescrip, .Value, csText
        Case K_PATENTE
          fields.Add2 cscCamPatente, .Value, csText
        Case K_PATENTESEMI
          fields.Add2 cscCamPatentesemi, .Value, csText
        Case K_TARA
          fields.Add2 cscCamTara, .Value, csLong
        Case K_ACTIVO
          fields.Add2 cscActivo, Val(.Value), csBoolean
        Case K_ESSEMI
          fields.Add2 cscCamEsSemi, Val(.Value), csBoolean
        Case K_TRANS_ID
          fields.Add2 cscTransId, .HelpId, csId
        Case K_CHOF_ID
          fields.Add2 cscChofId, .HelpId, csId
      End Select
    End With
  Next
  
  fields.HaveLastUpdate = True
  fields.HaveWhoModify = True
  
  If Not gDB.SaveEx(register, , _
                    cscCamCodigo, _
                    C_ABMClientSave, _
                    C_Module, _
                    LNGGetText(1045, vbNullString)) Then Exit Function
  
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
                      ' Camiones
  cIABMClient_Title = LNGGetText(1046, vbNullString)
End Property

Private Function cIABMClient_Validate() As Boolean
  Dim IPropiedad As cIABMProperty
  
  For Each IPropiedad In m_ObjAbm.Properties
      With IPropiedad
          Select Case .Key
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
  cIEditGeneric_ShowList = SecurityCanAccess(csPreGListCamion)
End Function

Private Property Set cIEditGeneric_ObjAbm(rhs As CSInterfacesABM.cIABMGeneric)
  Set m_ObjAbm = rhs
End Property

Private Property Get cIEditGeneric_Editing() As Boolean
  cIEditGeneric_Editing = m_Editing
End Property

Private Function cIEditGeneric_Delete(Id As Long) As Boolean
  If Not SecurityCanAccess(csPreGDeleteCamion) Then Exit Function

  Dim sqlstmt As String
  
  sqlstmt = "delete camion where cam_id = " & Id
  
  cIEditGeneric_Delete = gDB.Execute(sqlstmt, C_EditGenericDelete, C_Module)
End Function

Private Function cIEditGeneric_Search(Id As Long, Cancela As Boolean) As Boolean

End Function

Private Function cIEditGeneric_Edit(Id As Long, Optional ByVal InModalWindow As Boolean) As Boolean
  On Error GoTo ControlError
  
  If Id = csNO_ID Then
    m_IsNew = True
    If Not SecurityCanAccess(csPreGNewCamion) Then Exit Function
  Else
    m_IsNew = False
    If Not SecurityCanAccess(csPreGEditCamion) Then Exit Function
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

' funciones privadas
Private Function LoadCollection() As Boolean
  
  m_ObjAbm.Title2 = m_Codigo
  
  With m_ObjAbm.Properties
    
    .Clear
    
    With .Add(Nothing, cscCamCodigo)
      .PropertyType = cspText
      .Name = C_strCodigo
      .Size = 10
      .Key = K_CODIGO
      .Value = m_Codigo
    End With
         
    With .Add(Nothing, cscActivo)
      .PropertyType = cspCheck
      .Name = C_strActivo
      .Key = K_ACTIVO
      .Value = CInt(m_Activo)
    End With
    
    With .Add(Nothing, cscCamEsSemi)
      .PropertyType = cspCheck
      .Name = LNGGetText(3492, vbNullString) 'Es la Pantente del Semi
      .Key = K_ESSEMI
      .Value = CInt(m_EsSemi)
    End With
    
    With .Add(Nothing, cscCamPatente)
      .PropertyType = cspText
      .Name = LNGGetText(1047, vbNullString) 'Patente
      .Size = 20
      .Key = K_PATENTE
      .Value = m_patente
    End With
      
    With .Add(Nothing, cscCamPatentesemi)
      .PropertyType = cspText
      .Name = LNGGetText(1048, vbNullString) 'Patente Semi
      .Size = 20
      .Key = K_PATENTESEMI
      .Value = m_Patentesemi
      .Enabled = Not m_EsSemi
    End With
      
    With .Add(Nothing, cscCamTara)
      .PropertyType = cspNumeric
      .SubType = cspInteger
      .Name = LNGGetText(1049, vbNullString) 'Tara
      .Key = K_TARA
      .Value = m_Tara
      .Width = 1300
      .TopFromProperty = cscCamCodigo
      .Left = 5500
    End With
      
    With .Add(Nothing, cscTransId)
      .PropertyType = cspHelp
      .Table = csTransporte
      .Name = LNGGetText(1050, vbNullString) 'Transporte
      .Key = K_TRANS_ID
      .Value = m_Transporte
      .HelpId = m_trans_id
    End With
      
    With .Add(Nothing, cscChofId)
      .PropertyType = cspHelp
      .Table = csChofer
      .Name = LNGGetText(1051, vbNullString) 'Chofer
      .Key = K_CHOF_ID
      .Value = m_Chofer
      .HelpId = m_chof_id
    End With
          
    With .Add(Nothing, cscCamDescrip)
      .PropertyType = cspText
      .Name = C_strDescrip
      .SubType = cspMemo
      .Width = 6250
      .Height = 660
      .Size = 255
      .Key = K_DESCRIP
      .Value = m_Descrip
      .LeftFromProperty = cscCamCodigo
      .TopFromProperty = cscCamPatentesemi
      .TopToPrevious = 440
    End With
    
  End With
  
  If Not m_ObjAbm.Show(Me) Then Exit Function
  
  LoadCollection = True
End Function

Private Function Load(ByVal Id As Long) As Boolean

  Dim sqlstmt As String
  Dim rs      As Recordset
  
  sqlstmt = "select cam.*, chof_nombre, trans_nombre" & _
            " from camion cam left join chofer cho on cam.chof_id = cho.chof_id" & _
                            " left join transporte t on cam.trans_id = t.trans_id" & _
            " where cam.cam_id = " & Id

  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, C_LoadFunction, C_Module) Then Exit Function

  If Not rs.EOF Then

    m_Id = gDB.ValField(rs.fields, cscCamId)
    m_Codigo = gDB.ValField(rs.fields, cscCamCodigo)
    m_Descrip = gDB.ValField(rs.fields, cscCamDescrip)
    m_patente = gDB.ValField(rs.fields, cscCamPatente)
    m_Patentesemi = gDB.ValField(rs.fields, cscCamPatentesemi)
    m_Tara = gDB.ValField(rs.fields, cscCamTara)
    m_Activo = gDB.ValField(rs.fields, cscActivo)
    m_EsSemi = gDB.ValField(rs.fields, cscCamEsSemi)
    m_Transporte = gDB.ValField(rs.fields, cscTransNombre)
    m_Chofer = gDB.ValField(rs.fields, cscChofNombre)
    m_trans_id = gDB.ValField(rs.fields, cscTransId)
    m_chof_id = gDB.ValField(rs.fields, cscChofId)

  Else
    m_Id = csNO_ID
    m_Codigo = vbNullString
    m_Descrip = vbNullString
    m_patente = vbNullString
    m_Patentesemi = vbNullString
    m_Tara = 0
    m_EsSemi = False
    m_Activo = True
    m_trans_id = csNO_ID
    m_chof_id = csNO_ID
    m_Transporte = vbNullString
    m_Chofer = vbNullString

  End If

  Load = True

End Function

Private Function cIMenuClient_Initialize(F As Object, Host As CSMenu.cIMenuHost) As Boolean
  On Error GoTo ControlError
  
  Set m_Host = Host
  
  m_Host.Server.AddMenu C_MenuStock, csMenuConfigStock, C_MenuConfig, 0, True, False, False, False, True, Nothing
  m_Host.Server.AddMenu LNGGetText(1053, vbNullString), csPreGListCamion, C_MenuStock, 0, True, False, False, False, False, Me

  cIMenuClient_Initialize = True

  GoTo ExitProc
ControlError:
  MngError Err, C_MenuClientInit, C_Module, vbNullString
  If Err.Number Then Resume ExitProc

ExitProc:
  On Error Resume Next
End Function

Private Function cIMenuClient_ProcessMenu(ByVal Id As Long) As Variant
                                                'Camiones
  m_Host.MenuABMClick "CSGeneral2.cCamion", Me, LNGGetText(1046, vbNullString), 0, csETablasGeneral.csCamion
End Function

' construccion - destruccion
Private Sub Class_Terminate()
  On Error Resume Next
  Set m_ObjAbm = Nothing
  Set m_ObjTree = Nothing
End Sub
