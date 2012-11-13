VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cProvincia"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements CSInterfacesABM.cIEditGeneric
Implements CSInterfacesABM.cIABMClient
Implements CSMenu.cIMenuClient
'--------------------------------------------------------------------------------
' cProvincia
' 31-07-00

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cPronvincia"

Private Const K_NOMBRE      As Integer = 1
Private Const K_CODIGO      As Integer = 2
Private Const K_ACTIVO      As Integer = 3
Private Const K_DESCIP      As Integer = 4
Private Const K_PA_ID       As Integer = 5
' estructuras
' variables privadas
Private m_Id                As Long
Private m_Nombre            As String
Private m_Codigo            As String
Private m_descrip           As String
Private m_Pa_Id             As Long
Private m_Pais              As String
Private m_Activo            As Boolean

Private m_Editing          As Boolean

Private m_ObjAbm           As cIABMGeneric
Private m_ObjTree          As Object

Private m_IsNew            As Boolean

Private m_BranchId         As Long
Private m_TreeId           As Long

Private m_Host             As CSMenu.cIMenuHost
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
  
  With m_ObjAbm.Properties(cscProCodigo)
    .Value = C_C & .Value
  End With
  
'  With m_ObjAbm.Properties(cscProNombre)
'    .Value = C_CopiaDe & .Value
'  End With
  
  m_ObjAbm.ShowValue m_ObjAbm.Properties(cscProCodigo)
  m_ObjAbm.ShowValue m_ObjAbm.Properties(cscProNombre)
  
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

  Doc.ClientTable = csTProvincia
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
                               csPreGNewProvincia
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
      .fieldId = cscProId
      .Table = csTProvincia
      
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
                    fields.Add2 cscProNombre, .Value, csText
                Case K_CODIGO
                    fields.Add2 cscProCodigo, .Value, csText
                Case K_DESCIP
                    fields.Add2 cscProDescrip, .Value, csText
                Case K_PA_ID
                    fields.Add2 cscPaId, .HelpId, csId
                Case K_ACTIVO
                    fields.Add2 cscActivo, Val(.Value), csBoolean
            End Select
        End With
    Next
    
    fields.HaveLastUpdate = True
    fields.HaveWhoModify = True
                                                               'Error al grabar Provincias
    If Not gDB.SaveEx(register, , _
                      cscProCodigo, _
                      C_ABMClientSave, _
                      C_Module, _
                      LNGGetText(1409, vbNullString)) Then Exit Function
    
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
    cIABMClient_Title = LNGGetText(1410, vbNullString) 'Provincias
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
        Case K_PA_ID
          If ValEmpty(.HelpId, csId) Then
            MsgInfo LNGGetText(1411, vbNullString)
                    'Debe indicar un País
            Exit Function
          End If
        Case K_ACTIVO
      End Select
    End With
  Next
  
  cIABMClient_Validate = True
End Function

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
    cIEditGeneric_ShowList = SecurityCanAccess(csPreGListProvincia)
End Function

' Implementacion de cIEditGeneric
Private Property Set cIEditGeneric_ObjAbm(rhs As CSInterfacesABM.cIABMGeneric)
    Set m_ObjAbm = rhs
End Property

Private Property Get cIEditGeneric_Editing() As Boolean
    cIEditGeneric_Editing = m_Editing
End Property

Private Function cIEditGeneric_Delete(Id As Long) As Boolean
    If Not SecurityCanAccess(csPreGDeleteProvincia) Then Exit Function
    
    Dim sqlstmt As String
    
    sqlstmt = "delete Provincia where pro_id = " & Id
    
    cIEditGeneric_Delete = gDB.Execute(sqlstmt, C_EditGenericDelete, "cProvincia")
End Function

Private Function cIEditGeneric_Search(Id As Long, Cancela As Boolean) As Boolean

End Function

Private Function cIEditGeneric_Edit(Id As Long, Optional ByVal InModalWindow As Boolean) As Boolean
  On Error GoTo ControlError
  
  If Id = csNO_ID Then
    m_IsNew = True
    If Not SecurityCanAccess(csPreGNewProvincia) Then Exit Function
  Else
    m_IsNew = False
    If Not SecurityCanAccess(csPreGEditProvincia) Then Exit Function
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
  MngError Err, C_EditGenericEdit, "cProvincia", vbNullString
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

' MenuClient
Private Function cIMenuClient_Initialize(F As Object, Host As CSMenu.cIMenuHost) As Boolean
  On Error GoTo ControlError

  Set m_Host = Host
  
  m_Host.Server.AddMenu C_MenuGeneral, csMenuConfigGeneral, C_MenuConfig, 0, True, False, False, False, True, Nothing
                          'Pro&vincias
  m_Host.Server.AddMenu LNGGetText(1412, vbNullString), csPreGListProvincia, C_MenuGeneral, 0, True, False, False, False, False, Me

  cIMenuClient_Initialize = True

  GoTo ExitProc
ControlError:
  MngError Err, C_MenuClientInit, C_Module, vbNullString
  If Err.Number Then Resume ExitProc

ExitProc:
  On Error Resume Next
End Function

Private Function cIMenuClient_ProcessMenu(ByVal Id As Long) As Variant
                                                    ' Provincias
  m_Host.MenuABMClick "CSGeneral2.cProvincia", Me, LNGGetText(1410, vbNullString), 0, csETablasGeneral.csProvincia
End Function

' funciones privadas
Private Function LoadCollection() As Boolean
  
  m_ObjAbm.Title2 = m_Nombre
    
  With m_ObjAbm.Properties
    
    .Clear
    
    With .Add(Nothing, cscProNombre)
      .PropertyType = cspText
      .Name = C_strNombre
      .Size = 100
      .Key = K_NOMBRE
      .Value = m_Nombre
    End With
        
    With .Add(Nothing, cscProCodigo)
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
    End With
        
    With .Add(Nothing, cscPaId)
      .PropertyType = cspHelp
      .Table = csPais
      .Name = LNGGetText(1212, vbNullString) 'País
      .Key = K_PA_ID
      .Value = m_Pais
      .HelpId = m_Pa_Id
    End With
        
    With .Add(Nothing, cscProDescrip)
      .PropertyType = cspText
      .Name = C_strDescrip
      .Size = 255
      .SubType = cspMemo
      .Width = 5000
      .Height = 880
      .Value = m_descrip
      .Key = K_DESCIP
    End With
  
  End With
      
  If Not m_ObjAbm.Show(Me) Then Exit Function

  LoadCollection = True
End Function

Private Function Load(ByVal Id As Long) As Boolean
    
    Dim sqlstmt As String
    Dim rs      As ADODB.Recordset
    
    sqlstmt = "select provincia.*,pa_nombre" & _
              " from provincia, pais" & _
              " where provincia.pa_id = pais.pa_id" & _
                " and pro_id = " & Id
    
    If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, C_LoadFunction, "cProvincia") Then Exit Function
    
    If rs.EOF Then
        m_Activo = True
        m_Nombre = vbNullString
        m_Codigo = vbNullString
        m_descrip = vbNullString
        m_Id = csNO_ID
        m_Pa_Id = csNO_ID
        m_Pais = vbNullString
    Else
        m_Activo = gDB.ValField(rs.fields, cscActivo)
        m_Nombre = gDB.ValField(rs.fields, cscProNombre)
        m_Codigo = gDB.ValField(rs.fields, cscProCodigo)
        m_descrip = gDB.ValField(rs.fields, cscProDescrip)
        m_Id = gDB.ValField(rs.fields, cscProId)
        m_Pa_Id = gDB.ValField(rs.fields, cscPaId)
        m_Pais = gDB.ValField(rs.fields, cscPaNombre)
    End If
    
    Load = True
End Function

' construccion - destruccion
Private Sub Class_Terminate()
  On Error Resume Next
  Set m_ObjAbm = Nothing
  Set m_ObjTree = Nothing
End Sub
